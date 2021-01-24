//
//  Guest.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import FirebaseFirestore
import PencilKit

struct Guest {
    var id: String
    let eventId     : String
    var guestName   : String
    var guestNameImage : PKDrawing
    var guestNameImageData : Data
    var companyName : String
    var companyNameImageData : Data
    var retuals     : Array<Bool>
    var zipCode     : String
    var address     : String
    var telNumber   : String
    var relations   : Array<Bool>
    var groups      : Array<Bool>
    var description : String
    var pageNumber  : Int
    let createdAt   : Date
    var updatedAt   : Date
    
    init(document: QueryDocumentSnapshot) {
        let dictionary   = document.data()
        self.id          = document.documentID
        self.eventId     = dictionary["eventId"]     as? String ?? ""
        self.guestName   = dictionary["guestName"]   as? String ?? ""
        self.guestNameImage   = PKDrawing()
        self.guestNameImageData = dictionary["guestNameImageData"] as? Data ?? Data()
        self.companyName = dictionary["companyName"] as? String ?? ""
        self.companyNameImageData = dictionary["companyNameImageData"] as? Data ?? Data()
        self.retuals     = dictionary["retuals"]     as? Array  ?? [false, false]
        self.zipCode     = dictionary["zipCode"]     as? String ?? ""
        self.address     = dictionary["address"]     as? String ?? ""
        self.telNumber   = dictionary["telNumber"]   as? String ?? ""
        self.relations   = dictionary["rerlations"]  as? Array  ?? [false, false, false, false]
        self.groups      = dictionary["rerlations"]  as? Array  ?? [false, false, false, false, false, false, false, false, false]
        self.description = dictionary["description"] as? String ?? ""
        self.pageNumber  = 0
        self.createdAt   = dictionary["createdAt"]   as? Date   ?? Date()
        self.updatedAt   = dictionary["updatedAt"]   as? Date   ?? Date()
    }

    init(id: String) {
        self.id          = id
        self.eventId     = ""
        self.guestName   = ""
        self.guestNameImage = PKDrawing()
        self.guestNameImageData = Data()
        self.companyName = ""
        self.companyNameImageData = Data()
        self.retuals     = [false, false]
        self.zipCode     = ""
        self.address     = ""
        self.telNumber   = ""
        self.relations   = [false, false, false, false]
        self.groups      = [false, false, false, false, false, false, false, false, false]
        self.description = ""
        self.pageNumber  = 0
        self.createdAt   = Date()
        self.updatedAt   = Date()
    }
    
    static func collectionRef(eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    static func registGuest(guest: Guest, eventId: String) -> DocumentReference {
        let documentRef = Guest.collectionRef(eventId: eventId).addDocument(data: [
            "guestName"   : guest.guestName,
            "guestNameImageData" : guest.guestNameImageData,
            "companyName" : guest.companyName,
            "companyNameImageData" : guest.companyNameImageData,
            "retuals"     : guest.retuals,
            "zipCode"     : guest.zipCode,
            "address"     : guest.address,
            "telNumber"   : guest.telNumber,
            "relations"   : guest.relations,
            "groups"      : guest.groups,
            "description" : guest.description,
            "eventId"     : eventId,
            "createdAt"   : Date(),
            "updatedAt"   : Date(),
        ])
        return documentRef
    }
    
    static func updateGuest(guest: Guest, eventId: String) {
        Guest.collectionRef(eventId: eventId).document(guest.id).updateData([
            "guestName"   : guest.guestName,
            "guestNameImageData" : guest.guestNameImageData,
            "companyName" : guest.companyName,
            "companyNameImageData" : guest.companyNameImageData,
            "retuals"     : guest.retuals,
            "zipCode"     : guest.zipCode,
            "address"     : guest.address,
            "telNumber"   : guest.telNumber,
            "relations"   : guest.relations,
            "groups"      : guest.groups,
            "description" : guest.description,
            "updatedAt"   : Date(),
        ])
    }
}

// 入力されているかどうかチェック
extension Guest: Equatable {
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.id          == rhs.id
            && lhs.guestName   == rhs.guestName
            && lhs.companyName == rhs.companyName
            && lhs.retuals     == rhs.retuals
            && lhs.zipCode     == rhs.zipCode
            && lhs.address     == rhs.address
            && lhs.telNumber   == rhs.telNumber
            && lhs.relations   == rhs.relations
            && lhs.description == rhs.description

    }
}
