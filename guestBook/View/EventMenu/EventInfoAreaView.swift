//
//  EventInfoAreaView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/04/25.
//

import UIKit

class EventInfoAreaView: UIView {
    fileprivate let eventRegTimeHeadLine = UILabel()
    fileprivate let eventRegTime: Date
    fileprivate let guestsCountHeadLine = UILabel()
    fileprivate let guestsCountLabel = UILabel()
    fileprivate let guestsCount: Int?
    
    
    init(event: Event, guests: [Guest], frame: CGRect) {
        self.eventRegTime = event.createdAt
        self.guestsCount = guests.count
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        addSubview(guestsCountHeadLine)
        guestsCountHeadLine.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil)
        guestsCountHeadLine.text = "参加者登録数："
        guestsCountHeadLine.font = .systemFont(ofSize: 24)
        
        addSubview(guestsCountLabel)
        guestsCountLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: guestsCountHeadLine.trailingAnchor, bottom: nil, trailing: nil)
        guestsCountLabel.text = String(guestsCount ?? 0) + " 名"
        guestsCountLabel.font = .systemFont(ofSize: 24)
    }
    
    func setGuestsCount(count: Int) {
        guestsCountLabel.text = String(count) + " 名"
    }
}
