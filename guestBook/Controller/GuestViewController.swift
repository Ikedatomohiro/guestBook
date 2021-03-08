//
//  GuestViewController.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import PencilKit

protocol GuestUpdateDelegate: AnyObject {
    func update(guest: Guest)
}

protocol GuestItemUpdateDelegate: AnyObject {
    func update<T>(inputView: T)
}

class GuestViewController: UIViewController {
    
    var guest: Guest
    var retuals: [Retual]
    var relations: [Relation]
    var groups: [Group]
    weak var guestupdateDelegate: GuestUpdateDelegate?
    
    // UIView
    fileprivate let backGroundFrame    = UIView()
    fileprivate let cardHeaderView     = CardHeaderView()
    fileprivate let cardTitleView      = CardTitleView()
    fileprivate let guestNameView      = GuestNameView()
    fileprivate let companyNameView    = CompanyNameView()
    fileprivate let addressView        = AddressView()
    lazy var selectRelationView = SelectRelationView(guest: guest, relations: relations, frame: CGRect.zero)
    fileprivate let selectGroupView    = SelectGroupView()
    fileprivate let descriptionView    = DescriptionView()
    
    fileprivate let storage            = Storage.storage().reference(forURL: Keys.firestoreStorageUrl)
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    lazy var retualCollectionView = RetualCollectionView(guest, retuals, frame: CGRect.zero, collectionViewLayout: layout)
    lazy var groupCollectionView = GroupCollectionView(guest, groups, frame: CGRect.zero, collectionViewLayout: layout)
    
    init(guest: Guest, retuals: [Retual], relations: [Relation], groups: [Group]) {
        self.guest = guest
        self.retuals = retuals
        self.relations = relations
        self.groups = groups
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- layout
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupCardHeaderView()
        setupCardTitleView()
        setupRetualsSelectView()
        setupBackgroundFrame()
        setupGuestNameView()
        setupCompanyNameView()
        setupAddressView()
        setupSelectRelationView()
//        setupDescriptionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ペンシルはページ表示後にセットする
        setupPencils()
    }
    
    fileprivate func setupBasic() {
        view.backgroundColor = .white
    }
    
    fileprivate func setupCardHeaderView() {
        view.addSubview(cardHeaderView)
        cardHeaderView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: .zero, height: screenSize.height / 20))
        cardHeaderView.setupView(guest: guest)
    }
    
    fileprivate func setupCardTitleView() {
        view.addSubview(cardTitleView)
        cardTitleView.anchor(top: cardHeaderView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width / 2, height: screenSize.height / 12))
        cardTitleView.setupView()
    }
    
    fileprivate func setupRetualsSelectView() {
        view.addSubview(retualCollectionView)
        retualCollectionView.anchor(top: cardHeaderView.bottomAnchor, leading: nil, bottom: nil, trailing: cardHeaderView.trailingAnchor, size: .init(width: 300, height: screenSize.height / 12))
        retualCollectionView.backgroundColor = .white
        retualCollectionView.guestItemUpdateDelegate = self
    }
    
    fileprivate func setupBackgroundFrame() {
        view.addSubview(backGroundFrame)
        backGroundFrame.anchor(top: cardTitleView.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10), size: .init(width: .zero, height: screenSize.height * 3 / 5))
        backGroundFrame.accessibilityIdentifier = "backGroundFrame"
        backGroundFrame.layer.borderWidth = 2.0
    }
    
    fileprivate func setupGuestNameView() {
        view.addSubview(guestNameView)
        guestNameView.setupView(guest: guest)
        guestNameView.anchor(top: backGroundFrame.topAnchor, leading: backGroundFrame.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width * 1 / 2, height: screenSize.height / 5))
        guestNameView.layer.borderWidth = 1.0
        guestNameView.guestItemupdateDelegate = self
    }
    
    fileprivate func setupCompanyNameView() {
        view.addSubview(companyNameView)
        companyNameView.setupView(guest: guest)
        companyNameView.anchor(top: backGroundFrame.topAnchor, leading: guestNameView.trailingAnchor, bottom: guestNameView.bottomAnchor, trailing: backGroundFrame.trailingAnchor, size: .zero)
        companyNameView.layer.borderWidth = 1.0
        companyNameView.guestItemupdateDelegate = self
    }
    
    fileprivate func setupAddressView() {
        view.addSubview(addressView)
        addressView.setupView(guest: guest)
        addressView.anchor(top: guestNameView.bottomAnchor, leading: guestNameView.leadingAnchor, bottom: nil, trailing: companyNameView.trailingAnchor, size: .init(width: .zero, height: screenSize.height / 5))
        addressView.layer.borderWidth = 1.0
        addressView.guestItemupdateDelegate = self
    }
    
    // どなたのご関係ですか？
    fileprivate func setupSelectRelationView() {
        view.addSubview(selectRelationView)
//        selectRelationView.setupView(guest: guest, relations: relations)
        selectRelationView.anchor(top: addressView.bottomAnchor, leading: backGroundFrame.leadingAnchor, bottom: nil, trailing: backGroundFrame.trailingAnchor, size: .init(width: backGroundFrame.frame.width, height: screenSize.height / 5))
    }
    
    // どのようなご関係ですか？
    
    
    
    
    
    
    fileprivate func setupDescriptionView() {
        view.addSubview(descriptionView)
        descriptionView.setupView(guest: guest)
        descriptionView.anchor(top: backGroundFrame.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 10, right: 10), size: .init(width: backGroundFrame.frame.width, height: screenSize.height / 8))
        descriptionView.layer.borderWidth = 1.0
    }
    
    fileprivate func setupPencils() {
        guestNameView.setupPencil()
        companyNameView.setupPencil()
        addressView.setupPencil()
    }
}

// MARK:- Extensions
extension GuestViewController: GuestItemUpdateDelegate {
    func update<T>(inputView: T) {
        switch inputView {
        case is RetualCollectionView:
            guest.retuals = retualCollectionView.guest.retuals
            break
        case is GuestNameView:
            guest.guestName = guestNameView.guestNameTextField.text ?? ""
            let canvas = guestNameView.guestNameCanvas
            guest.guestNameImageData = canvas.drawing.dataRepresentation()
            let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: canvas.frame.width, height: canvas.frame.height), scale: 1.0)
            let imageFile = image.pngData() ?? Data()
            let fileName = "\(guest.id)_guestName"
            let strageRef = storage.child("\(fileName).png")
            strageRef.putData(imageFile, metadata: nil) { (metaData, error) in
                if error != nil {
                    print(error.debugDescription)
                }
            }
            break
        case is CompanyNameView:
            guest.companyName = companyNameView.companyNameTextField.text ?? ""
            guest.companyNameImageData = companyNameView.companyNameCanvas.drawing.dataRepresentation()
            break
        case is AddressView:
            guest.zipCode = addressView.zipCodeTextField.text ?? ""
            guest.zipCodeImageData = addressView.zipCodeCanvas.drawing.dataRepresentation()
            
            guest.telNumber = addressView.telNumberTextField.text ?? ""
            guest.telNumberImageData = addressView.telNumberCanvas.drawing.dataRepresentation()
            
            guest.address = addressView.addressTextField.text ?? ""
            guest.addressImageData = addressView.addressCanvas.drawing.dataRepresentation()
            break
        default:
            break
        }
        guestupdateDelegate?.update(guest: guest)
    }
}
