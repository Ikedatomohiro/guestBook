//
//  UIColor.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/12.
//

import UIKit

extension UIColor {
    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }
    
    static var tableViewCellColor = UIColor{_ in dynamicColor(light: lightGreent, dark: .gray)}
    static var tableViewHeaderColor = UIColor{_ in dynamicColor(light: UIColor.green, dark: UIColor.gray)}
    static var buttonColor = UIColor{_ in dynamicColor(light: green, dark: .blue)}
    static var textColor = UIColor{_ in dynamicColor(light: .black, dark: .white)}
    static var placeHolderTextColor = UIColor{_ in dynamicColor(light: .gray, dark: .white)}
}

let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
        return .black
    } else {
        return .white
    }
}

let lightGreent = UIColor.rgb(red: 209, green: 238, blue: 123)
let green = UIColor.rgb(red: 150, green: 200, blue: 20)
let gray = UIColor.rgb(red: 211, green: 211, blue: 211)
