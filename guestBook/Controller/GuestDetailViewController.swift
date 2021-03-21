//
//  GuestDetailViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/12/06.
//

import UIKit
import FirebaseFirestore

class GuestDetailViewController: UIViewController {
    
    fileprivate let guestsTable: UITableView = UITableView()
    fileprivate let guestInfoStackView = UIStackView()
    fileprivate var guests: [Guest]
    fileprivate let guestNameTitleLabel = UILabel()
    fileprivate let guestNameTextFeild = UITextField()
    fileprivate let db = Firestore.firestore().collection("events")
    fileprivate let index: Int
    
    let DeviseSize: CGSize = UIScreen.main.bounds.size
    
    init(guests: [Guest], index: Int) {
        self.guests = guests
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupBase()

        
        
    }
    
    fileprivate func setupBase() {
        view.backgroundColor = .white
        
    }



}
