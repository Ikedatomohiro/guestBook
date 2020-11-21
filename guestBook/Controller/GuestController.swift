//
//  GuestController.swift
//  guestBook
//
//  Created by 杉崎圭 on 2020/11/11.
//

import UIKit
import PencilKit

class GuestController: UIViewController {
    
    var guest: Guest
    
    fileprivate let cardTitleLabel = UILabel()
    fileprivate let selectRitualLabel = UILabel()
    fileprivate let guestNameLabel = UILabel()
    fileprivate let companyNameLabel = UILabel()
    fileprivate let zipCodeLabel = UILabel()
    fileprivate let telLabel = UILabel()
    fileprivate let addressLabel = UILabel()
    fileprivate let selectAcuaintanceQuestionLabel = UILabel()
    fileprivate let selectAcuaintanceLabel = UILabel()
    fileprivate let selectRelationQuestionLabel = UILabel()
    fileprivate let selectRelationLabel = UILabel()
    
    init(guest: Guest) {
        self.guest = guest
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder){fatalError()}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupCanvas()
    }
    
    fileprivate func setupLabels() {
        view.addSubview(cardTitleLabel)
        cardTitleLabel.text = "ご芳名カード"
        
        
        view.addSubview(selectRitualLabel)
        
        
        
        view.addSubview(guestNameLabel)
        guestNameLabel.fillSuperview()
        guestNameLabel.text = guest.guestName
        guestNameLabel.textColor = .black
        guestNameLabel.font = .systemFont(ofSize: 50, weight: .bold)
        guestNameLabel.textAlignment = .center
        
        
        
        view.addSubview(companyNameLabel)
        
        
        
        view.addSubview(zipCodeLabel)
        
        
        
        view.addSubview(telLabel)
        
        
        
        view.addSubview(addressLabel)
        view.addSubview(selectAcuaintanceQuestionLabel)
        view.addSubview(selectAcuaintanceLabel)
        view.addSubview(selectRelationQuestionLabel)
        view.addSubview(selectRelationLabel)
    }
    
    fileprivate func setupCanvas() {
        let canvas = PKCanvasView(frame: view.frame)
        self.view.addSubview(canvas)
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
