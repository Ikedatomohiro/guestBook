//
//  SelectGuests.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/25.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

let firestoreQueueGroup = DispatchGroup()
let firestoreQueue  = DispatchQueue.global(qos: .userInitiated)

class SelectGuests {
    
    var guests: [Guest] = []
    var pageNumber: Int = 1
    
    func collectionRef(_ eventId: String) -> CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    func fetchData(eventId: String, completion: @escaping ([Guest]) -> Void) {
        pageNumber = 1
        Guest.collectionRef(eventId).order(by:"createdAt").getDocuments(source: .cache) { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    var guest = Guest(document: document)
                    guest.pageNumber = self.pageNumber
                    self.pageNumber += 1
                    return guest
                })
                completion(self.guests)
            } else {
                print("取得に失敗しました。")
                print(error as Any)
                return
            }
        }
    }
    
    func selectGuestsFromRetual(eventId: String, retualId: String, completion: @escaping ([Guest]) -> Void) {
        pageNumber = 1
        // 得られた情報からデータを検索
        self.collectionRef(eventId).whereField("retuals.\(retualId)", isEqualTo: true).getDocuments(source: .cache) { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    var guest = Guest(document: document)
                    guest.pageNumber = self.pageNumber
                    self.pageNumber += 1
                    return guest
                })
                completion(self.guests)
            } else {
                print(error as Any)
                return
            }
        }
    }
    
    func selectGuestAll(eventId: String, completion: @escaping ([Guest]) -> Void) {
        pageNumber = 1
        Guest.collectionRef(eventId).order(by:"createdAt").getDocuments(source: .cache) { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    var guest = Guest(document: document)
                    guest.pageNumber = self.pageNumber
                    self.pageNumber += 1
                    return guest
                })
                completion(self.guests)
            } else {
                print(error as Any)
                return
            }
        }
    }
    
    func sortGuests(guests: inout [Guest], selectRank: Dictionary<String, Bool?>) -> [Guest] {
        if let guestRank = selectRank["guestName"] {
            if guestRank! {
                guests.sort(by: {$0.guestName < $1.guestName})
            } else if !guestRank! {
                guests.sort(by: {$0.guestName > $1.guestName})
            }
        } else {
            guests.sort(by: {$0.createdAt < $1.createdAt})
        }
        return guests
    }
    
    func getGuestCard(_ guest: Guest) -> StorageReference {
        let filename = "\(guest.id)_guestCard.png"
        let storageURL = Keys.firestoreStorageUrl
        let storageRef = Storage.storage().reference(forURL: storageURL).child(filename)
        return storageRef
    }
}
