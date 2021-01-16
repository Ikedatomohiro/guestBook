//
//  Canvas.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/16.
//

import UIKit
import PencilKit

extension PKCanvasView {
    
    func setupPencil(canvas: PKCanvasView) {
        if let windw = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: windw) {
                toolPicker.addObserver(canvas)
                toolPicker.setVisible(true, forFirstResponder: canvas)
                canvas.becomeFirstResponder()
            }
        }
    }
    
    
    
    
    
}
