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
        NavigationStack {
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
                        }
                    }
                    .frame(height: 300)
                    
                    // 축하 메시지
                    VStack(spacing: 10) {
                        Text("오늘의 할일을 모두 마쳤어요!")
                            .font(.headingFontMeidum)
                            .foregroundColor(.primary03)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
//                    // 돌아가기 버튼
//                    Button(action: {
//                        onDismiss()
//                    }) {
//                        CustomButtonLabel(title: "돌아가기")
//                    }
//                    .padding(.bottom, 50)
                }
            }
            .toolbar {
                // X 버튼 추가
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss() // 모달 닫기
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("ButtonSecondary"))
                    }
                }
            }
        }
    }
}

#Preview {
    AllTasksCompletedView(onDismiss: {})
}
