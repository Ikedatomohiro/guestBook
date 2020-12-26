//
//  Guest.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import FirebaseFirestore

struct Guest {
    var id: String
    var guestName: String
    let eventId  : String
    let createdAt: Date
    var updatedAt: Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.id = document.documentID
        self.guestName = dictionary["guestName"] as? String ?? ""
        self.eventId   = dictionary["eventId"]   as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? Date ?? Date()
        self.updatedAt = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    init(document: DocumentSnapshot) {
        let dictionary = document.data()
        self.id = document.documentID
        self.guestName = dictionary?["guestName"] as? String ?? ""
        self.eventId   = dictionary?["eventId"]   as? String ?? ""
        self.createdAt = dictionary?["createdAt"] as? Date ?? Date()
        self.updatedAt = dictionary?["updatedAt"] as? Date ?? Date()
    }

    init(id: String) {
        self.id        = id
        self.guestName = ""
        self.eventId   = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init() {
        self.id        = ""
        self.guestName = ""
        self.eventId   = ""
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
}
