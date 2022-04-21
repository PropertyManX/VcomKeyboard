//
//  UIColor+Keyboard.swift
//  UXin
//
//  Created by wbx on 2020/5/15.
//  Copyright © 2020 Vcom. All rights reserved.
//

import Foundation

extension UIColor {

    /// RGB
    /// - Parameters:
    ///   - r: 红色色值
    ///   - g: 绿色色值
    ///   - b: 蓝色色值
    ///   - a: 透明度
    /// - Returns: 颜色
    class func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    /// 16进制颜色转换
    /// - Parameter hex: 十六进制颜色 #FFFFFF / FFFFFF / EEEEEE2B / #EEEEEE2B
    /// - Returns: 颜色
    class func color(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString = String(cString[cString.index(after: cString.startIndex)...])
        }
        if cString.count != 6 {
            return UIColor.clear
        }

        let rString = String(cString[..<cString.index(cString.startIndex, offsetBy: 2)])
        let gString = String(cString[cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)])
        let bString = String(cString[cString.index(cString.endIndex, offsetBy: -2)...])
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
}
