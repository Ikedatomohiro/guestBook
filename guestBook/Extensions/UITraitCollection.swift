//
//  UITraitCollection.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/05/13.
//

import UIKit

extension UITraitCollection {
    public static var isDarkMode: Bool {
        if #available(iOS 13, *), current.userInterfaceStyle == .dark {
            return true
        }
        return false
    }
}
