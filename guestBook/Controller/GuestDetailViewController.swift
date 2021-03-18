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
//        setupGuestsTable()
//        setGuestInfoStackView()
        setupGuestDetail()
        
        
    }
    
    fileprivate func setupBase() {
        view.backgroundColor = .white
        
    }

    fileprivate func setupGuestsTable() {
        view.addSubview(guestsTable)
        guestsTable.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 4, height: .zero))
        guestsTable.delegate = self
        guestsTable.dataSource = self
        guestsTable.register(TextCell.self, forCellReuseIdentifier: TextCell.className)
    }
    
    fileprivate func setupGuestDetail() {
        view.addSubview(guestNameTitleLabel)
        guestNameTitleLabel.text = "御芳名"
        guestNameTitleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil)
        
        view.addSubview(guestNameTextFeild)
        guestNameTextFeild.anchor(top: guestNameTitleLabel.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil)
        guestNameTextFeild.text = guests[index].guestName
        guestNameTextFeild.layer.borderWidth = 1.0
        guestNameTextFeild.layer.cornerRadius = 5.0
        
        
        
    }
    
    fileprivate func setupGuestCardView() {
        
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
        
        guestNameTextFeild.text = guests[index].guestName
        guestNameTextFeild.addTarget(self, action: #selector(guestNameTextFeildDidChange), for: .editingDidEnd)
    }
    
    
    @objc private func guestNameTextFeildDidChange() {
        print("名前が変更されました。")
        let name = guestNameTextFeild.text!
        let guest = guests[index]
        db.document(guest.eventId).collection("guests").document(guest.id).updateData(["guestName": name, "updatedAt": Date()])
    }
}

// MARK:- Extensions
extension GuestDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.className) as? TextCell  else {
            fatalError("improper UITableViewCell")}
        cell.setText(text: "てきすと")
        return cell
    }
    
    
}

extension GuestDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップしました。")
    }
}
