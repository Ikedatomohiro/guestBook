//
//  CompanyNameView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/07.
//

import UIKit

class CompanyNameView: UIView {
    fileprivate let companyNameTitleLabel = UILabel()
    fileprivate let companyNameTextField  = UITextField()
    fileprivate let companyName: String   = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(companyName: String) {
        addSubview(companyNameTitleLabel)
        companyNameTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: 300, height: 40))
        companyNameTitleLabel.text = "会社名(団体名)"
        
        addSubview(companyNameTextField)
        companyNameTextField.anchor(top: companyNameTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        companyNameTextField.layer.borderWidth = 1.0
        companyNameTextField.layer.borderColor = .init(gray: 000000, alpha: 1)
        companyNameTextField.text = companyName
        companyNameTextField.addTarget(self, action: #selector(GuestController.textFieldDidChange), for: .editingDidEnd)
        

    }
}
