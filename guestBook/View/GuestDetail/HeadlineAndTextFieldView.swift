//
//  HeadlineAndTextFieldView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/21.
//

import UIKit

class HeadlineAndTextFieldView: UIView {
    var headlineLabel: UILabel = UILabel()
    var textField: UITextField = UITextField()

    init(headlineText: String, textFiledText: String, _ accessibilityIdentifier: String) {
        super.init(frame: CGRect())
        setup(headlineText, textFiledText, accessibilityIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup(_ headlineText: String, _ textFieldText: String, _ accessibilityIdentifier: String) {
        addSubview(headlineLabel)
        headlineLabel.anchor(top: topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: .zero, height: 30))
        headlineLabel.text = headlineText
        addSubview(textField)
        textField.anchor(top: headlineLabel.bottomAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: layoutMarginsGuide.trailingAnchor, size: .init(width: .zero, height: 30))
        textField.text = textFieldText
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.accessibilityIdentifier = accessibilityIdentifier
    }

    // MARK:-
    @objc func textFieldDidChange() {

        print("変更されました。")

    }
}
