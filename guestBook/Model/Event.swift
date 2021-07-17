//
//  Event.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/02.
//

import FirebaseFirestore

struct Event {
    let eventName: String
    let eventId: String
    let createdAt: Date
    let updatedAt: Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.eventName = dictionary["eventName"] as? String ?? ""
        self.eventId   = document.documentID
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
        self.updatedAt = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    init() {
        self.eventName = ""
        self.eventId   = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    static func registEvent(_ eventName: String) -> DocumentReference {
        let documentRef = Firestore.firestore().collection("events").addDocument(data: [
            "eventName" : eventName,
            "createdAt" : Date(),
            "updatedAt" : Date(),
        ])
        return documentRef
    }
}
