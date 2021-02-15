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
    let guestNameRankButton          = UIButton()
    fileprivate let companyNameLabel = UILabel()
    fileprivate let addressLabel     = UILabel()
    fileprivate let retualLabel      = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        setupBase()
        setupNumberLabel()
        setupGuestNameLabel()
        setupCompanyNameLabel()
        setupAddressLabel()
        setupRetualLabel()
        
        
        setupGuestNameRankButton()
    }
    
    func setupBase() {
        self.backgroundColor = .rgb(red: 150, green: 200, blue: 20)
    }
    
    func setupNumberLabel() {
        contentView.addSubview(numberLabel)
        numberLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: guestListView.numberWidth, height: .zero))
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        numberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numberLabel.text = "No."
    }
    
    func setupGuestNameLabel() {
        contentView.addSubview(guestNameLabel)
        guestNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: numberLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: guestListView.guestNameWidth, height: .zero))
        guestNameLabel.textColor = .white
        guestNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        guestNameLabel.text = "御芳名"
    }
    
    func setupGuestNameRankButton() {
        contentView.addSubview(guestNameRankButton)
        guestNameRankButton.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: layoutMarginsGuide.bottomAnchor, trailing: guestNameLabel.trailingAnchor)
        guestNameRankButton.setTitle("▲", for: .normal)
        
        
    }
    
    
    
    
    
    
    func setupCompanyNameLabel() {
        contentView.addSubview(companyNameLabel)
        companyNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: guestListView.companyNameWidth, height: .zero))
        companyNameLabel.textColor = .white
        companyNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        companyNameLabel.text = "会社名"
    }

    func setupAddressLabel() {
        contentView.addSubview(addressLabel)
        addressLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: guestListView.addressWidth, height: .zero))
        addressLabel.textColor = .white
        addressLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addressLabel.text = "御住所"
    }

    func setupRetualLabel() {
        contentView.addSubview(retualLabel)
        retualLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: addressLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: guestListView.retualWidth, height: .zero))
        retualLabel.textColor = .white
        retualLabel.font = UIFont.boldSystemFont(ofSize: 20)
        retualLabel.text = "参列儀式"
    }
}
