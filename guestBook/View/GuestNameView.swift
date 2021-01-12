//
//  guestNameView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/06.
//

import UIKit
import PencilKit

//protocol GuestNameImageUpdateDelegate: class {
//    func updateGuestNameImage(guestNameImage: ) -> String
//}

class GuestNameView: UIView {
    fileprivate let guestNameTitleLabel     = UILabel()
    let guestNameTextField      = UITextField()
    fileprivate let guestNameCanvas         = PKCanvasView()
    fileprivate let guestName: String = ""
    var guestNameImage: UIImage = UIImage()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupLabel()
        setupTextField(guestName: guest.guestName)
        setupCanvas()
    }
    fileprivate func setupLabel() {
        addSubview(guestNameTitleLabel)
        guestNameTitleLabel.text = "御芳名"
        guestNameTitleLabel.anchor(top: self.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 100, height: 100))
    }
    fileprivate func setupTextField(guestName: String) {
        addSubview(guestNameTextField)
        guestNameTextField.anchor(top: nil, leading: guestNameTitleLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        guestNameTextField.layer.borderWidth = 1.0
        guestNameTextField.text = guestName
    }
    fileprivate func setupCanvas() {
        addSubview(guestNameCanvas)
//        guestNameCanvas.fillSuperview()
        guestNameCanvas.anchor(top: guestNameTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 500, height: 200))
        guestNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        
        
        guestNameCanvas.isOpaque = false
        
        
        if let windw = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: windw) {
                toolPicker.addObserver(guestNameCanvas)
                toolPicker.setVisible(true, forFirstResponder: guestNameCanvas)
                guestNameCanvas.becomeFirstResponder()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guestNameImage = guestNameCanvas.drawing.image(from: CGRect(x: 0, y: 0, width: 500, height: 200), scale: 1.0)
        
    }
    
}




