//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CalendarAddTaskView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Calendar Add Task View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("캘린더에서 날짜를 선택하는 화면입니다")
                .font(.body)
                .foregroundColor(.gray)
            
            Button(action: {
                // 태스크 저장 로직
            }) {
                Text("Save Task")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Calendar")
    }
}

#Preview {
    NavigationStack {
        CalendarAddTaskView()
    }
} 