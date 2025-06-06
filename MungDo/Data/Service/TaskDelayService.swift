//
//  TaskDelayService.swift
//  MungDo
//
//  Created by cheshire on 6/6/25.
//


//
//  TaskDelayService.swift
//  MungDo
//

//  Created by Zhen on 6/5/25.
//

import Foundation

struct TaskDelayService {
    
    static func delayOverDueTask() {
        
        //모든 task 불러와서?
        // 날짜 비교해보고 reset
        
        var tasks: [TaskItem] = [
            // 어제 날짜 (미완)
            TaskItem(
                taskType: .heartworm,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                isCompleted: false
            ),
            // 오늘 날짜 (완)
            TaskItem(
                taskType: .walk,
                date: Date(),
                isCompleted: true
            )
        ]
        
        for index in 0..<tasks.count {
            guard tasks[index].isCompleted == false else { continue }
            
            if tasks[index].date < Date() {
                
                //(tasks[index].taskType.displayName + "delay 수정 필요")
                
                var schedule = TaskSchedule(
                    taskType: tasks[index].taskType,
                    startDate: tasks[index].date
                )
                let tomorrow = Calendar.current.date(
                    byAdding: .day,
                    value: 1,
                    to: tasks[index].date
                )!
                schedule.setStartDate(tomorrow)
              
                //더미
//                tasks[index].date = schedule.startDate
                
                //print("\(tasks[index].date) delay 수정 완")

                            
            }
        }
        
        
        
        
    }
    
}

