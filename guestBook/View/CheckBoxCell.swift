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

    fileprivate let checkBox = UIButton()
    fileprivate let label = UILabel()

    
    //    private let retualNameLabel: UILabel = {
//        let label = UILabel()
//        label.frame = CGRect(x: 0, y: 0, width: screenSize.width / 4, height: screenSize.width / 4)
//        label.textColor = UIColor.gray
//        label.textAlignment = .center
//        return label
//    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(checkBox)
        checkBox.fillSuperview()
        checkBox.backgroundColor = .white
        
//        checkBox.setTitle(indexPath.item, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContents(cellText: String) {
//        retualNameLabel.text = textName
        checkBox.setTitle(cellText, for: .normal)

    }
    
    func setup(retual: String) {
        
    }
    
    func activate(isActivate: Bool) {
//        isActivate ? on() : off()
    }
}
