//
//  Constants.swift
//  guestBook
//
//  Created by 池田友宏 on 2021/01/27.
//

import UIKit

//MARK:- スクリーンサイズ
let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

struct GuestCardView {
    static let guestNameWidth = screenSize.width / 2
    static let guestNameHeight = screenSize.height / 5
    static let companyNameWidth = screenSize.width / 2
    static let companyNameHeight = screenSize.height / 5
    static let addressWidth = screenSize.width
    static let addressHeight = screenSize.height / 5
    static let zipCodeWidth = screenSize.width * 2 / 5
    static let zipCodeHeight = 60
    static let telNumberWidth = screenSize.width * 2 / 5
    static let telNumberHeight = 60
}

struct GuestListView {
    static let numberWidth: Int = 50
    static let guestNameWidth: CGFloat = screenSize.width / 8
    static let companyNameWidth: CGFloat = screenSize.width / 5
    static let addressWidth: CGFloat = screenSize.width / 5
    static let retualWidth: CGFloat = screenSize.width / 5
}



// MARK:- 初期データ
struct DefaultParam {
    static let retuals: [String] = ["通夜", "告別式"]
    static let relations: [String] = ["故人様", "喪主様", "ご家族", "その他"]
    static let groups: [String] = ["会社関係", "お取引先", "学校関係", "官公庁", "各種団体", "町内会", "ご友人", "ご親戚", "その他"]
}
