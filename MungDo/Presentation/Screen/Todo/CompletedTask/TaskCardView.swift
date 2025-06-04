//
//  TaskCardView.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import SwiftUI

struct TaskCardView: View {
    let task: CompletedTaskView.TaskItem
    @State private var isPressed = false

    var body: some View {
        VStack {
            Spacer()
            // 이미지 중앙 배치
            ZStack {
                Circle()
                    .fill(Color.pink.opacity(0.1))
                    .frame(width: 213, height: 213)
                
                // 이미지 에셋 사용 (fallback으로 시스템 이미지)
                if !task.imageName.isEmpty {
                    Image(task.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.pink)
                } else {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.pink)
                }
            }
            // 텍스트는 이미지 바로 아래
            Text(task.title)
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
