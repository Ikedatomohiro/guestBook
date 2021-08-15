//
//  GuestListHeaderCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

protocol SentGuestsRankDelegate: AnyObject {
    func sendGuestRank(selectRank: Dictionary<String, Bool?>, sortColumn: Int)
}

class GuestListHeaderFooterView: UITableViewHeaderFooterView {
    
    fileprivate let numberLabel      = UILabel()
    let guestNameView                = UIView()
    fileprivate let guestNameLabel   = UILabel()
    var guestNameRankLabel           = UILabel()
    let guestNameTapArea             = UIButton()
    let companyNameView              = UIView()
    fileprivate let companyNameLabel = UILabel()
    let companyNameRankLabel         = UILabel()
    let addressView                  = UIView()
    let companyNameTapArea           = UIButton()
    fileprivate let addressLabel     = UILabel()
    fileprivate let retualLabel      = UILabel()
    var selectRank: Dictionary<String, Bool?> = ["guestName": nil, "companyName": nil]
    
    weak var sendGuestRank: SentGuestsRankDelegate?
    
    init(selectRank: Dictionary<String, Bool?>, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.selectRank = selectRank
        super.init(reuseIdentifier: reuseIdentifier)
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
        setupAddressLabel()
        setupRetualLabel()
    }
    
    func setupBase() {
        self.contentView.backgroundColor = .dynamicColor(light: green, dark: .white)
    }
    
    func setupNumberLabel() {
        contentView.addSubview(numberLabel)
        numberLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.numberWidth, height: .zero))
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        numberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numberLabel.text = "No."
    }
    
    func setupGuestNameView() {
        contentView.addSubview(guestNameView)
        guestNameView.anchor(top: topAnchor, leading: numberLabel.trailingAnchor, bottom: bottomAnchor, trailing: nil, size: .init(width: GuestListView.guestNameWidth, height: .zero))
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
        guestNameRankLabel.text = setRankLabel(rank: selectRank["guestName"] ?? nil)
    }
    
    func setupGuestNameTapArea() {
        contentView.addSubview(guestNameTapArea)
        guestNameTapArea.anchor(top: guestNameView.topAnchor, leading: guestNameView.leadingAnchor, bottom: guestNameView.bottomAnchor, trailing: guestNameView.trailingAnchor)
        guestNameTapArea.tag = 1
        guestNameTapArea.addTarget(self, action: #selector(changeRank), for: .touchUpInside)
    }
    
    func setupCompanyNameView() {
        contentView.addSubview(companyNameView)
        companyNameView.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameView.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.companyNameWidth, height: .zero))
        setupCompanyNameLabel()
        setupCompanyNameRankLabel()
        setupcompanyNameTapArea()
    }
    
    func setupCompanyNameLabel() {
        contentView.addSubview(companyNameLabel)
        companyNameLabel.anchor(top: topAnchor, leading: companyNameView.leadingAnchor, bottom: bottomAnchor, trailing: nil)
        companyNameLabel.textColor = .white
        companyNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        companyNameLabel.text = "会社名"
    }
    
    func setupCompanyNameRankLabel() {
        contentView.addSubview(companyNameRankLabel)
        companyNameRankLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        companyNameRankLabel.textColor = .white
        companyNameRankLabel.text = setRankLabel(rank: selectRank["companyName"] ?? nil)
    }
    
    func setupcompanyNameTapArea() {
        contentView.addSubview(companyNameTapArea)
        companyNameTapArea.anchor(top: companyNameView.topAnchor, leading: companyNameView.leadingAnchor, bottom: companyNameView.bottomAnchor, trailing: companyNameView.trailingAnchor)
        companyNameTapArea.tag = 2
        companyNameTapArea.addTarget(self, action: #selector(changeRank), for: .touchUpInside)
    }
    
    func setupAddressLabel() {
        contentView.addSubview(addressLabel)
        addressLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameView.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.addressWidth, height: .zero))
        addressLabel.textColor = .white
        addressLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addressLabel.text = "御住所"
    }
    
    func setupRetualLabel() {
        contentView.addSubview(retualLabel)
        retualLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: addressLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.retualWidth, height: .zero))
        retualLabel.textColor = .white
        retualLabel.font = UIFont.boldSystemFont(ofSize: 20)
        retualLabel.text = "参列儀式"
    }
    
    // MARK:-
    @objc func changeRank(sender: UIButton) {
        // tag: 1 御芳名
        if sender.tag == Constants.RankGuestName {
            if selectRank["guestName"] == nil {
                selectRank["guestName"] = true
            } else if selectRank["guestName"] == true {
                selectRank["guestName"] = false
            } else if selectRank["guestName"] == false {
                selectRank["guestName"] = nil
            }
            // tag: 2 会社名
        } else if sender.tag == Constants.RankCompaneName {
            if selectRank["companyName"] == nil {
                selectRank["companyName"] = true
            } else if selectRank["companyName"] == true {
                selectRank["companyName"] = false
            } else if selectRank["companyName"] == false {
                selectRank["companyName"] = nil
            }
        }
        sendGuestRank?.sendGuestRank(selectRank: selectRank, sortColumn: sender.tag)
    }
    
    func setRankLabel(rank: Bool?) -> String {
        var rankString = "▲▼"
        if rank == nil {
            rankString = "▲▼"
        } else if rank == true {
            rankString = "▲"
        } else if rank == false {
            rankString = "▼"
        }
        return rankString
    }
}
