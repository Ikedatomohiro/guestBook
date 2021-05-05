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
    lazy var menuListView = SideMenuView()
    weak var sendMenuBackgroundDidTapDelegate: SendMenuBackgroundDidTapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgrountView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMenuListView()
    }

    fileprivate func setupBackgrountView() {
        view.addSubview(backgroundView)
        backgroundView.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(menuBackgroundDidTap(_:)))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    @objc func menuBackgroundDidTap(_ sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.menuListView.center.x -= screenSize.width / 4
            self.backgroundView.alpha = 0
        } completion: { (Bool) in
            self.sendMenuBackgroundDidTapDelegate?.backGroundDidTap()
        }
    }
    
    fileprivate func setupMenuListView() {

        view.addSubview(menuListView)
        menuListView.anchor(top: self.view.topAnchor, leading: nil, bottom: self.view.bottomAnchor, trailing: backgroundView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -screenSize.width / 4), size: .init(width: screenSize.width / 4, height: .zero))
        menuListView.backgroundColor = .white
        UIView.animate(withDuration: 0.2, animations: {
            self.menuListView.center.x += screenSize.width / 4
            self.backgroundView.alpha = 0.1
        }, completion: nil)
    }
}
