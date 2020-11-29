//
//  SettingViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/29.
//

import UIKit

class SettingViewController: UIViewController {

    
    var collectionTestView: UICollectionView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.backgroundColor = .systemBlue



        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: self.view.frame.width / 5,
            height: self.view.frame.width / 5
        )
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionTestView = UICollectionView(
            frame: self.view.frame ,
            collectionViewLayout:flowLayout
        )
        collectionTestView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionTestView.dataSource = self
        self.view.addSubview(collectionTestView)


    }
    

}
    
    
extension SettingViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = .red
        }else{
            cell.backgroundColor = .blue
        }

        
        
        return cell
    }
    
    
    
}



