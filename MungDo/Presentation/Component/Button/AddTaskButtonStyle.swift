//
//  Untitled.swift
//  MungDo
//
//  Created by 제하맥 on 6/11/25.
//
import SwiftUI

struct AddTaskButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bodyFontSmall)
            .foregroundColor(.neutrals01)
            .frame(maxWidth: .infinity, maxHeight: 64)
            .background(Color.primary01)
            .cornerRadius(18)
            .shadow(color: Color(red: 1, green: 0.44, blue: 0.38).opacity(0.2), radius: 6, x: 4, y: 4)
    }
}
