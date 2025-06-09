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
    @State var selectedDate = Date()
    @State private var reloadTrigger = UUID()
    @State private var showDeleteAlert = false
    @State private var taskToDelete: TaskItem?

    // SwiftData에서 태스크를 불러오기
    @Query private var allTaskItems: [TaskItemEntity]


    // 현재 선택된 날짜의 저장된 태스크만 필터링
    private var tasksForSelectedDate: [TaskItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        //안찍힘! 
        print("▶ [Debug] allTaskItems count: \(allTaskItems.count)")
            for entity in allTaskItems {
                print("  • 엔티티 date=\(entity.date), type=\(entity.taskTypeRawValue), completed=\(entity.isCompleted)")
            }

        // 저장된 태스크 아이템들 중 선택된 날짜에 해당하는 것들만
        let savedTasks = allTaskItems.filter { entity in
            entity.date >= startOfDay && entity.date < endOfDay
        }.map { $0.toTaskItem() }

        return savedTasks
    }

    var body: some View {
        HStack(spacing: 40) {
            // 왼쪽 캘린더
            VStack {
                FSCustomCalendarView(tasks: allTaskItems, currentPage: selectedDate, selectedDate: $selectedDate)
                    .id(reloadTrigger)
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

                // ScrollView 대신 List 사용
                List {
                    ForEach(tasksForSelectedDate, id: \.id) { taskItem in
                        TaskListItemView(
                            taskItem: taskItem,
                            onToggleComplete: { updatedTask in
                                toggleTaskCompletion(updatedTask)
                            }
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteTask(taskItem)
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                    }

                    if tasksForSelectedDate.isEmpty {
                        Text("이 날짜에는 예정된 일정이 없습니다")
                            .font(.system(size: 36))
                            .foregroundColor(.gray)
                            .padding()
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
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
                    onComplete: {
                        showTaskFlow = false
                        reloadTrigger = UUID() },

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
        .alert("일정 삭제", isPresented: $showDeleteAlert) {
            Button("오늘 일정만 삭제하기", role: .destructive) {
                if let task = taskToDelete {
                    deleteTodayTask(task)
                }
                taskToDelete = nil
            }
            Button("전체 일정 삭제", role: .destructive) {
                if let task = taskToDelete {
                    deleteAllTasks(task)
                }
                taskToDelete = nil
            }
            Button("취소", role: .cancel) {
                taskToDelete = nil
            }
        } message: {
            Text("어떤 일정을 삭제하시겠습니까?")
        }
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
            // 캘린더 즉시 업데이트
            reloadTrigger = UUID()
        } catch {
            print("Failed to save task: \(error)")
        }
    }

    private func deleteTask(_ task: TaskItem) {
        taskToDelete = task
        showDeleteAlert = true
    }

    private func deleteTodayTask(_ task: TaskItem) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: task.date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

        if let existingEntity = allTaskItems.first(where: { entity in
            entity.taskTypeRawValue == task.taskType.rawValue &&
            entity.date >= startOfDay && entity.date < endOfDay
        }) {
            modelContext.delete(existingEntity)
            try? modelContext.save()
            reloadTrigger = UUID() // 캘린더 업데이트
        }
    }

    private func deleteAllTasks(_ task: TaskItem) {
        // 해당 태스크 타입의 모든 일정 삭제 (자동 생성된 것들도 포함)
        let tasksToDelete = allTaskItems.filter { entity in
            entity.taskTypeRawValue == task.taskType.rawValue
        }
        
        for taskEntity in tasksToDelete {
            modelContext.delete(taskEntity)
        }

        try? modelContext.save()
        reloadTrigger = UUID() // 캘린더 업데이트
    }
}

//#Preview {
//    NavigationStack {
//        CheckTaskView()
//    }
//    .modelContainer(for: [TaskItemEntity.self, TaskScheduleEntity.self])
//}
