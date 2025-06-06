//
//  CheckTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI
import SwiftData

struct CheckTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showTaskFlow = false
    @State private var selectedDate = Date()
    
    // SwiftData에서 태스크를 불러오기
    @Query private var allTaskItems: [TaskItemEntity]
    @Query private var allTaskSchedules: [TaskScheduleEntity]
    
    // 현재 선택된 날짜의 태스크만 필터링
    private var tasksForSelectedDate: [TaskItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        // 저장된 태스크 아이템들 중 선택된 날짜에 해당하는 것들
        let savedTasks = allTaskItems.filter { entity in
            entity.date >= startOfDay && entity.date < endOfDay
        }.map { $0.toTaskItem() }
        
        // 스케줄에 따라 생성해야 할 태스크들 확인
        var scheduledTasks: [TaskItem] = []
        for schedule in allTaskSchedules {
            let scheduledTasksForMonth = schedule.toTaskSchedule().scheduledTasksForMonth(
                forMonth: calendar.component(.month, from: selectedDate),
                year: calendar.component(.year, from: selectedDate)
            )
            
            for scheduledTask in scheduledTasksForMonth {
                if calendar.isDate(scheduledTask.date, inSameDayAs: selectedDate) {
                    // 이미 저장된 태스크가 있는지 확인
                    let exists = savedTasks.contains { savedTask in
                        savedTask.taskType == scheduledTask.taskType &&
                        calendar.isDate(savedTask.date, inSameDayAs: scheduledTask.date)
                    }
                    
                    if !exists {
                        scheduledTasks.append(scheduledTask)
                    }
                }
            }
        }
        
        return savedTasks + scheduledTasks
    }
    
    var body: some View {
        HStack(spacing: 40) {
            // 왼쪽 캘린더
            VStack {
                TestCalendarView(showDots: true, selectedDate: $selectedDate)
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
            }
            .frame(maxWidth: .infinity)
            
            // 오른쪽 태스크 리스트
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    Text(dateFormatter.string(from: selectedDate) + "의 일정")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tasksForSelectedDate, id: \.id) { taskItem in
                            TaskListItemView(
                                taskItem: taskItem,
                                onToggleComplete: { updatedTask in
                                    toggleTaskCompletion(updatedTask)
                                }
                            )
                        }
                        
                        if tasksForSelectedDate.isEmpty {
                            Text("이 날짜에는 예정된 일정이 없습니다")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(.vertical)
                }
                .frame(maxHeight: .infinity)
                
                Button(action: { showTaskFlow = true }) {
                    CustomButtonLabel(title: "추가하기")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color("BackgroundPrimary"))
        .fullScreenCover(isPresented: $showTaskFlow) {
            NavigationStack {
                NameAddTaskView(
                    onComplete: { showTaskFlow = false },
                    selectedDate: selectedDate
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                        .foregroundColor(Color("ButtonSecondary"))
                }
            }
        }
        .toolbarBackground(Color("BackgroundPrimary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
    // MARK: - Helper Methods
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    private func toggleTaskCompletion(_ task: TaskItem) {
        // 완료 상태 토글
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: task.date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        // 기존 저장된 태스크 찾기
        if let existingEntity = allTaskItems.first(where: { entity in
            entity.taskTypeRawValue == task.taskType.rawValue &&
            entity.date >= startOfDay && entity.date < endOfDay
        }) {
            // 기존 태스크 업데이트
            existingEntity.isCompleted.toggle()
        } else {
            // 새로운 태스크 생성
            let newEntity = TaskItemEntity(
                taskType: task.taskType,
                date: task.date,
                isCompleted: !task.isCompleted
            )
            modelContext.insert(newEntity)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        CheckTaskView()
    }
    .modelContainer(for: [TaskItemEntity.self, TaskScheduleEntity.self])
}
