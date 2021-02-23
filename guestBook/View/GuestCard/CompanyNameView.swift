//
//  CompanyNameView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/07.
//

import UIKit
import PencilKit

class CompanyNameView: UIView {
    fileprivate let companyNameTitleLabel = UILabel()
    let companyNameTextField              = UITextField()
    let companyNameCanvas     = PKCanvasView()
    weak var guestItemupdateDelegate: GuestItemUpdateDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupLabel()
        setupTextField(companyName: guest.companyName)
        setupCanvas(ImageData: guest.companyNameImageData)
    }
    fileprivate func setupLabel() {
        addSubview(companyNameTitleLabel)
        companyNameTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        companyNameTitleLabel.text = "会社名(団体名)"
        companyNameTitleLabel.font = .systemFont(ofSize: 24)

    }
    fileprivate func setupTextField(companyName: String) {
        addSubview(companyNameTextField)
        companyNameTextField.anchor(top: nil, leading: companyNameTitleLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        companyNameTextField.layer.borderWidth = 1.0
        companyNameTextField.text = companyName
        companyNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)

    }
    fileprivate func setupCanvas(ImageData: Data) {
        addSubview(companyNameCanvas)
//        companyNameCanvas.fillSuperview()
        companyNameCanvas.anchor(top: topAnchor, leading: leadingAnchor , bottom: bottomAnchor, trailing: trailingAnchor)
        companyNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        companyNameCanvas.isOpaque = false
        companyNameCanvas.delegate = self
        companyNameCanvas.layer.borderWidth = 1.0
        companyNameCanvas.setDrawingData(companyNameCanvas, ImageData)
        companyNameCanvas.setupPencil(canvas: companyNameCanvas)
    }
    @objc func textFieldDidChange() {
        guestItemupdateDelegate?.update(inputView: self)
    }
}

extension CompanyNameView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guestItemupdateDelegate?.update(inputView: self)
    }
}
