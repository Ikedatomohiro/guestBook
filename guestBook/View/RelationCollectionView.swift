//
//  RelationCollectionView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

class RelationCollectionView: UICollectionView {

    fileprivate let relations: [String] = ["故人様", "喪主様", "ご家族", "その他"]
    fileprivate var guest: Guest
    weak var updateDelegate: GuestUpdateDelegate?

    init(guest: Guest, frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.guest = guest
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

extension RelationCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        
        cell.setupContents(textName: relations[indexPath.item])
        cell.setupButton(isActive: guest.relations[indexPath.item])
        
        return cell
    }
    
}

extension RelationCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        var isActive = guest.relations[indexPath.row]
        if isActive == true {
            isActive = false
        } else {
            isActive = true
        }
        guest.relations[indexPath.row] = isActive
        let guestId = updateDelegate?.update(guest: guest)
        if (guest.id == "new" && guestId != nil) {
            guest.id = guestId!
        }
        collectionView.reloadData()
    }
}
extension RelationCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }
    // セルの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    // セル同士の縦間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    // セル同士の横間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
