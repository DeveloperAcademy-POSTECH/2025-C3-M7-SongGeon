//
//  ConfettiPiece.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import SwiftUI

struct ConfettiPiece: View {
    let index: Int
    @State private var isAnimating = false
    
    var body: some View {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        let color = colors[index % colors.count]
        
        Rectangle()
            .fill(color)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .offset(
                x: isAnimating ? CGFloat.random(in: -200...200) : 0,
                y: isAnimating ? CGFloat.random(in: -300...300) : 0
            )
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(
                    .easeOut(duration: Double.random(in: 2...4))
                    .delay(Double.random(in: 0...2))
                ) {
                    isAnimating = true
                }
            }
    }
}
