//
//  AllTasksCompletedView.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import SwiftUI

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
