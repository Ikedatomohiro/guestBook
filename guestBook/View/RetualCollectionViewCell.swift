//
//  CheckBoxCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/28.
//

import UIKit

class CheckBoxCell: UICollectionViewCell {

    //スクリーンサイズの取得
    let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

    fileprivate let retualsButton = UIButton()
    fileprivate let retualLabel   = UILabel()

    
    //    private let retualNameLabel: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(x: 0, y: 0, width: screenSize.width / 4, height: screenSize.width / 4)
//        label.textColor = UIColor.gray
//        label.textAlignment = .center
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(retualsButton)
        retualsButton.fillSuperview()
        retualsButton.backgroundColor = .green
        
//        retualsButton.setTitle(indexPath.item, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(retual: String) {
//        retualNameLabel.text = textName
    retualsButton.setTitle(retual, for: .normal)

    }
    
}
