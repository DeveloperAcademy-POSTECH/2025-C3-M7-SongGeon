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
    @Query private var allTaskItems: [TaskItemEntity]
    
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
            
            VStack(spacing: 16) {
                // 완전히 한 문장으로 통합
                HStack {
                    Text("'\(taskType.displayName)'가 \(dateFormatter.string(from: selectedDate))부터 \(taskType.defaultCycleDescription) 반복돼요.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                }
                // 주기 안내 텍스트
                VStack {
                    HStack {
                        Text("반복 주기")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer()
                    }
            }
            
                // 반복 주기 수정
                HStack {
                    Text(taskType.defaultCycleDescription)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)

                    Spacer()
                }
            }
            .padding(.horizontal)

            Spacer()

            // 캘린더 view
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 700, height: 450)
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
            .padding(.top, 50)
            Spacer()

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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")

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
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }

    private func saveTasks() {
        let calendar = Calendar.current
        let cycleDays = taskType.defaultCycle // 7일

        // 선택한 날짜부터 3개의 태스크 생성
        for i in 0..<3 {
            guard let taskDate = calendar.date(byAdding: .day, value: i * cycleDays, to: selectedDate) else {
                continue
            }
            if !allTaskItems.filter{$0.date == taskDate && $0.taskType == taskType}.isEmpty{
                print("이미 있는 태스크임")
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
