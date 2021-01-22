//
//  CardTitleView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/07.
//

import UIKit

class CardTitleView: UIView {
    fileprivate let cardTitleLabel       = UILabel()
    
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
        addSubview(cardTitleLabel)
        cardTitleLabel.text = "御芳名カード"
        cardTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        cardTitleLabel.font = .systemFont(ofSize: 36)
    }
}
