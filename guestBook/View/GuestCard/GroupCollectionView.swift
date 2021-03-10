//
//  GroupCollectionView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/17.
//

import UIKit

class GroupCollectionView: UICollectionView {
    fileprivate var guest: Guest
    fileprivate let groups: [Group]
    weak var updateDelegate: GuestUpdateDelegate?

    init(_ guest: Guest, _ groups: [Group], frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.guest = guest
        self.groups = groups
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

//MARK:- Extensions
extension GroupCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        // 対象のセルのIDをセット
        let groupId = groups[indexPath.item].id

        cell.setupContents(textName: groups[indexPath.item].group)
        let belongs = guest.groups[groupId] ?? false
        cell.setButtonColor(isActive: belongs)
        return cell
    }
    
}

extension GroupCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        // 対象のセルのIDをセット
        let groupId = groups[indexPath.item].id
        // ラベルの色を変える
        let cell = collectionView.cellForItem(at: indexPath) as! CheckBoxCell
        cell.animateView(cell.label)
        var isActive = guest.groups[groupId]
        if isActive == true {
            isActive = false
        } else {
            isActive = true
        }
        guest.groups[groupId] = isActive
        updateDelegate?.update(guest: guest)
        collectionView.reloadData()
    }
}

extension GroupCollectionView: UICollectionViewDelegateFlowLayout {
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
