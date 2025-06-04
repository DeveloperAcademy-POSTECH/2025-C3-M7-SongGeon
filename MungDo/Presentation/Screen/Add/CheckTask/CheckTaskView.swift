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
        GeometryReader { geometry in
            HStack(spacing: geometry.size.width * 0.03) { // 화면 너비의 3%
                // 왼쪽 캘린더 (전체 너비의 60%)
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .aspectRatio(1.0, contentMode: .fit) // 정사각형 비율 유지
                        
                        TestCalendarView()
                            .padding(.all, geometry.size.width * 0.015) // 너비의 1.5%만큼 패딩
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.6)
                
                // 오른쪽 태스크 리스트 (전체 너비의 35%)
                VStack(spacing: geometry.size.height * 0.025) { // 높이의 2.5%
                    // 제목
                    HStack {
                        Text("오늘의 일정")
                            .font(.system(size: geometry.size.width * 0.02, weight: .bold)) // 너비 기반 폰트
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    // 태스크 리스트
                    ScrollView {
                        LazyVStack(spacing: geometry.size.height * 0.015) { // 높이의 1.5%
                            ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                                TaskListItemView(taskItem: $tasks[index])
                            }
                        }
                        .padding(.vertical, geometry.size.height * 0.01)
                    }
                    .frame(maxHeight: geometry.size.height * 0.5) // 최대 높이 50%
                    
                    Spacer()
                    
                    // 추가하기 버튼
                    Button(action: { showTaskFlow = true }) {
                        CustomButtonLabel(title: "추가하기")
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.35)
            }
            .padding(.all, geometry.size.width * 0.04) // 전체 너비의 4%만큼 패딩
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
