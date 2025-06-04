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
                            .fill(Color("ButtonPrimary"))
                            //.frame(height: 200)
                    image
                        .resizable()
                        .scaledToFit()
                        //.frame(height: 150)
                        
                    
                }
                .frame(width: 400, height: 400)
                .padding(.horizontal,16)
               
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 48)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color("ButtonSecondary"))
                    .shadow(color: Color.buttonPrimary.opacity(0.4), radius: 20, x: 4, y: 4)
                    
            )
            .padding(.vertical, 32)
            .padding(16)
            
        
        
    }
        
}
