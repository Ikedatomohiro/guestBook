//
//  MenuViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/03.
//

import UIKit
import FirebaseAuth

protocol SideMenuDelegate: AnyObject {
    func hideSideMenuView()
    func hidePopup()
    func sideMenuItemDidTap(sideMenuItem: SideMenuListView.SideMenuItem)
    func signOut()
}
// functionのデフォルト動作を設定。今回は何もしない状態を設定。
extension SideMenuDelegate {
    func hideSideMenuView() {}
    func sideMenuItemDidTap(sideMenuItem: SideMenuListView.SideMenuItem) {}
    func signOut() {}
}

class SideMenuViewController: UIViewController {
    
    var backgroundView = UIView()
    lazy var sideMenuView = SideMenuListView()
    weak var sideMenuDelegate: SideMenuDelegate?
    weak var eventListViewControllerDelegate: EventListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMenuListView()
    }
    
    fileprivate func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(menuBackgroundDidTap(_:)))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    @objc func menuBackgroundDidTap(_ sender: UIGestureRecognizer) {
        // サイドメニューを表示した状態で、サイドメニュー以外のエリアをタップしたときにサイドメニューをスライドアウトさせる
        UIView.animate(withDuration: 0.3) {
            self.sideMenuView.center.x -= screenSize.width / 4
            self.backgroundView.alpha = 0
        } completion: { (Bool) in
            // サイドメニューを表示しているviewを削除
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
        sideMenuView.sideMenuDelegate = self
    }
    
    func signOutApplicaition() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let dialog = UIAlertController(title: "サインアウトしました。", message: "", preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
        eventListViewControllerDelegate?.moveTosignPage()
    }
}

// MARK:- Extensions
extension SideMenuViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let sideMenuPC = SideMenuPresentationController(presentedViewController: presented, presenting: presenting)
        sideMenuPC.sideMenuDelegate = self
        return sideMenuPC
    }
}

extension SideMenuViewController: SideMenuDelegate {
    func hidePopup() {
        sideMenuDelegate?.hideSideMenuView()
    }
    
    func sideMenuItemDidTap(sideMenuItem: SideMenuListView.SideMenuItem) {
        // サイドメニューを非表示にする
        UIView.animate(withDuration: 0.3) {
            self.sideMenuView.center.x -= screenSize.width / 4
            self.backgroundView.alpha = 0
        }
        // モーダルのViewControllerを表示
        guard let VC = sideMenuItem.viewController else {
            sideMenuDelegate?.hideSideMenuView()
            print("サインアウト処理を行います。")
            // ログインページに遷移
            return
        }
        VC.modalPresentationStyle = .custom
        VC.transitioningDelegate = self
        present(VC, animated: true)
    }
    
    func signOut() {
        signOutApplicaition()
    }
}

