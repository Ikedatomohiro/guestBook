//
//  GuestListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/21.
//

import UIKit
import FirebaseFirestore

    class GuestListViewController: UIViewController {

    fileprivate let event: Event
    fileprivate var guests = [Guest]()
    fileprivate var guestListTableView = UITableView()
    fileprivate var db = Firestore.firestore()
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchGuestList()
        setupGuestListTableView()
        setBackButtonTitle()
    }

    func fetchGuestList() {
        db.collection("events").document(event.eventId).collection("guests").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
//            self.guests = documents.map{Guest(document: $0)}
            self.guests = documents.map{ (document) -> Guest in
                return Guest(document: document)
            }
            self.guestListTableView.reloadData()
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    fileprivate func setupGuestListTableView() {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        guestListTableView.delegate = self
        guestListTableView.dataSource = self
        guestListTableView.register(GuestCell.self, forCellReuseIdentifier: GuestCell.className)
    }
        
    // 戻るボタンの名称をセット
    fileprivate func setBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "参加者一覧に戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

extension GuestListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let guestDetailVC = GuestDetailViewController(guest: guests[indexPath.row])
        guestDetailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestDetailVC, animated: true)
    }
}

extension GuestListViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuestCell.className) as? GuestCell else { fatalError("improper UITableViewCell")}
        cell.setupGuestData(guest: guests[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

extension GuestListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 戻るボタンを押したときにデータを更新したい
        fetchGuestList()
        self.guestListTableView.reloadData()
    }
}
