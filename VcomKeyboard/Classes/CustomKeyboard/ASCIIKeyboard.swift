//
//  ASCIIKeyboard.swift
//  UXin
//
//  Created by wbx on 2020/5/18.
//  Copyright © 2020 Vcom. All rights reserved.
//

import UIKit

/// 字母键盘
class ASCIIKeyboard: UIView {
    // 所有按钮高度
    private var buttonHeight: CGFloat = 0
    // 输入按钮宽度
    private var buttonWidth: CGFloat = 0
    // 按钮之间的间距
    private var buttonSpace: CGFloat = 0
    // 功能按钮宽度
    private var functionButtonWidth: CGFloat = 0
    // 收起键盘按钮宽度
    private var resignButtonWidth: CGFloat = 0
    private var firstRowTitles: NSArray = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
    private var secondRowTitles: NSArray = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
    private var thirdRowTitles: NSArray = ["z", "x", "c", "v", "b", "n", "m"]

    /// 切换到数字键盘回调
    var changeNumberBlock: ChangeNumberKeyboardBlock?
    /// 切换到符号键盘回调
    var changeSymbolBlock: ChangeSymbolKeyboardBlock?

    /// 初始化
    /// - Parameter frame: frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Keyboard.kKeyboardViewBackgroundColor

        buttonSpace = Keyboard.kASCIIKeyboardBtnHorizontalSpace
        buttonHeight = Keyboard.kASCIIKeyboardBtnHeight
        buttonWidth = btnWidth()
        functionButtonWidth = functionBtnWidth()
        resignButtonWidth = resignBtnWidth()

