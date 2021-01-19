//
//  RetualCollectionView.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/27.
//

import UIKit

class RetualCollectionView: UICollectionView {
    fileprivate let retuals: [String] = ["□通夜", "□告別式"]
    fileprivate var guest: Guest
    weak var updateDelegate: GuestUpdateDelegate?
//    weak var updateRetualDelegate: UpdateRetualDelegate?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup(guest: Guest) {
        self.guest = guest
        self.dataSource = self
        self.delegate = self
        self.register(CheckBoxCell.self, forCellWithReuseIdentifier: CheckBoxCell.className)
        
    }
}

extension RetualCollectionView: UICollectionViewDataSource {
    // cellの個数設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retuals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        
        cell.setupContents(textName: retuals[indexPath.item])
        cell.setupButton(isActive: guest.retuals[indexPath.item])
        
        return cell
    }
}

extension RetualCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        var isActive = guest.retuals[indexPath.row]
        if isActive == true {
            isActive = false
        } else {
            isActive = true
        }
        guest.retuals[indexPath.row] = isActive
        let guestId = updateDelegate?.update(inputView: collectionView)
        if (guest.id == "new" && guestId != nil) {
            guest.id = guestId!
        }
        collectionView.reloadData()
    }
}
extension RetualCollectionView: UICollectionViewDelegateFlowLayout {
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
