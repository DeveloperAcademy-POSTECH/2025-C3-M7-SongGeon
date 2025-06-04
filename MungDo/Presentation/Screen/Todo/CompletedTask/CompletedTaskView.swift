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
        TaskItem(title: "심장사상충 약 먹이기", isCompleted: true, imageName: "heartwormIcon"),
        TaskItem(title: "산책 30분 하기", isCompleted: true, imageName: "walkIcon"),
        TaskItem(title: "광견병·코로나 예방접종하기", isCompleted: true, imageName: "vaccinationIcon"),
        TaskItem(title: "목욕시키기", isCompleted: true, imageName: "bathIcon"),
        TaskItem(title: "외부기생충 약 먹이기", isCompleted: true, imageName: "externalParasiteIcon"),
        TaskItem(title: "놀아주기", isCompleted: true, imageName: "walkIcon")
    ]

    // 완료된 태스크만 필터링
    private var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
    }

    // 모든 태스크 완료 여부 확인
    private var allTasksCompleted: Bool {
        return tasks.allSatisfy { $0.isCompleted }
    }

    @State private var currentIndex = 0
    @Environment(\.dismiss) private var dismiss
    @State private var showCelebration = false

    var body: some View {
        ZStack {
            // 배경색
            Color("BackgroundPrimary")
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
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 20) {
                                // 첫 번째 셀을 가운데에 오게 하기 위한 leading spacer
                                Spacer()
                                    .frame(width: (UIScreen.main.bounds.width - 647) / 2)
                                
                                ForEach(Array(completedTasks.enumerated()), id: \.element.id) { index, task in
                                    TaskCardView(task: task)
                                        .frame(width: 647, height: 403)
                                        .scaleEffect(index == currentIndex ? 1.0 : 0.9)
                                        .opacity(index == currentIndex ? 1.0 : 0.7)
                                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                        .id(index)
                                }
                                
                                // 마지막 셀을 가운데에 오게 하기 위한 trailing spacer
                                Spacer()
                                    .frame(width: (UIScreen.main.bounds.width - 647) / 2)
                            }
                        }
                        .scrollDisabled(true) // 수동 스크롤 비활성화
                        .onChange(of: currentIndex) { oldValue, newValue in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        if value.translation.width > threshold && currentIndex > 0 {
                                            currentIndex -= 1
                                        } else if value.translation.width < -threshold && currentIndex < completedTasks.count - 1 {
                                            currentIndex += 1
                                        }
                                    }
                                }
                        )
                    }

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
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if currentIndex < completedTasks.count - 1 {
                                currentIndex += 1
                            } else {
                                // 마지막 카드에서 모든 태스크가 완료되었다면 축하 화면으로
                                if allTasksCompleted {
                                    showCelebration = true
                                } else {
                                    // 마지막 카드에서는 처음으로 돌아가기
                                    currentIndex = 0
                                }
                            }
                        }
                    }) {
                        HStack {
                            let isLastCard = currentIndex >= completedTasks.count - 1
                            let buttonText = if allTasksCompleted && isLastCard {
                                "완료!"
                            } else if isLastCard {
                                "처음으로"
                            } else {
                                "다음"
                            }
                            
                            Text(buttonText)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 120)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color("ButtonPrimary"))
                        )
                        .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCelebration) {
            AllTasksCompletedView(onDismiss: {
                showCelebration = false
            })
        }
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
//            ToolbarItem(placement: .principal) {
//                Text("완료된 할 일")
//                    .font(.system(size: 20, weight: .semibold))
//                    .foregroundColor(.black)
//            }
        }
        .toolbarBackground(Color("BackgroundPrimary"), for: .navigationBar)
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

struct AllTasksCompletedView: View {
    let onDismiss: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 배경
            Color("BackgroundPrimary")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // 축하 애니메이션과 강아지 일러스트
                ZStack {
                    // Confetti 효과
                    ForEach(0..<20, id: \.self) { index in
                        ConfettiPiece(index: index)
                    }
                    
                    // 강아지 일러스트 (임시로 시스템 이미지 사용)
                    VStack(spacing: 20) {
                        Image(systemName: "dog.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.brown)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: true)
                        
                        // 실제로는 강아지 일러스트 이미지를 사용
                        // Image("celebration_dog")
                        //     .resizable()
                        //     .scaledToFit()
                        //     .frame(width: 200, height: 200)
                    }
                }
                .frame(height: 300)
                
                // 축하 메시지
                VStack(spacing: 10) {
                    Text("오늘의 할일을 모두 마쳤어요!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // 돌아가기 버튼
                Button(action: {
                    onDismiss()
                }) {
                    Text("돌아가기")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 280, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color("ButtonPrimary"))
                        )
                        .shadow(color: .pink.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 50)
            }
            
            // 오른쪽 상단 X 버튼
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.8))
                            )
                    }
                    .padding(.top, 60)
                    .padding(.trailing, 30)
                }
                Spacer()
            }
        }
    }
}

// Confetti 효과를 위한 컴포넌트 (더 간단한 버전)
struct ConfettiPiece: View {
    let index: Int
    @State private var isAnimating = false
    
    var body: some View {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        let color = colors[index % colors.count]
        
        Rectangle()
            .fill(color)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .offset(
                x: isAnimating ? CGFloat.random(in: -200...200) : 0,
                y: isAnimating ? CGFloat.random(in: -300...300) : 0
            )
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(
                    .easeOut(duration: Double.random(in: 2...4))
                    .delay(Double.random(in: 0...2))
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    NavigationStack {
        CompletedTaskView()
    }
}


