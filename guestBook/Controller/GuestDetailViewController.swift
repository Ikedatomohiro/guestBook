//
//  GuestDetailViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/12/06.
//

import UIKit
import FirebaseFirestore

class GuestDetailViewController: UIViewController {

    fileprivate let guestInfoStackView = UIStackView()
    fileprivate let guest: Guest
    fileprivate let guestNameLabel     = UILabel()
    fileprivate let guestNameTextFeild = UITextField()
    fileprivate let db = Firestore.firestore().collection("events")
    
    let DeviseSize: CGSize = UIScreen.main.bounds.size
    
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
        setGuestInfoStackView()
        setupGuestInfo()
        
        
    }

    fileprivate func setGuestInfoStackView() {
        view.addSubview(guestInfoStackView)
        guestInfoStackView.spacing = 10.0
        guestInfoStackView.axis    = .vertical
        guestInfoStackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: DeviseSize.width/4, height: DeviseSize.height))
        
        let RightBorder = CALayer()
        RightBorder.frame = CGRect(x: guestInfoStackView.frame.width - 1.0, y: 0, width: 1.0, height: guestInfoStackView.frame.height)
        RightBorder.backgroundColor = UIColor.lightGray.cgColor
        guestInfoStackView.layer.addSublayer(RightBorder)
    }

    fileprivate func setupGuestInfo() {
        self.view.addSubview(guestNameTextFeild)
        guestInfoStackView.addArrangedSubview(guestNameTextFeild)
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: guestNameTextFeild.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.green.cgColor
        guestNameTextFeild.layer.addSublayer(topBorder)
        
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
