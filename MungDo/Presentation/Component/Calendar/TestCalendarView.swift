//
//  TestCalendarView.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import SwiftUI

struct TestCalendarView: View {
    //task 생성 예시
    @State var tasks:[TaskItem] = [
        TaskItem(taskType: .walk, date: .now, isCompleted: true),
        TaskItem(taskType: .externalParasite, date: Calendar.current.date(from: DateComponents(year: 2025, month: 6  , day: 11))!, isCompleted: false)
    ]

    @State private var reloadTrigger = false
    @State private var currentPage: Date = Date()
    @State var showDots: Bool
    @Binding var selectedDate: Date


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
            CalendarView(tasks: $tasks, currentPage: $currentPage, showDots: $showDots, selectedDate: $selectedDate)
                .id(reloadTrigger)
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
