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
    fileprivate let eventMenuList         = UIStackView()
    fileprivate let showGuestCardButton   = UIButton()
    fileprivate let showGuestDetailButton = UIButton()
    fileprivate let showSettingButton     = UIButton()
    fileprivate var retuals:[Retual]      = []
    fileprivate var pageNumber: Int       = 0
    
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
        setupEventMenuList()
        setBackButtonTitle() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = fetchData()
    }
    
    //MARK:- Function
    func fetchData() -> Bool {
        var fetchFlg = false
        pageNumber = 1
        Guest.collectionRef(event.eventId).order(by:"createdAt").getDocuments() { (querySnapshot, error) in
            if (error == nil) {
                guard let docments = querySnapshot?.documents else { return }
                self.guests = docments.map({ (document) -> Guest in
                    var guest = Guest(document: document)
                    guest.pageNumber = self.pageNumber
                    self.pageNumber += 1
                    return guest
                })
                fetchFlg = true
            } else {
                print("取得に失敗しました。")
                print(error as Any)
                return
            }
        }
        return fetchFlg
    }
    
    fileprivate func setupBase() {
        navigationItem.title = event.eventName
        retuals = getRetuals(eventId: event.eventId)
        self.view.backgroundColor = .red
    }
    
    
    fileprivate func setupEventMenuList() {
        self.view.addSubview(eventMenuList)
        eventMenuList.spacing = 10.0
        eventMenuList.axis = .vertical
        eventMenuList.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil)
        
        view.addSubview(showGuestCardButton)
        showGuestCardButton.setTitle("参加者入力画面へ", for: .normal)
        showGuestCardButton.backgroundColor = .systemGreen
        showGuestCardButton.layer.cornerRadius = 5
        eventMenuList.addArrangedSubview(showGuestCardButton)
        showGuestCardButton.addTarget(self, action: #selector(showGuestCard), for: .touchUpInside)
        
        view.addSubview(showGuestDetailButton)
        showGuestDetailButton.setTitle("参加者一覧", for: .normal)
        showGuestDetailButton.backgroundColor = .systemBlue
        showGuestDetailButton.layer.cornerRadius = 5
        eventMenuList.addArrangedSubview(showGuestDetailButton)
        showGuestDetailButton.addTarget(self, action: #selector(showGuestList), for: .touchUpInside)
        
        view.addSubview(showSettingButton)
        showSettingButton.setTitle("設定", for: .normal)
        showSettingButton.backgroundColor = .systemTeal
        showSettingButton.layer.cornerRadius = 5
        eventMenuList.addArrangedSubview(showSettingButton)
        showSettingButton.addTarget(self, action: #selector(showSetting), for: .touchUpInside)
        
    }
    
    @objc private func showGuestCard() {
        let guestCardVC = GuestsPageViewController(event, retuals, guests)
        guestCardVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestCardVC, animated: true)
    }
    
    @objc private func showGuestList() {
        let guestListVC = GuestListViewController(event, retuals, guests)
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
}
