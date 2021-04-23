//
//  UIView.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/04/23.
//

import UIKit

extension UIView {
    // 親のViewControllerを取得
    func parentViewController() -> UIViewController? {
        var parent: UIResponder? = self
        while let next = parent?.next {
            if let viewController = next as? UIViewController {
                return viewController
            }
            parent = next
        }
        return nil
    }
}
