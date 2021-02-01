//
//  GuestListHeaderCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

class GuestListHeaderCell: UITableViewCell {
    
    fileprivate let numberLabel      = UILabel()
    fileprivate let guestNameLabel   = UILabel()
    fileprivate let companyNameLabel = UILabel()
    fileprivate let retualLabel      = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        contentView.addSubview(numberLabel)
        numberLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 30, height: .zero))
        numberLabel.textAlignment = .center
        numberLabel.text = "No."
        
        contentView.addSubview(guestNameLabel)
        guestNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: numberLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        guestNameLabel.textAlignment = .center
        guestNameLabel.text = "御芳名"
        
        contentView.addSubview(companyNameLabel)
        companyNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        companyNameLabel.textAlignment = .center
        companyNameLabel.text = "会社名"
        
        contentView.addSubview(retualLabel)
        retualLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        retualLabel.text = "参列儀式"
        
        
        
    }

}
