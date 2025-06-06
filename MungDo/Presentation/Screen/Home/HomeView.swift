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
//                    Text("MungDo")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
                    
                    HStack() {
                        NavigationLink(destination: CheckTaskView()) {
//                            Text("Add Task")
//                                .font(.title2)
//                                .foregroundColor(.white)
//                                .frame(width: 200, height: 50)
//                                .background(Color.blue)
//                                .cornerRadius(10)
                            CardView(image:Image("Home/home_add"), title:"날짜별로 모아보기")
                        }
                        
                        NavigationLink(destination: TodoListView()) {
//                            Text("Todo List")
//                                .font(.title2)
//                                .foregroundColor(.white)
//                                .frame(width: 200, height: 50)
//                                .background(Color.green)
//                                .cornerRadius(10)
                            CardView(image:Image("Home/home_look"), title:"오늘 할 일 열어놓기")
                        }
                    }
                    .padding(.horizontal, 48)
                }
            }
            //.navigationTitle("Home")
        }
    }
}


struct CardView: View {
    
    let image: Image
    let title: String
    
    var body: some View {
        
            VStack(spacing: 16){
                ZStack{
                    RoundedRectangle(cornerRadius:20) 
                            .fill(Color("ButtonPrimary"))
                            //.frame(height: 200)
                    image
                        .resizable()
                        .scaledToFit()
                        //.frame(height: 150)
                        
                    
                }
                .frame(width: 400, height: 400)
                .padding(.horizontal,16)
               
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 48)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color("ButtonSecondary"))
                    .shadow(color: Color.buttonPrimary.opacity(0.4), radius: 20, x: 4, y: 4)
                    
            )
            .padding(.vertical, 32)
            .padding(16)
            
        
        
    }
        
}

#Preview {
    HomeView()
}
