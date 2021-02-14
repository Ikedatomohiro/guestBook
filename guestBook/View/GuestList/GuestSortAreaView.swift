//
//  GuestSortAreaView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

protocol SendRetualDelegate: AnyObject {
    func sendRetual(retual: Retual)
}

class GuestSortAreaView: UIView {
    
    fileprivate let guestSortTypePickerView = UIPickerView()
    fileprivate var retuals: [Retual]
    var retualList: [Retual] = []
    weak var sendRetualDelegate: SendRetualDelegate?

    
    // MARK:-
    init(_ retuals: [Retual], frame: CGRect) {
        self.retuals = retuals
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        let retual = Retual.init(name: "---")
        retualList.append(retual)
        retualList.append(contentsOf: retuals)

        guestSortTypePickerView.delegate = self
        guestSortTypePickerView.dataSource = self
        
        // はじめに表示する項目を指定
        guestSortTypePickerView.selectRow(0, inComponent: 0, animated: true)
         
        // 画面にピッカーを追加
        addSubview(guestSortTypePickerView)
        guestSortTypePickerView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: nil, size: .init(width: 120, height: .zero))
    }
    
}

// MARK:- Extensions
extension GuestSortAreaView:UIPickerViewDelegate {
    
}

extension GuestSortAreaView:UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return retualList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return retualList[row].retualName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(retualList[row])
        sendRetualDelegate?.sendRetual(retual: retualList[row])

    }
}
