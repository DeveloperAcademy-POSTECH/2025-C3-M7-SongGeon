//
//  TaskCardView.swift
//  MungDo
//
//  Created by 제하맥 on 5/31/25.
//

import SwiftUI

struct TaskTagCardView: View {
    let title: String
    let image: Image
    let isSelected: Bool
    let cycleText: String

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 16){
                ZStack {
                    Circle()
                        .fill(Color("Secondary03"))
                        .frame(width: 120, height: 120)

                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(title)
                        .font(.bodyFontMedium)
                        .foregroundColor(Color.primary03)
                    Text(cycleText)
                        .font(.bodyFontLittle)
                        .foregroundColor(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.white)
        .cornerRadius(28)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .inset(by: 2)
                .stroke(isSelected ? Color("ButtonSecondary") : Color.clear, lineWidth: 4)
        )
        .shadow(color: isSelected ? Color.clear : Color(red: 1, green: 0.44, blue: 0.38).opacity(0.08),
                radius: 6, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 20) {
        TaskTagCardView(title: "심장사상충 약\n먹이기", image: Image("heartwormIcon"), isSelected: true, cycleText: "매일")
        TaskTagCardView(title: "산책하기", image: Image("walkIcon"), isSelected: false, cycleText: "매일")
    }
    .padding()
    .background(Color("BackgroundPrimary"))
}
