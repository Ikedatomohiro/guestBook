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
    let uids: [String]
    let createdAt: Date
    let updatedAt: Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.eventName = dictionary["eventName"] as? String ?? ""
        self.eventId   = document.documentID
        self.uids      = dictionary["uid"] as? Array ?? []
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
        self.updatedAt = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    init() {
        self.eventName = ""
        self.eventId   = ""
        self.uids      = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    static func registEvent(_ eventName: String, _ uid: String) -> DocumentReference {
        let documentRef = Firestore.firestore().collection("events").addDocument(data: [
            "eventName" : eventName,
            "uids"      : [uid],
            "createdAt" : Date(),
            "updatedAt" : Date(),
        ])
        return documentRef
    }
}
