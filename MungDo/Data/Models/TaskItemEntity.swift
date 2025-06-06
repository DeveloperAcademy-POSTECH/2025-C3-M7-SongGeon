//
//  TaskItemEntity.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import Foundation
import SwiftData

@Model
final class TaskItemEntity {
    @Attribute(.unique) var id: UUID
    var taskTypeRawValue: String
    var date: Date
    var isCompleted: Bool
    var createdAt: Date
    
    init(taskType: TaskType, date: Date, isCompleted: Bool = false) {
        self.id = UUID()
        self.taskTypeRawValue = taskType.rawValue
        self.date = date
        self.isCompleted = isCompleted
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
    
    // TaskItem으로 변환
    func toTaskItem() -> TaskItem {
        return TaskItem(taskType: taskType, date: date, isCompleted: isCompleted)
    }
} 