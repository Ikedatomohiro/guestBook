//
//  EventSettingViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/07/18.
//

import UIKit

protocol EventSettingDelegate: AnyObject {
    func sendTextToTable<T>(inputView: T)
    func sendTextToController<T>(inputView: T)
}
extension EventSettingDelegate {
    func sendTextToTable<T>(inputView: T) {}
    func sendTextToController<T>(inputView: T) {}
}

class EventSettingViewController: UIViewController {
    var event: Event
    lazy var eventSettingTableView = EventSettingTableView(event: event, frame: .zero, style: .plain)
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchEvent(eventId: event.eventId) { (event) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Eventを前のコントローラーに返す
    }
    
    fileprivate func fetchEvent(eventId: String, completion: @escaping(String) -> Void) {
        let documentRef = Event.getEvent(eventId)
        documentRef.getDocument { (DocumentSnapshot, error) in
            if error == nil {
                guard let document = DocumentSnapshot else { return }
                self.event = Event(documentSnapshot: document)
                self.setupTable()
            }
        }
    }
    
    fileprivate func setupTable() {
        view.addSubview(eventSettingTableView)
        eventSettingTableView.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.layoutMarginsGuide.leadingAnchor, bottom: self.view.layoutMarginsGuide.bottomAnchor, trailing: self.view.layoutMarginsGuide.trailingAnchor)
        eventSettingTableView.register(EventSettingTableViewCell.self, forCellReuseIdentifier: EventSettingTableViewCell.className)
        eventSettingTableView.eventSettingDelegate = self
    }
}

// MARK:- Extensions
extension EventSettingViewController: EventSettingDelegate {
    func sendTextToController<T>(inputView: T) {
        if type(of: inputView) == UITextField.self {
            guard let textField = inputView as? UITextField else { return }
            let identifire = textField.accessibilityIdentifier
            print("OK")
            if identifire == "eventName" {
                event.eventName = textField.text ?? event.eventName
            } else if identifire == "deceasedName" {
                event.deceasedName = textField.text ?? event.deceasedName
            } else if identifire == "chiefMourner" {
                event.chiefMourner = textField.text ?? event.chiefMourner
            } else if identifire == "eventDate" {
                event.eventDate = textField.text ?? event.eventDate
            } else if identifire == "eventPlace" {
                event.eventPlace = textField.text ?? event.eventPlace
            }
        } else if type(of: inputView) == UITextView.self {
            guard let textView = inputView as? UITextView else { return }
            let identifire = textView.accessibilityIdentifier
            if identifire == "description" {
                event.description = textView.text ?? event.description
            }
        } else {
            return;
        }
        Event.updateEvent(event)
    }
}
