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

    var body: some View {
        HStack(alignment: .center, spacing: 16){
            ZStack {
                Circle()
                    .fill(Color("Secondary03"))
                    .frame(width: 96, height: 96)

                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            Text(title)
                .font(.system(size: 22, weight: .semibold))
        }

        .padding(.vertical, 46)
        .padding(.horizontal, 41)
        .frame(width: 316, height: 188, alignment: .topLeading)
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
        TaskTagCardView(title: "심장사상충 약\n먹이기", image: Image("heartwormIcon"), isSelected: true)
        TaskTagCardView(title: "산책하기", image: Image("walkIcon"), isSelected: false)
    }
    .padding()
    .background(Color("BackgroundPrimary"))
}
