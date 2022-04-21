//
//  KeyboardDefine.swift
//  UXin
//
//  Created by wbx on 2020/5/15.
//  Copyright © 2020 Vcom. All rights reserved.
//

import Foundation

/// 键盘相关参数定义
struct Keyboard {
    /// 屏幕宽度
    static let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    /// 键盘安全描述文本高度
    static let kCustomKeyboardSafeDescrHeight: CGFloat = 40
    /// 键盘高度
    static let kCustomKeyboardHeight: CGFloat = 220
    /// 数字键盘高度
    static let kNumberKeyboardBtnHeight: CGFloat = (kCustomKeyboardHeight / 4)
    /// 字母键盘按钮水平间距
    static let kASCIIKeyboardBtnHorizontalSpace: CGFloat = 5
    /// 字母键盘按钮垂直间距
    static let kASCIIKeyboardBtnVerticalSpace: CGFloat = 10
    /// 字母键盘高度
    static let kASCIIKeyboardBtnHeight: CGFloat = ((kCustomKeyboardHeight - kASCIIKeyboardBtnVerticalSpace * 4 ) / 4)
    /// 字母键盘按钮圆角
    static let kASCIIKeyboardBtnCornerRadius: CGFloat = 5
    /// 数字键盘边框宽度
    static let kASCIIKeyboardBtnBorderWidth: CGFloat = 0.5
    /// 键盘背景色
    static let kKeyboardViewBackgroundColor = UIColor.color(hex: "f1f1f1")
    /// 数字键盘边框颜色
    static let kKeyboardBtnLayerColor = UIColor.color(hex: "dadada")
    /// 键盘按钮高亮状态颜色
    static let kKeyboardBtnHighlightedColor = UIColor.color(hex: "d2d2d2")
    /// 有背景的按钮颜色
    static let kKeyboardBtnDefaultColor = UIColor.color(hex: "e5e5e5")
    /// 白色背景按钮颜色
    static let kKeyboardBtnWhiteColor = UIColor.white
    /// 深色字体
    static let kKeyboardBtnDarkTitleColor = UIColor.color(hex: "000000")
    /// 浅色字体
    static let kKeyboardBtnLightTitleColor = UIColor.color(hex: "3d3d3d")
    /// 大字体
    static let kKeyboardBtnBigFont = UIFont.systemFont(ofSize: 24)
    /// 小字体
    static let kKeyboardBtnSmallFont = UIFont.systemFont(ofSize: 18)
}

/// 自定义键盘类型
enum CustomKeyboardType: Int {
    case ASCII          // 字母-ASCII键盘，类似系统键盘
    case Secury         // 密码键盘，数字不随机
    case Number         // 数字键盘，数字随机
    case Symbol         // 符号键盘，包含特殊符号
    case StockInput     // 搜索股票的键盘——有“600”按钮的快捷数字键盘
    case StockPosition  // 股票买卖数量键盘，带有仓位选择
}

/// 按钮类型
enum KeyboardButtonType: Int {
    case None = 10000           // 空白
    case Number                 // 数字
    case Letter                 // 字母
    case Symbol                 // 符号
    case Delete                 // 删除按钮
    case Resign                 // 数字键盘收起
    case Decimal                // 数字键盘小数点
    case Underline              // 字母键盘下划线
    case ABC                    // 切换英文键盘
    case Complete               // 完成
    case Comma                  // 逗号
    case ToggleCase             // 大小写切换
    case ASCIIDelete            // 字母键盘的删除按钮
    case ToNumber               // 切换数字键盘按钮
    case ToASCII                // 切换英文键盘按钮(符号键盘上的按钮)
    case ASCIISymbol            // 切换符号键盘按钮(符号键盘上的按钮) #+=
    case ASCIISpace             // 字母键盘空格键
    case ASCIIResign            // 字母键盘收起键
    case ASCIIDecimal           // 字母键盘小数点
    case StockHeader600         // 股票600开头
    case StockHeader601         // 股票601开头
    case StockHeader000         // 股票000开头
    case StockHeader002         // 股票002开头
    case StockHeader300         // 股票300开头
    case StockHeader00          // 股票00开头
    case StockPositionFull      // 全仓
    case StockPositionHalf      // 半仓
    case StockPositionOneThird  // 三分之一
    case StockPositionQuartern  // 四分之一
}
/// 切换到字母键盘回调
typealias ChangeASCIIKeyboardBlock = () -> Void
/// 全仓、半仓、1/3、1/4 按钮点击回调
typealias StockPositionBtnClickBlock = (_ keyboardType: KeyboardButtonType) -> Void
/// 切换数字键盘回调
typealias ChangeNumberKeyboardBlock = () -> Void
/// 切换符号键盘回调
typealias ChangeSymbolKeyboardBlock = () -> Void
/// web中WebNumberKeyboard键盘确定按钮回调
typealias WebKeyboardSubmitBlock = (_ text: String) -> Void
