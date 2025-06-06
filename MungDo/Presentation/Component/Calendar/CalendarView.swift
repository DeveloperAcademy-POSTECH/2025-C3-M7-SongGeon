import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    @Binding var tasks: [TaskItem]
    @Binding var currentPage: Date
    
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.register(TaskDotCell.self, forCellReuseIdentifier: "cell")
        
        // 헤더
        calendar.headerHeight = 100
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 26, weight: .bold)
        calendar.scrollEnabled = false // 스크롤 막고 버튼으로만 이동
        calendar.headerHeight = 0
        
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

            // task 있는 날짜에만 점 보이게 + 상태에 따라 색상 다르게
            if let taskItem = parent.tasks.first(where: {
                Calendar.current.isDate($0.date, inSameDayAs: date)
            }) {
                cell.customDot.isHidden = false
                if taskItem.isCompleted {
                    cell.customDot.backgroundColor = .checkPrimary
                } else {
                    cell.customDot.backgroundColor = .buttonPrimary
                }
            } else {
                cell.customDot.isHidden = true
            }
            
            return cell
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
            HStack {
                Spacer()
                Button(action: {
                    currentPage = moveMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding()
                Text(monthTitle(for: currentPage))
                    .font(.system(size: 26, weight: .bold))
                    .bold()
                Button(action: {
                    currentPage = moveMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                }
                .padding()
                Spacer()
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
