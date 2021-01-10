//
//  RetualCollectionView.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/27.
//

import UIKit

class RetualCollectionView: UICollectionView {
    fileprivate let retuals: [String]                    = ["通夜", "告別式"]
    fileprivate let guest: Guest

    init(guest: Guest,frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {

        self.guest = guest
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    func setup() {
        self.dataSource = self
        self.delegate = self
        self.register(CheckBoxCell.self, forCellWithReuseIdentifier: CheckBoxCell.className)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        if (cell.backgroundColor == )
        cell.selectedBackgroundView = CellBgView(num: indexPath.row)
        
        return cell
    }
}
// 背景用のView
class CellBgView: UIView {

    init(num: Int) {
        super.init(frame: CGRect.zero)
        // 偶数と奇数で色変えてみよう
        backgroundColor = num % 2 == 0 ? .red : .orange
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RetualCollectionView: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        print(indexPath.item)
        
        
        
        
    }
}
extension RetualCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //ここでは画面の横サイズの半分の大きさのcellサイズを指定
        return CGSize(width: 100, height: 50)
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
        return 0
    }
}
