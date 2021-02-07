//
//  CheckBoxCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/28.
//

import UIKit

class CheckBoxCell: UICollectionViewCell {

    fileprivate let label          = UILabel()
    fileprivate let isActive: Bool = false

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
        label.layer.cornerRadius = 5
        label.textAlignment = .center
    }
    
    func setupContents(textName: String) {
        label.text = textName
        label.font = .systemFont(ofSize: 24)
    }
    func setupButton(isActive: Bool) {
        if isActive == true {
            label.backgroundColor = .orange
        } else if isActive == false {
            label.backgroundColor = .gray
        }
    }
    
    
}