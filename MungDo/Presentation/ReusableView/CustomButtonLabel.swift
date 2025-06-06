import SwiftUI

struct CustomButtonLabel: View {
    let title: String
    var isEnabled: Bool = true // 기본값은 true로 설정

    var body: some View {
        Text(title)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(isEnabled ? Color.blue : Color.gray) // 활성화 상태에 따라 색상 변경
            .cornerRadius(10)
    }
} 