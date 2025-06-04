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
            
            // 캘린더 영역
            HStack {
                Spacer()
                TestCalendarView()
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
            
            Spacer()
            
            // 완료 버튼
            HStack {
                Spacer()
                Button(action: {
                    onComplete()
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
        CalendarAddTaskView(taskType: .vaccination, onComplete: {})
    }
} 
