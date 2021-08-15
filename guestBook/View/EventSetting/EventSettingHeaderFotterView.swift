//
//  EventSettingHeaderFotterView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/08/15.
//

import UIKit

class EventSettingHeaderFotterView: UITableViewHeaderFooterView {
    
    var headlineLabel = UILabel()
    
    func setup() {
        setupBase()
        setupHeadlineLabel()
    }

    fileprivate func setupBase() {
        self.contentView.backgroundColor = .dynamicColor(light: green, dark: .white)
    }
    
    fileprivate func setupHeadlineLabel() {
        addSubview(headlineLabel)
        headlineLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        headlineLabel.text = "儀式情報"
        headlineLabel.textColor = .dynamicColor(light: .white, dark: .black)
        headlineLabel.textAlignment = .center
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
}
