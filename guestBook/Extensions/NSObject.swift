//
//  NSObject.swift
//  guestBook
//
//  Created by 池田友宏 on 2020/11/02.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
