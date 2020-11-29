//
//  RetualCollectionViewController.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/27.
//

import UIKit
import FirebaseFirestore

//private let reuseIdentifier = "Cell"
let flowLayout = UICollectionViewFlowLayout()

class RetualCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        flowLayout.itemSize = CGSize(width: 100, height: 50)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30), collectionViewLayout: flowLayout)
//        self.backgroundColor = .cyan

//        self.register(RetualCollectionViewCell.self , forCellWithReuseIdentifier: RetualCollectionViewCell.className)
//        self.register(UICollectionViewCell.self , forCellWithReuseIdentifier: RetualCollectionViewCell.className)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
