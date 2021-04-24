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
    fileprivate let moveGuestListButton = UIButton()
    fileprivate let moveSettingButton     = UIButton()
    fileprivate var retuals: [Retual]     = []
    fileprivate var relations: [Relation] = []
    fileprivate var groups: [Group]       = []
    fileprivate var pageNumber: Int       = 0
    let selectGuests = SelectGuests()
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
        setupMoveGuestCardButton()
        setupMoveGuestListButton()
        setupMoveSettingButton()
        setBackButtonTitle() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectGuests.fetchData(eventId: event.eventId) { (guests) in
            self.guests = guests
        }
    }
    
    //MARK:- Function
    fileprivate func setupBase() {
        navigationItem.title = event.eventName
        self.getRetualRelationGroupData()
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupMoveGuestCardButton() {
        view.addSubview(moveGuestCardButton)
        moveGuestCardButton.setTitle("参加者入力", for: .normal)
        moveGuestCardButton.backgroundColor = green
        moveGuestCardButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 40))
        moveGuestCardButton.layer.cornerRadius = 5
        moveGuestCardButton.addTarget(self, action: #selector(showGuestCard), for: .touchUpInside)
    }
    
    fileprivate func setupMoveGuestListButton() {
        view.addSubview(moveGuestListButton)
        moveGuestListButton.setTitle("参加者一覧", for: .normal)
        moveGuestListButton.backgroundColor = green
        moveGuestListButton.anchor(top: moveGuestCardButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 40))
        moveGuestListButton.layer.cornerRadius = 5
        moveGuestListButton.addTarget(self, action: #selector(showGuestList), for: .touchUpInside)
    }
    
    fileprivate func setupMoveSettingButton() {
        view.addSubview(moveSettingButton)
        moveSettingButton.setTitle("設定", for: .normal)
        moveSettingButton.backgroundColor = green
        moveSettingButton.anchor(top: moveGuestListButton.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 40))
        moveSettingButton.layer.cornerRadius = 5
        moveSettingButton.addTarget(self, action: #selector(showSetting), for: .touchUpInside)
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
        // パスワードか何かを要求する？？
        
        
        
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
