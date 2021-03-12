//
//  SelectRelationView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

protocol SendRelationDataDelegate: AnyObject {
    func sendRelationData(relationCollectionView: RelationCollectionView)
}

class SelectRelationView: UIView {
    fileprivate let relationAskLabel = UILabel()
    var guest: Guest
    var relations: [Relation]
    var relationCollectionView: RelationCollectionView
    weak var guestItemUpdateDelegate: GuestItemUpdateDelegate?
    
    init(_ guest: Guest, _ relations: [Relation], _ relationCollectionView: RelationCollectionView, frame: CGRect) {
        self.guest = guest
        self.relations = relations
        self.relationCollectionView = relationCollectionView
        super.init(frame: frame)
        self.setupView(relationCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(_ relationCollectionView: RelationCollectionView) {
        setupRelationLabel()
        setupRelationCollectionView(relationCollectionView)
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
    
    fileprivate func setupRelationCollectionView(_ relationCollectionView: RelationCollectionView) {
        addSubview(relationCollectionView)
        relationCollectionView.anchor(top: layoutMarginsGuide.topAnchor, leading: relationAskLabel.trailingAnchor, bottom: relationAskLabel.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        relationCollectionView.backgroundColor = .white
        relationCollectionView.sendRelationDataDelegate = self
    }
}

//MARK:- Extensions
extension SelectRelationView: SendRelationDataDelegate {
    func sendRelationData(relationCollectionView: RelationCollectionView) {
        guestItemUpdateDelegate?.update(inputView: relationCollectionView)
    }
}
