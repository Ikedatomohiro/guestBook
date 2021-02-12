//
//  RetualAttendanceCollectionView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/12.
//

import UIKit

class RetualAttendanceCollectionView: UICollectionView {
    var guest: Guest
    var retuals: [Retual] = []
    
    init(guest: Guest, retuals: [Retual], frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
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
        self.register(ListCell.self, forCellWithReuseIdentifier: ListCell.className)
    }
}

// MARK:- Extensions
extension RetualAttendanceCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retuals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.className, for: indexPath) as! ListCell
        cell.setupContents(text: retuals[indexPath.item].retualName)
        return cell
        
    }
}

extension RetualAttendanceCollectionView: UICollectionViewDelegate {
    override func numberOfItems(inSection section: Int) -> Int {
        return 1
    }
}
    
extension RetualAttendanceCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    
    // セルの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    //セル同士の縦間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // セル同士の横間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
    




