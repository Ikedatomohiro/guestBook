//
//  GuestDetailViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/12/06.
//

import UIKit

class GuestDetailViewController: UIViewController {
    
    fileprivate var guest: Guest
    fileprivate let guestCard: UIImageView = UIImageView()
    var index: Int?
    
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBase()
        setupGuestData()
    }
    
    fileprivate func setupBase() {
        view.backgroundColor = .white
    }

    fileprivate func setupGuestData() {
        view.addSubview(guestCard)
        guestCard.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        let selectGuest = SelectGuests()
        let storageRef = selectGuest.getGuestCard(guest)
        storageRef.getData(maxSize: 1024 * 1024 * 10) { (data: Data?, error: Error?) in
            if error != nil {
                return
            }
            if let imageData = data {
                let guestCardImage: UIImageView = UIImageView()
                guestCardImage.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
                guestCardImage.image = UIImage(data: imageData)
                self.guestCard.image = guestCardImage.image
                self.guestCard.contentMode = .scaleAspectFit
                self.guestCard.clipsToBounds = true
            }
        }
    }
}
