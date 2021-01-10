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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
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
        cardTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil)
        cardTitleLabel.font = .systemFont(ofSize: 36)
    }
    fileprivate func setupRetualCollectionView(guest: Guest) {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 100, height: 100)
            return layout
        }()
//        let retualCollectionView = RetualCollectionView(guest: guest, frame: CGRect(x: 0, y: 0, width: 200, height: 100), collectionViewLayout: layout)
        let retualCollectionView = RetualCollectionView(guest: guest, frame: CGRect.zero, collectionViewLayout: layout)
        addSubview(retualCollectionView)
        retualCollectionView.anchor(top: nil, leading: cardTitleLabel.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: 200, height: 50))
    }
    fileprivate func setupPageLabel(pageNumber: Int) {
        addSubview(pageLabel)
        pageLabel.text = "No. \(pageNumber)"
        pageLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: 100, height: 100))
    }
}
