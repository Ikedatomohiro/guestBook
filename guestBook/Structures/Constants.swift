//
//  Constants.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/27.
//

import UIKit

struct Constants {
    static let defaultRetuals: [String] = ["通夜", "告別式"]
    
}

//スクリーンサイズの取得
let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

let guestNameWidth = screenSize.width / 2
let guestNameHeight = screenSize.height / 5
let companyNameWidth = screenSize.width / 2
let companyNameHeight = screenSize.height / 5
