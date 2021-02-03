//
//  GuestSortAreaView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

class GuestSortAreaView: UIView {
    
    fileprivate let guestSortTypePickerView = UIPickerView()
    fileprivate let retuals: [Retual]

    // MARK:-
    init(retuals: [Retual],frame: CGRect) {
        self.retuals = retuals
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setup() {
        
        

        
        guestSortTypePickerView.delegate = self
        guestSortTypePickerView.dataSource = self
        
        // はじめに表示する項目を指定
        guestSortTypePickerView.selectRow(1, inComponent: 0, animated: true)
         
        // 画面にピッカーを追加
        addSubview(guestSortTypePickerView)
        guestSortTypePickerView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: 500, height: .zero))
    }
    
}

extension GuestSortAreaView:UIPickerViewDelegate {
    
}

extension GuestSortAreaView:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return retuals.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return retuals[row].retualName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(retuals[row])
    }
}
