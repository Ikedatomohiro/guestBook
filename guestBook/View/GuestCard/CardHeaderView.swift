//
//  CardHeaderView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/07.
//

import UIKit

class CardHeaderView: UIView {
    fileprivate let cardTitleLabel  = UILabel()
    fileprivate let cardHeaderLabel = UILabel()
    fileprivate let guestId: String = ""
    fileprivate let pageLabel       = UILabel()
    fileprivate var pageNumber = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(index: Int?) {
        setupLabel()
        setupPageLabel(index: index)
    }
    
    fileprivate func setupLabel() {
        addSubview(cardHeaderLabel)
        cardHeaderLabel.text = "〜御会葬賜り心より御礼申し上げます〜"
        cardHeaderLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        cardHeaderLabel.textAlignment = .center
    }
    
    fileprivate func setupPageLabel(index: Int?) {
        addSubview(pageLabel)
        pageLabel.text = "No. \(pageNumber)"
        pageLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10))
        guard var pageNumber = index else { return }
        pageNumber += 1
        pageLabel.text = "No. \(pageNumber)"
    }
}
