//
//  FirestoreService.swift
//  MungDo
//
//  Created by Zhen on 6/4/25.
//

import FirebaseFirestore


final class FirestoreService {
    static let shared = FirestoreService()  //싱글톤... 인스턴스 하나만 만들어서 공유
    private let db = Firestore.firestore()
    
    //task 추가
    func addTask (
        num: Int,
        taskDisplayName: String,
        taskDoneDate: Date,
        completion: @escaping (Error?) -> Void  //함수 종료 후 실행해야 할(받은) 클로저.
    ){
        let userRef = db.collection("user")
        
        userRef .whereField("num", isEqualTo: num).getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
            }
            // snapshot = 쿼리 결과를 담은 optional 객체. 쿼리 결과 snapshot 에 문서 배열이 존재하고, 그 문서 배열이 비어있지 않을 때.
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(error)
                return
            }
            
            //document가 여러개면 첫번째 사용
            let userDoc = documents[0]
            let userDocId = userDoc.documentID
            
            //taskCollection
            let taskColl = userRef.document(userDocId).collection("task")
            
            let data: [String: Any] = [
                "taskDisplayName" : taskDisplayName,
                "taskDoneDate" : Timestamp(date: taskDoneDate)
            ]
            
            var ref = taskColl.addDocument(data: data) { err in
                if let err = err {
                    //실제 추가 시 error 발생
                    completion(error)
                } else {
                    completion(nil)
                }
            
            }
        }
    }
    

}


