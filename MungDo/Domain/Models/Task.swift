//
//  Task.swift
//  MungDo
//
//  Created by 제하맥 on 6/4/25.
//
import Foundation

struct Task: Identifiable {
    let id: UUID
    let taskType: TaskType
    var taskState: TaskState = TaskState.scheduled
    
    var scheduledDate: Date? = nil
    var completedDate: Date? = nil
    var postponedDate: Date? = nil
    
    var nextTaskID : UUID? = nil

    init(
        id: UUID = UUID(),
        taskType: TaskType,
        taskState: TaskState,
        scheduledDate: Date
    ) {
        self.id = id
        self.taskType = taskType
        self.taskState = taskState
        self.scheduledDate = scheduledDate
    }
    //아직 작성중
    
}
