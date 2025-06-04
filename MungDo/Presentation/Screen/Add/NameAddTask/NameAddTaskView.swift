//
//  AddNameTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct NameAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTaskType: TaskType? = nil
    @State private var path = NavigationPath()
    
    let title: String = "어떤 일을 추가할까요?"
    var onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // 제목
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            
            // 태스크 카드 그리드
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 24
            ) {
                ForEach(TaskType.allCases) { taskType in
                    TaskTagCardView(
                        title: taskType.displayName,
                        isSelected: selectedTaskType == taskType
                    )
                    .onTapGesture {
                        if selectedTaskType == taskType {
                            selectedTaskType = nil
                        } else {
                            selectedTaskType = taskType
                        }
                    }
                }
            }
            
            Spacer()
            
            // 다음 버튼
            HStack {
                Spacer()
                if let selectedTask = selectedTaskType {
                    NavigationLink(
                        destination: CalendarAddTaskView(
                            taskType: selectedTask,
                            onComplete: onComplete
                        )
                    ) {
                        CustomButtonLabel(title: "다음")
                    }
                } else {
                    CustomButtonLabel(title: "다음", isEnabled: false)
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundPrimary"))
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTaskType = nil
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

#Preview {
    NavigationStack {
        NameAddTaskView(onComplete: {})
    }
}
