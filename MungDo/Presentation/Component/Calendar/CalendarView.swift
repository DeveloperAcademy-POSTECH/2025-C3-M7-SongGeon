import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    @Binding var tasks: [TaskItem]
    @Binding var currentPage: Date
    @Binding var showDots: Bool
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.register(TaskDotCell.self, forCellReuseIdentifier: "cell")
        
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
        
        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
                    let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! TaskDotCell

                    // ✅ showDots가 true일 때만 점 표시
                    if parent.showDots {
                        if let taskItem = parent.tasks.first(where: {
                            Calendar.current.isDate($0.date, inSameDayAs: date)
                        }) {
                            cell.customDot.isHidden = false
                            cell.customDot.backgroundColor = taskItem.isCompleted ? .checkPrimary : .buttonPrimary
                        } else {
                            cell.customDot.isHidden = true
                        }
                    } else {
                        cell.customDot.isHidden = true
                    }

                    return cell
                }
    }
}


#Preview {
    TestCalendarView(showDots: true)
}
