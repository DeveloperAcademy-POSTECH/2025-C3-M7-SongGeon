//
//  TaskRecurrenceEntity.swift
//  MungDo
//
//  Created by cheshire on 6/5/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class TaskRecurrenceEntity {
    @Attribute(.unique) var id: UUID = UUID()
    var taskName: String = ""
    var taskTypeRawValue: String? = nil  // 기본 TaskType인 경우
    var customTaskName: String? = nil    // 사용자 정의 태스크인 경우
    var startDate: Date = Date()
    var cycleDays: Int = 1
    var isActive: Bool = true
    var createdAt: Date = Date()
    
    init(taskName: String, taskType: TaskType? = nil, customTaskName: String? = nil, startDate: Date, cycleDays: Int) {
        self.id = UUID()
        self.taskName = taskName
        self.taskTypeRawValue = taskType?.rawValue
        self.customTaskName = customTaskName
        self.startDate = startDate
        self.cycleDays = cycleDays
        self.isActive = true
        self.createdAt = Date()
    }
    
    var taskType: TaskType? {
        get {
            guard let rawValue = taskTypeRawValue else { return nil }
            return TaskType(rawValue: rawValue)
        }
        set {
            taskTypeRawValue = newValue?.rawValue
        }
    }
    
    var isCustomTask: Bool {
        return taskType == nil && customTaskName != nil
    }
    
    // 다음 실행 날짜들을 계산하는 메서드
    func getNextDates(from date: Date, count: Int = 10) -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        var currentDate = startDate
        
        // startDate가 주어진 날짜보다 이전인 경우, 주어진 날짜 이후의 첫 번째 날짜를 찾음
        while currentDate < date {
            guard let nextDate = calendar.date(byAdding: .day, value: cycleDays, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        // count만큼의 날짜를 계산
        for _ in 0..<count {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: cycleDays, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
    
    // 특정 날짜에 해당하는지 확인하는 메서드
    func shouldOccurOn(date: Date) -> Bool {
        let calendar = Calendar.current
        let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: date).day ?? 0
        return daysSinceStart >= 0 && daysSinceStart % cycleDays == 0
    }
}