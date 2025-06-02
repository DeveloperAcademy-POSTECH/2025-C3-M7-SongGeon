//
//  CustomNavigationBar.swift
//  MungDo
//
//  Created by 제하맥 on 6/2/25.
//

import SwiftUI

struct CustomToolBar: ToolbarContent {
    var showDepth: Bool = false
    var currentDepth: Int = 1
    var totalDepth: Int = 1
    let onBack: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 22, height: 36)
                    .foregroundColor(Color.buttonSecondary)
            }
        }

        ToolbarItem(placement: .principal) {
            if showDepth {
                DepthIndicator(current: currentDepth, total: totalDepth)
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            Rectangle()
                .frame(width: 22, height: 36)
                .opacity(0) // 균형 유지를 위한 빈 영역
        }
    }
}
