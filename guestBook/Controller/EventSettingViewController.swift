//
//  EventSettingViewController.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/07/18.
//

import UIKit

class EventSettingViewController: UIViewController {
    
    fileprivate let deceasedAreaView          = DeceasedNameView()
    fileprivate let inputAreaView             = UIView()

    fileprivate let placeHeadlineLabel        = UILabel()
    fileprivate var placeTextfield            = UITextField()
    fileprivate let eventDateHeadlineLabel    = UILabel()
    fileprivate var eventDateTextfield        = UITextField()
    fileprivate let detailHeadlineLabel       = UITextField()
    fileprivate var detailTextarea            = UITextView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        setup()


    }
    
    fileprivate func setup() {
        setupHeadlineArea()
//        setupInputAres()
    }
    
    fileprivate func setupHeadlineArea() {
        
        
        
        
//        view.addSubview(deceasedNameHeadlineLabel)
//        deceasedNameHeadlineLabel.
    }
    
}
