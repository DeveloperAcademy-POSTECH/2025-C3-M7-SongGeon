//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CalendarAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    let taskType: TaskType
    var onComplete: () -> Void
    var selectedDate: Date
    
    var body: some View {
        VStack{
            HStack{
                Text("'\(taskType.displayName)' 언제부터 시작할까요?")
                    .font(.system(size: 37, weight: .semibold))
                    .padding(28)
                Spacer()
            }
            
            //MARK: - 캘린더 view
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 628, height: 403)
                    .background(.white)
                    .cornerRadius(20)
                TestCalendarView()
                    .frame(width: 600, height: 380)
            }
            //Todo - selectedDate 가 먼저 선택되도록 수정
            //Todo - 만약 사용자가 다른 Date를 선택하면 그 값을 selectedDate로 저장하기
            
            HStack {
                Spacer()
                Button(action: {
                    onComplete()
                    let newSchedule = TaskSchedule(taskType: self.taskType, startDate: self.selectedDate)
                    //Todo - 생성한 TaskSchedule을 저장하는 로직이 필요
                }) {
                    CustomButtonLabel(title: "완료")
                }
                Spacer()
            }
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color("BackgroundPrimary"))
        .navigationBarBackButtonHidden(true)
        .toolbar{
            CustomToolBar(
                showDepth: true,
                currentDepth: 2,
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
        CalendarAddTaskView(
            taskType: .walk,
            onComplete: {},
            selectedDate: Date()
        )
    }
}
