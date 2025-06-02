//
//  AddNameTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct NameAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex: Int? = nil
    @State private var path = NavigationPath()
    
    let taskTitles = [
            "심장사상충 약\n먹이기",
            "산책하기",
            "광견병·코로나\n예방접종하기",
            "목욕하기",
            "외부기생충 약\n먹이기"
        ]
    let title: String = "어떤 일을 추가할까요?"
    var onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text(title)
                .font(.system(size: 37, weight: .semibold))
                .padding(28)
            
            //Mark: 태스크 카드를 Grid로 나열
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 28) {
                ForEach(taskTitles.indices, id: \.self) { index in
                    TaskTagCardView(title: taskTitles[index], isSelected: selectedIndex == index)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
            
            HStack {
                Spacer()
                CustomButton(
                    action: {
                        if let selectedIndex = selectedIndex {
                            let selectedTitle = taskTitles[selectedIndex]
                            path.append(selectedTitle) // 목적지로 이동
                        }
                    },
                    title: "다음",
                    isEnabled: selectedIndex != nil
                )
                Spacer()
            }
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            CustomToolBar(
                showDepth: true,
                currentDepth: 1,
                totalDepth: 2,
                onBack: {
                    dismiss()
                }
            )
        }
    }
}

//#Preview {
//    NavigationStack {
//        NameAddTaskView()
//    }
//} 
