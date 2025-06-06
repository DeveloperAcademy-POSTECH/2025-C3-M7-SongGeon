//
//  TaskViewModel.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var selectedDate: Date = Date()
    
    private var modelContext: ModelContext?
    
    init() {
        // 임시 샘플 데이터
        loadSampleTasks()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadTasks()
    }
    
    func saveTaskSchedule(taskType: TaskType, startDate: Date) {
        guard let context = modelContext else { 
            print("No model context available")
            return 
        }
        
        let entity = TaskScheduleEntity(taskType: taskType, startDate: startDate)
        context.insert(entity)
        
        do {
            try context.save()
            generateTasksFromSchedule(entity)
        } catch {
            print("Failed to save task schedule: \(error)")
        }
    }
    
    func loadTasks() {
        guard let context = modelContext else {
            loadSampleTasks()
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        let descriptor = FetchDescriptor<TaskItemEntity>(
            predicate: #Predicate<TaskItemEntity> { item in
                item.date >= startOfDay && item.date < endOfDay
            },
            sortBy: [SortDescriptor(\.date)]
        )
        
        do {
            let entities = try context.fetch(descriptor)
            self.tasks = entities.map { $0.toTaskItem() }
        } catch {
            print("Failed to load tasks: \(error)")
            loadSampleTasks()
        }
    }
    
    func updateTaskCompletion(task: TaskItem, isCompleted: Bool) {
        // 임시로 로컬 업데이트만
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = TaskItem(taskType: task.taskType, date: task.date, isCompleted: isCompleted)
        }
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        loadTasks()
    }
    
    private func loadSampleTasks() {
        tasks = [
            TaskItem(taskType: .vaccination, date: Date(), isCompleted: true),
            TaskItem(taskType: .heartworm, date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), isCompleted: false)
        ]
    }
    
    private func generateTasksFromSchedule(_ schedule: TaskScheduleEntity) {
        guard let context = modelContext else { return }
        
        let calendar = Calendar.current
        let cycle = schedule.taskType.defaultCycle
        var currentDate = schedule.startDate
        let endDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
        
        while currentDate <= endDate {
            let entity = TaskItemEntity(
                taskType: schedule.taskType,
                date: currentDate,
                isCompleted: false
            )
            context.insert(entity)
            
            guard let nextDate = calendar.date(byAdding: .day, value: cycle, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        do {
            try context.save()
            loadTasks()
        } catch {
            print("Failed to generate tasks: \(error)")
        }
    }
} 