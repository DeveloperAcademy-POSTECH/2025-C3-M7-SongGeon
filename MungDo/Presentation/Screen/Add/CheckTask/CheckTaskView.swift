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
        HStack(spacing: 40){
            // 왼쪽 캘린더
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 680 , height: 680)
                    .background(.white)
                    .cornerRadius(20)
                TestCalendarView()
                    .frame(width: 656 , height: 620)
            }
            
            // 오른쪽 태스크 리스트
            VStack(spacing: 20) {
                HStack {
                    Text("오늘의 일정")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                            TaskListItemView(taskItem: $tasks[index])
                        }
                    }
                    .padding(.vertical, 8)
                }
                .frame(maxHeight: 400)
                
                Spacer()
                
                Button(action: {showTaskFlow = true }) {
                    CustomButtonLabel(title: "추가하기")
                }
            }
            .frame(width: 400)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color("BackgroundPrimary"))
        .fullScreenCover(isPresented: $showTaskFlow) {
            NavigationStack {
                NameAddTaskView(
                    onComplete: { showTaskFlow = false },
                    selectedDate: Date()
                    // to: 이토
                    // 달력에서 선택한 날짜가 전달되도록 수정해주신다면 감사감사
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomToolBar(
                showDepth: false,
                onBack: {
                    dismiss()
                }
            )
        }
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
