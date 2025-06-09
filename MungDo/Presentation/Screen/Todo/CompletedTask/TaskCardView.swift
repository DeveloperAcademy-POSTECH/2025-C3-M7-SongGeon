//
//  TaskCardView.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import SwiftUI

struct TaskCardView: View {
    let taskItem: TaskItem
    @State private var isPressed = false

    var body: some View {
        VStack {
            Spacer()
            // 이미지 중앙 배치
            ZStack {
                Circle()
                    .fill(Color("Secondary03"))
                    .frame(width: 213, height: 213)
                
                // TaskType의 displayIcon 사용
                if(taskItem.isCompleted){
                    Image("checked")
                }
                else{
                    taskItem.taskType.displayIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color.pink)
                }
                
            }
            // 텍스트는 이미지 바로 아래
            Text(taskItem.taskType.displayName)
                .font(.system(size: 27, weight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    TaskCardView(taskItem: TaskItem(taskType: .walk, date: Date(), isCompleted: false))
        .frame(width: 647, height: 403)
        .padding()
}
