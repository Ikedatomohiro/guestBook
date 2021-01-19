//
//  CardTitleView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/07.
//

import UIKit

class CardTitleView: UIView {
    fileprivate let cardTitleLabel       = UILabel()
    fileprivate let pageLabel            = UILabel()
    fileprivate let pageNumber: Int      = 0
    
    fileprivate let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    let retualCollectionView = RetualCollectionView(frame: .zero, collectionViewLayout: layout)
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupLabel()
        setupRetualCollectionView(guest: guest)
        setupPageLabel(pageNumber: guest.pageNumber)
    }
    fileprivate func setupLabel() {
        addSubview(cardTitleLabel)
        cardTitleLabel.text = "御芳名カード"
        cardTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        cardTitleLabel.font = .systemFont(ofSize: 36)
    }
    fileprivate func setupRetualCollectionView(guest: Guest) {
        addSubview(retualCollectionView)
        retualCollectionView.anchor(top: layoutMarginsGuide.topAnchor, leading: cardTitleLabel.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 100, bottom: 0, right: 0), size: .init(width: 400, height: 50))
        retualCollectionView.setup(guest: guest)
        retualCollectionView.backgroundColor = .white
    }
    fileprivate func setupPageLabel(pageNumber: Int) {
        addSubview(pageLabel)
        pageLabel.text = "No. \(pageNumber)"
        pageLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: 100, height: 100))
    }
}

