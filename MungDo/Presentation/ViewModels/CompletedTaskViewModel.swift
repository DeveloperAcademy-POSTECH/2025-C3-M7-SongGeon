//
//  CompletedTaskViewModel.swift
//  MungDo
//
//  Created by Zhen on 6/4/25.
//

import Foundation
import Combine

final class CompletedTaskViewModel: ObservableObject {
    
    @Published var taskDisplayName: String = ""
    @Published var taskDoneDate: Date = Date()
    
    @Published var isSaving: Bool = false
    @Published var saveErrorMessage: String? = nil
    @Published var saveSuccess: Bool = false
    
    func saveTaskToDb(num: Int){
        self.isSaving = true
        self.saveErrorMessage = nil
        self.saveSuccess = false
        
        FirestoreService.shared.addTask(
            num: num,
            taskDisplayName: taskDisplayName,
            taskDoneDate: taskDoneDate)
        {
            [weak self] error in
            DispatchQueue.main.async {
                self?.isSaving = false
                if let error = error {
                    self?.saveErrorMessage = error.localizedDescription
                } else {
                    self?.saveSuccess = true
                }
                self?.taskDisplayName = ""
                self?.taskDoneDate = Date()
            }
            
        }
        
    }
}
