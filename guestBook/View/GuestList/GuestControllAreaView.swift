//
//  GuestSortAreaView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/01/31.
//

import UIKit

protocol SendRetualDelegate: AnyObject {
    func selectGuestsByRetual(retual: Retual)
}

class GuestControllAreaView: UIView {
    
    fileprivate let guestSortTypePickerView = UIPickerView()
    var guests: [Guest]
    var event: Event
    fileprivate var retuals: [Retual]
    var retualList: [Retual] = []
    weak var sendRetualDelegate: SendRetualDelegate?
    var csvOutputButton = UIButton()
    
    // MARK:-
    init(_ guests: [Guest], _ event: Event, _ retuals: [Retual], frame: CGRect) {
        self.guests = guests
        self.event = event
        self.retuals = retuals
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        setupGuestSortPickerView()
        setupCsvOutputButton()
    }
    
    func setupGuestSortPickerView() {
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
    
    func resetGuestSortPickerview() {
        guestSortTypePickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    fileprivate func setupCsvOutputButton() {
        addSubview(csvOutputButton)
        csvOutputButton.setTitle("CSVファイル作成", for: .normal)
        csvOutputButton.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: self.trailingAnchor, size: .init(width: 150, height: 40))
        csvOutputButton.addTarget(self, action: #selector(tapCsvOutputButton), for: .touchUpInside)
        csvOutputButton.backgroundColor = green
        csvOutputButton.layer.cornerRadius = 5
    }
    
    @objc func tapCsvOutputButton() {
        animateView(csvOutputButton)
        csvOutput()
    }
    
    func csvOutput() {
        guard let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let path = dirURL.appendingPathComponent("\(event.eventName).csv")
        let csvList = CsvList()
        let data: Data? = csvList.outputGuestList(guests, retuals)
        guard let textFile = data else { return }
        do {
            try textFile.write(to: path)
            aLartCsvOutput(title: "CSVファイル出力", message: "ファイルアプリにCSVファイルを作成しました。")
        } catch {
            print("CSVファイル出力失敗")
        }
    }
    
    func animateView(_ viewToAnimate:UIView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                viewToAnimate.transform = .identity
            }, completion: nil)
        }
    }
    
    fileprivate func aLartCsvOutput(title: String, message: String) {
        var alertController: UIAlertController!
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        parentViewController()?.present(alertController, animated: true, completion: nil)
        print("CSVファイル出力成功")
    }
    
    // 検索結果や並べ替えの後の情報を反映
    func updateGuestsData(_ guests: [Guest]) {
        self.guests = guests
    }
}

// MARK:- Extensions
extension GuestControllAreaView:UIPickerViewDelegate {
    
}

extension GuestControllAreaView:UIPickerViewDataSource {
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
        sendRetualDelegate?.selectGuestsByRetual(retual: retualList[row])
        
    }
}
