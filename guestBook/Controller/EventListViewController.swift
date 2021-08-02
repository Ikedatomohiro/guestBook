//
//  EventListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/10/27.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol EventListViewControllerDelegate: AnyObject {
    func moveTosignPage()
}

class EventListViewController: UIViewController {
    let titleLabel         = UILabel()
    fileprivate let logInButton        = UIButton()
    fileprivate let createEventButton  = UIButton()
    fileprivate let db                 = Firestore.firestore()
    fileprivate let eventNameTextField = UITextField()
    lazy var eventListTableView        = EventListTableView(events: events, frame: .zero, style: .plain)
    fileprivate var events             = [Event]()
    fileprivate let defaultRetuals     = DefaultParam.retuals
    fileprivate let defaultRelations   = DefaultParam.relations
    fileprivate let defaultGroups      = DefaultParam.groups
    fileprivate var number: Int        = 0
    fileprivate let sideMenuVC         = SideMenuViewController()
    fileprivate var sideMenuAppearance = false
    weak var eventListViewContollerDelegate:EventListViewControllerDelegate?
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // 非表示にしたNavigationControllerを再度表示させる
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setupBase()
        fetchEventList()
        setupCreateEventButton()
        setupEventListTableView()
        setBackButtonTitle()
        setupSettingImage()
    }
    
    fileprivate func setupBase() {
        view.backgroundColor = dynamicColor
        if Auth.auth().currentUser != nil {
            print("signed in \(Auth.auth().currentUser?.uid)")
        } else {
            print("サインインしてください。")
            moveToSignInPage()
        }
    }
    
    func setupCreateEventButton() {
        view.addSubview(createEventButton)
        createEventButton.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 20, right: 10), size: .init(width: 100, height: 50))
        createEventButton.setTitle("新規作成", for: UIControl.State.normal)
        createEventButton.backgroundColor = green
        createEventButton.layer.cornerRadius = 5
        createEventButton.addTarget(self, action: #selector(createEventButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func createEventButtonDidTap() {
        createEventButton.animateView(createEventButton)
        let VC = CreateEventViewController()
        VC.modalPresentationStyle = .custom
        VC.transitioningDelegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
    fileprivate func setupEventNameTextFeild() {
        view.addSubview(eventNameTextField)
        eventNameTextField.anchor(top: createEventButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 70))
        eventNameTextField.borderStyle = .bezel
    }
    
    fileprivate func setupEventListTableView() {
        view.addSubview(eventListTableView)
        eventListTableView.anchor(top: createEventButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: .zero, bottom: .zero, right: .zero))
        eventListTableView.eventListTableViewDelegate = self
        eventListTableView.register(EventListCell.self, forCellReuseIdentifier: EventListCell.className)
    }
    
    // Firestoreからイベント名リストを取得
    fileprivate func fetchEventList() {
        db.collection("events").getDocuments() { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            self.events = documents.map{ (document) -> Event in
                return Event(document: document)
            }
            self.eventListTableView.reloadEventListData(events: self.events)
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    fileprivate func moveToSignInPage() {
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signInVC, animated: true)
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
    
    // NavigationBarのアイコンセット
    fileprivate func setupSettingImage() {
        let imageSize = CGSize(width: 30, height: 30)
        let settingIcon = settingImageIcon
        let settingImage = settingIcon.withRenderingMode(.automatic).reSizeImage(reSize: imageSize)
        let menu = UIBarButtonItem(image: settingImage, style: .done, target: self, action: #selector(sideMenuToggle))
        self.navigationItem.leftBarButtonItem = menu
        self.navigationController?.navigationBar.tintColor = UIColor.dynamicColor(light: .gray, dark: .white)
    }
    
    @objc fileprivate func sideMenuToggle() {
        if sideMenuAppearance == false {
            view.addSubview(sideMenuVC.view)
            sideMenuVC.view.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
            sideMenuVC.sideMenuDelegate = self
            sideMenuVC.eventListViewControllerDelegate = self
            sideMenuAppearance = true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.sideMenuVC.sideMenuView.center.x -= screenSize.width / 4
                self.sideMenuVC.backgroundView.alpha = 0
            } completion: { (Bool) in
                self.sideMenuVC.view.removeFromSuperview()
                self.sideMenuAppearance = false
            }
        }
    }
    
    fileprivate func moveToEventMenu(event: Event) {
        let eventMenuVC = EventMenuViewController(event: event)
        eventMenuVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(eventMenuVC, animated: true)
    }
}

// MARK:- Extension
extension EventListViewController: EventListTableViewDelegate {
    func didSelectEvent(event: Event) {
        moveToEventMenu(event: event)
    }
}

extension EventListViewController: SideMenuDelegate {
    func hidePopup() {
        sideMenuVC.view.removeFromSuperview()
        sideMenuAppearance = false
    }
    
    // サイドメニューが表示されているときに背景をタップすると元の表示に戻る
    func hideSideMenuView() {
        sideMenuVC.view.removeFromSuperview()
        sideMenuAppearance = false
    }
    
}

extension EventListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let createEventPC = CreateEventPresentationController(presentedViewController: presented, presenting: presenting)
        createEventPC.createEventDelegate = self
        return createEventPC
    }
}

extension EventListViewController: CreateEventDelegate {
    func createEvent(eventName: String) {
        
        let docmentRef = Event.registEvent(eventName)
        let eventId = docmentRef.documentID
        // 儀式、ご関係の初期値を登録
        registDefaultParam(eventId: eventId)
        // ログイン機能を実装したら"users"を挟む
        
        // テーブル再読み込み
        fetchEventList()
    }
}

extension EventListViewController: EventListViewControllerDelegate {
    func moveTosignPage() {
        self.moveToSignInPage()
    }
}
