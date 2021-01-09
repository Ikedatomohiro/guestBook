//
//  CardHeaderView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/07.
//

import UIKit

class CardHeaderView: UIView {
    fileprivate let cardTitleLabel                       = UILabel()
    fileprivate let cardHeaderLabel                      = UILabel()
    fileprivate let guestId: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupLabel()
    }
    fileprivate func setupLabel() {
        addSubview(cardHeaderLabel)
        cardHeaderLabel.text = "〜御会葬賜り心より御礼申し上げます〜"
        cardHeaderLabel.textAlignment = .center
        cardHeaderLabel.fillSuperview()
    }
}
