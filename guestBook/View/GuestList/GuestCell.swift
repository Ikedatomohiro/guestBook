//
//  GuestCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/21.
//

import UIKit

class GuestCell: UITableViewCell {
    
    fileprivate var numberLabel    = UILabel()
    fileprivate var guestNameLabel = UILabel()
    fileprivate var companyNameLabel = UILabel()
    fileprivate let addressLabel     = UILabel()
    fileprivate var retualAttendanceLabel = UILabel()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func setupGuestData(guest: Guest) {
        setupNumberLabel(guest)
        setupGuestNameLabel(guest)
        setupCompanyNameLabel(guest)
        setupRetualAttendanceLabel(guest)
        setupAddresLabel(guest)
    }
    
    fileprivate func setupNumberLabel(_ guest: Guest) {
        addSubview(numberLabel)
        numberLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 30, height: .zero))
        numberLabel.text = String(guest.pageNumber)
        numberLabel.textAlignment = .center
    }
    
    fileprivate func setupGuestNameLabel(_ guest: Guest) {
        addSubview(guestNameLabel)
        guestNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: numberLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 8, height: .zero))
        guestNameLabel.text = guest.guestName
        guestNameLabel.numberOfLines = 0
    }
    
    fileprivate func setupCompanyNameLabel(_ guest: Guest) {
        addSubview(companyNameLabel)
        companyNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        companyNameLabel.text = guest.companyName
        companyNameLabel.numberOfLines = 0
    }
    
    fileprivate func setupAddresLabel(_ guest: Guest) {
        addSubview(addressLabel)
        addressLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        addressLabel.text = guest.address
        addressLabel.numberOfLines = 0
    }

    fileprivate func setupRetualAttendanceLabel(_ guest: Guest) {
        
    }


}

