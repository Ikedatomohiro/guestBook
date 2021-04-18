//
//  CheckBoxCell.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/28.
//

import UIKit

class CheckBoxCell: UICollectionViewCell {

    let label          = UILabel()
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
        label.textAlignment = .center
    }
    
    func setupContents(textName: String) {
        label.text = textName
        label.font = .systemFont(ofSize: 24)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
    }
    
    func setButtonColor(isActive: Bool) {
        if isActive == true {
            label.backgroundColor = green
        } else if isActive == false {
            label.backgroundColor = gray
        }
    }
    
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
                
            }, completion: nil)
        }
    }
}
