//
//  CustomNavigationBar.swift
//  MungDo
//
//  Created by 제하맥 on 6/2/25.
//

import SwiftUI

struct CustomToolBar: ToolbarContent {
    var showBack: Bool = true
    let onBack: () -> Void
    var showXMark: Bool = false
    let onXMark: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if showBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 36)
                        .foregroundColor(Color.secondary01)
                }
            }
            else {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .opacity(0) // 균형 유지를 위한 빈 영역
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            if showXMark {
                Button(action: onXMark) {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 36)
                        .foregroundColor(Color.secondary01)
                }
            }
            else {
                Rectangle()
                    .frame(width: 10, height: 10)
                    .opacity(0) // 균형 유지를 위한 빈 영역
            }
        }
    }
}
