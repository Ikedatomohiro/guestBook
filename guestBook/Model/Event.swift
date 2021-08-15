//
//  Event.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/02.
//

import FirebaseFirestore

struct Event {
    var eventName: String
    let eventId: String
    var uids: [String]
    var deceasedName: String
    var chiefMourner: String
    var eventDate: String
    var eventPlace: String
    var description: String
    let createdAt: Date
    var updatedAt: Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary    = document.data()
        self.eventName    = dictionary["eventName"] as? String ?? ""
        self.eventId      = document.documentID
        self.uids         = dictionary["uid"] as? Array ?? []
        self.deceasedName = dictionary["deceasedName"] as? String ?? ""
        self.chiefMourner = dictionary["chiefMourner"] as? String ?? ""
        self.eventDate    = dictionary["eventDate"] as? String ?? ""
        self.eventPlace   = dictionary["eventPlace"] as? String ?? ""
        self.description  = dictionary["description"] as? String ?? ""
        self.createdAt    = dictionary["createdAt"] as? Date ?? Date()
        self.updatedAt    = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    init() {
        self.eventName    = ""
        self.eventId      = ""
        self.uids         = []
        self.deceasedName = ""
        self.chiefMourner = ""
        self.eventDate    = ""
        self.eventPlace   = ""
        self.description  = ""
        self.createdAt    = Date()
        self.updatedAt    = Date()
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        let dictionary    = documentSnapshot.data()!
        self.eventName    = dictionary["eventName"] as? String ?? ""
        self.eventId      = documentSnapshot.documentID
        self.uids         = dictionary["uid"] as? Array ?? []
        self.deceasedName = dictionary["deceasedName"] as? String ?? ""
        self.chiefMourner = dictionary["chiefMourner"] as? String ?? ""
        self.eventDate    = dictionary["eventDate"] as? String ?? ""
        self.eventPlace   = dictionary["eventPlace"] as? String ?? ""
        self.description  = dictionary["description"] as? String ?? ""
        self.createdAt    = dictionary["createdAt"] as? Date ?? Date()
        self.updatedAt    = dictionary["updatedAt"] as? Date ?? Date()
    }
    
    static func getEvent(_ eventId: String) -> DocumentReference {
        let documentRef = Firestore.firestore().collection("events").document(eventId)
        return documentRef
    }
    
    
    static func registEvent(_ eventName: String, _ uid: String) -> DocumentReference? {
        var documentRef: DocumentReference? = nil
        documentRef = Firestore.firestore().collection("events").addDocument(data: [
            "eventName" : eventName,
            "uids"      : [uid],
            "createdAt" : Date(),
            "updatedAt" : Date(),
        ]) { error in
            if let error = error {
                print("Create event error: \(error)")
                fatalError()
            } else {
                print("Event added with ID: \(documentRef!.documentID)")
            }
        }
        return documentRef
    }
    
    static func updateEvent(_ event: Event) {
        Firestore.firestore().collection("events").document(event.eventId).updateData([
            "eventName"    : event.eventName,
            "deceasedName" : event.deceasedName,
            "chiefMourner" : event.chiefMourner,
            "eventDate"    : event.eventDate,
            "eventPlace"   : event.eventPlace,
            "description"  : event.description,
            "updatedAt"    : Date(),
        ])
    }
}
