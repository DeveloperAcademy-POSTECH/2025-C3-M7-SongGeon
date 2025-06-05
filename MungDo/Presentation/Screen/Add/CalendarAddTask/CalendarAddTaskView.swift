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
        VStack(spacing: 40) {
            // 제목
            HStack {
                Text("'\(taskType.displayName)' 언제부터 시작할까요?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            //MARK: - 캘린더 view
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 628, height: 403)
                    .background(.white)
                    .cornerRadius(20)
                TestCalendarView(showDots: false)
                    .aspectRatio(1.6, contentMode: .fit)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .frame(maxWidth: 600)
                Spacer()
            }
            //Todo - selectedDate 가 먼저 선택되도록 수정
            //Todo - 만약 사용자가 다른 Date를 선택하면 그 값을 selectedDate로 저장하기
            
            Spacer()
            
            // 완료 버튼
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
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundPrimary"))
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
        CalendarAddTaskView(
            taskType: .walk,
            onComplete: {},
            selectedDate: Date()
        )
    }
}
