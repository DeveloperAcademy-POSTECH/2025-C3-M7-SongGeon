//
//  ContentView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Text("MungDo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 30) {
                    NavigationLink(destination: CheckTaskView()) {
                        Text("Add Task")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: TodoListView()) {
                        Text("Todo List")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
