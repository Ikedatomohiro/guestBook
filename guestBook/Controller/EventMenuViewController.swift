//
//  EventMenuViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit

class EventMenuViewController: UIViewController {

    fileprivate let event: Event
    fileprivate let eventMenuList = UIStackView()
    fileprivate let showGuestCardButton = UIButton()
    fileprivate let showGuestDetailButton = UIButton()
    fileprivate let showSettingButton = UIButton()

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = event.eventName
        self.view.backgroundColor = .red
        setupEventMenuList()

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
        
        view.addSubview(showSettingButton)
        showSettingButton.setTitle("設定", for: .normal)
        showSettingButton.backgroundColor = .systemTeal
        showSettingButton.layer.cornerRadius = 5
        eventMenuList.addArrangedSubview(showSettingButton)
    }
    
    @objc private func showGuestCard() {
        let guestCardVC = GuestsController()
        guestCardVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(guestCardVC, animated: true)
    }
}
