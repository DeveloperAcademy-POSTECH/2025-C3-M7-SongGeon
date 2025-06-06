//
//  SimpleTaskViewModel.swift
//  MungDo
//
//  Created by cheshire on 6/4/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class SimpleTaskViewModel: ObservableObject {
    @Published var tasks: [SimpleTaskEntity] = []
    @Published var selectedDate: Date = Date()
    
    private var modelContext: ModelContext?
    
    init() {
        
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadTasks()
    }
    
    func saveTask(taskName: String, taskTypeString: String, date: Date) {
        guard let context = modelContext else { 
            print("No model context available")
            return 
        }
        
        let entity = SimpleTaskEntity(taskName: taskName, taskTypeString: taskTypeString, date: date)
        context.insert(entity)
        
        do {
            try context.save()
            loadTasks()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func loadTasks() {
        guard let context = modelContext else {
            return
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay
        
        let descriptor = FetchDescriptor<SimpleTaskEntity>(
            predicate: #Predicate<SimpleTaskEntity> { entity in
                entity.date >= startOfDay && entity.date < endOfDay
            },
            sortBy: [SortDescriptor(\.date)]
        )
        
        do {
            self.tasks = try context.fetch(descriptor)
        } catch {
            print("Failed to load tasks: \(error)")
        }
    }
    
    func updateTaskCompletion(entity: SimpleTaskEntity, isCompleted: Bool) {
        guard let context = modelContext else { return }
        
        entity.isCompleted = isCompleted
        
        do {
            try context.save()
            loadTasks()
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        loadTasks()
    }
} 