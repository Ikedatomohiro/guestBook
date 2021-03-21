//
//  GuestDetailViewCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/18.
//

import UIKit

class GuestDetailViewCell: UITableViewCell {
    
    fileprivate var guestNameLabel = UILabel()
    fileprivate let guestNameTitle = UILabel()
    fileprivate var gestNameTextField = UITextField()
    fileprivate var companyNameTextField = UITextField()
    fileprivate var companyNameTitle = UILabel()
    var guestNameArea = HeadlineAndTextFieldView(headlineText: "御芳名", textFiledText: "")
    var companyNameArea = HeadlineAndTextFieldView(headlineText: "会社名", textFiledText: "")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(_ guest: Guest, index: Int) {
        setGuestName(guest)
        setCompanyName(guest)
    }

    fileprivate func setGuestName(_ guest: Guest) {
        guestNameArea.textField.text = guest.guestName
        contentView.addSubview(guestNameArea)
        guestNameArea.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 60))
    }
    
    fileprivate func setCompanyName(_ guest: Guest) {
        companyNameArea.textField.text = guest.companyName
        contentView.addSubview(companyNameArea)
        companyNameArea.anchor(top: guestNameArea.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 60))
    }
    
}
