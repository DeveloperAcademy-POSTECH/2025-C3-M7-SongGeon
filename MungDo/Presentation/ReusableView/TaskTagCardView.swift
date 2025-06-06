import SwiftUI

struct TaskTagCardView: View {
    let title: String
    let image: Image // 실제로는 String으로 이미지 이름을 받을 수도 있습니다.
    var isSelected: Bool

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding()
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .gray)
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
} 