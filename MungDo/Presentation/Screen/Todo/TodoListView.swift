//
//  TodoListView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct TodoListView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Todo List View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("할 일 목록을 관리하는 화면입니다\n추후에 이 화면은 없어지고 완료 되면 완료 페이지, 완료 되지 않았다면 미완료 페이지를 띄우는 식.")
                .font(.body)
                .foregroundColor(.gray)
            
            VStack(spacing: 20) {
                NavigationLink(destination: CompletedTaskView()) {
                    Text("Completed Tasks")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: UnfinishedTaskView()) {
                    Text("Unfinished Tasks")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Todo List")
    }
}

#Preview {
    NavigationStack {
        TodoListView()
    }
} 
