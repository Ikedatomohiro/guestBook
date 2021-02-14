//
//  Guest.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import FirebaseFirestore
import PencilKit
import FirebaseStorage

fileprivate let storage = Storage.storage().reference(forURL: Keys.firestoreStorageUrl)

struct Guest {
    var id: String
    let eventId: String
    var guestName: String
    var guestNameImage: PKDrawing
    var guestNameImageData: Data
    var companyName: String
    var companyNameImageData: Data
    var retuals: Dictionary<String, Bool> = [:]
    var zipCode: String
    var zipCodeImageData: Data
    var address: String
    var addressImageData: Data
    var telNumber: String
    var telNumberImageData: Data
    var relations: Array<Bool>
    var groups: Array<Bool>
    var description: String
    var descriptionImageData: Data
    var pageNumber: Int
    let createdAt: Date
    var updatedAt: Date
    
    // MARK:-
    
    init(document: QueryDocumentSnapshot) {
        let dictionary            = document.data()
        self.id                   = document.documentID
        self.eventId              = dictionary["eventId"]     as? String ?? ""
        self.guestName            = dictionary["guestName"]   as? String ?? ""
        self.guestNameImage       = PKDrawing()
        self.guestNameImageData   = dictionary["guestNameImageData"] as? Data ?? Data()
        self.companyName          = dictionary["companyName"] as? String ?? ""
        self.companyNameImageData = dictionary["companyNameImageData"] as? Data ?? Data()
        self.retuals              = dictionary["retuals"]     as? Dictionary<String, Bool> ?? [:]
        self.zipCode              = dictionary["zipCode"]     as? String ?? ""
        self.zipCodeImageData     = dictionary["zipCodeImageData"] as? Data ?? Data()
        self.address              = dictionary["address"]     as? String ?? ""
        self.addressImageData     = dictionary["addressImageData"] as? Data ?? Data()
        self.telNumber            = dictionary["telNumber"]   as? String ?? ""
        self.telNumberImageData   = dictionary["telNumberImageData"] as? Data ?? Data()
        self.relations            = dictionary["rerlations"]  as? Array  ?? [false, false, false, false]
        self.groups               = dictionary["rerlations"]  as? Array  ?? [false, false, false, false, false, false, false, false, false]
        self.description          = dictionary["description"] as? String ?? ""
        self.descriptionImageData = dictionary["descriptionImageData"] as? Data ?? Data()
        self.pageNumber           = 0
        self.createdAt            = dictionary["createdAt"]   as? Date   ?? Date()
        self.updatedAt            = dictionary["updatedAt"]   as? Date   ?? Date()
    }
    
    init(_ id: String,_ retualList: [Retual]) {
        self.id                   = id
        self.eventId              = ""
        self.guestName            = ""
        self.guestNameImage       = PKDrawing()
        self.guestNameImageData   = Data()
        self.companyName          = ""
        self.companyNameImageData = Data()
        self.zipCode              = ""
        self.zipCodeImageData     = Data()
        self.address              = ""
        self.addressImageData     = Data()
        self.telNumber            = ""
        self.telNumberImageData   = Data()
        self.relations            = [false, false, false, false]
        self.groups               = [false, false, false, false, false, false, false, false, false]
        self.description          = ""
        self.descriptionImageData = Data()
        self.pageNumber           = 0
        self.createdAt            = Date()
        self.updatedAt            = Date()
        
        self.retuals     = setDefaultAttendance(retualList: retualList)        
    }
    
    static func registGuest(_ guest: Guest,_ eventId: String) -> DocumentReference {
        let documentRef = Guest.collectionRef(eventId).addDocument(data: [
            "guestName"            : guest.guestName,
            "guestNameImageData"   : guest.guestNameImageData,
            "companyName"          : guest.companyName,
            "companyNameImageData" : guest.companyNameImageData,
            "retuals"              : guest.retuals,
            "zipCode"              : guest.zipCode,
            "zipCodeImageData"     : guest.zipCodeImageData,
            "address"              : guest.address,
            "addressImageData"     : guest.addressImageData,
            "telNumber"            : guest.telNumber,
            "telNumberImageData"   : guest.telNumberImageData,
            "relations"            : guest.relations,
            "groups"               : guest.groups,
            "description"          : guest.description,
            "descriptionImageData" : guest.descriptionImageData,
            "eventId"              : eventId,
            "createdAt"            : Date(),
            "updatedAt"            : Date(),
        ])
        return documentRef
    }
    
    static func updateGuest(_ guest: Guest,_ eventId: String) {
        Guest.collectionRef(eventId).document(guest.id).updateData([
            "guestName"            : guest.guestName,
            "guestNameImageData"   : guest.guestNameImageData,
            "companyName"          : guest.companyName,
            "companyNameImageData" : guest.companyNameImageData,
            "retuals"              : guest.retuals,
            "zipCode"              : guest.zipCode,
            "zipCodeImageData"     : guest.zipCodeImageData,
            "address"              : guest.address,
            "addressImageData"     : guest.addressImageData,
            "telNumber"            : guest.telNumber,
            "telNumberImageData"   : guest.telNumberImageData,
            "relations"            : guest.relations,
            "groups"               : guest.groups,
            "description"          : guest.description,
            "descriptionImageData" : guest.descriptionImageData,
            "updatedAt"            : Date(),
        ])
    }
    
    static func collectionRef(_ eventId: String) ->CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    // 儀式の参列をデフォルト不参加にセット。デフォルトのretualsListの配列をDictionary型に変換して返す。
    func setDefaultAttendance(retualList: [Retual]) -> Dictionary<String, Bool> {
        return retualList.reduce(into: [String: Bool]()) { $0[$1.id] = false }
    }

    // 検索



}

// MARK:- Extensions
// 入力されているかどうかチェック
extension Guest: Equatable {
    static func == (lhs: Guest, rhs: Guest) -> Bool {
        return lhs.id                   == rhs.id
            && lhs.guestName            == rhs.guestName
            && lhs.guestNameImageData   == rhs.guestNameImageData
            && lhs.companyName          == rhs.companyName
            && lhs.companyNameImageData == rhs.companyNameImageData
            && lhs.retuals              == rhs.retuals
            && lhs.zipCode              == rhs.zipCode
            && lhs.zipCodeImageData     == rhs.zipCodeImageData
            && lhs.address              == rhs.address
            && lhs.addressImageData     == rhs.addressImageData
            && lhs.telNumber            == rhs.telNumber
            && lhs.telNumberImageData   == rhs.telNumberImageData
            && lhs.relations            == rhs.relations
            && lhs.description          == rhs.description
            && lhs.descriptionImageData == rhs.descriptionImageData
    }
}
