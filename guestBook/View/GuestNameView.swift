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
    fileprivate let guestNameTitleLabel = UILabel()
    let guestNameTextField              = UITextField()
    fileprivate let guestNameCanvas     = PKCanvasView()
    fileprivate let honorificTitle      = UILabel()
    var guestNameImageData         = Data()
    
    
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
    }
    fileprivate func setupCanvas(ImageData: Data) {
        addSubview(guestNameCanvas)
//        guestNameCanvas.fillSuperview()
        guestNameCanvas.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor , bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor, padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        guestNameCanvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        guestNameCanvas.isOpaque = false
        guestNameCanvas.layer.borderWidth = 1.0
        //        guestNameCanvas.drawing = PKDrawing(data: guestNameImageData) のような感じでデータをセット
        guestNameCanvas.setupPencil(canvas: guestNameCanvas)
        guestNameImageData = guestNameCanvas.drawing.dataRepresentation()
//        guestNameCanvas.drawing = try PKDrawing(data: guestNameImageData)
        // 仮で保存 これでなにかは保存できているみたい。
//        Guest.collectionRef(eventId: "Ek8tGxTMN0afqzCjXpWE").document("YBbcTpprfqklHR6fRMCA").updateData(["guestNameImageData": guestNameImageData])
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guestNameImageData = guestNameCanvas.drawing.dataRepresentation()

        
        
        // 仮で保存 これでなにかは保存できているみたい。
        Guest.collectionRef(eventId: "Ek8tGxTMN0afqzCjXpWE").document("YBbcTpprfqklHR6fRMCA").updateData(["guestNameImageData": guestNameImageData])
//        let guestNameImage = guestNameCanvas.drawing.image(from: <#T##CGRect#>, scale: <#T##CGFloat#>)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("moved")
    }
}




