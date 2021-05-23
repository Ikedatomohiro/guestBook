//
//  EventNameCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/02.
//

import UIKit

class EventListCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEventName(event: Event) {
        self.textLabel?.text = event.eventName
    }    
}
