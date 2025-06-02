//
//  CheckTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CheckTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Check Task View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("태스크를 체크하는 화면입니다")
                .font(.body)
                .foregroundColor(.gray)
            
            NavigationLink(destination: NameAddTaskView()) {
                Text("Next: Add Name")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar{
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
