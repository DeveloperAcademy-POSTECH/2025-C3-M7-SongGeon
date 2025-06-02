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
        VStack(alignment: .leading, spacing: 0) {
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
        .padding(55)
        .background(Color.backgroundPrimary)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12, height: 20)
                        .foregroundColor(Color.buttonSecondary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                DepthIndicator(current: 1, total: 2)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Rectangle()
                    .frame(width: 22, height: 36)
                    .opacity(0)
            }
        }
        .toolbarBackground(Color.backgroundPrimary, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        NameAddTaskView()
    }
} 
