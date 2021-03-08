//
//  Group.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/07.
//

import FirebaseFirestore

struct Group {
    var id: String
    var number: Int // 順番保持用
    var group: String
    var eventId: String
    let createdAt: Date
    var updatedAt: Date
    
    init(name: String) {
        self.id         = ""
        self.number     = 0
        self.group      = name
        self.eventId    = ""
        self.createdAt  = Date()
        self.updatedAt  = Date()
    }
    
    init(docment: QueryDocumentSnapshot) {
        let dictionary  = docment.data()
        self.id         = docment.documentID
        self.number     = dictionary["number"]     as? Int    ?? 0
        self.group      = dictionary["group"]      as? String ?? ""
        self.eventId    = dictionary["eventID"]    as? String ?? ""
        self.createdAt  = dictionary["createdAt"]  as? Date   ?? Date()
        self.updatedAt  = dictionary["updatedAt"]  as? Date   ?? Date()
    }
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("groups")
    }
    
    static func registGroup(group: Group, eventId: String, number: Int) {
        Group.collectionRef(eventId: eventId).addDocument(data: [
            "number"     : number,
            "group"      : group.group,
            "eventId"    : eventId,
            "createdAt"  : Date(),
            "updatedAt"  : Date()
        ])
        return
    }
}
