//
//  SettingViewController.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/29.
//

import UIKit
import PencilKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Three Lines of Code ここに3行のコードを足す
        let canvas = PKCanvasView(frame: view.frame)
        view.addSubview(canvas)
        canvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        canvas.delegate = self
        // PKToolPicker: ドラッグして移動できるツールパレット (ペンや色などを選択できるツール)
        if let window = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.addObserver(canvas)
                toolPicker.setVisible(true, forFirstResponder: canvas)
                canvas.becomeFirstResponder()
            }
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("動いています。")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("おわり")
    }
    
    
}
    
extension SettingViewController: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("おわりました。")
        print(canvasView.drawing.dataRepresentation())
    }
}
