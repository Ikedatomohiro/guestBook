//
//  GuestDetailViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/12/06.
//

import UIKit
import FirebaseFirestore

class GuestDetailViewController: UIViewController {

    fileprivate let guest: Guest
    fileprivate let guestNameTextFeild = UITextField()
    fileprivate let db = Firestore.firestore().collection("events")
    
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGuestInfo()
        
        
    }

    
    fileprivate func setupGuestInfo() {
        self.view.addSubview(guestNameTextFeild)
        guestNameTextFeild.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 30))
        guestNameTextFeild.text = guest.guestName
        guestNameTextFeild.addTarget(self, action: #selector(guestNameTextFeildDidChange), for: .editingDidEnd)
    }
    
    @objc private func guestNameTextFeildDidChange() {
        print("名前が変更されました。")
        let name = guestNameTextFeild.text!
        print(name)
        print(guest.id)
        db.document(guest.eventId).collection("guests").document(guest.id).updateData(["guestName": name, "updatedAt": Date()])
    }
}
