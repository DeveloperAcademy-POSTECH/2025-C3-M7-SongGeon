//
//  CheckTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CheckTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTaskFlow = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Check Task View")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("태스크를 체크하는 화면입니다")
                .font(.body)
                .foregroundColor(.gray)

            CustomButton(
                action: {showTaskFlow = true},
                title: "추가하기"
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color.backgroundPrimary)
        .fullScreenCover(isPresented: $showTaskFlow) {
            NavigationStack {
                NameAddTaskView(onComplete: {
                    showTaskFlow = false
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomToolBar(
                showDepth: false,
                onBack: {
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        CheckTaskView()
    }
} 
