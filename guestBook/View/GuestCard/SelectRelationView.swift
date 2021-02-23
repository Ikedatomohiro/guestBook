//
//  SelectRelationView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

class SelectRelationView: UIView {
    fileprivate let relationAskLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupRelationLabel()
        setupRelationCollectionView(guest: guest)
    }
    
    fileprivate func setupRelationLabel() {
        addSubview(relationAskLabel)
        relationAskLabel.text = """
        どなたの
        御関係ですか
        """
        relationAskLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 150, height: 80))
        relationAskLabel.font = .systemFont(ofSize: 24)
        relationAskLabel.numberOfLines = 0
    }
    
    fileprivate func setupRelationCollectionView(guest: Guest) {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            return layout
        }()
        
        let relationCollectionView = RelationCollectionView(guest: guest, frame: CGRect.zero, collectionViewLayout: layout)
        addSubview(relationCollectionView)
        relationCollectionView.anchor(top: layoutMarginsGuide.topAnchor, leading: relationAskLabel.trailingAnchor, bottom: relationAskLabel.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        relationCollectionView.backgroundColor = .white
    }


}
