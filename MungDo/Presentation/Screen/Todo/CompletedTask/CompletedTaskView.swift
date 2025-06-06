//
//  CompletedTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI
import SwiftData

struct CompletedTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex = 0
    @State private var showCelebration = false

    // SwiftData에서 오늘의 태스크를 불러오기
    @Query private var allTaskItems: [TaskItemEntity]
    @Query private var allTaskSchedules: [TaskScheduleEntity]

    // 오늘 예정된 태스크들 (완료되지 않은 것들)
    private var todayTasks: [TaskItem] {
        let today = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: today)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

        // 저장된 태스크 중 오늘 것들
        let savedTasks = allTaskItems.filter { entity in
            entity.date >= startOfDay && entity.date < endOfDay
        }.map { $0.toTaskItem() }

        // 스케줄에 따라 생성해야 할 오늘의 태스크들
        var scheduledTasks: [TaskItem] = []
        for schedule in allTaskSchedules {
            let scheduledTasksForMonth = schedule.toTaskSchedule().scheduledTasksForMonth(
                forMonth: calendar.component(.month, from: today),
                year: calendar.component(.year, from: today)
            )

            for scheduledTask in scheduledTasksForMonth {
                if calendar.isDate(scheduledTask.date, inSameDayAs: today) {
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

    // 모든 태스크 완료 여부 확인
    private var allTasksCompleted: Bool {
        return todayTasks.allSatisfy { $0.isCompleted }
    }

    //db 확인용
    @StateObject private var addService = CompletedTaskAddService()
    // 임시로 넣어 둔 user 번호 (식별)
    let userNum: Int = 1011112222

    var body: some View {
        ZStack {
            // 배경색
            Color("BackgroundPrimary")
                .ignoresSafeArea()

            VStack(spacing: 30) {
                if todayTasks.isEmpty {
                    // 완료된 태스크가 없을 때
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)

                        Text("오늘 예정된 일정이 없습니다")
                            .font(.title2)
                            .foregroundColor(.gray)

                        Text("일정을 추가해보세요!")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                } else {
                    // 카드 캐러셀
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                // 첫 번째 셀을 가운데에 오게 하기 위한 leading spacer
                                Spacer()
                                    .frame(width: (UIScreen.main.bounds.width - 647) / 2)

                                ForEach(Array(todayTasks.enumerated()), id: \.element.id) { index, task in
                                    TaskCardView(taskItem: task)
                                        .frame(width: 647, height: 403)
                                        .scaleEffect(index == currentIndex ? 1.0 : 0.9)
                                        .opacity(index == currentIndex ? 1.0 : 0.7)
                                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                        .id(index)
                                }

                                // 마지막 셀을 가운데에 오게 하기 위한 trailing spacer
                                Spacer()
                                    .frame(width: (UIScreen.main.bounds.width - 647) / 2)
                            }
                        }
                        .scrollDisabled(true) // 수동 스크롤 비활성화
                        .onChange(of: currentIndex) { oldValue, newValue in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if value.translation.width > threshold && currentIndex > 0 {
                                            currentIndex -= 1
                                        } else if value.translation.width < -threshold && currentIndex < todayTasks.count - 1 {
                                            currentIndex += 1
                                        }
                                    }
                                }
                        )
                    }

                    // 페이지 인디케이터
                    HStack(spacing: 8) {
                        ForEach(0..<todayTasks.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.pink : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        }
                    }

                    // 완료됨 버튼 (카드 밖으로 이동)
                    Button(action: {
                        let task = todayTasks[currentIndex]
                        completeCurrentTask(task)

                        withAnimation(.easeInOut(duration: 0.5)) {
                            if currentIndex < todayTasks.count - 1 {
                                currentIndex += 1
                            } else {
                                // 마지막 카드에서 모든 태스크가 완료되었다면 축하 화면으로
                                if allTasksCompleted {
                                    showCelebration = true
                                } else {
                                    // 마지막 카드에서는 처음으로 돌아가기
                                    currentIndex = 0
                                }
                            }
                        }
                    }) {
                        HStack {
                            let isLastCard = currentIndex >= todayTasks.count - 1
                            let buttonText = if allTasksCompleted && isLastCard {
                                "완료!"
                            } else if isLastCard {
                                "처음으로"
                            } else {
                                "다음"
                            }

                            Text(buttonText)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 120)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color("ButtonPrimary"))
                        )
                        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCelebration) {
            AllTasksCompletedView(onDismiss: {
                showCelebration = false
            })
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

    private func completeCurrentTask(_ task: TaskItem) {
        // 완료 상태로 변경
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: task.date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

        // 기존 저장된 태스크 찾기
        if let existingEntity = allTaskItems.first(where: { entity in
            entity.taskTypeRawValue == task.taskType.rawValue &&
            entity.date >= startOfDay && entity.date < endOfDay
        }) {
            // 기존 태스크 업데이트
            existingEntity.isCompleted = true
        } else {
            // 새로운 완료 태스크 생성
            let newEntity = TaskItemEntity(
                taskType: task.taskType,
                date: task.date,
                isCompleted: true
            )
            modelContext.insert(newEntity)
        }

        do {
            try modelContext.save()

            // Firebase에 저장 (기존 CompletedTaskAddService 활용)
            addService.taskDisplayName = task.taskType.displayName
            addService.taskDoneDate = task.date
            addService.saveTaskToDb(num: userNum)

        } catch {
            print("Failed to save completed task: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        CompletedTaskView()
    }
    .modelContainer(for: [TaskItemEntity.self, TaskScheduleEntity.self])
}



