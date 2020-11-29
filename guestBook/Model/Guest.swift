//
//  Guest.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import FirebaseFirestore

struct Guest {
    let id: String
    let guestName: String
    let createdAt: Date
    let updatedAt: Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.id = document.documentID
        self.guestName = dictionary["guestName"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
        self.updatedAt = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    init() {
        self.id = ""
        self.guestName = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
