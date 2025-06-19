import SwiftUI
import FSCalendar
import SwiftData

struct CalendarView: UIViewRepresentable {
    @Binding var tasks: [TaskItemEntity]
    @Binding var currentPage: Date
    @Binding var selectedDate: Date
    //@Query private var allTaskItems: [TaskItemEntity]

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
        print("뷰 다시 그려짐")
        uiView.select(selectedDate)
        uiView.setCurrentPage(currentPage, animated: true)
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
            parent.selectedDate = date
            let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                formatter.timeZone = TimeZone(identifier: "Asia/Seoul")  // ✅ 한국 시간 기준
                print("사용자가 선택한 날짜: \(formatter.string(from: date))")
        }

        func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
            let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! TaskDotCell

            let sameDayTasks = parent.tasks.filter {
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }

            if !sameDayTasks.isEmpty {
                cell.customDot.isHidden = false
                let allCompleted = sameDayTasks.allSatisfy { $0.isCompleted }
                cell.customDot.backgroundColor = allCompleted ? .checkPrimary : .buttonPrimary
            } else {
                cell.customDot.isHidden = true
            }
            return cell
        }
    }
}
