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
    let title: String = "어떤 일을 추가할까요?"
    let buttonTitle: String = "다음"
    
    @State private var selectedIndex: Int? = nil
    @State private var goToNext = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            CustomNavigationBar(
                showDepth: true,
                currentDepth: 1,
                totalDepth: 2,
                onBack: {
                    dismiss()
                }
            )
            
            Text(title)
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
            
            HStack {
                Spacer()
                NavigationActionButton(
                    title: buttonTitle,
                    isEnabled: selectedIndex != nil
                ) {
                    goToNext = true
                }
                Spacer()
            }
            .padding(.bottom, 28)
            
            NavigationLink(
                destination: CalendarAddTaskView(),
                //다음 페이지로 선택한 task 카테고리 전달하기
                //destination: {
                //  if let selectedIndex = selectedIndex {
                //                      CalendarAddTaskView(taskTitle: taskTitles[selectedIndex])
                //                        }
                //                    },
                isActive: $goToNext,
                label: {
                    EmptyView()
                }
            )
            .padding(28)
        }
        .padding(55)
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true) //수정: 기본 뒤로가기 버튼 숨김
        .navigationBarHidden(true) //수정: 기본 내비게이션 바 숨김
    }
}

#Preview {
    NavigationStack {
        NameAddTaskView()
    }
} 
