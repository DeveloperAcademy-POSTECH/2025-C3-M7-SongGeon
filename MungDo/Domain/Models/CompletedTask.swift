//
//  CompletedTask.swift
//  MungDo
//
//  Created by 제하맥 on 6/4/25.
//

import Foundation

struct CompletedTask: Identifiable {
    let id: UUID
    let taskType: TaskType
    var completedDate: Date
    
    var displayTaskName: String{
        taskType.displayName
    }
    
    init(
        id: UUID = UUID(),
        taskType: TaskType,
        completedDate: Date
    ) {
        self.id = id
        self.taskType = taskType
        self.completedDate = completedDate
    }
}
