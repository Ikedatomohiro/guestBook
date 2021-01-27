//
//  Retual.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/27.
//

import FirebaseFirestore

struct Retual {
    var id         : String
    var number     : Int
    var retualName : String
    let eventId    : String
    let createdAt  : Date
    var updatedAt  : Date
//    var retualDictionary: Dictionary<String, String>
    init(name: String) {
        self.id         = ""
        self.number     = 0
        self.retualName = name
        self.eventId    = ""
        self.createdAt  = Date()
        self.updatedAt  = Date()
    }
    
    init(docment: QueryDocumentSnapshot) {
        let dictionary  = docment.data()
        self.id         = docment.documentID
        self.number     = dictionary["number"] as? Int ?? 0
        self.retualName = dictionary["retualName"] as? String ?? ""
        self.eventId    = dictionary["eventID"]    as? String ?? ""
        self.createdAt  = dictionary["createdAt"]  as? Date   ?? Date()
        self.updatedAt  = dictionary["updatedAt"]  as? Date   ?? Date()
    }
    
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("retuals")
    }
    
    static func registRetual(retual: Retual, eventId: String, number: Int) {
        Retual.collectionRef(eventId: eventId).addDocument(data: [
            "number"     : number,
            "retualName" : retual.retualName,
            "eventId"    : eventId,
            "createdAt"  : Date(),
            "updatedAt"  : Date()
        ])
        return
    }
    
    static func setDefaultRetualDictionary(retuals: Array<String>) {
//        for retual in retuals {
//            retualDictionary[retual[retualId]] = retual[retualName]
//        }
    }
    
}
