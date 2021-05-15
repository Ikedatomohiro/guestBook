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
let tableViewCellColor = UIColor.dynamicColor(light: lightGreent, dark: UIColor.gray)
let tableViewHeaderColor = UIColor.dynamicColor(light: UIColor.green, dark: UIColor.gray)
let buttonColor = UIColor.dynamicColor(light: green, dark: .blue)
let textColor = UIColor.dynamicColor(light: .black, dark: .white)
