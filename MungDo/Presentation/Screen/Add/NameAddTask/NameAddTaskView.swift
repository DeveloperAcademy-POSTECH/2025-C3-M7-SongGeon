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
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 16) {
                    Text(title)
                        .font(.headingFontMeidum)
                        .foregroundColor(.primary03)
                    Spacer()
                    
                    // 태스크 카드 그리드
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                    ) {
                        ForEach(TaskType.allCases) { taskType in
                            TaskTagCardView(
                                title: taskType.displayName,
                                image: taskType.displayIcon,
                                isSelected: selectedTaskType == taskType,
                                cycleText: taskType.defaultCycleDescription
                            )
                            .onTapGesture {
                                if selectedTaskType == taskType {
                                    selectedTaskType = nil
                                } else {
                                    selectedTaskType = taskType
                                }
                            }
                            .padding(geometry.size.height*0.01)
                        }
                        .frame(height: geometry.size.height*0.3)
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
                                .shadow(color: Color(red: 1, green: 0.44, blue: 0.38).opacity(0.2), radius: 6, x: 4, y: 4)
                        }
                        Spacer()
                    }
                }
                .padding(geometry.size.height*0.05)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundPrimary"))
        .contentShape(Rectangle())
        .onTapGesture {
            selectedTaskType = nil
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            CustomToolBar(showBack:false, onBack: {},showXMark: true, onXMark: {onComplete()})
        }
    }
}

#Preview {
    NavigationStack {
        NameAddTaskView(onComplete: {}, selectedDate: Date())
    }
}
