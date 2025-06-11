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
            Spacer()
            VStack(spacing: 16) {
                // 완전히 한 문장으로 통합
                HStack {
                    Text("'\(taskType.displayName)'가 ")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text("\(dateFormatter.string(from: selectedDate))")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.buttonSecondary)
                    Text("부터 \(taskType.defaultCycleDescription) 주기로 반복돼요.")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .padding(.top, 40)
            .padding(.horizontal)
            
            //Spacer()
            
            // 캘린더 view
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 850, height: 600)
                    .background(.white)
                    .cornerRadius(20)
                
                FSCustomCalendarView(currentPage: selectedDate, selectedDate: $selectedDate)
                    .frame(width: 800, height: 550)
                //                TestCalendarView(selectedDate: $selectedDate)
                //                    .aspectRatio(1.6, contentMode: .fit)
                //                    .padding()
                //                    .background(
                //                        RoundedRectangle(cornerRadius: 20)
                //                            .fill(Color.white)
                //                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                //                    )
                //                    .frame(maxWidth: 600)
                
            }
            .padding(.top, 10)
            .padding(.bottom, 50)
            //Spacer()
            
            // 완료 버튼
            HStack {
                Spacer()
                Button(action: {
                    saveTasks()
                    onComplete()
                }) {
                    CustomButtonLabel(title: "다 됐어요")
                }
                Spacer()
            }
            .padding(.bottom, 40)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundPrimary"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomToolBar(onBack: {dismiss()}, showXMark: true, onXMark: {onComplete()})
        }
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
