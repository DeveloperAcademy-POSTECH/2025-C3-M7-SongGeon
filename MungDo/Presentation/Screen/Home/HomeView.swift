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
            ZStack {
                Color.backgroundPrimary.edgesIgnoringSafeArea(.all)
                VStack(spacing: 50) {

                    
                    HStack() {
                        NavigationLink(destination: CheckTaskView()) {
                            HomeCardView(image:Image("Home/home_add"), title:"날짜별로 모아보기")
                        }
                        
                        NavigationLink(destination: TodoListView()) {
                            HomeCardView(image:Image("Home/home_look"), title:"오늘 할 일 열어놓기")
                        }
                    }
                    .padding(.horizontal, 48)
                }
            }
            //.navigationTitle("Home")
        }
    }
}




#Preview {
    HomeView()
}
