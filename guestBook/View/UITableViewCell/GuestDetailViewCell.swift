//
//  GuestDetailViewCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/18.
//

import UIKit

class GuestDetailViewCell: UITableViewCell {
    
    fileprivate var guestNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(_ guest: Guest, index: Int) {
        setGuestName(guest)
    }

    fileprivate func setGuestName(_ guest: Guest) {
        contentView.addSubview(guestNameLabel)
        guestNameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        guestNameLabel.text = guest.companyName
    }
    
}
