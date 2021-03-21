//
//  HeadlineAndTextFieldView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/03/21.
//

import UIKit

class HeadlineAndTextFieldView: UIView {
    var headlineLabel = UILabel()
    var textFieldText = UITextField()
    
    convenience init(_ headLineLabel: String, _ textFiledText: String) {
        self.headlineLabel = headlineLabel
        self.textFieldText = textFieldText
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
