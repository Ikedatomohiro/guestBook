//
//  ListCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/02/12.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        contentView.addSubview(label)
        label.fillSuperview()
    }
    
    func setupContents(text: String) {
        label.text = text
    
    
    }
    
    
    
}
