//
//  UIImage.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/04/29.
//

import UIKit

extension UIImage {
    // resize image
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }

    // scale the image at rates
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    public class func dynamicImage(light: UIImage, dark: UIImage) -> UIImage {
        if UITraitCollection.isDarkMode {
            return dark
        }
        return light
    }
}

let settingImageIcon = UIImage.dynamicImage(light: #imageLiteral(resourceName: "menu_light.png"), dark: UIImage(named: "menu_dark")!)
