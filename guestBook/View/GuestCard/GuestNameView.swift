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
    
    fileprivate func setupCanvas(ImageData: Data) {
        addSubview(guestNameCanvas)
        guestNameCanvas.anchor(top: topAnchor, leading: leadingAnchor , bottom: bottomAnchor, trailing: trailingAnchor)
        guestNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        guestNameCanvas.isOpaque = false
        guestNameCanvas.delegate = self
        guestNameCanvas.setDrawingData(guestNameCanvas, ImageData)
        guestNameCanvas.setupPencil(canvas: guestNameCanvas)
    }
}

// MARK:- Extensions
extension GuestNameView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guestItemupdateDelegate?.update(inputView: self)
    }
    
}
