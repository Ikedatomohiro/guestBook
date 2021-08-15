//
//  EventSettingTableViewCell.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/08/12.
//

import UIKit

class EventSettingTableViewCell: UITableViewCell {
    fileprivate var headlineLabel = UILabel()
    fileprivate var settingInfoTextField = UITextField()
    fileprivate var settingInfoTextView = UITextView()
    weak var eventSettingDelegate: EventSettingDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupEventSettingTableViewCell(event: Event, item: EventSettingTableView.EventSettingItem, indexPath: Int) {
        setupTextField(event: event, item: item, indexPath: indexPath)
    }

    fileprivate func setupTextField(event: Event, item: EventSettingTableView.EventSettingItem, indexPath: Int) {
        setupBase(indexPath: indexPath)
        addSubview(headlineLabel)
        headlineLabel.anchor(top: self.layoutMarginsGuide.topAnchor, leading: self.layoutMarginsGuide.leadingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: screenSize.width / 6, height: .zero))
        headlineLabel.text = item.rawValue
        // 項目によって利用するテキストエリアを切り替える
        if item.self == .description {
            setTextView(event: event, item: item, indexPath: indexPath)
        } else {
            setTextField(event: event, item: item)
        }
    }
    
    fileprivate func setupBase(indexPath: Int) {
        self.backgroundColor = setColor(indexPath: indexPath)
    }
 
    fileprivate func setTextField(event: Event ,item: EventSettingTableView.EventSettingItem) {
        contentView.addSubview(settingInfoTextField)
        settingInfoTextField.anchor(top: self.layoutMarginsGuide.topAnchor, leading: headlineLabel.layoutMarginsGuide.trailingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.layoutMarginsGuide.trailingAnchor)
        settingInfoTextField.accessibilityIdentifier = "\(item.self)"
        settingInfoTextField.placeholder = "\(item.rawValue)"
        settingInfoTextField.text = setText(event: event, item: item)
        settingInfoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    
    fileprivate func setTextView(event: Event ,item: EventSettingTableView.EventSettingItem, indexPath: Int) {
        contentView.addSubview(settingInfoTextView)
        settingInfoTextView.backgroundColor = setColor(indexPath: indexPath)
        settingInfoTextView.font = .systemFont(ofSize: 18)
        settingInfoTextView.anchor(top: self.layoutMarginsGuide.topAnchor, leading: headlineLabel.layoutMarginsGuide.trailingAnchor, bottom: self.layoutMarginsGuide.bottomAnchor, trailing: self.layoutMarginsGuide.trailingAnchor)
        settingInfoTextView.accessibilityIdentifier = "\(item.self)"
        settingInfoTextView.text = setText(event: event, item: item)
        settingInfoTextView.delegate = self
        
    }
    
    fileprivate func setColor(indexPath: Int) -> UIColor {
        var color: UIColor
        if indexPath % 2 == 0 {
            color = .white
        } else {
            color = .tableViewCellColor
        }
        return color
    }
    
    fileprivate func setText(event: Event, item: EventSettingTableView.EventSettingItem) -> String {
        var text = ""
        if item.self == EventSettingTableView.EventSettingItem.eventName {
            text = event.eventName
        } else if item.self == EventSettingTableView.EventSettingItem.deceasedName {
            text = event.deceasedName
        } else if item.self == EventSettingTableView.EventSettingItem.chiefMourner {
            text = event.chiefMourner
        } else if item.self == EventSettingTableView.EventSettingItem.eventDate {
            text = event.eventDate
        } else if item.self == EventSettingTableView.EventSettingItem.eventPlace {
            text = event.eventPlace
        } else if item.self == EventSettingTableView.EventSettingItem.description {
            text = event.description
        }
        return text
    }
    
    @objc fileprivate func textFieldDidChange() {
        eventSettingDelegate?.sendTextToTable(inputView: settingInfoTextField)
    }
}
// MARK:- Extensions
extension EventSettingTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        eventSettingDelegate?.sendTextToTable(inputView: settingInfoTextView)
    }
}
