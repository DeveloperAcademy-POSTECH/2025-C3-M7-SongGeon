//
//  CustomNavigationBar.swift
//  MungDo
//
//  Created by 제하맥 on 6/2/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    var showDepth: Bool = false
    var currentDepth: Int = 1
    var totalDepth: Int = 1
    var onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 12, height: 20)
                    .foregroundColor(Color.buttonSecondary)
                    .frame(width: 22, height: 36, alignment: .leading)
            }

            Spacer()

            if showDepth {
                DepthIndicator(current: currentDepth, total: totalDepth)
                    .frame(maxWidth: .infinity)
            }

            Spacer()
            
            // 공간 균형 맞추기 위한 투명 버튼
            if showDepth {
                Rectangle()
                    .frame(width: 22, height: 36)
                    .opacity(0)
            }
        }
        .padding(.top, 80)

    }
}
