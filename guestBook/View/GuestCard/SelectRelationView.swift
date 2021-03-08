//
//  SelectRelationView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

class SelectRelationView: UIView {
    fileprivate let relationAskLabel = UILabel()
    var guest: Guest
    var relations: [Relation]
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    lazy var relationCollectionView = RelationCollectionView(guest: guest, relations, frame: CGRect.zero, collectionViewLayout: layout)

    init(guest: Guest, relations: [Relation], frame: CGRect) {
        self.guest = guest
        self.relations = relations
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupRelationLabel()
        setupRelationCollectionView()
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
    
    fileprivate func setupRelationCollectionView() {
//        let relationCollectionView = RelationCollectionView(guest: guest, relations, frame: CGRect.zero, collectionViewLayout: layout)
        addSubview(relationCollectionView)
        relationCollectionView.anchor(top: layoutMarginsGuide.topAnchor, leading: relationAskLabel.trailingAnchor, bottom: relationAskLabel.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        relationCollectionView.backgroundColor = .white
    }


}
