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

//スクリーンサイズの取得
let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

protocol GuestUpdateDelegate: class {
    func update(guest: Guest) -> String
}

class GuestController: UIViewController {
    
    var guest: Guest
    weak var updateDelegate: GuestUpdateDelegate?
    
    
//    fileprivate let retualCollectionView = RetualCollectionView()
    fileprivate let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    fileprivate lazy var retualCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    fileprivate let cardHeaderView = CardHeaderView()
    fileprivate let cardTitleView = CardTitleView()
    fileprivate let guestNameView = GuestNameView()
    fileprivate let companyNameView = CompanyNameView()
    fileprivate let guestNameTextField                   = UITextField()
    fileprivate let companyNameTextField                   = UITextField()
    fileprivate let zipCodeLabel                         = UILabel()
    fileprivate let telLabel                             = UILabel()
    fileprivate let addressLabel                         = UILabel()
    fileprivate let selectAcuaintanceQuestionLabel       = UILabel()
    fileprivate let selectAcuaintanceLabel               = UILabel()
    fileprivate let selectRelationQuestionLabel          = UILabel()
    fileprivate let selectRelationLabel                  = UILabel()
    fileprivate let retuals: [String]                    = ["通夜", "告別式"]
    fileprivate let relationLabel                        = UILabel()
    fileprivate let relations: [String]                  = ["故人様", "喪主様", "ご家族", "その他"]
    fileprivate let group: [String]                      = ["会社関係", "お取引先", "学校関係", "官公庁", "各種団体", "町内会", "ご友人", "ご親戚", "その他"]
    fileprivate let description1                         = UILabel()
    fileprivate let description2                         = UILabel()
    fileprivate let headerStackView                      = UIStackView()
    fileprivate let guestNameStackVirew                  = UIStackView()
    fileprivate let companyNameStackVirew                = UIStackView()
    fileprivate let db                                   = Firestore.firestore().collection("events")
    fileprivate let storage                              = Storage.storage().reference()

        
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder){fatalError()}
    
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
//        setupLabels()
        setupCardHeaderView()
        setupCardTitleView()
        setupRetualCollectionView()
        setupGuestNameView()
        setupCompanyNameView()
//        setupSelectView()
    }
    fileprivate func setupBasic() {
        view.backgroundColor = .white

     }
    fileprivate func setupCardHeaderView() {
        view.addSubview(cardHeaderView)
        cardHeaderView.setupView(guestId: guest.id)
        cardHeaderView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: screenSize.width, height: screenSize.height / 20))
    }
    fileprivate func setupCardTitleView() {
        view.addSubview(cardTitleView)
        cardTitleView.setupView(pageNumber: guest.pageNumber)
        cardTitleView.anchor(top: cardHeaderView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: screenSize.width, height: screenSize.height / 10))
    }
    fileprivate func setupRetualCollectionView() {
        view.addSubview(retualCollectionView)
        retualCollectionView.dataSource = self
        retualCollectionView.delegate = self
        retualCollectionView.register(CheckBoxCell.self, forCellWithReuseIdentifier: CheckBoxCell.className)
        
//        retualCollectionView.backgroundColor = .blue
//        retualCollectionView.fillSuperview()
        retualCollectionView.anchor(top: cardTitleView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 50))
    }
    
    fileprivate func setupGuestNameView() {
        view.addSubview(guestNameView)
        guestNameView.setupView(guestName: guest.guestName)
        guestNameView.anchor(top: retualCollectionView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width * 3 / 5, height: screenSize.height / 5))
        guestNameView.layer.borderWidth = 1.0
     }
    fileprivate func setupCompanyNameView() {
        view.addSubview(companyNameView)
        companyNameView.setupView(companyName: guest.companyName)
        companyNameView.anchor(top: retualCollectionView.bottomAnchor, leading: guestNameView.trailingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor)
        companyNameView.layer.borderWidth = 2
    }
     fileprivate func setupSelectView() {
//         selectView.setup()
     }
    
    fileprivate func setupLabels() {
     

        
        
        
         
        
//        // 参加儀式選択


        
//
//        view.addSubview(zipCodeLabel)
//
//
//
//        view.addSubview(telLabel)
//
//
//
//        view.addSubview(addressLabel)
//        view.addSubview(selectAcuaintanceQuestionLabel)
//        view.addSubview(selectAcuaintanceLabel)
//        view.addSubview(selectRelationQuestionLabel)
//        view.addSubview(selectRelationLabel)
        
        
        
    }
    
    @objc func textFieldDidChange() {
        print("名前が変更されました。")
        let name = guestNameTextField.text ?? ""
        let companyName = companyNameTextField.text ?? ""
        guest.guestName = name
        guest.companyName = companyName

        let guestId = updateDelegate?.update(guest: guest)
        if (guest.id == "new" && guestId != nil) {
            guest.id = guestId!
        }
    }
}

extension GuestController: UICollectionViewDataSource {
    // cellの個数設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return retuals.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCell.className, for: indexPath) as! CheckBoxCell
        
        cell.setupContents(textName: retuals[indexPath.item])
        return cell
    }
}
extension GuestController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
