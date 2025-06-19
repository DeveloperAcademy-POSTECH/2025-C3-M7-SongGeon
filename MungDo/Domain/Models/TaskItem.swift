//
//  TaskItem.swift
//  MungDo
//
//  Created by 제하맥 on 6/5/25.
//
import Foundation

struct TaskItem: Identifiable, Hashable, Equatable {
    let id = UUID()
    let taskType: TaskType
    // let -> var 변경, 사유 : delay 구현

    var date: Date
    var isCompleted: Bool

    init(taskType: TaskType, date: Date, isCompleted: Bool = false) {
        self.taskType = taskType
        self.date = date
        self.isCompleted = isCompleted
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    // Equatable 구현
    static func == (lhs: TaskItem, rhs: TaskItem) -> Bool {
        return lhs.id == rhs.id
    }

    // Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
