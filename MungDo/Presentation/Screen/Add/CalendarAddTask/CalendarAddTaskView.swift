//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CalendarAddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    
    let taskTitle: String
    let title: String = "\'심장사상충 약 먹이기\' 언제부터 시작할까요?"
    var onComplete: () -> Void
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.system(size: 37, weight: .semibold))
                    .padding(28)
                Spacer()
            }
            
            //달력 구현 영역
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 628, height: 403)
              .background(.white)
              .cornerRadius(20)
            
            HStack {
                Spacer()
                CustomButton(
                    action: { onComplete() },
                    title: "완료"
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
                currentDepth: 2,
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
//        CalendarAddTaskView()
//    }
//} 
