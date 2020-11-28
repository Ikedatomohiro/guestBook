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
    
//    let retuals: [String]
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.eventName = dictionary["eventName"] as? String ?? ""
        self.eventId   = document.documentID
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
    }
}
