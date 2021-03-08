//
//  Relation.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/07.
//

import FirebaseFirestore

struct Relation {
    var id: String
    var number: Int // 順番保持用
    var relation: String
    var eventId: String
    let createdAt: Date
    var updatedAt: Date
    
    init(name: String) {
        self.id         = ""
        self.number     = 0
        self.relation   = name
        self.eventId    = ""
        self.createdAt  = Date()
        self.updatedAt  = Date()
    }
    
    init(docment: QueryDocumentSnapshot) {
        let dictionary  = docment.data()
        self.id         = docment.documentID
        self.number     = dictionary["number"]     as? Int    ?? 0
        self.relation   = dictionary["relation"]   as? String ?? ""
        self.eventId    = dictionary["eventID"]    as? String ?? ""
        self.createdAt  = dictionary["createdAt"]  as? Date   ?? Date()
        self.updatedAt  = dictionary["updatedAt"]  as? Date   ?? Date()
    }
    
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("relations")
    }
    
    static func registRelation(relation: Relation, eventId: String, number: Int) {
        Relation.collectionRef(eventId: eventId).addDocument(data: [
            "number"     : number,
            "relation"   : relation.relation,
            "eventId"    : eventId,
            "createdAt"  : Date(),
            "updatedAt"  : Date()
        ])
        return
    }
}


