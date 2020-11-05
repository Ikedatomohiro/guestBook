//
//  GuestCardViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/04.
//

import UIKit
import PencilKit

class GuestCardViewController: UIViewController {
    
    fileprivate let event: Event
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate let cardTitleLabel = UILabel()
    fileprivate let selectRitualLabel = UILabel()
    fileprivate let retualArray:[String] = ["通夜", "告別式"]
    fileprivate let guestNameLabel = UILabel()
    fileprivate let companyNameLabel = UILabel()
    fileprivate let zipCodeLabel = UILabel()
    fileprivate let telLabel = UILabel()
    fileprivate let addressLabel = UILabel()
    fileprivate let selectAcuaintanceQuestionLabel = UILabel()
    fileprivate let selectAcuaintanceLabel = UILabel()
    fileprivate let selectRelationQuestionLabel = UILabel()
    fileprivate let selectRelationLabel = UILabel()

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .purple
        setCanvas()
        

    }
    
    fileprivate func setupLabels() {
        view.addSubview(cardTitleLabel)
        cardTitleLabel.text = "ご芳名カード"
        
        
        view.addSubview(selectRitualLabel)
        
        
        
        view.addSubview(guestNameLabel)
        
        
        
        view.addSubview(companyNameLabel)
        
        
        
        view.addSubview(zipCodeLabel)
        
        
        
        view.addSubview(telLabel)
        
        
        
        view.addSubview(addressLabel)
        view.addSubview(selectAcuaintanceQuestionLabel)
        view.addSubview(selectAcuaintanceLabel)
        view.addSubview(selectRelationQuestionLabel)
        view.addSubview(selectRelationLabel)
        
        
        
        
    }
    
    fileprivate func setCanvas() {
        let canvas = PKCanvasView(frame: view.frame)
        view.addSubview(canvas)
        canvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        
        // PKToolPicker: ドラッグして移動できるツールパレット (ペンや色などを選択できるツール)
        if let window = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.addObserver(canvas)
                toolPicker.setVisible(true, forFirstResponder: canvas)
                canvas.becomeFirstResponder()
            }
        }
    }
}
