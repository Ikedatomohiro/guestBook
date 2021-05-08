//
//  MenuViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/03.
//

import UIKit

protocol SideMenuDelegate: AnyObject {
    func hideSideMenuView()
    func hidePopup()
}

class SideMenuViewController: UIViewController {
    
    var backgroundView = UIView()
    lazy var sideMenuView = SideMenuListView()
    weak var sideMenuDelegate: SideMenuDelegate?
    
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
            self.sideMenuView.center.x -= screenSize.width / 4
            self.backgroundView.alpha = 0
        } completion: { (Bool) in
            self.sideMenuDelegate?.hideSideMenuView()
        }
    }
    
    fileprivate func setupMenuListView() {
        view.addSubview(sideMenuView)
        sideMenuView.anchor(top: self.view.topAnchor, leading: nil, bottom: self.view.bottomAnchor, trailing: backgroundView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -screenSize.width / 4), size: .init(width: screenSize.width / 4, height: .zero))
        sideMenuView.backgroundColor = .white
        UIView.animate(withDuration: 0.2, animations: {
            self.sideMenuView.center.x += screenSize.width / 4
            self.backgroundView.alpha = 0.1
        }, completion: nil)
        sideMenuView.sideMenuItemDidTapDelegate = self
    }
    
    fileprivate func hideModalView() {
        sideMenuDelegate?.hideSideMenuView()
    }
}

// MARK:- Extensions
extension SideMenuViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let sideMenuPC = SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
        sideMenuPC.modalBackGroundDidTapDelegate = self
        return sideMenuPC
    }
}

extension SideMenuViewController: SideMenuItemDidTapDelegate {
    func sideMenuItemDidTap(sideMenuItem: SideMenuListView.SideMenuItem) {
        // サイドメニューを非表示にする
        UIView.animate(withDuration: 0.3) {
            self.sideMenuView.center.x -= screenSize.width / 4
            self.backgroundView.alpha = 0
        }
        // モーダルのViewControllerを表示
        guard let VC = sideMenuItem.viewController else {
            sideMenuDelegate?.hideSideMenuView()
            print("サインアウト")
            return
        }
        VC.modalPresentationStyle = .custom
        VC.transitioningDelegate = self
        present(VC, animated: true)
    }
}

extension SideMenuViewController: SideMenuPresentationDelegate {
    func hideModal() {
        hideModalView()
        //        sideMenuDelegate?.hideSideMenuView()
    }
}

extension SideMenuViewController: SideMenuDelegate {
    func hideSideMenuView() {
    }
    
    func hidePopup() {
        hideModalView()
    }
    
    
}
