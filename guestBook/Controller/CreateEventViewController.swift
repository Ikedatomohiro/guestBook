//
//  CreateEventViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/07/11.
//

import UIKit

protocol CreateEventDelegate: AnyObject {
    func hidePopup()
    func sendEventName(eventName: String)
    func createEvent(eventName: String)
}
// デフォルト動作設定
extension CreateEventDelegate {
    func sendEventName(eventName: String) {}
    func createEvent(eventName: String) {}
}


class CreateEventViewController: UIViewController {
    
    fileprivate let createEventHeadlineLabel = UILabel()
    fileprivate let eventNameTextField = UITextField()
    fileprivate let errorMessageLabel  = UILabel()
    fileprivate let createBUtton = UIButton()
    fileprivate let cancelButton = UIButton()
    
    weak var createEventDelegate: CreateEventDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .white
        
    }
    
    fileprivate func setup() {
        setupCreateEventHeadlineLabel()
        setupEventNameTextFeild()
        setupCancelButton()
        setupCreateButton()
    }
    
    fileprivate func setupCreateEventHeadlineLabel() {
        view.addSubview(createEventHeadlineLabel)
        createEventHeadlineLabel.text = "儀式名を入力してください"
        createEventHeadlineLabel.font = .systemFont(ofSize: 28)
        createEventHeadlineLabel.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 30, left: .zero, bottom: .zero, right: .zero))
        createEventHeadlineLabel.textAlignment = .center
    }
    
    fileprivate func setupEventNameTextFeild() {
        view.addSubview(eventNameTextField)
        eventNameTextField.anchor(top: createEventHeadlineLabel.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: .zero, right: 20),size: .init(width: .zero, height: 50))
        eventNameTextField.layer.borderColor = UIColor.black.cgColor
        eventNameTextField.layer.borderWidth = 1.0
        eventNameTextField.layer.cornerRadius = 5
    }
    
    fileprivate func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.anchor(top: eventNameTextField.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 100, bottom: .zero, right: .zero), size: .init(width: 100, height: .zero))
        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.backgroundColor = .systemPink
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        
    }
    
    fileprivate func setupCreateButton() {
        view.addSubview(createBUtton)
        createBUtton.anchor(top: eventNameTextField.bottomAnchor, leading: nil, bottom: nil, trailing: view.layoutMarginsGuide.trailingAnchor, padding: .init(top: 20, left: .zero, bottom: .zero, right: 100), size: .init(width: 100, height: .zero))
        createBUtton.setTitle("作成する", for: .normal)
        createBUtton.backgroundColor = green
        createBUtton.layer.cornerRadius = 5
        createBUtton.addTarget(self, action: #selector(createButtonDidTap), for: .touchUpInside)
    }
    
    @objc fileprivate func cancelButtonDidTap() {
        createEventDelegate?.hidePopup()
    }
    
    @objc fileprivate func createButtonDidTap() {
        createEventDelegate?.hidePopup()
        if let eventName = eventNameTextField.text {
            createEventDelegate?.sendEventName(eventName: eventName)
            eventNameTextField.text = ""
        }
    }
}
