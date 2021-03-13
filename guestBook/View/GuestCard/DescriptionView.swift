//
//  DescriptionView.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/16.
//

import UIKit
import PencilKit

class DescriptionView: UIView {
    
    fileprivate let descriptionText   = UILabel()
    fileprivate let descriptionTextField = UITextField()
    fileprivate let descriptionWriteArea = UIView()
    fileprivate let descriptionWriteAreaTitle = UILabel()
    let descriptionCanvas = PKCanvasView()
    weak var guestItemupdateDelegate: GuestItemUpdateDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(guest: Guest) {
        setupDescriptionLabel()
        setupDescriptionWriteArea(guest)
        setupCanvas(ImageData: guest.descriptionImageData)
    }
    
    fileprivate func setupDescriptionLabel() {
        addSubview(descriptionText)
        descriptionText.text = "名刺をお持ちの方は受付にお渡しください。\n該当する□へチェックをお願い致します。"
        descriptionText.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil)
        descriptionText.font = .systemFont(ofSize: 24)
        descriptionText.numberOfLines = 0
    }
    
    fileprivate func setupDescriptionWriteArea(_ guest: Guest) {
        addSubview(descriptionWriteArea)
        descriptionWriteArea.anchor(top: layoutMarginsGuide.topAnchor, leading: descriptionText.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: trailingAnchor)
        descriptionWriteArea.layer.borderWidth = 1.0
        addSubview(descriptionWriteAreaTitle)
        descriptionWriteAreaTitle.anchor(top: descriptionWriteArea.topAnchor, leading: descriptionWriteArea.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 0, right: 0))
        descriptionWriteAreaTitle.text = "備考"
        descriptionWriteAreaTitle.font = .systemFont(ofSize: 20)
    }
    
    fileprivate func setupCanvas(ImageData: Data) {
        addSubview(descriptionCanvas)
        descriptionCanvas.anchor(top: descriptionWriteArea.topAnchor, leading: descriptionWriteArea.leadingAnchor , bottom: descriptionWriteArea.bottomAnchor, trailing: descriptionWriteArea.trailingAnchor)
        descriptionCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        descriptionCanvas.isOpaque = false
        descriptionCanvas.delegate = self
        descriptionCanvas.setDrawingData(descriptionCanvas, ImageData)
    }
    
    // ペンシルはページ表示後にセットする
    func setupPencil() {
        descriptionCanvas.setupPencil(canvas: descriptionCanvas)
    }
}

//MARK:- Extensions
extension DescriptionView: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        guestItemupdateDelegate?.update(inputView: self)
    }
}

