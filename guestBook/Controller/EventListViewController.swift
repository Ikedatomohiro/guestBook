//
//  EventListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/10/27.
//

import UIKit
import FirebaseFirestore

class EventListViewController: UIViewController {
    let titleLabel         = UILabel()
    fileprivate let logInButton        = UIButton()
    fileprivate let createEventButton  = UIButton()
    fileprivate let db                 = Firestore.firestore()
    fileprivate let eventNameTextField = UITextField()
    let eventNameTableView = UITableView()
    fileprivate var events             = [Event]()
    fileprivate let defaultRetuals     = DefaultParam.retuals
    fileprivate let defaultRelations   = DefaultParam.relations
    fileprivate let defaultGroups      = DefaultParam.groups
    fileprivate var number: Int        = 0
    fileprivate let menuVC = SideMenuViewController()
    fileprivate var sideMenuAppearance = false
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitleLabel()
        setLogInButton()
        setupCreateEventButton()
        setupEventNameTextFeild()
        setupEventNameTableView()
        fetchEventNameList()
        setBackButtonTitle()
        setupSettingImage()
    }
    
    //MARK:- Function
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.backgroundColor = .systemYellow
        titleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0))
        titleLabel.text = "芳名帳アプリ"
    }
    
    func setupCreateEventButton() {
        view.addSubview(createEventButton)
        createEventButton.anchor(top: titleLabel.layoutMarginsGuide.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 30), size: .init(width: 200, height: 50))
        createEventButton.setTitle("イベント新規作成", for: UIControl.State.normal)
        createEventButton.backgroundColor = .systemGray
        createEventButton.layer.cornerRadius = 5
        createEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
    }
    
    @objc private func createEvent() {
        let eventName = eventNameTextField.text
        if eventName != nil {
            let docmentRef = db.collection("events").addDocument(data: ["eventName": eventName!])
            let eventId = docmentRef.documentID
            // 儀式、ご関係の初期値を登録
            registDefaultParam(eventId: eventId)
            // ログイン機能を実装したら"users"を挟む
            eventNameTextField.text = ""
        }
        // テーブル再読み込み
        fetchEventNameList()
    }
    
    fileprivate func setupEventNameTextFeild() {
        view.addSubview(eventNameTextField)
        eventNameTextField.anchor(top: createEventButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 70))
        eventNameTextField.borderStyle = .bezel
    }
    
    fileprivate func setupEventNameTableView() {
        view.addSubview(eventNameTableView)
        eventNameTableView.anchor(top: eventNameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        eventNameTableView.delegate = self
        eventNameTableView.dataSource = self
        eventNameTableView.register(EventNameCell.self, forCellReuseIdentifier: EventNameCell.className)
    }
    
    // Firestoreからイベント名リストを取得
    fileprivate func fetchEventNameList() {
        db.collection("events").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.events = documents.map{ (document) -> Event in
                return Event(document: document)
            }
            self.eventNameTableView.reloadData()
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    fileprivate func setLogInButton() {
        view.addSubview(logInButton)
        logInButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 200, height: 50))
        logInButton.setTitle("ログインする", for: UIControl.State.normal)
        logInButton.backgroundColor = .systemGreen
        logInButton.layer.cornerRadius = 5
        logInButton.addTarget(self, action: #selector(showLogInPage), for: .touchUpInside)
    }
    
    @objc private func showLogInPage() {
        let logInVC = LogInViewController()
        logInVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(logInVC, animated: true)
    }
    
    // 戻るボタンの名称をセット
    fileprivate func setBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "イベントリストに戻る"
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    fileprivate func registDefaultParam(eventId: String) {
        // 儀式のデフォルト値を登録
        number = 0
        for retual in defaultRetuals {
            number += 1
            Retual.registRetual(retual: Retual(name: retual), eventId: eventId, number: number)
        }
        number = 0
        // どなたのご関係のデフォルト値を登録
        for relation in defaultRelations {
            number += 1
            Relation.registRelation(relation: Relation(name: relation), eventId: eventId, number: number)
        }
        number = 0
        // どのようなご関係のデフォルト値を登録
        for group in defaultGroups {
            number += 1
            Group.registGroup(group: Group(name: group), eventId: eventId, number: number)
        }
    }
    
    fileprivate func setupSettingImage() {
        let imageSize = CGSize(width: 30, height: 30)
        let settingImage = #imageLiteral(resourceName: "menu.png").withRenderingMode(.automatic).reSizeImage(reSize: imageSize)
        let menu = UIBarButtonItem(image: settingImage, style: .done, target: self, action: #selector(showSetting))
        self.navigationItem.leftBarButtonItem = menu
        self.navigationController?.navigationBar.tintColor = UIColor.rgb(red: 48, green: 48, blue: 48)
    }
    
    @objc fileprivate func showSetting() {
        if sideMenuAppearance == false {
            view.addSubview(menuVC.view)
            menuVC.view.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
            menuVC.sendMenuBackgroundDidTapDelegate = self
            sideMenuAppearance = true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.menuVC.menuListView.center.x -= screenSize.width / 4
            } completion: { (Bool) in
                self.menuVC.view.removeFromSuperview()
                self.sideMenuAppearance = false
            }
        }
    }
}

// MARK:- Extension
extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventMenuVC = EventMenuViewController(event: events[indexPath.row])
        eventMenuVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(eventMenuVC, animated: true)
    }
}

extension EventListViewController: UITableViewDataSource {
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

extension EventListViewController: SendMenuBackgroundDidTapDelegate {
    // サイドメニューが表示されているときに背景をタップすると本の表示に戻る
    func backGroundDidTap() {
        menuVC.view.removeFromSuperview()
    }
}
