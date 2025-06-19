//
//  DepthIndicator.swift
//  MungDo
//
//  Created by 제하맥 on 6/2/25.
//

// 사용하지 않는 view
// Depth 표기를 다시 도입할 경우를 우려해서 남겨둠

import SwiftUI

struct DepthIndicator: View {
    var current: Int
    var total: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...total, id: \.self) { index in
                if index == current {
                    // 강조된 현재 단계
                    Text("\(index)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.buttonSecondary)
                        .clipShape(Circle())
                } else {
                    // 비활성 단계
                    Text("\(index)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 22, height: 22)
                        .background(Color.buttonDisable)
                        .clipShape(Circle())
                }
            }
        }
    }
}
