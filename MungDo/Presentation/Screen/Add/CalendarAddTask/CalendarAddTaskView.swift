//
//  CalendarAddTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CalendarAddTaskView: View {
    let title: String = "\'심장사상충 약 먹이기\' 언제부터 시작할까요?"
    
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
            
            HStack{
                Spacer()
                NavigationLink(destination: CheckTaskView()) {
                    Text("완료")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 316, height: 64)
                        .background( Color.buttonPrimary)
                        .cornerRadius(18)
                }
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
        CalendarAddTaskView()
    }
} 
