//
//  EventMenuViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import FirebaseFirestore

class EventMenuViewController: UIViewController {
    
    fileprivate let event: Event
    fileprivate var guests: [Guest]       = []
    fileprivate let moveGuestCardButton   = UIButton()
    fileprivate let moveGuestListButton   = UIButton()
    fileprivate let moveSettingButton     = UIButton()
    fileprivate var retuals: [Retual]     = []
    fileprivate var relations: [Relation] = []
    fileprivate var groups: [Group]       = []
    let selectGuests = SelectGuests()
    lazy var eventInfoAreaView     = EventInfoAreaView(event: event, guests: guests, frame: .zero)
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBase()
        setupEventInfoArea()
        setupMoveGuestCardButton()
        setupMoveGuestListButton()
        setupMoveSettingButton()
        setBackButtonTitle() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //MARK:- Function
    fileprivate func setupBase() {
        navigationItem.title = event.eventName
        self.getRetualRelationGroupData()
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupEventInfoArea() {
        view.addSubview(eventInfoAreaView)
        eventInfoAreaView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor)
    }
    
    fileprivate func fetchData() {
        selectGuests.fetchData(eventId: event.eventId) { (guests) in
            self.guests = guests
            // 参加者の登録数をセット
            self.eventInfoAreaView.setGuestsCount(count: guests.count)
        }
    }
    
    fileprivate func setupMoveGuestCardButton() {
        view.addSubview(moveGuestCardButton)
        buttonCustomise(button: moveGuestCardButton, text: "参加者入力")
        moveGuestCardButton.anchor(top: eventInfoAreaView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveGuestCardButton.addTarget(self, action: #selector(showGuestCard), for: .touchUpInside)
    }
    
    fileprivate func setupMoveGuestListButton() {
        view.addSubview(moveGuestListButton)
        buttonCustomise(button: moveGuestListButton, text: "参加者一覧")
        moveGuestListButton.anchor(top: moveGuestCardButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveGuestListButton.addTarget(self, action: #selector(showGuestList), for: .touchUpInside)
    }
    
    fileprivate func setupMoveSettingButton() {
        view.addSubview(moveSettingButton)
        buttonCustomise(button: moveSettingButton, text: "設定")
        moveSettingButton.anchor(top: moveGuestListButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        moveSettingButton.addTarget(self, action: #selector(showSetting), for: .touchUpInside)
    }
    
    fileprivate func buttonCustomise(button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
        button.backgroundColor = green
        button.titleLabel?.font = .systemFont(ofSize: 24)
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 5
    }
    
    @objc private func showGuestCard() {
        let guestsPVC = GuestsPageViewController(event, retuals, relations, groups, guests)
        guestsPVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestsPVC, animated: true)
    }
    
    @objc private func showGuestList() {
        let guestListVC = GuestListViewController(event, retuals,guests)
        guestListVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestListVC, animated: true)
    }
    
    @objc private func showSetting() {
        let settingVC = SettingViewController()
        settingVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // 戻るボタンの名称をセット
    fileprivate func setBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "メニューに戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    fileprivate func getRetuals(eventId: String) -> [Retual] {
        Retual.collectionRef(eventId: eventId).order(by:"number").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.retuals = documents.map({ (document) -> Retual in
                let retual = Retual(docment: document)
                return retual
            })
        }
        return self.retuals
    }
    
    fileprivate func getRelations(eventId: String) -> [Relation] {
        Relation.collectionRef(eventId: eventId).order(by: "number").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.relations = documents.map({ (documnt) -> Relation in
                let relation = Relation(docment: documnt)
                return relation
            })
        }
        return self.relations
    }
    
    fileprivate func getGroups(eventId: String) -> [Group] {
        Group.collectionRef(eventId: eventId).order(by: "number").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.groups = documents.map({ (documnt) -> Group in
                let group = Group(docment: documnt)
                return group
            })
        }
        return self.groups
    }
    
    fileprivate func getRetualRelationGroupData() {
        self.retuals = getRetuals(eventId: event.eventId)
        self.relations = getRelations(eventId: event.eventId)
        self.groups = getGroups(eventId: event.eventId)
    }
}
