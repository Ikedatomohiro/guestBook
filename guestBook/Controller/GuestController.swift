//
//  GuestController.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import UIKit
import PencilKit
import FirebaseFirestore
import FirebaseStorage

protocol GuestUpdateDelegate: class {
    func update(guest: Guest)
}

class GuestController: UIViewController {
    
    var guest: Guest
    weak var updateDelegate: GuestUpdateDelegate?
    fileprivate let cardTitleLabel                       = UILabel()
//    fileprivate let retualCollectionView = RetualCollectionView()
//    fileprivate var retualCollectionView: UICollectionView!
    fileprivate let layout = UICollectionViewLayout()
    fileprivate lazy var retualCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    fileprivate let guestNameTitleLabel                  = UILabel()
    fileprivate let guestNameLabel                       = UILabel()
    let guestNameTextField                   = UITextField()
    
    fileprivate let companyNameLabel                     = UILabel()
    fileprivate let zipCodeLabel                         = UILabel()
    fileprivate let telLabel                             = UILabel()
    fileprivate let addressLabel                         = UILabel()
    fileprivate let selectAcuaintanceQuestionLabel       = UILabel()
    fileprivate let selectAcuaintanceLabel               = UILabel()
    fileprivate let selectRelationQuestionLabel          = UILabel()
    fileprivate let selectRelationLabel                  = UILabel()
    fileprivate let retuals: [String] = ["通夜", "告別式"]
    fileprivate let db                                   = Firestore.firestore().collection("events")
    fileprivate let storage                              = Storage.storage().reference()


    //スクリーンサイズの取得
//    let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder){fatalError()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabels()
//        setupCanvas()
    }
    
    fileprivate func setupLabels() {
        view.addSubview(cardTitleLabel)
        cardTitleLabel.text = "ご芳名カード"
        cardTitleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 50))
        

        // 参加儀式選択
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(
//            width: self.view.frame.width / 10,
//            height: self.view.frame.width / 5
//        )
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: 20, height: 10)
        
        retualCollectionView = UICollectionView(
            frame: self.view.frame ,
            collectionViewLayout:flowLayout
        )
        retualCollectionView.dataSource = self
        retualCollectionView.delegate = self
        retualCollectionView.isScrollEnabled = true
        
        retualCollectionView.register(RetualCollectionViewCell.self, forCellWithReuseIdentifier: RetualCollectionViewCell.className)
        
        
        view.addSubview(retualCollectionView)
        retualCollectionView.anchor(top: cardTitleLabel.topAnchor, leading: cardTitleLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 30, bottom: 0, right: 0), size: .init(width: 300, height: 50))


        // 参加者名前
        view.addSubview(guestNameTitleLabel)
        guestNameTitleLabel.anchor(top: retualCollectionView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 20))
        guestNameTitleLabel.text = "御芳名"

        view.addSubview(guestNameTextField)
        guestNameTextField.anchor(top: guestNameTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        guestNameTextField.layer.borderWidth = 1.0
        guestNameTextField.layer.borderColor = .init(gray: 000000, alpha: 1)
        guestNameTextField.text = guest.guestName
        print(guest.guestName)
        guestNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
//        guestNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        
        view.addSubview(guestNameLabel)
        guestNameLabel.fillSuperview()
        guestNameLabel.text = guest.id
        guestNameLabel.textColor = .black
//        guestNameLabel.font = .systemFont(ofSize: 50, weight: .bold)
//        guestNameLabel.textAlignment = .center
        
        
        
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
    
    @objc private func textFieldDidChange() {
        print("名前が変更されました。")
        let name = guestNameTextField.text!
        guest.guestName = name
        print(guest.id)

        updateDelegate?.update(guest: guest)
        
    }
}

extension GuestController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retuals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RetualCollectionViewCell.className, for: indexPath)
        let retualsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        retualsButton.setTitle(retuals[indexPath.item], for: .normal)
//        retualsButton.addTarget(self, action: #selector(retualsButtonTapped), for: .touchUpInside)
        cell.addSubview(retualsButton)
        
        return cell
    }
    
    @objc func retualsButtonTapped() {
        print("Tapped")
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
