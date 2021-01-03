//
//  Guest.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import FirebaseFirestore

struct Guest {
    var id: String
    let eventId    : String
    var guestName  : String
    var companyName: String
    let createdAt  : Date
    var updatedAt  : Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary   = document.data()
        self.id          = document.documentID
        self.eventId     = dictionary["eventId"]     as? String ?? ""
        self.guestName   = dictionary["guestName"]   as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? ""
        self.createdAt   = dictionary["createdAt"]   as? Date   ?? Date()
        self.updatedAt   = dictionary["updatedAt"]   as? Date   ?? Date()
    }

    init(id: String) {
        self.id          = id
        self.eventId     = ""
        self.guestName   = ""
        self.companyName = ""
        self.createdAt   = Date()
        self.updatedAt   = Date()
    }
    
    init() {
        self.id          = ""
        self.eventId     = ""
        self.guestName   = ""
        self.companyName = ""
        self.createdAt   = Date()
        self.updatedAt   = Date()
    }
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    static func registGuest(guest: Guest, eventId: String) -> DocumentReference {
        let documrntRef = Guest.collectionRef(eventId: eventId).addDocument(data: [
            "guestName"  : guest.guestName,
            "companyName": guest.companyName,
            "eventId"    : eventId,
            "createdAt"  : Date(),
            "updatedAt"  : Date(),
        ])
        return documrntRef
    }
    
    static func updateGuest(guest: Guest, eventId: String) {
        Guest.collectionRef(eventId: eventId).document(guest.id).updateData([
            "guestName"  : guest.guestName,
            "companyName": guest.companyName,
            "updatedAt"  : Date(),
            ])
    }
}

// 入力されているかどうかチェック
extension Guest: Equatable {
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.id          == rhs.id
            && lhs.guestName   == rhs.guestName
            && lhs.companyName == rhs.companyName
    }
}
