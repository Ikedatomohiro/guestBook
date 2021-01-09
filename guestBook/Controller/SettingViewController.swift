//
//  SettingViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/29.
//

import UIKit

class SettingViewController: UIViewController {

    private let collectionView: UICollectionView = {
           //セルのレイアウト設計
           let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

           //各々の設計に合わせて調整
           layout.scrollDirection = .vertical
           layout.minimumInteritemSpacing = 0
           layout.minimumLineSpacing = 0

           let collectionView = UICollectionView( frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height ), collectionViewLayout: layout)
           collectionView.backgroundColor = UIColor.white
           //セルの登録
           collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
           return collectionView
       }()
    
    fileprivate let fruits: [String] = ["apple", "grape", "lemon", "banana", "cherry", "strobery", "peach", "orange"]

    override func viewDidLoad() {
        super.viewDidLoad()

        //生成したcollectionViewのdataSourceとdelegteを紐づける
        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

    }
    

}
    
    
extension SettingViewController:UICollectionViewDataSource {
    
    //cellの個数設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fruits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

        let cellText = fruits[indexPath.item]
        cell.setupContents(textName: cellText)

        return cell
    }
}

//イベントの設定(何もなければ記述の必要なし)
extension SettingViewController: UICollectionViewDelegate {

}


//cellのサイズの設定
extension SettingViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      //ここでは画面の横サイズの半分の大きさのcellサイズを指定
      return CGSize(width: screenSize.width / 2.0, height: screenSize.width / 2.0)
  }
}
