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
        cardTitleLabel.text = "御 芳 名 カ ー ド"
        cardTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 5, left: 10, bottom: 5, right: 0))
        cardTitleLabel.font = .systemFont(ofSize: 32)
    }
}
