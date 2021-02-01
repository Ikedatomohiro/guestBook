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
    fileprivate var guests: [Guest]
    fileprivate var guestListTableView = UITableView()
//    lazy var guestListTableView = GuestListTableView(guests: guests, frame: .zero, style: .plain)

    fileprivate var guestSortAreaView: UIView = GuestSortAreaView()
    fileprivate var pageNumber  : Int     = 1

        

    init(event: Event) {
        self.event = event
        self.guests = [Guest]()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()

        fetchGuestList()
        setSearchArea()
        setupGuestListTableView(guests: guests)
        setBackButtonTitle()
    }

    fileprivate func setupBasic() {
        view.backgroundColor = .white
    }

    fileprivate func fetchGuestList() {
        Guest.collectionRef(eventId: event.eventId).getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.guests = documents.map{ (document) -> Guest in
                var guest = Guest(document: document)
                guest.pageNumber = self.pageNumber
                self.pageNumber += 1
                return guest
            }
            self.guestListTableView.reloadData()
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    fileprivate func setSearchArea() {
        view.addSubview(guestSortAreaView)
        guestSortAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, size: .init(width: screenSize.width, height: screenSize.height / 15))

    }
    
        
    fileprivate func setupGuestListTableView(guests: [Guest]) {
        view.addSubview(guestListTableView)
        guestListTableView.anchor(top: guestSortAreaView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
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

    // リスト高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    // ヘッダー
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let guestListHeader = GuestListHeaderCell()

        guestListHeader.backgroundColor = .yellow


        return guestListHeader
    }
    // ヘッダー高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
}

extension GuestListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 戻るボタンを押したときにデータを更新したい
        fetchGuestList()
        self.guestListTableView.reloadData()
    }
}
