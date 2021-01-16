//
//  DescriptionView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/16.
//

import UIKit
import PencilKit

class DescriptionView: UIView {
    
    fileprivate let description1      = UILabel()
    fileprivate let description2      = UILabel()
    let descriptionTextField          = UITextField()
    fileprivate let descriptionCanvas = PKCanvasView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupDescriptionLabel()
        setupDescriptionTexField()
    }
    
    fileprivate func setupDescriptionLabel() {
        addSubview(description1)
        description1.text = "名刺をお持ちの方は受付にお渡しください。"
        description1.anchor(top: layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 500, height: 100))
        
        
    }
    fileprivate func setupDescriptionTexField() {
        addSubview(descriptionTextField)
    }
}
