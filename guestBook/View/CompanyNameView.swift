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
    let companyNameTextField  = UITextField()
    fileprivate let companyNameCanvas     = PKCanvasView()
    fileprivate let companyName: String   = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(companyName: String) {
        setupLabel()
        setupTextField()
//        setupCanvas()
    }
    fileprivate func setupLabel() {
        addSubview(companyNameTitleLabel)
        companyNameTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: 300, height: 40))
        companyNameTitleLabel.text = "会社名(団体名)"
    }
    fileprivate func setupTextField() {
        addSubview(companyNameTextField)
        companyNameTextField.anchor(top: companyNameTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        companyNameTextField.layer.borderWidth = 1.0
        companyNameTextField.layer.borderColor = .init(gray: 000000, alpha: 1)
        companyNameTextField.text = companyName
    }
    fileprivate func setupCanvas() {
        addSubview(companyNameCanvas)
        companyNameCanvas.fillSuperview()
        companyNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        companyNameCanvas.isOpaque = false

        if let windw = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: windw) {
                toolPicker.addObserver(companyNameCanvas)
                toolPicker.setVisible(true, forFirstResponder: companyNameCanvas)
                companyNameCanvas.becomeFirstResponder()
            }
        }
    }
}
