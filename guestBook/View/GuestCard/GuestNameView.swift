//
//  guestNameView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/06.
//

import UIKit
import PencilKit
import SwiftyJSON

class GuestNameView: UIView {
    fileprivate let guestNameTitleLabel = UILabel()
    let guestNameTextField              = UITextField()
    let guestNameCanvas                 = PKCanvasView()
    fileprivate let honorificTitle      = UILabel()
    var guestNameImageData              = Data()
    weak var guestItemupdateDelegate: GuestItemUpdateDelegate?

    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupLabel()
        setupTextField(guestName: guest.guestName)
        setupCanvas(ImageData: guest.guestNameImageData)
        
    }
    fileprivate func setupLabel() {
        addSubview(guestNameTitleLabel)
        guestNameTitleLabel.text = "御芳名"
        guestNameTitleLabel.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 5, left: 5, bottom: 0, right: 5))
        guestNameTitleLabel.font = .systemFont(ofSize: 24)
        // 敬称
        addSubview(honorificTitle)
        honorificTitle.text = "様"
        honorificTitle.anchor(top: nil, leading: nil, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        honorificTitle.font = .systemFont(ofSize: 40)
    }
    fileprivate func setupTextField(guestName: String) {
        addSubview(guestNameTextField)
        guestNameTextField.anchor(top: nil, leading: guestNameTitleLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 40))
        guestNameTextField.layer.borderWidth = 1.0
        guestNameTextField.text = guestName
        guestNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
    }
    fileprivate func setupCanvas(ImageData: Data) {
        addSubview(guestNameCanvas)
        guestNameCanvas.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor , bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        guestNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        guestNameCanvas.isOpaque = false
        guestNameCanvas.delegate = self
        guestNameCanvas.layer.borderWidth = 1.0
        do {
            self.guestNameCanvas.drawing = try PKDrawing(data: ImageData)
        }
        catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        guestNameCanvas.setupPencil(canvas: guestNameCanvas)
    }

    @objc func textFieldDidChange() {
        guestItemupdateDelegate?.update(inputView: self)
    }
    
}

extension GuestNameView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guestItemupdateDelegate?.update(inputView: self)
    }

}