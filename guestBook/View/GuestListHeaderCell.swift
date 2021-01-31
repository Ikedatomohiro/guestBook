//
//  GuestListHeaderCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

class GuestListHeaderCell: UITableViewCell {
    
    fileprivate let numberLabel = UILabel()
    fileprivate let guestNameLabel = UILabel()
    fileprivate let companyNamelabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        contentView.addSubview(numberLabel)
        numberLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        numberLabel.text = "No."
        
        
        contentView.addSubview(guestNameLabel)
        guestNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: numberLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        guestNameLabel.text = "御芳名"
        
        
        contentView.addSubview(companyNamelabel)
        companyNamelabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        companyNamelabel.text = "会社名"
        
        
    }

}
