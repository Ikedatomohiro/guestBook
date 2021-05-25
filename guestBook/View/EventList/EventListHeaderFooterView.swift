//
//  EventListHeaderFooterView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/23.
//

import UIKit

class EventListHeaderFooterView: UITableViewHeaderFooterView {
    
    var eventNameHeadline = UILabel()
    var evenCreatedAtHeadline = UILabel()
    
    func setup() {
        setupBase()
        setupHeadlineLabel()
    }
    
    fileprivate func setupBase() {
        self.contentView.backgroundColor = .dynamicColor(light: green, dark: .white)
    }
    
    fileprivate func setupHeadlineLabel() {
        setupEventNameHeadlineLabel()
        setupEventCreatedAtHeadlineLabel()
    }

    fileprivate func setupEventNameHeadlineLabel() {
        self.addSubview(eventNameHeadline)
        eventNameHeadline.text = "儀式名"
        eventNameHeadline.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        eventNameHeadline.textColor = .dynamicColor(light: .white, dark: .black)
        eventNameHeadline.font = UIFont.boldSystemFont(ofSize: 20)
    }

    fileprivate func setupEventCreatedAtHeadlineLabel() {
        self.addSubview(evenCreatedAtHeadline)
        evenCreatedAtHeadline.text = "儀式登録日"
        evenCreatedAtHeadline.anchor(top: self.layoutMarginsGuide.topAnchor, leading: eventNameHeadline.trailingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        evenCreatedAtHeadline.textColor = .dynamicColor(light: .white, dark: .black)
        evenCreatedAtHeadline.font = UIFont.boldSystemFont(ofSize: 20)
    }
}
