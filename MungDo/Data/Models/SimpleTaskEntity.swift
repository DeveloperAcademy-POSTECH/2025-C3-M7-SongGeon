//
//  SimpleTaskEntity.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import Foundation
import SwiftData

@Model
final class SimpleTaskEntity {
    @Attribute(.unique) var id: UUID = UUID()
    var taskName: String = ""
    var taskTypeString: String = ""
    var date: Date = Date()
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    
    init(taskName: String, taskTypeString: String, date: Date, isCompleted: Bool = false) {
        self.id = UUID()
        self.taskName = taskName
        self.taskTypeString = taskTypeString
        self.date = date
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
} 