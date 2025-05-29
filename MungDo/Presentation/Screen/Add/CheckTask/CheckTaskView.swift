//
//  CheckTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CheckTaskView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Check Task View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("태스크를 체크하는 화면입니다")
                .font(.body)
                .foregroundColor(.gray)
            
            NavigationLink(destination: AddNameTaskView()) {
                Text("Next: Add Name")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Check Task")
    }
}

#Preview {
    NavigationStack {
        CheckTaskView()
    }
} 
