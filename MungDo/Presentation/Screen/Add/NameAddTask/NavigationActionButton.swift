//
//  NavigationActionButtonView.swift
//  MungDo
//
//  Created by 제하맥 on 6/1/25.
//


import SwiftUI

struct NavigationActionButton: View { // 수정
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 316, height: 64)
                .background(isEnabled ? Color.buttonPrimary : Color.buttonDisable)
                .cornerRadius(18)
        }
        .disabled(!isEnabled)
    }
}
