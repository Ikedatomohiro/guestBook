//
//  AddressView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/13.
//

import UIKit
import PencilKit

class AddressView: UIView {
    fileprivate let addressTitleLabel   = UILabel()
    let addressTextField                = UITextField()
    let addressCanvas       = PKCanvasView()
    fileprivate let zipCodeTitleLabel   = UILabel()
    fileprivate let zipCodeLabel        = UILabel()
    fileprivate let zipCodeLabel1       = UILabel()
    fileprivate let zipCodeLabel2       = UILabel()
    fileprivate let zipCodeLabel3       = UILabel()
    fileprivate let zipCodeLabelBar     = UILabel()
    fileprivate let zipCodeLabel4       = UILabel()
    fileprivate let zipCodeLabel5       = UILabel()
    fileprivate let zipCodeLabel6       = UILabel()
    fileprivate let zipCodeLabel7       = UILabel()
    let zipCodeCanvas       = PKCanvasView()
    let zipCodeTextField                = UITextField()
    fileprivate let telNumberTitleLabel = UILabel()
    let telNumberTextField              = UITextField()
    let telNumberCanvas     = PKCanvasView()
    weak var guestItemupdateDelegate: GuestItemUpdateDelegate?
    
    // MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupAdrressLabel(guest)
        setupAddressTextField(address: guest.address)
        setupZipCodeLabel(guest)
        setupZipCodeTextField(zipCode: guest.zipCode)
        setupTelNumberLabel(guest)
        setupTelNumberTextField(telNumber: guest.telNumber)
        
    }
    
    // MARK:- address
    fileprivate func setupAdrressLabel(_ guest: Guest) {
        addSubview(addressTitleLabel)
        addressTitleLabel.text = "御住所"
        addressTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 30))
        addressTitleLabel.font = .systemFont(ofSize: 24)
        // 手書きエリア
        addSubview(addressCanvas)
        addressCanvas.anchor(top: nil, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: 400, height: 60))
        addressCanvas.isOpaque = false
        addressCanvas.layer.borderWidth = 1.0
        addressCanvas.setDrawingData(addressCanvas, guest.addressImageData)
        addressCanvas.setupPencil(canvas: addressCanvas)
        addressCanvas.delegate = self
        addressCanvas.accessibilityIdentifier = "address"
    }
    
    fileprivate func setupAddressTextField(address: String) {
        addSubview(addressTextField)
        addressTextField.anchor(top: addressTitleLabel.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        addressTextField.layer.borderWidth = 1.0
        addressTextField.text = address
        addressTextField.accessibilityIdentifier = "address"
        addressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    // MARK:- telNumber
    fileprivate func setupTelNumberLabel(_ guest: Guest) {
        addSubview(telNumberTitleLabel)
        let telText = "TEL　　　　　　(　　　　　　)                    　"
        // アンダーラインを引く
        let attributedString = NSMutableAttributedString(string: telText)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        telNumberTitleLabel.attributedText = attributedString
        telNumberTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: addressTitleLabel.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        telNumberTitleLabel.font = .systemFont(ofSize: 24)
        // 手書きエリア
        addSubview(telNumberCanvas)
        telNumberCanvas.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: 400, height: 60))
        telNumberCanvas.isOpaque = false
        telNumberCanvas.layer.borderWidth = 1.0
        telNumberCanvas.setDrawingData(telNumberCanvas, guest.telNumberImageData)
        telNumberCanvas.setupPencil(canvas: telNumberCanvas)
        telNumberCanvas.delegate = self
        telNumberCanvas.accessibilityIdentifier = "telNumber"
    }
    
    fileprivate func setupTelNumberTextField(telNumber: String) {
        addSubview(telNumberTextField)
        telNumberTextField.anchor(top: telNumberTitleLabel.bottomAnchor, leading: zipCodeTextField.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        telNumberTextField.layer.borderWidth = 1.0
        telNumberTextField.text = telNumber
        telNumberTextField.accessibilityIdentifier = "telNumber"
        telNumberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    // MARK:- zipCode
    fileprivate func setupZipCodeLabel(_ guest: Guest) {
        // 郵便番号の枠
        setupZipCodeFrame()
        // 手書きエリア
        addSubview(zipCodeCanvas)
        zipCodeCanvas.anchor(top: layoutMarginsGuide.topAnchor, leading: addressTitleLabel.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: 400, height: 60))
        zipCodeCanvas.isOpaque = false
        zipCodeCanvas.layer.borderWidth = 1.0
        zipCodeCanvas.setDrawingData(zipCodeCanvas, guest.zipCodeImageData)
        zipCodeCanvas.setupPencil(canvas: zipCodeCanvas)
        zipCodeCanvas.delegate = self
        zipCodeCanvas.accessibilityIdentifier = "zipCode"
    }
    
    fileprivate func setupZipCodeTextField(zipCode: String) {
        addSubview(zipCodeTextField)
        zipCodeTextField.anchor(top: zipCodeTitleLabel.bottomAnchor, leading: addressTextField.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        zipCodeTextField.layer.borderWidth = 1.0
        zipCodeTextField.text = zipCode
        zipCodeTextField.accessibilityIdentifier = "zipCode"
        zipCodeTextField.placeholder = "郵便番号"
        zipCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        
    }
    
    fileprivate func setupZipCodeFrame() {
        addSubview(zipCodeLabel)
        zipCodeLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: addressTitleLabel.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: 320, height: 40))
        addSubview(zipCodeTitleLabel)
        zipCodeTitleLabel.text = "〒"
        zipCodeTitleLabel.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel.leadingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeTitleLabel.font = .systemFont(ofSize: 24)
        
        addSubview(zipCodeLabel1)
        zipCodeLabel1.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeTitleLabel.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel1.layer.borderWidth = 1.0
        addSubview(zipCodeLabel2)
        zipCodeLabel2.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel1.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel2.layer.borderWidth = 1.0
        addSubview(zipCodeLabel3)
        zipCodeLabel3.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel2.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel3.layer.borderWidth = 1.0
        addSubview(zipCodeLabelBar)
        zipCodeLabelBar.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel3.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabelBar.text = "ー"
        zipCodeLabelBar.textAlignment = .center
        addSubview(zipCodeLabel4)
        zipCodeLabel4.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabelBar.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel4.layer.borderWidth = 1.0
        addSubview(zipCodeLabel5)
        zipCodeLabel5.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel4.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel5.layer.borderWidth = 1.0
        addSubview(zipCodeLabel6)
        zipCodeLabel6.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel5.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel6.layer.borderWidth = 1.0
        addSubview(zipCodeLabel7)
        zipCodeLabel7.anchor(top: zipCodeLabel.topAnchor, leading: zipCodeLabel6.trailingAnchor, bottom: zipCodeLabel.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 0, right: 0), size: .init(width: 30, height: 40))
        zipCodeLabel7.layer.borderWidth = 1.0
    }
    
    // MARK:-
    @objc func textFieldDidChange() {
        guestItemupdateDelegate?.update(inputView: self)
    }
}

// MARK:- Extensions
extension AddressView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guestItemupdateDelegate?.update(inputView: self)
    }
}
