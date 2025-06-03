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
        VStack(alignment: .leading, spacing: 28) {

            Text(title)
                .font(.system(size: 37, weight: .semibold))
                .padding(28)
            
            //Mark: 태스크 카드를 Grid로 나열
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 28) {
                ForEach(TaskType.allCases) { taskType in
                    TaskTagCardView(
                        title: taskType.displayName,
                        isSelected: selectedTaskType == taskType)
                        .onTapGesture {
                            selectedTaskType = taskType
                        }
                }
            }
            .padding(.bottom, 40)

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
                    // 비활성화된 버튼처럼 보이도록 디자인
                    CustomButtonLabel(title: "다음", isEnabled: false)
                }
                Spacer()
            }
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            CustomToolBar(
                showDepth: true,
                currentDepth: 1,
                totalDepth: 2,
                onBack: {
                    dismiss()
                }
            )
        }

    }
}

#Preview {
    NavigationStack {
        NameAddTaskView(onComplete: {})
    }
}
