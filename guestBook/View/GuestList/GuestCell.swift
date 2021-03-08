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
    let retualAttendanceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGuestCell(_ guest: Guest,_ retuals: [Retual], indexPath: Int) {
        setupBase(indexPath)
        setupNumberLabel(guest)
        setupGuestNameLabel(guest)
        setupCompanyNameLabel(guest)
        setupAddresLabel(guest)
        setupRetualAttendanceLabel(guest, retuals)
    }
    
    func setupBase(_ indexPath: Int) {
        if indexPath % 2 == 0 {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = .rgb(red: 209, green: 238, blue: 123)
        }
    }
    
    fileprivate func setupNumberLabel(_ guest: Guest) {
        addSubview(numberLabel)
        numberLabel.anchor(top: self.layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.numberWidth, height: .zero))
        numberLabel.text = String(guest.pageNumber)
        numberLabel.textAlignment = .center
    }
    
    fileprivate func setupGuestNameLabel(_ guest: Guest) {
        addSubview(guestNameLabel)
        guestNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: numberLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.guestNameWidth, height: .zero))
        guestNameLabel.text = guest.guestName
        guestNameLabel.numberOfLines = 0
    }
    
    fileprivate func setupCompanyNameLabel(_ guest: Guest) {
        addSubview(companyNameLabel)
        companyNameLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.companyNameWidth, height: .zero))
        companyNameLabel.text = guest.companyName
        companyNameLabel.numberOfLines = 0
    }
    
    fileprivate func setupAddresLabel(_ guest: Guest) {
        addSubview(addressLabel)
        addressLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: companyNameLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.addressWidth, height: .zero))
        addressLabel.text = guest.address
        addressLabel.numberOfLines = 0
    }

    fileprivate func setupRetualAttendanceLabel(_ guest: Guest,_ retuals: [Retual]) {
        addSubview(retualAttendanceLabel)
        retualAttendanceLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: addressLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: GuestListView.retualWidth, height: .zero))
        retualAttendanceLabel.text = setRetualAttendanceList(guest, retuals)
    }

    func setRetualAttendanceList(_ guest: Guest,_ retuals: [Retual]) -> String {
        var labelText: String = ""
        for retual in retuals where guest.retuals["\(retual.id)"] == true {
            if labelText != "" {
                labelText = labelText + " ・ "
            }
            labelText = labelText + retual.retualName
        }
        return labelText
    }
}

