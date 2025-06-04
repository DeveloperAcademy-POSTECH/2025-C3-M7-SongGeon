//
//  CompletedTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CompletedTaskView: View {
    // 임시 데이터 모델
    struct TaskItem {
        let id = UUID()
        let title: String
        let isCompleted: Bool
        let imageName: String
    }

    // 임시 데이터
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "숨이 심장사상충 약 먹이기", isCompleted: true, imageName: ""),
        TaskItem(title: "산책 30분 하기", isCompleted: true, imageName: ""),
        TaskItem(title: "사료 챙겨주기", isCompleted: true, imageName: ""),
        TaskItem(title: "목욕시키기", isCompleted: true, imageName: ""),
        TaskItem(title: "병원 예약하기", isCompleted: true, imageName: ""),
        TaskItem(title: "놀아주기", isCompleted: true, imageName: "")
    ]

    // 완료된 태스크만 필터링
    private var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
    }

    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // 배경색
            Color(.backgroundPrimary)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                if completedTasks.isEmpty {
                    // 완료된 태스크가 없을 때
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)

                        Text("완료된 일정이 없습니다")
                            .font(.title2)
                            .foregroundColor(.gray)

                        Text("일정을 추가하고 완료해보세요!")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                } else {

                    // 카드 캐러셀
                    GeometryReader { geometry in
                        let cardWidth: CGFloat = 647
                        let cardSpacing: CGFloat = 20

                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: cardSpacing) {
                                ForEach(Array(completedTasks.enumerated()), id: \.element.id) { index, task in
                                    TaskCardView(task: task)
                                        .frame(width: cardWidth, height: 403)
                                        .scaleEffect(index == currentIndex ? 1.0 : 0.9)
                                        .opacity(index == currentIndex ? 1.0 : 0.7)
                                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                }
                            }
                            .padding(.horizontal, (geometry.size.width - cardWidth) / 2)
                        }
                        .content
                        .offset(x: -CGFloat(currentIndex) * (cardWidth + cardSpacing))
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    if value.translation.width > threshold && currentIndex > 0 {
                                        currentIndex -= 1
                                    } else if value.translation.width < -threshold && currentIndex < completedTasks.count - 1 {
                                        currentIndex += 1
                                    }
                                }
                        )
                    }
                    .frame(height: 420)
                    .clipped()

                    // 페이지 인디케이터
                    HStack(spacing: 8) {
                        ForEach(0..<completedTasks.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.pink : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        }
                    }

                    // 완료됨 버튼 (카드 밖으로 이동)
                    Button(action: {
                        // 완료 취소 액션
                        print("완료 취소 버튼 탭됨")
                    }) {
                        HStack {

                            Text("완료")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 120)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.buttonPrimary)
                        )
                        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
        }
//        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                        .foregroundColor(Color.buttonSecondary)
                }
            }

//            ToolbarItem(placement: .principal) {
//                Text("완료된 할 일")
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(.black)
//            }
        }
        .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

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
                Image(systemName: task.imageName)
                    .font(.system(size: 50))
                    .foregroundColor(.pink)
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

#Preview {
    NavigationStack {
        CompletedTaskView()
    }
}
