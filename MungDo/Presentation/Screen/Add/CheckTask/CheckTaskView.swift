//
//  CheckTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CheckTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTaskFlow = false
    
    // 샘플 태스크 데이터
    @State private var tasks: [TaskItem] = [
        TaskItem(taskType: .vaccination, date: Date(), isCompleted: true),
        TaskItem(taskType: .heartworm, date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), isCompleted: false)
    ]
    
    var body: some View {
        HStack(spacing: 40) {
            // 왼쪽 캘린더
            VStack {
                TestCalendarView()
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
                    Text("오늘의 일정")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                            TaskListItemView(taskItem: $tasks[index])
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
                NameAddTaskView(onComplete: {
                    showTaskFlow = false
                })
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
}

// TaskItem 모델
struct TaskItem: Identifiable, Hashable, Equatable {
    let id = UUID()
    let taskType: TaskType
    let date: Date
    var isCompleted: Bool
    
    init(taskType: TaskType, date: Date, isCompleted: Bool = false) {
        self.taskType = taskType
        self.date = date
        self.isCompleted = isCompleted
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // Equatable 구현
    static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    NavigationStack {
        CheckTaskView()
    }
} 
