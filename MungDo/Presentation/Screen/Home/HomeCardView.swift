//
//  HomeCardView.swift
//  MungDo
//
//  Created by Zhen on 6/2/25.
//
import SwiftUI


struct HomeCardView: View {
    
    let image: Image
    let title: String
    
    var body: some View {
        
        VStack(spacing: 16){
            ZStack{
                RoundedRectangle(cornerRadius:20)
                    .fill(Color.primary01)
                image
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 400, height: 400)
            .padding(.horizontal,16)
            
            Text(title)
                .font(.headingFont)
                .foregroundColor(.primary02)
                .multilineTextAlignment(.center)
                .padding(.top, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.secondary01)
                .shadow(color: Color.primary01.opacity(0.4), radius: 20, x: 4, y: 4)
            
        )
        .padding(.vertical, 32)
        .padding(16)
    }
}
