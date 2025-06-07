//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI
import SwiftData

struct CalendarAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    let taskType: TaskType
    var onComplete: () -> Void
    @State var selectedDate: Date
    
    
    init(taskType: TaskType, onComplete: @escaping () -> Void, selectedDate: Date) {
        self.taskType = taskType
        self.onComplete = onComplete
        self.selectedDate = selectedDate
    }

    var body: some View {
        VStack(spacing: 40) {
            // 제목
            HStack {
                Text("'\(taskType.displayName)' 언제부터 시작할까요?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }

            // 캘린더 view
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 628, height: 403)
                    .background(.white)
                    .cornerRadius(20)

                FSCustomCalendarView(selectedDate: $selectedDate)
                    .frame(width: 628, height: 403)
//                TestCalendarView(selectedDate: $selectedDate)
//                    .aspectRatio(1.6, contentMode: .fit)
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.white)
//                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
//                    )
//                    .frame(maxWidth: 600)
                Spacer()
            }

            // 주기 안내 텍스트
            VStack(spacing: 8) {
                HStack {
                    Text("반복 주기")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                HStack {
                    Text("일주일마다 반복됩니다")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }

            Spacer()

            // 완료 버튼
            HStack {
                Spacer()
                Button(action: {
                    saveTasks()
                    onComplete()
                    
                }) {
                    CustomButtonLabel(title: "완료")
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundPrimary"))
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

    private func saveTasks() {
        let calendar = Calendar.current
        let cycleDays = taskType.defaultCycle // 7일

        // 선택한 날짜부터 3개의 태스크 생성
        for i in 0..<3 {
            guard let taskDate = calendar.date(byAdding: .day, value: i * cycleDays, to: selectedDate) else {
                continue
            }

            let newTask = TaskItemEntity(
                taskType: taskType,
                date: taskDate,
                isCompleted: false
            )
            modelContext.insert(newTask)
        }

        do {
            try modelContext.save()
            print("3 Tasks saved successfully for \(taskType.displayName)")
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        CalendarAddTaskView(
            taskType: .walk,
            onComplete: {},
            selectedDate: Date()
        )
    }
    .modelContainer(for: [TaskItemEntity.self, TaskScheduleEntity.self])
}
