//
//  TaskCalendarView.swift
//  MungDo
//
//  Created by cheshire on 6/5/25.
//

import SwiftUI

struct TaskCalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentPage: Date = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            // 헤더 (월/년 표시 및 네비게이션)
            HStack {
                Button(action: {
                    currentPage = calendar.date(byAdding: .month, value: -1, to: currentPage) ?? currentPage
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentPage))
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    currentPage = calendar.date(byAdding: .month, value: 1, to: currentPage) ?? currentPage
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            
            // 요일 헤더
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 날짜 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        Button(action: {
                            selectedDate = date
                        }) {
                            Text(dayFormatter.string(from: date))
                                .font(.system(size: 16))
                                .foregroundColor(colorForDate(date))
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(backgroundColorForDate(date))
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Text("")
                            .frame(width: 32, height: 32)
                    }
                }
            }
            
            // 오늘 버튼
            HStack {
                Button(action: {
                    let today = Date()
                    selectedDate = today
                    currentPage = today
                }) {
                    Text("오늘")
                        .font(.system(size: 16))
                        .foregroundColor(Color("ButtonPrimary"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .overlay(
                            Capsule()
                                .stroke(Color("ButtonPrimary"), lineWidth: 1)
                        )
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            // 선택된 날짜가 현재 표시된 월과 다르면 페이지 변경
            if !calendar.isDate(newValue, equalTo: currentPage, toGranularity: .month) {
                currentPage = newValue
            }
        }
    }
    
    // MARK: - Helper computed properties
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentPage),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end - 1)
        else { return [] }
        
        var days: [Date?] = []
        var currentDate = monthFirstWeek.start
        
        while currentDate < monthLastWeek.end {
            if calendar.isDate(currentDate, equalTo: currentPage, toGranularity: .month) {
                days.append(currentDate)
            } else {
                days.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    private func colorForDate(_ date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: selectedDate) {
            return .white
        } else if calendar.isDate(date, inSameDayAs: Date()) {
            return Color("ButtonPrimary")
        } else {
            return .primary
        }
    }
    
    private func backgroundColorForDate(_ date: Date) -> Color {
        if calendar.isDate(date, inSameDayAs: selectedDate) {
            return Color("ButtonPrimary")
        } else {
            return .clear
        }
    }
}

#Preview {
    @State var selectedDate = Date()
    return TaskCalendarView(selectedDate: $selectedDate)
        .padding()
} 