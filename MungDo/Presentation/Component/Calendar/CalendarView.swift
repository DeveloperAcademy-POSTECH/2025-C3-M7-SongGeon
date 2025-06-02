//
//  CalendarView.swift
//  MungDo
//
//  Created by 문창재 on 6/2/25.
//

import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        //SwiftUI <-> UIKit 데이터 주고받을 때 필요한 항목
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        //헤더
        calendar.headerHeight = 100
        calendar.appearance.headerDateFormat = "yyyy년 MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 26, weight: .bold)
        
        //요일
        calendar.appearance.weekdayFont = .systemFont(ofSize: 18)
        calendar.appearance.weekdayTextColor = .gray
        
        //날짜
        calendar.appearance.titleFont = .systemFont(ofSize: 18, weight: .bold)
        calendar.appearance.titlePlaceholderColor = .lightGray
        
        //선택된 날짜
        calendar.appearance.selectionColor = .buttonPrimary
        calendar.appearance.titleSelectionColor = .white
        
        
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.locale = Locale(identifier: "ko_KR")
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        //
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView

        init(_ parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            //parent.selectedDate = date
        }
    }
}

#Preview {
    CalendarView()
}
