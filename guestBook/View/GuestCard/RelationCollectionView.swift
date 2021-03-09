//
//  RelationCollectionView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

class RelationCollectionView: UICollectionView {

    var guest: Guest
    var relations: [Relation]
    weak var sendRelationDataDelegate: SendRelationDataDelegate?

    init(guest: Guest, _ relations: [Relation], frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.guest = guest
        self.relations = relations
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(CheckBoxCell.self, forCellWithReuseIdentifier: CheckBoxCell.className)
    }
    
}

// MARK:- Extensions
extension RelationCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        
        cell.setupContents(textName: relations[indexPath.item].relation)
        // 対象のセルのIDをセット
        let relationId = relations[indexPath.item].id
        cell.setupContents(textName: relations[indexPath.item].relation)
        
        let relation = guest.relations[relationId] ?? false
        cell.setupButton(isActive: relation)

        return cell
    }
}

extension RelationCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        // 対象のセルのIDをセット
        let relationId = relations[indexPath.item].id
        // ラベルの色を変える
        let cell = collectionView.cellForItem(at: indexPath) as! CheckBoxCell
        cell.animateView(cell.label)
        var isActive = guest.relations[relationId]
        if isActive == true {
            isActive = false
        } else {
            isActive = true
        }
        guest.relations[relationId] = isActive
        sendRelationDataDelegate?.sendRelationData(relationCollectionView: self)
        collectionView.reloadData()
    }
}

extension RelationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 40)
    }
    // セルの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    // セル同士の縦間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // セル同士の横間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
