//
//  GuestCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/21.
//

import UIKit

class GuestCell: UITableViewCell {
    
    fileprivate var guestTextLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func setupGuestData(guest: Guest) {
        self.textLabel?.text = guest.guestName
    }


    fileprivate func setup() {
        contentView.addSubview(guestTextLabel)
        guestTextLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil)
        guestTextLabel.text = "練習のラベル"
    }


}

