import SwiftUI

struct TestCalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack {
            Text("날짜 선택")
                .font(.title2)
                .fontWeight(.semibold)
            DatePicker(
                "날짜 선택",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
} 
