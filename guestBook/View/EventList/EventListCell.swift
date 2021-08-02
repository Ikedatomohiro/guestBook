//
//  EventNameCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/02.
//

import UIKit

class EventListCell: UITableViewCell {
    
    fileprivate var eventNameLabel      = UILabel()
    fileprivate var eventCreatedAtLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEventCell(_ event: Event) {
        setupEventNameLabel(event: event)
        setupEventCreatedAtLabel(event: event)
    }
    
    fileprivate func setupEventNameLabel(event: Event) {
        addSubview(eventNameLabel)
        eventNameLabel.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        eventNameLabel.text = event.eventName
    }
    
    fileprivate func setupEventCreatedAtLabel(event: Event) {
        addSubview(eventCreatedAtLabel)
        eventCreatedAtLabel.anchor(top: self.layoutMarginsGuide.topAnchor, leading: eventNameLabel.trailingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 5, height: .zero))
        // Date型をString型に変換。このときもろもろを設定。
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.string(from: event.createdAt)
        eventCreatedAtLabel.text = date
    }

}
