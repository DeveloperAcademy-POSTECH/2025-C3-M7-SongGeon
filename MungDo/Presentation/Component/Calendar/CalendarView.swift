import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    @Binding var events:[Event]
    @Binding var currentPage: Date
    
    //일정이 있는 날짜 배열 (예시: 4일에 일정이 있다고 가정)
    struct Event: Identifiable {
        let id = UUID()
        let date: Date
        var status: Status
        
        enum Status {
            case before
            case done
        }
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // 빈 날짜 표시
        calendar.placeholderType = .fillHeadTail
        
        // 헤더
        calendar.headerHeight = 100
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 26, weight: .bold)
        calendar.scrollEnabled = false // 스크롤 막고 버튼으로만 이동
        calendar.headerHeight = 0
        
        calendar.appearance.todayColor = .buttonSecondary
        
        // 요일
        calendar.appearance.weekdayFont = .systemFont(ofSize: 18)
        calendar.appearance.weekdayTextColor = .gray
        
        // 날짜
        calendar.appearance.titleFont = .systemFont(ofSize: 18, weight: .bold)
        calendar.appearance.titlePlaceholderColor = .lightGray
        
        // 선택된 날짜
        calendar.appearance.selectionColor = .buttonPrimary
        calendar.appearance.titleSelectionColor = .white
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 이벤트 점
        calendar.appearance.eventDefaultColor = .red
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.setCurrentPage(currentPage, animated: true)
        uiView.reloadData()
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance { // FSCalendarDelegateAppearance 추가
        var parent: CalendarView

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            //parent.selectedDate = date
        }
        
        //일정이 있는 날짜에만 점(이벤트) 표시
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let calendar = Calendar.current
            for event in parent.events {
                if calendar.isDate(event.date, inSameDayAs: date) {
                    return 1 // 점 하나 표시
                }
            }
            return 0 // 점 없음
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
                    let calendar = Calendar.current
                    for event in parent.events {
                        if calendar.isDate(event.date, inSameDayAs: date) {
                            switch event.status {
                            case .before:
                                return [UIColor.red]
                            case .done:
                                return [UIColor.green]
                            }
                        }
                    }
                    return nil
                }
    }
}

struct TestCalendarView: View {
    //이벤트 생성 예시
    @State var events: [CalendarView.Event] = [CalendarView.Event(date: .now, status: .before)]
    @State private var reloadTrigger = false
    @State private var currentPage: Date = Date()
    
    var body: some View {
        VStack{
            ZStack{
                HStack {
                    Button {
                        currentPage = Date()
                    } label: {
                        Text("오늘")
                            .font(.system(size: 16))
                            .foregroundStyle(.buttonPrimary)
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .overlay {
                                Capsule()
                                    .fill(.clear)
                                    .stroke(.buttonPrimary, lineWidth: 1)
                            }
                    }
                    .padding()
                    .padding(.horizontal, 40)
                    Spacer()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        currentPage = moveMonth(by: -1)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    Text(monthTitle(for: currentPage))
                        .font(.system(size: 26, weight: .bold))
                        .bold()
                    Button(action: {
                        currentPage = moveMonth(by: 1)
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    Spacer()
                }
                
            }
            CalendarView(events: $events, currentPage: $currentPage)
                .id(reloadTrigger)
            //일정 완료 테스트 버튼
//            Button{
//                events[0].status = .done
//                reloadTrigger.toggle()
//            }label:{
//                Text("완료")
//            }
        }
    }
    // 월 이동 함수
    func moveMonth(by offset: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: offset, to: currentPage) ?? currentPage
    }

    // 현재 페이지 텍스트
    func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
}

#Preview {
    TestCalendarView()
}
