//
//  PopupView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/08.
//

import UIKit

class PopupTextView: UIView {
    
    fileprivate let headline: String
    fileprivate let text: String
    fileprivate let statusBar = UIView()
    fileprivate let statusBarHeadlineLabel = UILabel()
    fileprivate let closeButton = UIButton()
    fileprivate var textView = UITextView()
    weak var sideMenuDelegate: SideMenuDelegate?
    
    init(headline: String, text: String, frame: CGRect) {
        self.headline = headline
        self.text = text
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.backgroundColor = .white
        setupStatusBar()
        setupText()
    }
    
    fileprivate func setupStatusBar() {
        setupStatusBarHeader()
        setupCloseButton()
        setupStatusBarHeadlineLabel()
    }
    
    fileprivate func setupStatusBarHeader() {
        addSubview(statusBar)
        statusBar.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, size: .init(width: .zero, height: 50))
        statusBar.backgroundColor = green
    }
    
    fileprivate func setupCloseButton() {
        
        let size = CGSize(width: 15, height: 15)
        let closeButtonImage = #imageLiteral(resourceName: "closeButton.png").reSizeImage(reSize: size)
        closeButton.setImage(closeButtonImage, for: .normal)
        statusBar.addSubview(closeButton)
        closeButton.anchor(top: statusBar.layoutMarginsGuide.topAnchor, leading: nil, bottom: statusBar.layoutMarginsGuide.bottomAnchor, trailing: statusBar.layoutMarginsGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 10, right: 10))
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
    }
    
    @objc func tapCloseButton() {
        sideMenuDelegate?.hidePopup()
    }
    
    fileprivate func setupStatusBarHeadlineLabel() {
        statusBar.addSubview(statusBarHeadlineLabel)
        statusBarHeadlineLabel.fillSuperview()
        statusBarHeadlineLabel.text = headline
        statusBarHeadlineLabel.textAlignment = .center
        statusBarHeadlineLabel.textColor = .white
        statusBarHeadlineLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    func setupText() {
        addSubview(textView)
        textView.anchor(top: statusBar.bottomAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.layoutMarginsGuide.trailingAnchor)
        textView.isEditable = false
        textView.textColor = .black
        textView.text = text
    }
}
