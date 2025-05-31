//
//  AddNameTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct NameAddTaskView: View {
    let taskTitles = [
            "심장사상충 약\n먹이기",
            "산책하기",
            "광견병·코로나\n예방접종하기",
            "목욕하기",
            "외부기생충 약\n먹이기"
        ]
    
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text("어떤 일을 추가할까요?")
                .font(.system(size: 37, weight: .semibold))
                .padding(28)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 28) {
                ForEach(taskTitles.indices, id: \.self) { index in
                    TaskCardView(title: taskTitles[index], isSelected: selectedIndex == index)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }

            HStack{
                Spacer()
                NavigationLink(destination: CalendarAddTaskView()) {
                    Text("다음")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 316, height: 64)
                        .background(selectedIndex == nil ? Color.buttonDisable : Color.buttonPrimary)
                        .cornerRadius(18)
                }
                .disabled(selectedIndex == nil)
                Spacer()
            }
            .padding(.bottom, 28)
        }
        .padding(55)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    NavigationStack {
        NameAddTaskView()
    }
} 
