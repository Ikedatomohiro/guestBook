//
//  SelectGuest.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/25.
//

import UIKit
import FirebaseFirestore

let firestoreQueueGroup = DispatchGroup()
let firestoreQueue  = DispatchQueue.global(qos: .userInitiated)

class SelectGuest {
    
    var guests: [Guest] = []
    var pageNumber: Int = 1
    
    func collectionRef(_ eventId: String) -> CollectionReference {
        return Firestore.firestore().collection("events").document(eventId).collection("guests")
    }
    
    func selectGuestFromRetual(eventId: String, retualId: String, completion: @escaping ([Guest]) -> Void) {
        // 得られた情報からデータを検索
        self.collectionRef(eventId).whereField("retuals.\(retualId)", isEqualTo: true).getDocuments { (querySnapshot, error) in
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
        Guest.collectionRef(eventId).getDocuments { (querySnapshot, error) in
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
}
