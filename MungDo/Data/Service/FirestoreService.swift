//
//  FirestoreService.swift
//  MungDo
//
//  Created by Zhen on 6/4/25.
//

import FirebaseFirestore


final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    func addTask (
        num: Int,
        taskDisplayName: String,
        taskDoneDate: Date
    ){
        let userRef = db.collection("user")
        
        userRef .whereField("num", isEqualTo: num).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            //있는지 확인
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print( "No documents")
                return
            }
            
            //여러개면 첫번째
            let userDoc = documents[0]
            let userDocId = userDoc.documentID
            
            //taskCollection
            let taskColl = userRef.document(userDocId).collection("task")
            
            let data: [String: Any] = [
                "taskDisplayName" : taskDisplayName,
                "taskDoneDate" : Timestamp(date: taskDoneDate)
            ]
            
            let ref = taskColl.addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("\(taskDisplayName) added")
                }
            
            }
        }
    }


}


