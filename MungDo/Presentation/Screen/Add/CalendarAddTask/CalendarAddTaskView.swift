//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CalendarAddTaskView: View {
    let title: String = "\'심장사상충 약 먹이기\' 언제부터 시작할까요?"
    let buttonTitle: String = "완료"
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.dismiss) private var dismiss
    
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
                    title: buttonTitle,
                    isEnabled: true
                ) {
                    //버튼 기능 구현 필요

                }
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

#Preview {
    NavigationStack {
        CalendarAddTaskView()
    }
} 
