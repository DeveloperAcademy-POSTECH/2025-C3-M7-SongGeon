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
        GeometryReader { outerGeometry in
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius:20)
                        .fill(Color.primary01)
                    VStack {
                        Spacer()
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, outerGeometry.size.width * 0.05)
                    }
                }
                .frame(
                    width: outerGeometry.size.width * 0.8,
                    height: outerGeometry.size.width * 0.8
                )
                .padding(outerGeometry.size.width * 0.1)
                
                Text(title)
                    .font(.headingFontLarge)
                    .foregroundColor(.primary02)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.secondary01)
                    .shadow(color: Color(red: 1, green: 0.45, blue: 0.38).opacity(0.12), radius: 6, x: 6, y: 6)
            )
        }
    }
}

#Preview {
    HomeCardView(
        image: Image("Home/home_add"),
        title: "예시 제목"
    )
    .padding()
}
