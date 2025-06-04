//
//  TaskSchedule.swift
//  MungDo
//
//  Created by 제하맥 on 6/4/25.
//

import Foundation

struct TaskSchedule: Identifiable {
    let id: UUID
    let taskType: TaskType
    var startDate: Date
    
    init(
        id: UUID = UUID(),
        taskType: TaskType,
        startDate: Date
    ) {
        self.id = id
        self.taskType = taskType
        self.startDate = startDate
    }
    
    mutating func setStartDate(_ date: Date = Date()) {
        self.startDate = date
    }
    
    func scheduledDates(forMonth month: Int, year: Int) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        let calendar = Calendar.current
        let cycle = taskType.defaultCycle
        let components = DateComponents(year: year, month: month)
        
        // 이번달의 처음과 끝 날짜 계산
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        else { return [] }
        
        // 반복 날짜 계산
        while currentDate <= endOfMonth {
            if currentDate >= startOfMonth {
                dates.append(currentDate)
            }
            currentDate = calendar.date(byAdding: .day, value: cycle, to: currentDate)!
        }
        
        return dates
    }
}
