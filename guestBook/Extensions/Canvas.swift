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
    
    func setDrawingData(_ canvas: PKCanvasView,_ ImageData: Data) {
        if ImageData != Data() {
            do {
                canvas.drawing = try PKDrawing(data: ImageData)
            }
            catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
