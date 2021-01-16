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
//protocol UpdateRetualDelegate: class {
//    func updateRetual(guest: Guest) -> String
//}



class GuestController: UIViewController {
    fileprivate let backGroundFrame = UIView()
    var guest: Guest
    weak var updateDelegate: GuestUpdateDelegate?
//    weak var updateRetualDelegate: UpdateRetualDelegate?
    fileprivate let cardHeaderView                  = CardHeaderView()
    fileprivate let cardTitleView                   = CardTitleView()
    fileprivate let guestNameView                   = GuestNameView()
    fileprivate let companyNameView                 = CompanyNameView()
    fileprivate let addressView                     = AddressView()
 
    
    fileprivate let descriptionView                 = DescriptionView()
    
    
    fileprivate let selectAcuaintanceQuestionLabel  = UILabel()
    fileprivate let selectAcuaintanceLabel          = UILabel()
    fileprivate let selectRelationQuestionLabel     = UILabel()
    fileprivate let selectRelationLabel             = UILabel()
    fileprivate let relations: [String]             = ["故人様", "喪主様", "ご家族", "その他"]
    fileprivate let groups: [String]                = ["会社関係", "お取引先", "学校関係", "官公庁", "各種団体", "町内会", "ご友人", "ご親戚", "その他"]
    fileprivate let storage                         = Storage.storage().reference()

        
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder){fatalError()}
    
    // MARK:- layout
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupCardHeaderView()
        setupCardTitleView()
        setupBackgroundFrame()
        setupGuestNameView()
        setupCompanyNameView()
        setupAddressView()
    }
    fileprivate func setupBasic() {
        view.backgroundColor = .white
     }
    fileprivate func setupCardHeaderView() {
        view.addSubview(cardHeaderView)
        cardHeaderView.setupView()
        cardHeaderView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: screenSize.width, height: screenSize.height / 20))
    }
    fileprivate func setupCardTitleView() {
        view.addSubview(cardTitleView)
        cardTitleView.setupView(guest: guest)
        cardTitleView.anchor(top: cardHeaderView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width, height: screenSize.height / 12))
    }
    fileprivate func setupBackgroundFrame() {
        view.addSubview(backGroundFrame)
        backGroundFrame.anchor(top: cardTitleView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10), size: .init(width: screenSize.width, height: screenSize.height * 3 / 5))
        backGroundFrame.layer.borderWidth = 2.0

    }
    fileprivate func setupGuestNameView() {
        view.addSubview(guestNameView)
        guestNameView.setupView(guest: guest)
        guestNameView.anchor(top: backGroundFrame.topAnchor, leading: backGroundFrame.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width * 4 / 7, height: screenSize.height / 5))
        guestNameView.layer.borderWidth = 1.0
        guestNameView.guestNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
     }
    fileprivate func setupCompanyNameView() {
        view.addSubview(companyNameView)
        companyNameView.setupView(guest: guest)
        companyNameView.anchor(top: backGroundFrame.topAnchor, leading: guestNameView.trailingAnchor, bottom: guestNameView.bottomAnchor, trailing: backGroundFrame.trailingAnchor)
        companyNameView.layer.borderWidth = 1.0
        companyNameView.companyNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
     fileprivate func setupAddressView() {
        view.addSubview(addressView)
        addressView.setupView(guest: guest)
        addressView.anchor(top: guestNameView.bottomAnchor, leading: backGroundFrame.leadingAnchor, bottom: nil, trailing: backGroundFrame.trailingAnchor, size: .init(width: backGroundFrame.frame.width, height: screenSize.height / 5))
        addressView.layer.borderWidth = 1.0
        addressView.addressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    // どなたのご関係ですか？
    
    
    // どのようなご関係ですか？
    
    
    
    
    
    
    fileprivate func setupDescriptionView() {
        view.addSubview(descriptionView)
        descriptionView.setupView(guest: guest)
        descriptionView.anchor(top: backGroundFrame.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor, size: .init(width: backGroundFrame.frame.width, height: screenSize.height / 5))
        descriptionView.layer.borderWidth = 1.0
    }

    
    
    
    
    //MARK:- func
    @objc func textFieldDidChange() {
        print("名前が変更されました。")
        let name = guestNameView.guestNameTextField.text ?? ""
        let companyName = companyNameView.companyNameTextField.text ?? ""
        guest.guestName = name
        guest.companyName = companyName

        let guestId = updateDelegate?.update(guest: guest)
        if (guest.id == "new" && guestId != nil) {
            guest.id = guestId!
        }
    }
}
