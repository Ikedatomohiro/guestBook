//
//  CheckBoxCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/28.
//

import UIKit

class CheckBoxCell: UICollectionViewCell {

    fileprivate let retualsButton = UIButton()
    fileprivate let label   = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(label)
        label.fillSuperview()
        label.backgroundColor = .gray
        
    }
    
    func setupContents(textName: String) {
        label.text = textName
    }
    
}
