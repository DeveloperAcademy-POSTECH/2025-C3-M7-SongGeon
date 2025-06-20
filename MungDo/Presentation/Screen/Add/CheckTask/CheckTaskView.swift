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
        GeometryReader { geometry in
            let availableHeight = geometry.size.height*0.85
            HStack{
                //MARK: - 왼쪽 캘린더
                VStack(alignment: .leading) {
                    Spacer()
                    Text("날짜별로 모아보기")
                        .font(.headingFontMeidum)
                        .foregroundColor(.primary03)
                    Spacer()
                    FSCustomCalendarView(tasks: allTaskItems, currentPage: selectedDate, selectedDate: $selectedDate)
                        .frame(width: availableHeight, height: availableHeight)
                        .id(reloadTrigger)
                        .aspectRatio(1.0, contentMode: .fit)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.neutrals01)
                                .shadow(color: Color(red: 1, green: 0.45, blue: 0.38).opacity(0.08), radius: 6, x: 0, y: 4)
                        )
                }
                Spacer(minLength:24.0)
                //MARK: - 오른쪽 태스크 리스트
                VStack(alignment: .leading) {
                    Spacer()
                    Text(dateFormatter.string(from: selectedDate) + "의 일정")
                        .font(.bodyFontLarge)
                        .foregroundColor(.neutrals03)
                    Spacer()
                    VStack {
                        List {
                            ForEach(tasksForSelectedDate, id: \.id) { taskItem in
                                TaskListItemView(
                                    taskItem: taskItem,
                                    onToggleComplete: { updatedTask in
                                        toggleTaskCompletion(updatedTask)
                                    }
                                )
                                
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteTask(taskItem)
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                                .padding(.bottom, 12)
                            }

                            if tasksForSelectedDate.isEmpty {
                                Text("이 날 예정된 일정이 없어요.")
                                    .font(.headingFontSmall)
                                    .foregroundColor(.primary03)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                        .frame(maxHeight: .infinity)
                        Spacer()
                        Button("새로운 할 일 추가하기") {
                            showTaskFlow = true
                        }
                        .buttonStyle(AddTaskButtonStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: availableHeight)
                    
                }
            }
            .padding(.horizontal, geometry.size.height*0.05)
            .padding(.bottom, geometry.size.height*0.03)
            .padding(.top, geometry.size.height*0.01)
            .background(Color.primary02)
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
            //MARK: - Toolbar 영역
            .navigationBarBackButtonHidden(true)
            .toolbar{
                CustomToolBar(onBack: {dismiss()}, onXMark: {})
            }
            //MARK: - Alert 영역
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

#Preview {
    NavigationStack {
        CheckTaskView(selectedDate: Date())
    }
    .modelContainer(for: [TaskItemEntity.self])
}
