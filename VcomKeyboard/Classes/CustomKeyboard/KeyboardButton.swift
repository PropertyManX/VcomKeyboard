//
//  KeyboardButton.swift
//  UXin
//
//  Created by wbx on 2020/5/15.
//  Copyright © 2020 Vcom. All rights reserved.
//  swiftlint:disable function_body_length
//  swiftlint:disable cyclomatic_complexity

import UIKit

/// 键盘按钮
class KeyboardButton: UIButton {
    private var _keyboardButtonType: KeyboardButtonType?

    /// 键盘按钮的类型
    var keyboardButtonType: KeyboardButtonType? {
        get {
            return _keyboardButtonType
        }
        set {
            _keyboardButtonType = newValue
            setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnHighlightedColor), for: .selected)
            configKeyboardButton(type: _keyboardButtonType!)
        }
    }

    /// 设置按钮样式
    /// - Parameter type: 按钮类型
    private func configKeyboardButton(type: KeyboardButtonType) {
        switch type {
        case .None: break
        case .Number:
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .Letter:
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .Symbol:
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .Delete:
            setImage(UIImage(named: "Keyboard.bundle/button_backspace_delete"), for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .Resign:
            setImage(UIImage(named: "Keyboard.bundle/button_keyboard_shouqi"), for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .Decimal:
            setTitle(".", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .Underline:
            setTitle("_", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .ABC:
            setTitle("ABC", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .Complete:
            setTitle("完成", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: true)
        case .Comma:
            setTitle(",", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ToggleCase:
            setImage(UIImage(named: "Keyboard.bundle/CH_EN_icon_unsel"), for: .normal)
            setImage(UIImage(named: "Keyboard.bundle/CH_EN_icon_sel"), for: .selected)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ASCIIDelete:
            setImage(UIImage(named: "Keyboard.bundle/button_backspace_delete"), for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ToNumber:
            setTitle("123", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ToASCII:
            setTitle("ABC", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ASCIISymbol:
            setTitle("#+=", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ASCIISpace:
            setTitle("空格", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ASCIIResign:
            setImage(UIImage(named: "Keyboard.bundle/button_keyboard_shouqi"), for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: true)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .ASCIIDecimal:
            setTitle(".", for: .normal)
            configKeyboardButtonType(isFunctionKeyboard: false)
            configKeyboardButtonType(isNumberKeyboard: false)
        case .StockHeader600:
            setTitle("600", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockHeader601:
            setTitle("601", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockHeader000:
            setTitle("000", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockHeader002:
            setTitle("002", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockHeader300:
            setTitle("300", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockHeader00:
            setTitle("00", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockPositionFull:
            setTitle("全仓", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockPositionHalf:
            setTitle("半仓", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockPositionOneThird:
            setTitle("1/3仓", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        case .StockPositionQuartern:
            setTitle("1/4仓", for: .normal)
            configStockBtn()
            configKeyboardButtonType(isNumberKeyboard: true)
        }
    }

    /// 数字键盘和字母键盘按钮样式
    /// - Parameter isNumberKeyboard: 是否是数字键盘
    private func configKeyboardButtonType(isNumberKeyboard: Bool) {
        if isNumberKeyboard {
            self.layer.borderWidth = Keyboard.kASCIIKeyboardBtnBorderWidth
            self.layer.borderColor = Keyboard.kKeyboardBtnLayerColor.cgColor
        } else {
            self.layer.cornerRadius = Keyboard.kASCIIKeyboardBtnCornerRadius
            self.clipsToBounds = true
        }
    }

    /// 功能按钮和可输入按钮样式
    /// - Parameter isFunctionKeyboard: 是否是功能按钮
    private func configKeyboardButtonType(isFunctionKeyboard: Bool) {
        if isFunctionKeyboard {
            self.setTitleColor(Keyboard.kKeyboardBtnLightTitleColor, for: .normal)
            self.titleLabel?.font = Keyboard.kKeyboardBtnSmallFont
            self.setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnDefaultColor), for: .normal)
        } else {
            self.setTitleColor(Keyboard.kKeyboardBtnDarkTitleColor, for: .normal)
            self.titleLabel?.font = Keyboard.kKeyboardBtnBigFont
            self.setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnWhiteColor), for: .normal)
        }
    }

    /// 股票相关操作按钮
    private func configStockBtn() {
        self.setTitleColor(Keyboard.kKeyboardBtnLightTitleColor, for: .normal)
        self.titleLabel?.font = Keyboard.kKeyboardBtnSmallFont
        self.setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnWhiteColor), for: .normal)
    }
}
