//
//  UnfinishedTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct UnfinishedTaskView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Unfinished Task View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("미완료된 태스크들을 보여주는 화면입니다")
                .font(.body)
                .foregroundColor(.gray)
            
            // 미완료된 태스크 목록 (임시)
            VStack(spacing: 10) {
                Text("🔲 미완료 태스크 1")
                Text("🔲 미완료 태스크 2")
                Text("🔲 미완료 태스크 3")
            }
            .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Unfinished Tasks")
    }
}

#Preview {
    NavigationStack {
        UnfinishedTaskView()
    }
} 