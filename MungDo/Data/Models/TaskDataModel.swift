//
//  TaskDataModel.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class TaskDataModel {
    var id: UUID
    var taskTypeRawValue: String
    var scheduledDate: Date
    var isCompleted: Bool
    var createdAt: Date
    
    // TaskType enum을 computed property로 제공
    var taskType: TaskType {
        get {
            return TaskType(rawValue: taskTypeRawValue) ?? .heartworm
        }
        set {
            taskTypeRawValue = newValue.rawValue
        }
    }
    
    init(taskType: TaskType, scheduledDate: Date, isCompleted: Bool = false) {
        self.id = UUID()
        self.taskTypeRawValue = taskType.rawValue
        self.scheduledDate = scheduledDate
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}