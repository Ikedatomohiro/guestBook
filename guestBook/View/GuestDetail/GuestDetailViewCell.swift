//
//  GuestDetailViewCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/18.
//

import UIKit

class GuestDetailViewCell: UITableViewCell {
    var guestNameArea = HeadlineAndTextFieldView(headlineText: "御芳名", textFiledText: "", "guestName")
    var companyNameArea = HeadlineAndTextFieldView(headlineText: "会社名", textFiledText: "", "companyName")
    var zipCodeArea = HeadlineAndTextFieldView(headlineText: "郵便番号", textFiledText: "", "zipCode")
    var telNumberArea = HeadlineAndTextFieldView(headlineText: "電話番号", textFiledText: "", "telNumber")
    var addressArea = HeadlineAndTextFieldView(headlineText: "御住所", textFiledText: "", "address")
    var descriptionArea = HeadlineAndTextFieldView(headlineText: "備考", textFiledText: "", "description")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(_ guest: Guest, index: Int) {
        setGuestName(guest)
        setCompanyName(guest)
        setZipCode(guest)
        setTelNumber(guest)
        setAddress(guest)
        setDescription(guest)
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
    
    fileprivate func setZipCode(_ guest: Guest) {
        zipCodeArea.textField.text = guest.zipCode
        contentView.addSubview(zipCodeArea)
        zipCodeArea.anchor(top: companyNameArea.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 60))
    }
    
    fileprivate func setTelNumber(_ guest: Guest) {
        telNumberArea.textField.text = guest.telNumber
        contentView.addSubview(telNumberArea)
        telNumberArea.anchor(top: zipCodeArea.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 60))
    }

    fileprivate func setAddress(_ guest: Guest) {
        addressArea.textField.text = guest.address
        contentView.addSubview((addressArea))
        addressArea.anchor(top: telNumberArea.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 60))
    }
    
    fileprivate func setDescription(_ guest: Guest) {
        descriptionArea.textField.text = guest.description
        contentView.addSubview((descriptionArea))
        descriptionArea.anchor(top: addressArea.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 60))
    }
}
