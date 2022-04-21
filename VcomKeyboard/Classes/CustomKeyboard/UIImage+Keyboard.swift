//
//  UIImage+Keyboard.swift
//  UXin
//
//  Created by wbx on 2020/5/15.
//  Copyright © 2020 Vcom. All rights reserved.
//

import Foundation

extension UIImage {

    /// 颜色转图片
    /// - Parameter color: 颜色
    /// - Returns: 图片UIImage
    class func image(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
}
