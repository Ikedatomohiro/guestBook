//
//  GuestController.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import UIKit
import PencilKit

class GuestController: UIViewController {
    
    var guest: Guest
    fileprivate let cardTitleLabel = UILabel()
//    fileprivate let retualCollectionView = RetualCollectionView()
    fileprivate var retualCollectionView: UICollectionView!

    fileprivate let guestNameLabel = UILabel()
    fileprivate let companyNameLabel = UILabel()
    fileprivate let zipCodeLabel = UILabel()
    fileprivate let telLabel = UILabel()
    fileprivate let addressLabel = UILabel()
    fileprivate let selectAcuaintanceQuestionLabel = UILabel()
    fileprivate let selectAcuaintanceLabel = UILabel()
    fileprivate let selectRelationQuestionLabel = UILabel()
    fileprivate let selectRelationLabel = UILabel()
    
    fileprivate let retuals: [String] = ["通夜", "告別式"]

    
    
    

    
    
    
    
    //スクリーンサイズの取得
//    let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder){fatalError()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
//        setupCanvas()
    }
    
    fileprivate func setupLabels() {
        view.addSubview(cardTitleLabel)
        cardTitleLabel.text = "ご芳名カード"
        cardTitleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 50))
        
        
        
        

        
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(
//            width: self.view.frame.width / 10,
//            height: self.view.frame.width / 5
//        )
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        retualCollectionView = UICollectionView(
            frame: self.view.frame ,
            collectionViewLayout:flowLayout
        )
        retualCollectionView.dataSource = self
        retualCollectionView.delegate = self

        retualCollectionView.register(RetualCollectionViewCell.self, forCellWithReuseIdentifier: RetualCollectionViewCell.className)
        
        
        view.addSubview(retualCollectionView)
        retualCollectionView.anchor(top: cardTitleLabel.topAnchor, leading: cardTitleLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0), size: .init(width: 200, height: 50))


        
        
        
        
        
        
        
        
        view.addSubview(guestNameLabel)
        guestNameLabel.fillSuperview()
        guestNameLabel.text = guest.guestName
        guestNameLabel.textColor = .black
        guestNameLabel.font = .systemFont(ofSize: 50, weight: .bold)
        guestNameLabel.textAlignment = .center
        
        
        
        view.addSubview(companyNameLabel)
        
        
        
        view.addSubview(zipCodeLabel)
        
        
        
        view.addSubview(telLabel)
        
        
        
        view.addSubview(addressLabel)
        view.addSubview(selectAcuaintanceQuestionLabel)
        view.addSubview(selectAcuaintanceLabel)
        view.addSubview(selectRelationQuestionLabel)
        view.addSubview(selectRelationLabel)
        
        
        
        
        
        
        
        
        
        
    }
    
    fileprivate func setupCanvas() {
        let canvas = PKCanvasView(frame: view.frame)
        self.view.addSubview(canvas)
        canvas.tool = PKInkingTool(.pen, color: .black, width: 30)

        // PKToolPicker: ドラッグして移動できるツールパレット (ペンや色などを選択できるツール)
        if let window = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.addObserver(canvas)
                toolPicker.setVisible(true, forFirstResponder: canvas)
                canvas.becomeFirstResponder()
            }
        }
    }
}

extension GuestController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retuals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RetualCollectionViewCell.className, for: indexPath)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RetualCollectionViewCell.className, for: indexPath)
        let cellText = retuals[indexPath.item]
        print(cellText)
        
        

//print(cellText)
        return cell
    }


}
extension GuestController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // クリックしたときのアクション
        print(indexPath.item)
    }
}

//cellのサイズの設定
extension GuestController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      //ここでは画面の横サイズの半分の大きさのcellサイズを指定
      return CGSize(width: 100, height: 50)
  }
}
