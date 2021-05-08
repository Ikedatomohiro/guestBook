//
//  PrivacyPolicyViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/05.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    fileprivate let statusBar = UIView()
    fileprivate let statusBarHeadlineLabel = UILabel()
    fileprivate let closeButton = UIButton()
    fileprivate var textView = UITextView()
    
    fileprivate var privacyPolicyHeadline: String = ""
    fileprivate var privacyPolicyText = ""
    lazy var privacyPolicyPopupView = PopupTextView(headline: privacyPolicyHeadline, text: privacyPolicyText, frame: .zero)
    weak var sideMenuDelegate: SideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyPolicyHeadline = "プライバシーポリシー"
        setupText()
        self.view.addSubview(privacyPolicyPopupView)
        privacyPolicyPopupView.fillSuperview()
        privacyPolicyPopupView.sideMenuDelegate = self
    }
    
    func setupText() {
        privacyPolicyText = """
        

        第16条（準拠法・裁判管轄）
        本規約の解釈にあたっては，日本法を準拠法とします。
        本サービスに関して紛争が生じた場合には，管理者の本店所在地を管轄する裁判所を専属的合意管轄とします。

        以上
        """
    }
}

// MARK:- Extensions
extension PrivacyPolicyViewController: SideMenuDelegate {
    func hideSideMenuView() {
    }
    
    func hidePopup() {
        sideMenuDelegate?.hidePopup()
    }
}
