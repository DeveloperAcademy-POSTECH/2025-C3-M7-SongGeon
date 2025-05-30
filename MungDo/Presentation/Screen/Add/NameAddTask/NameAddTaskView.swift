//
//  AddNameTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct NameAddTaskView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Add Name Task View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("태스크 이름을 추가하는 화면입니다")
                .font(.body)
                .foregroundColor(.gray)
            
            NavigationLink(destination: CalendarAddTaskView()) {
                Text("Next: Calendar")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Add Name")
    }
}

#Preview {
    NavigationStack {
        NameAddTaskView()
    }
} 
