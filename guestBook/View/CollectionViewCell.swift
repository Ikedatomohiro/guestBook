//
//  CollectionViewCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/09.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private let fruitsNameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: screenSize.width / 2.0, height: screenSize.width / 2.0)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setup() {
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 3.0

        contentView.addSubview(fruitsNameLabel)
    }

    func setupContents(textName: String) {
        fruitsNameLabel.text = textName
    }
}
