//
//  TaskScheduleViewModel.swift
//  MungDo
//
//  Created by cheshire on 6/5/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class TaskScheduleViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var selectedDate: Date = Date()
    @Published var taskRecurrences: [TaskRecurrenceEntity] = []
    @Published var completedTasks: [TaskItemEntity] = []
    
    private var modelContext: ModelContext?
    
    init() {
        selectedDate = Date()
        loadSampleData()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadTaskRecurrences()
        loadTasksForSelectedDate()
    }
    
    // MARK: - Task Recurrence 관리
    
    func saveTaskRecurrence(taskName: String, taskType: TaskType? = nil, customTaskName: String? = nil, startDate: Date, cycleDays: Int) {
        guard let context = modelContext else { return }
        
        let recurrence = TaskRecurrenceEntity(
            taskName: taskName,
            taskType: taskType,
            customTaskName: customTaskName,
            startDate: startDate,
            cycleDays: cycleDays
        )
        
        context.insert(recurrence)
        
        do {
            try context.save()
            loadTaskRecurrences()
            generateTasksForCurrentMonth()
        } catch {
            print("Failed to save task recurrence: \(error)")
        }
    }
    
    func loadTaskRecurrences() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<TaskRecurrenceEntity>(
            predicate: #Predicate<TaskRecurrenceEntity> { $0.isActive == true },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        
        do {
            taskRecurrences = try context.fetch(descriptor)
        } catch {
            print("Failed to load task recurrences: \(error)")
        }
    }
    
    // MARK: - 날짜별 Task 로딩
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        loadTasksForSelectedDate()
    }
    
    func loadTasksForSelectedDate() {
        guard let context = modelContext else {
            loadSampleData()
            return
        }
        
        // 저장된 완료 기록 불러오기
        loadCompletedTasksForDate(selectedDate)
        
        // 해당 날짜에 예정된 tasks 생성
        var scheduledTasks: [TaskItem] = []
        
        for recurrence in taskRecurrences {
            if recurrence.shouldOccurOn(date: selectedDate) {
                let taskType = recurrence.taskType
                let isCompleted = completedTasks.contains { entity in
                    let calendar = Calendar.current
                    let isSameDay = calendar.isDate(entity.date, inSameDayAs: selectedDate)
                    if let taskType = taskType {
                        return isSameDay && entity.taskTypeRawValue == taskType.rawValue
                    } else {
                        return isSameDay && entity.taskTypeRawValue == recurrence.taskName
                    }
                }
                
                let task = TaskItem(
                    taskType: taskType ?? .walk, // 기본값으로 .walk 사용, 사용자 정의인 경우 별도 처리 필요
                    date: selectedDate,
                    isCompleted: isCompleted
                )
                scheduledTasks.append(task)
            }
        }
        
        tasks = scheduledTasks
    }
    
    func loadCompletedTasksForDate(_ date: Date) {
        guard let context = modelContext else { return }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        let descriptor = FetchDescriptor<TaskItemEntity>(
            predicate: #Predicate<TaskItemEntity> { entity in
                entity.date >= startOfDay && entity.date < endOfDay && entity.isCompleted == true
            }
        )
        
        do {
            completedTasks = try context.fetch(descriptor)
        } catch {
            print("Failed to load completed tasks: \(error)")
        }
    }
    
    // MARK: - Task 완료 처리
    
    func completeTask(_ task: TaskItem) {
        guard let context = modelContext else { return }
        
        // 이미 완료된 task인지 확인
        let existingEntity = completedTasks.first { entity in
            let calendar = Calendar.current
            let isSameDay = calendar.isDate(entity.date, inSameDayAs: task.date)
            return isSameDay && entity.taskTypeRawValue == task.taskType.rawValue
        }
        
        if existingEntity == nil {
            // 새로운 완료 기록 생성
            let completedEntity = TaskItemEntity(
                taskType: task.taskType,
                date: task.date,
                isCompleted: true
            )
            context.insert(completedEntity)
            
            do {
                try context.save()
                loadTasksForSelectedDate()
                
                // Firebase에 저장 (기존 CompletedTaskAddService 활용)
                let addService = CompletedTaskAddService()
                addService.taskDisplayName = task.taskType.displayName
                addService.taskDoneDate = task.date
                addService.saveTaskToDb(num: 1011112222) // 임시 사용자 번호
                
            } catch {
                print("Failed to save completed task: \(error)")
            }
        }
    }
    
    // MARK: - 월별 Task 생성
    
    func generateTasksForCurrentMonth() {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        
        // 이번 달의 첫날과 마지막날
        guard let startOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return
        }
        
        // 각 recurrence에 대해 이번 달의 모든 해당 날짜를 계산
        for recurrence in taskRecurrences {
            let dates = recurrence.getNextDates(from: startOfMonth, count: 50) // 충분한 수만큼 계산
            
            for date in dates {
                if date <= endOfMonth {
                    // 이미 저장된 task가 있는지 확인하고 없으면 생성
                    // (필요시 구현)
                }
            }
        }
    }
    
    // MARK: - Sample Data
    
    private func loadSampleData() {
        tasks = [
            TaskItem(taskType: .vaccination, date: selectedDate, isCompleted: false),
            TaskItem(taskType: .heartworm, date: selectedDate, isCompleted: false),
            TaskItem(taskType: .walk, date: selectedDate, isCompleted: false)
        ]
    }
}
