//
//  eventListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/10/27.
//

import UIKit
import FirebaseFirestore

class eventListViewController: UIViewController {
    fileprivate let titleLabel = UILabel()
    fileprivate let createEventButton = UIButton()
    fileprivate let db = Firestore.firestore()
    fileprivate let eventNameTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        setUpTitleLabel()
        setUpCreateEventButton()
        setUpEventNameTextFeild()

    }

    func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.backgroundColor = .blue
        titleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 80, left: 30, bottom: 0, right: 0))
        titleLabel.text = "芳名帳アプリ"
    }
    
    func setUpCreateEventButton() {
        view.addSubview(createEventButton)
        createEventButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 30), size: .init(width: 150, height: 50))
        createEventButton.setTitle("イベント新規作成", for: UIControl.State.normal)
        createEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
    }
    
    @objc private func createEvent() {
        let eventName = eventNameTextField.text
        db.collection("users").addDocument(data: ["eventName": eventName!])
        eventNameTextField.text = ""
    }
    
    func setUpEventNameTextFeild() {
        view.addSubview(eventNameTextField)
        eventNameTextField.anchor(top: createEventButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 70))
    }
    
}

