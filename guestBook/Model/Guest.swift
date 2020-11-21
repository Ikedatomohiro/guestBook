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
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.id = document.documentID
        self.guestName = dictionary["guestName"] as? String ?? ""
        self.createdAt = dictionary["createdTime"] as? Date ?? Date()
    }
    
}
