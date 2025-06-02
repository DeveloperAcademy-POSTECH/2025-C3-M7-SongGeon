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

            Text(title)
                .font(.system(size: 37, weight: .semibold))
                .padding(28)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 28) {
                ForEach(taskTitles.indices, id: \.self) { index in
                    TaskTagCardView(title: taskTitles[index], isSelected: selectedIndex == index)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
            .padding(.bottom, 40)

            HStack {
                Spacer()
                CustomButton(
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
                isActive: $goToNext,
                label: {
                    EmptyView()
                }
            )
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

#Preview {
    NavigationStack {
        NameAddTaskView()
    }
} 
