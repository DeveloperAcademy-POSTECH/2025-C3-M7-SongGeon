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
        TaskItem(title: "산책하기", isCompleted: true, imageName: "walkIcon"),
        TaskItem(title: "광견병•코로나 예방접종하기", isCompleted: true, imageName: "vaccinationIcon"),
        TaskItem(title: "목욕하기", isCompleted: true, imageName: "bathIcon"),
        TaskItem(title: "외부기생충 약 먹이기", isCompleted: true, imageName: "externalParasiteIcon"),
    ]

    // 완료된 태스크만 필터링
    private var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
    }

    // 모든 태스크 완료 여부 확인
    private var allTasksCompleted: Bool {
        return tasks.allSatisfy { $0.isCompleted }
    }

    //db 확인용
    @StateObject private var addService = CompletedTaskAddService()
    // 임시로 넣어 둔 user 번호 (식별)
    let userNum: Int = 1011112222

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
                        let task = completedTasks[currentIndex]
                            addService.taskDisplayName = task.title
                            addService.taskDoneDate = Date()

                            // 2) DB 저장 트리거
                            addService.saveTaskToDb(num: userNum)
                        
                        
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
        }
        .toolbarBackground(Color("BackgroundPrimary"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}




#Preview {
    NavigationStack {
        CompletedTaskView()
    }
}


