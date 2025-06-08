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
    
    let title: String = "어떤 일을 추가할까요?"
    var onComplete: () -> Void
    var selectedDate: Date
    
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 50)
                    .padding(.leading, 50)
                Spacer()
                
                // 태스크 카드 그리드
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 30
                ) {
                    ForEach(TaskType.allCases) { taskType in
                        TaskTagCardView(
                            title: taskType.displayName,
                            image: taskType.displayIcon,
                            isSelected: selectedTaskType == taskType,
                            cycleText: taskType.cycleDisplayText
                        )
                        .onTapGesture {
                            if selectedTaskType == taskType {
                                selectedTaskType = nil
                            } else {
                                selectedTaskType = taskType
                            }
                        }
                    }
//                    .padding(.bottom, 40)
                }
                Spacer()
                HStack {
                    Spacer()
                    if let selectedTask = selectedTaskType {
                        NavigationLink(
                            destination: CalendarAddTaskView(
                                taskType: selectedTask,
                                onComplete: onComplete,
                                selectedDate: self.selectedDate
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
}

#Preview {
    NavigationStack {
        NameAddTaskView(onComplete: {}, selectedDate: Date())
    }
}
