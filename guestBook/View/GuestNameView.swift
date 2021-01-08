//
//  guestNameView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/06.
//

import UIKit
import PencilKit

class GuestNameView: UIView {
    fileprivate let guestNameTitleLabel     = UILabel()
    fileprivate let guestNameTextField      = UITextField()
    fileprivate let guestNameCanvas         = PKCanvasView()
    fileprivate let guestName: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guestName: String) {
//        view.addSubview(guestNameTitleLabel)
//        guestNameTitleLabel.anchor(top: guestNameStackVirew.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 20))
        
//        addSubview(guestNameCanvas)
        guestNameCanvas.fillSuperview()
        guestNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        guestNameCanvas.isOpaque = false

        if let windw = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: windw) {
                toolPicker.addObserver(guestNameCanvas)
                toolPicker.setVisible(true, forFirstResponder: guestNameCanvas)
                guestNameCanvas.becomeFirstResponder()
            }
        }
        
        addSubview(guestNameTitleLabel)
        guestNameTitleLabel.text = "御芳名"
        guestNameTitleLabel.anchor(top: self.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 100, height: 100))
//        guestNameStackVirew.addArrangedSubview(guestNameTitleLabel)

        addSubview(guestNameTextField)
        guestNameTextField.anchor(top: guestNameTitleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        guestNameTextField.layer.borderWidth = 1.0
        guestNameTextField.layer.borderColor = .init(gray: 000000, alpha: 1)
        guestNameTextField.text = guestName
//        print(guest.guestName)
//        guestNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
//        guestNameStackVirew.addArrangedSubview(guestNameTextField)

    }

}



