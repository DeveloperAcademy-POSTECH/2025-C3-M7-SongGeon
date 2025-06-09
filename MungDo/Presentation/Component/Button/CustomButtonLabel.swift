//
//  CustomButton.swift
//  MungDo
//
//  Created by 제하맥 on 6/2/25.
//

import SwiftUI

struct CustomButtonLabel: View {
    let title: String
    var isEnabled: Bool = true
    var width: CGFloat = 316
    var height: CGFloat = 64
    var fontSize: CGFloat = 24
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(.white)
            .frame(width: width, height: height)
            .background(isEnabled ? Color.buttonPrimary : Color.buttonDisable)
            .cornerRadius(18)
    }
}

