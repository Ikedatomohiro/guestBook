//
//  MenuViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/03.
//

import UIKit

protocol SendMenuBackgroundDidTapDelegate: AnyObject {
    func backGroundDidTap()
}

class SideMenuViewController: UIViewController {
    
    var backgroundView = UIView()
    var menuListView = UIView()
    weak var sendMenuBackgroundDidTapDelegate: SendMenuBackgroundDidTapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrountView()
        setupMenuListView()
    }

    fileprivate func setupBackgrountView() {
        view.addSubview(backgroundView)
        backgroundView.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        backgroundView.backgroundColor = .blue
        backgroundView.alpha = 0.1
        let gesture = UITapGestureRecognizer(target: self, action: #selector(menuBackgroundDidTap(_:)))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    @objc func menuBackgroundDidTap(_ sender: UIGestureRecognizer) {
        sendMenuBackgroundDidTapDelegate?.backGroundDidTap()
    }
    
    fileprivate func setupMenuListView() {
        view.addSubview(menuListView)
        menuListView.anchor(top: self.view.topAnchor, leading: nil, bottom: self.view.bottomAnchor, trailing: backgroundView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -10), size: .init(width: screenSize.width / 4, height: .zero))
        menuListView.backgroundColor = .purple
        
    }
    
}

