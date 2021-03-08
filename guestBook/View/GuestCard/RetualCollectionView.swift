//
//  RetualCollectionView.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/27.
//

import UIKit

class RetualCollectionView: UICollectionView {
    var guest: Guest
    var retuals: [Retual]
    weak var guestItemUpdateDelegate: GuestItemUpdateDelegate?

    init(_ guest: Guest, _ retuals: [Retual] ,frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        self.guest = guest
        self.retuals = retuals
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
extension RetualCollectionView: UICollectionViewDataSource {
    // cellの個数設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retuals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        // 対象のセルのIDをセット
        let retualId = retuals[indexPath.item].id
        cell.setupContents(textName: retuals[indexPath.item].retualName)
        
        let attendance = guest.retuals[retualId] ?? false
        cell.setupButton(isActive: attendance)
        
        return cell
    }
}

extension RetualCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        // 対象のセルのIDをセット
        let retualId = retuals[indexPath.item].id
        // ラベルの色を変える
        let cell = collectionView.cellForItem(at: indexPath) as! CheckBoxCell
        cell.animateView(cell.label)
        // guest.retualsのretual.idに対してBool値を切り替える
        var isActive = guest.retuals[retualId]
        if isActive == true {
            isActive = false
        } else {
            isActive = true
        }
        guest.retuals[retualId] = isActive
        guestItemUpdateDelegate?.update(inputView: self)
        
        collectionView.reloadData()
    }
}

extension RetualCollectionView: UICollectionViewDelegateFlowLayout {
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
