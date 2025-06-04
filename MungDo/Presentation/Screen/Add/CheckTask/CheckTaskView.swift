//
//  CheckTaskView.swift
//  MungDo
//
//  Created by cheshire on 5/29/25.
//

import SwiftUI

struct CheckTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTaskFlow = false
    
    var body: some View {
        HStack{
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 680 , height: 680)
                    .background(.white)
                    .cornerRadius(20)
                TestCalendarView()
                    .frame(width: 656 , height: 620)
            }
            Spacer()
            VStack(spacing: 30) {
                Text("Check Task View")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("태스크를 체크하는 화면입니다")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: { showTaskFlow = true }) {
                    CustomButtonLabel(title: "추가하기")
                }
                
               
            }
            Spacer()
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(55)
        .background(Color.backgroundPrimary)
        .fullScreenCover(isPresented: $showTaskFlow) {
            NavigationStack {
                NameAddTaskView(onComplete: {
                    showTaskFlow = false
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomToolBar(
                showDepth: false,
                onBack: {
                    dismiss()
                }
            )
        }
    }
}


#Preview {
    NavigationStack {
        CheckTaskView()
    }
} 
