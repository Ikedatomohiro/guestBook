//
//  EventListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/10/27.
//

import UIKit
import FirebaseFirestore

class EventListViewController: UIViewController {
    fileprivate let titleLabel = UILabel()
    fileprivate let createEventButton = UIButton()
    fileprivate let db = Firestore.firestore()
    fileprivate let eventNameTextField = UITextField()
    fileprivate let eventNameTableView = UITableView()
    fileprivate var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupTitleLabel()
        setupCreateEventButton()
        setupEventNameTextFeild()
        setupEventNameTableView()
        fetchEventNameList()
    }

    func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.backgroundColor = .blue
        titleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 80, left: 30, bottom: 0, right: 0))
        titleLabel.text = "芳名帳アプリ"
    }
    
    func setupCreateEventButton() {
        view.addSubview(createEventButton)
        createEventButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 30), size: .init(width: 150, height: 50))
        createEventButton.setTitle("イベント新規作成", for: UIControl.State.normal)
        createEventButton.backgroundColor = .systemGray
        createEventButton.layer.cornerRadius = 20
        createEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
    }
    
    @objc private func createEvent() {
        let eventName = eventNameTextField.text
        db.collection("eventName").addDocument(data: ["eventName": eventName!]) // ログイン機能を実装したら"users"を挟む
        eventNameTextField.text = ""
        // テーブル再読み込み
        fetchEventNameList()
    }
    
    fileprivate func setupEventNameTextFeild() {
        view.addSubview(eventNameTextField)
        eventNameTextField.anchor(top: createEventButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 70))
    }
    fileprivate func setupEventNameTableView() {
        view.addSubview(eventNameTableView)
        eventNameTableView.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        eventNameTableView.delegate = self
        eventNameTableView.dataSource = self
        eventNameTableView.register(EventNameCell.self, forCellReuseIdentifier: EventNameCell.className)
    }
    func fetchEventNameList() {
        events = []
        print("データ取ります")
        db.collection("eventName").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else { return }
            self.events = documents.map{ (document) -> Event in
                return Event(document: document)
            }
            self.eventNameTableView.reloadData()
            if let err = err {
                print(err)
                return
            }
        }
        
        
    }
}

extension EventListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let guestCardVC = GuestCardViewController(event: events[indexPath.row])
        guestCardVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestCardVC, animated: true)
    }
}

extension EventListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventNameCell.className) as? EventNameCell else { fatalError("improper UITableViewCell")}
        cell.setupEventName(event: events[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
}