        createKeyboard()
    }

    /// 创建键盘
    private func createKeyboard() {
        createFirstRow(offsetY: Keyboard.kASCIIKeyboardBtnVerticalSpace / 2)
    }

    /// 第一行
    /// - Parameter offsetY: 偏移
    private func createFirstRow(offsetY: CGFloat) {
        var secondOffsetY: CGFloat = 0.0
        // 距两边间距
        let sideSpace = 2
        for i in 0..<firstRowTitles.count {
            let btn = createBtn()
            btn.setTitle((firstRowTitles.object(at: i) as! String), for: .normal)
            btn.frame = CGRect(x: CGFloat(sideSpace + i * Int((buttonSpace + buttonWidth))), y: offsetY, width: buttonWidth, height: buttonHeight)
            btn.keyboardButtonType = .Letter
            addSubview(btn)

            secondOffsetY = btn.frame.maxY + Keyboard.kASCIIKeyboardBtnVerticalSpace
        }

        createSecondRow(offsetY: secondOffsetY)
    }

    /// 第二行
    /// - Parameter offsetY: 偏移
    private func createSecondRow(offsetY: CGFloat) {
        var thirdOffsetY: CGFloat = 0.0
        // 第二行9个按钮的总宽度
        let btnsWidth: CGFloat = CGFloat(secondRowTitles.count) * buttonWidth
        // 9个按钮之间间隙总宽度
        let spacesWidth: CGFloat = CGFloat((secondRowTitles.count - 1)) * buttonSpace
        // 距两边间距
        let sideSpace = (Keyboard.kScreenWidth - btnsWidth - spacesWidth) / 2
        for i in 0..<secondRowTitles.count {
            let btn = createBtn()
            btn.setTitle((secondRowTitles.object(at: i) as! String), for: .normal)
            btn.frame = CGRect(x: sideSpace + CGFloat(i) * (buttonSpace + buttonWidth), y: offsetY, width: buttonWidth, height: buttonHeight)
            btn.keyboardButtonType = .Letter
            addSubview(btn)

            thirdOffsetY = btn.frame.maxY + Keyboard.kASCIIKeyboardBtnVerticalSpace
        }

        createThirdRow(offsetY: thirdOffsetY)
    }

    /// 第三行
    /// - Parameter offsetY: 偏移
    private func createThirdRow(offsetY: CGFloat) {
        var fourthOffsetY: CGFloat = 0.0
        let sideSpace = Keyboard.kASCIIKeyboardBtnHorizontalSpace / 2
        for i in 0..<thirdRowTitles.count + 2 { // 第三行多加两个功能键
            let btn = createBtn()
            if i == 0 {
                btn.frame = CGRect(x: sideSpace, y: offsetY, width: functionButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ToggleCase
            } else if i == thirdRowTitles.count + 1 {
                btn.frame = CGRect(x: Keyboard.kScreenWidth - sideSpace - functionButtonWidth, y: offsetY, width: functionButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ASCIIDelete
            } else {
                // 第一个按钮 x 偏移量
                let letterBtnX = buttonSpace + CGFloat((i - 1)) * (buttonSpace + buttonWidth)
                let offsetX = sideSpace + functionButtonWidth + letterBtnX
                btn.frame = CGRect(x: offsetX, y: offsetY, width: buttonWidth, height: buttonHeight)
                btn.setTitle((thirdRowTitles.object(at: i - 1) as! String), for: .normal)
                btn.keyboardButtonType = .Letter
            }
            addSubview(btn)

            fourthOffsetY = btn.frame.maxY + Keyboard.kASCIIKeyboardBtnVerticalSpace
        }

        createFourthRow(offsetY: fourthOffsetY)
    }

    /// 第四行
    /// - Parameter offsetY: 偏移
    func createFourthRow(offsetY: CGFloat) {
        // 距两边间距
        let sideSpace = Keyboard.kASCIIKeyboardBtnHorizontalSpace / 2
        let resignX = Keyboard.kScreenWidth - sideSpace - resignButtonWidth
        let decimalX = resignX - buttonWidth - buttonSpace
        for i in 0..<6 {
            let btn = createBtn()
            if i == 0 { // 切换数字键盘
                btn.frame = CGRect(x: sideSpace, y: offsetY, width: functionButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ToNumber
            } else if i == 1 { // #+=符号
                btn.frame = CGRect(x: sideSpace + functionButtonWidth + buttonSpace, y: offsetY, width: functionButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ASCIISymbol
            } else if i == 2 { // 逗号
                btn.frame = CGRect(x: sideSpace + functionButtonWidth + buttonSpace + functionButtonWidth + buttonSpace, y: offsetY, width: buttonWidth, height: buttonHeight)
                btn.keyboardButtonType = .Comma
            } else if i == 3 { // 小数点
                btn.frame = CGRect(x: decimalX, y: offsetY, width: buttonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ASCIIDecimal
            } else if i == 4 { // 收起键盘
                btn.frame = CGRect(x: resignX, y: offsetY, width: resignButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ASCIIResign
            } else { // 空格
                let originX = sideSpace + functionButtonWidth * 2 + buttonSpace * 3 + buttonWidth
                let width = Keyboard.kScreenWidth - 2 * sideSpace - buttonSpace * 5 - functionButtonWidth * 2 - buttonWidth * 2  - resignButtonWidth
                btn.frame = CGRect(x: originX, y: offsetY, width: width, height: buttonHeight)
                btn.keyboardButtonType = .ASCIISpace
            }

            addSubview(btn)
        }
    }

    private func createBtn() -> KeyboardButton {
        let btn: KeyboardButton = KeyboardButton(type: .custom)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchDown)
        return btn
    }

    @objc private func btnClick(sender: KeyboardButton) {
        weak var textView = UIResponder.firstResponderTextView()
        switch sender.keyboardButtonType {
        case .Letter:
            inputText(text: (sender.titleLabel?.text)!)
        case .ASCIIDecimal:
            inputText(text: (sender.titleLabel?.text)!)
        case .Comma:
            inputText(text: (sender.titleLabel?.text)!)
        case .ASCIISymbol:
            if let block = changeSymbolBlock {
                block()
            }
        case .ASCIISpace:
            inputText(text: " ")
        case .ToNumber:
            if let block = changeNumberBlock {
                block()
            }
        case .ToggleCase:
            keyboardToggleCase(button: sender)
        case .ASCIIDelete:
            textView?.deleteBackward()
        case .ASCIIResign:
            textView?.resignFirstResponder()
        default:
            break
        }
    }

    /// 输入字符
    /// - Parameter text: 字符串
    private func inputText(text: String) {
        UIResponder.inputText(text)
    }

    /// 切换大小写
    /// - Parameter button: 大小写切换按钮
    private func keyboardToggleCase(button: KeyboardButton) {
        button.isSelected = !button.isSelected
        for subview in subviews {
            if subview.isKind(of: KeyboardButton.self) {
                let subBtn = subview as? KeyboardButton
                if subBtn?.keyboardButtonType == .Letter {
                    let title: String = (subBtn?.titleLabel?.text)!
                    subBtn?.setTitle(button.isSelected ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
        }
    }

    /// 获取键盘按钮的宽度
    /// - Returns: 按钮的宽度
    private func btnWidth() -> CGFloat {
        return (Keyboard.kScreenWidth - buttonSpace * CGFloat(firstRowTitles.count)) / CGFloat(firstRowTitles.count)
    }

    /// 获取功能键按钮的宽度
    /// - Returns: 按钮的宽度
    private func functionBtnWidth() -> CGFloat {
        // 第三行所有字母按钮的宽度
        let btnsWidth: CGFloat = CGFloat(thirdRowTitles.count) * buttonWidth
        // 第三行所有字母按钮加上空隙的宽度 7个字母按钮是8个空隙，再加上第一个功能键左边间隙，第二个功能键右边间隙，两个间隙=1个字母间隙，一共是count+2个间隙
        let btnsAndSpaceWidth: CGFloat = btnsWidth + CGFloat((thirdRowTitles.count + 2)) * buttonSpace
        // 两个功能键的总宽度
        let functionsWidth = Keyboard.kScreenWidth - btnsAndSpaceWidth
        let functionBtnWidth = functionsWidth / 2
        return functionBtnWidth
    }

    /// 第四行的键盘收起键宽度
    /// - Returns: 按钮的宽度
    private func resignBtnWidth() -> CGFloat {
        // 收起键盘按钮的宽度 = 一个字母键宽度 + 一个间隙 + 一个功能键的宽度
        return buttonWidth + buttonSpace + functionButtonWidth
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
