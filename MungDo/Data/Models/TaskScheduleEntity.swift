//
//  TaskScheduleEntity.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
// 테스트

import Foundation
import SwiftData

@Model
final class TaskScheduleEntity {
    @Attribute(.unique) var id: UUID
    var taskTypeRawValue: String
    var startDate: Date
    var createdAt: Date
    
    init(taskType: TaskType, startDate: Date) {
        self.id = UUID()
        self.taskTypeRawValue = taskType.rawValue
        self.startDate = startDate
        self.createdAt = Date()
    }
    
    var taskType: TaskType {
        get {
            return TaskType(rawValue: taskTypeRawValue) ?? .walk
        }
        set {
            taskTypeRawValue = newValue.rawValue
        }
    }
    
    // TaskSchedule으로 변환
    func toTaskSchedule() -> TaskSchedule {
        return TaskSchedule(taskType: taskType, startDate: startDate)
    }
} 
