//
//  GuestListHeaderCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

protocol SentGuestsRankDelegate: AnyObject {
    func sendGuestRank(selectRank: Dictionary<String, Bool?>)
}

class GuestListHeaderCell: UITableViewCell {
    
    fileprivate let numberLabel      = UILabel()
    let guestNameView                = UIView()
    fileprivate let guestNameLabel   = UILabel()
    let guestNameRankLabel           = UILabel()
    let guestNameTapArea             = UIButton()
    var guestNameRankAsc: Bool?      = nil
    let companyNameView              = UIView()
    fileprivate let companyNameLabel = UILabel()
    let companyNameRankLabel         = UILabel()
    var companyNameRankAsc: Bool?      = nil
    let addressView                  = UIView()
    fileprivate let addressLabel     = UILabel()
    fileprivate let retualLabel      = UILabel()
    var selectRank: Dictionary<String, Bool?> = [:]
    
    weak var sendGuestRank: SentGuestsRankDelegate?
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
        setupGuestNameView()
        setupCompanyNameView()
        
//        setupAddressLabel()
//        setupRetualLabel()
        
        
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
    
    func setupGuestNameView() {
        contentView.addSubview(guestNameView)
        guestNameView.anchor(top: topAnchor, leading: numberLabel.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: guestListView.guestNameWidth, height: .zero))
        setupGuestNameLabel()
        setupGuestNameRankButton()
        setupGuestNameTapArea()
    }
    
    func setupGuestNameLabel() {
        contentView.addSubview(guestNameLabel)
        guestNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameView.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        guestNameLabel.textColor = .white
        guestNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        guestNameLabel.text = "御芳名"
    }
    
    func setupGuestNameRankButton() {
        contentView.addSubview(guestNameRankLabel)
        guestNameRankLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0))
        guestNameRankLabel.textColor = .white
    }
    
    func setupGuestNameTapArea() {
        contentView.addSubview(guestNameTapArea)
        guestNameTapArea.anchor(top: guestNameView.topAnchor, leading: guestNameView.leadingAnchor, bottom: guestNameView.bottomAnchor, trailing: guestNameView.trailingAnchor)
        guestNameTapArea.tag = 1
        guestNameTapArea.addTarget(self, action: #selector(changeRank), for: .touchUpInside)
        
    }
    
    func setupCompanyNameView() {
        contentView.addSubview(companyNameView)
        companyNameView.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameView.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        setupCompanyNameLabel()
        setupCompanyNameRankButton()
        
    }
    

    func setupCompanyNameLabel() {
        contentView.addSubview(companyNameLabel)
        companyNameLabel.anchor(top: topAnchor, leading: companyNameView.leadingAnchor, bottom: bottomAnchor, trailing: nil)
        companyNameLabel.textColor = .white
        companyNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        companyNameLabel.text = "会社名"
    }

    func setupCompanyNameRankButton() {
        contentView.addSubview(companyNameRankLabel)
        companyNameRankLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        companyNameRankLabel.textColor = .white
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
    // MARK:-
    @objc func changeRank(sender: UIButton) {
        // tag: 1 御芳名
        if sender.tag == 1 {
            if guestNameRankAsc == nil {
                guestNameRankAsc = true
                guestNameRankLabel.text = "▲"
            } else if guestNameRankAsc == true {
                guestNameRankAsc = false
                guestNameRankLabel.text = "▼"
            } else if guestNameRankAsc == false {
                guestNameRankAsc = nil
                guestNameRankLabel.text = ""
            }
        // tag: 2 会社名
        } else if sender.tag == 2 {
            if companyNameRankAsc == nil {
                companyNameRankAsc = true
                companyNameRankLabel.text = "▲"
            } else if companyNameRankAsc == true {
                companyNameRankAsc = false
                companyNameRankLabel.text = "▼"
            } else if companyNameRankAsc == false {
                companyNameRankAsc = nil
                companyNameRankLabel.text = ""
            }
        }
        selectRank["guestName"]   = guestNameRankAsc
        selectRank["companyName"] = companyNameRankAsc
        sendGuestRank?.sendGuestRank(selectRank: selectRank)
    }
    
}


