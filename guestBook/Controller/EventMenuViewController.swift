//
//  EventMenuViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit

class EventMenuViewController: UIViewController {

    fileprivate let event: Event
    fileprivate let eventNameLabel = UILabel()
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
        
        self.view.backgroundColor = .red
        setupEventNameLabel()
        setupEventMenuList()

    }
    
    fileprivate func setupEventNameLabel() {
        self.view.addSubview(eventNameLabel)
        eventNameLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 100))
        eventNameLabel.text = event.eventName
    }

    fileprivate func setupEventMenuList() {
        self.view.addSubview(eventMenuList)
        eventMenuList.spacing = 10.0
        eventMenuList.axis = .vertical
        eventMenuList.anchor(top: eventNameLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil)
        
        view.addSubview(showGuestCardButton)
        showGuestCardButton.setTitle("参加者入力画面へ", for: .normal)
        showGuestCardButton.backgroundColor = .systemGreen
        showGuestCardButton.layer.cornerRadius = 10
        eventMenuList.addArrangedSubview(showGuestCardButton)
        
        view.addSubview(showGuestDetailButton)
        showGuestDetailButton.setTitle("参加者一覧", for: .normal)
        showGuestDetailButton.backgroundColor = .systemBlue
        showGuestDetailButton.layer.cornerRadius = 10
        eventMenuList.addArrangedSubview(showGuestDetailButton)
        
        view.addSubview(showSettingButton)
        showSettingButton.setTitle("設定", for: .normal)
        showSettingButton.backgroundColor = .systemTeal
        showSettingButton.layer.cornerRadius = 10
        eventMenuList.addArrangedSubview(showSettingButton)
    }
}
