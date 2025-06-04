import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    @Binding var tasks: [Task]
    @Binding var currentPage: Date
    
    
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
            for task in parent.tasks {
                if let taskDate = task.scheduledDate{
                    if calendar.isDate(taskDate, inSameDayAs: date) {
                        return 1 // 점 하나 표시
                    }
                }
            }
            return 0 // 점 없음
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            let calendar = Calendar.current
            for task in parent.tasks {
                if let taskDate = task.scheduledDate{
                    if calendar.isDate(taskDate, inSameDayAs: date) {
                        switch task.taskState {
                        case .scheduled:
                            return [UIColor.red]
                        case .completed:
                            return [.checkPrimary]
                        case .postponed:
                            return [.backgroundPrimary]
                        }
                    }
                }
                
            }
            return nil
        }
    }
}


#Preview {
    TestCalendarView()
}
