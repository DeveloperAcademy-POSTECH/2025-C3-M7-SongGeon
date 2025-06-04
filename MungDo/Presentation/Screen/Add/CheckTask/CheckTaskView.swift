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
                
                Button(action: { showTaskFlow = true }) {
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
                NameAddTaskView(onComplete: {
                    showTaskFlow = false
                })
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

// 태스크 리스트 아이템 뷰
struct TaskListItemView: View {
    @Binding var taskItem: TaskItem
    
    var body: some View {
        HStack(spacing: 16) {
            // 아이콘
            ZStack {
                Circle()
                    .fill(taskItem.taskType == .vaccination ? Color.red.opacity(0.1) : Color.orange.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                if taskItem.taskType == .vaccination {
                    Image(systemName: "cross.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                } else {
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 20))
                }
            }
            
            // 제목
            VStack(alignment: .leading, spacing: 2) {
                Text(taskItem.taskType.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // 완료 체크박스
            Button(action: {
                taskItem.isCompleted.toggle()
            }) {
                ZStack {
                    Circle()
                        .stroke(taskItem.isCompleted ? Color.green : Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if taskItem.isCompleted {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        CheckTaskView()
    }
} 
