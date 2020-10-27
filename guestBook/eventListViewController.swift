//
//  eventListViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/10/27.
//

import UIKit

class eventListViewController: UIViewController {
    fileprivate let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        setUpTitleLabel()



    }

    func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.backgroundColor = .blue
        titleLabel.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 80, left: 30, bottom: 0, right: 0))
        titleLabel.text = "芳名帳アプリ"
    }
}

