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
    let createdTime: Date
    
    
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.eventName = dictionary["eventName"] as? String ?? ""
        self.eventId   = document.documentID
        self.createdTime = dictionary["createdTime"] as? Date ?? Date()
    }
}
