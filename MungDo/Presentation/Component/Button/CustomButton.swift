//
//  CustomButton.swift
//  MungDo
//
//  Created by 제하맥 on 6/2/25.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let title: String
    var isEnabled: Bool = true
    var width: CGFloat = 316
    var height: CGFloat = 64
    var fontSize: CGFloat = 20
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(isEnabled ? Color.buttonPrimary : Color.buttonDisable)
                .cornerRadius(18)
        }
        .disabled(!isEnabled)
    }
}

