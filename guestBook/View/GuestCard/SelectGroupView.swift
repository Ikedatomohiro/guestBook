//
//  SelectGroupView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

class SelectGroupView: UIView {
    fileprivate let groupAskLabel    = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupGroupAskLabel()
        setupGoupCollectionView(guest: guest)
    }
    fileprivate func setupGroupAskLabel() {
        addSubview(groupAskLabel)
        groupAskLabel.text = "どのようなご関係ですか"
        groupAskLabel.anchor(top: groupAskLabel.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: 250, height: 80))
    }
    fileprivate func setupGoupCollectionView(guest: Guest) {
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            return layout
        }()
        
//        let groupCollectionView = GroupCollectionView(guest: guest, frame: CGRect.zero, collectionViewLayout: layout)
    }
}

