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
    let addressCanvas = PKCanvasView()
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
    let zipCodeCanvas = PKCanvasView()
    fileprivate let telNumberTitleLabel = UILabel()
    let telNumberCanvas = PKCanvasView()
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
        setupAddressCanvas(ImageData: guest.addressImageData)
        setupZipCodeLabel(guest)
        setupZipCodeCanvas(ImageData: guest.zipCodeImageData)
        setupTelNumberLabel(guest)
        setupTelNumberCanvas(ImageData: guest.telNumberImageData)
        
    }
    
    // MARK:- address
    fileprivate func setupAdrressLabel(_ guest: Guest) {
        addSubview(addressTitleLabel)
        addressTitleLabel.text = "御住所"
        addressTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 5), size: .init(width: 100, height: 30))
        addressTitleLabel.font = .systemFont(ofSize: 24)
    }
    
    fileprivate func setupAddressCanvas(ImageData: Data) {
        // 手書きエリア
        addSubview(addressCanvas)
        addressCanvas.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        addressCanvas.isOpaque = false
        addressCanvas.layer.borderWidth = 1.0
        addressCanvas.setDrawingData(addressCanvas, ImageData)
        addressCanvas.delegate = self
        addressCanvas.accessibilityIdentifier = "address"
    }
    
    // MARK:- telNumber
    fileprivate func setupTelNumberLabel(_ guest: Guest) {
        addSubview(telNumberTitleLabel)
        let telText = "TEL　　　　　　(　　　　　　)                    　"
        // アンダーラインを引く
        let attributedString = NSMutableAttributedString(string: telText)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange.init(location: 0, length: attributedString.length));
        telNumberTitleLabel.attributedText = attributedString
        telNumberTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: zipCodeLabel.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        telNumberTitleLabel.font = .systemFont(ofSize: 24)
        
    }
    
    fileprivate func setupTelNumberCanvas(ImageData: Data) {
        addSubview(telNumberCanvas)
        telNumberCanvas.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, size: .init(width: screenSize.width * 2 / 5, height: 60))
        telNumberCanvas.isOpaque = false
        telNumberCanvas.setDrawingData(telNumberCanvas, ImageData)
        telNumberCanvas.delegate = self
        telNumberCanvas.accessibilityIdentifier = "telNumber"
    }
    
    // MARK:- zipCode
    fileprivate func setupZipCodeLabel(_ guest: Guest) {
        // 郵便番号の枠
        setupZipCodeFrame()
    }
    
    fileprivate func setupZipCodeCanvas(ImageData: Data) {
        addSubview(zipCodeCanvas)
        zipCodeCanvas.anchor(top: topAnchor, leading: addressTitleLabel.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: screenSize.width * 2 / 5, height: 60))
        zipCodeCanvas.isOpaque = false
        zipCodeCanvas.setDrawingData(zipCodeCanvas, ImageData)
        zipCodeCanvas.delegate = self
        zipCodeCanvas.accessibilityIdentifier = "zipCode"
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
    
    // ペンシルはページ表示後にセットする
    func setupPencil() {
        addressCanvas.setupPencil(canvas: addressCanvas)
        telNumberCanvas.setupPencil(canvas: telNumberCanvas)
        zipCodeCanvas.setupPencil(canvas: zipCodeCanvas)
    }
}

// MARK:- Extensions
extension AddressView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        self.accessibilityIdentifier = canvasView.accessibilityIdentifier
        guestItemupdateDelegate?.update(inputView: self)
    }
}
