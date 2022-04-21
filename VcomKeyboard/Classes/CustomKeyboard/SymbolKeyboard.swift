//
//  SymbolKeyboard.swift
//  UXin
//
//  Created by wbx on 2020/5/18.
//  Copyright © 2020 Vcom. All rights reserved.
//

import UIKit

class SymbolKeyboard: UIView {
    // 所有按钮高度
    private var buttonHeight: CGFloat = 0
    // 输入按钮宽度
    private var buttonWidth: CGFloat = 0
    // 按钮之间的间距
    private var buttonSpace: CGFloat = 0
    // 功能按钮宽度
    private var functionButtonWidth: CGFloat = 0
    // 删除键按钮宽度
    private var deleteButtonWidth: CGFloat = 0
    // 收起键盘按钮宽度
    private var resignButtonWidth: CGFloat = 0
    private var firstRowTitles: NSArray = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"]
    private var secondRowTitles: NSArray = ["'", "\"", "=", "_", ":", ";", "?", "~", "|", "·"]
    private var thirdRowTitles: NSArray = ["+", "-", "\\", "/", "[", "]", "{", "}"]
    private var fourthRowTitles: NSArray = [",", ".", "<", ">", "€", "£", "¥"]

    /// 切换到数字键盘回调
    var changeNumberBlock: ChangeNumberKeyboardBlock?
    /// 切换到符号键盘回调
    var changeASCIIBlock: ChangeASCIIKeyboardBlock?

    /// 初始化
    /// - Parameter frame: frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Keyboard.kKeyboardViewBackgroundColor

        buttonSpace = Keyboard.kASCIIKeyboardBtnHorizontalSpace
        buttonHeight = Keyboard.kASCIIKeyboardBtnHeight
        buttonWidth = btnWidth()
        functionButtonWidth = functionBtnWidth()
        deleteButtonWidth = deleteBtnWidth()
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
            btn.keyboardButtonType = .Symbol
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
            btn.keyboardButtonType = .Symbol
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
        for i in 0..<thirdRowTitles.count + 1 { // 第三行多加两个功能键
            let btn = createBtn()
            if i == thirdRowTitles.count {
                btn.frame = CGRect(x: Keyboard.kScreenWidth - sideSpace - deleteButtonWidth, y: offsetY, width: deleteButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ASCIIDelete
            } else {
                // 第一个按钮 x 偏移量
                let letterBtnX = CGFloat(i) * (buttonSpace + buttonWidth)
                let offsetX = sideSpace + letterBtnX
                btn.frame = CGRect(x: offsetX, y: offsetY, width: buttonWidth, height: buttonHeight)
                btn.setTitle((thirdRowTitles.object(at: i) as! String), for: .normal)
                btn.keyboardButtonType = .Symbol
            }
            addSubview(btn)

            fourthOffsetY = btn.frame.maxY + Keyboard.kASCIIKeyboardBtnVerticalSpace
        }

        createFourthRow(offsetY: fourthOffsetY)
    }

    /// 第四行
    /// - Parameter offsetY: 偏移
    private func createFourthRow(offsetY: CGFloat) {
        // 距两边间距
        let sideSpace = Keyboard.kASCIIKeyboardBtnHorizontalSpace / 2
        let numberX = sideSpace
        let asciiX = Keyboard.kScreenWidth - sideSpace - functionButtonWidth
        for i in 0..<fourthRowTitles.count + 2 {
            let btn = createBtn()
            if i == 0 { // 切换数字键盘
                btn.frame = CGRect(x: numberX, y: offsetY, width: functionButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ToNumber
            } else if i == fourthRowTitles.count + 1 { // 切换字母键盘
                btn.frame = CGRect(x: asciiX, y: offsetY, width: functionButtonWidth, height: buttonHeight)
                btn.keyboardButtonType = .ToASCII
            } else { // 其他字符
                let originX = sideSpace + functionButtonWidth + buttonSpace + CGFloat((i - 1)) * (buttonSpace + buttonWidth)
                btn.frame = CGRect(x: originX, y: offsetY, width: buttonWidth, height: buttonHeight)
                btn.setTitle((fourthRowTitles.object(at: i - 1) as! String), for: .normal)
                btn.keyboardButtonType = .Symbol
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
        case .Symbol:
            inputText(text: (sender.titleLabel?.text)!)
        case .ToASCII:
            if let block = changeASCIIBlock {
                block()
            }
        case .ToNumber:
            if let block = changeNumberBlock {
                block()
            }
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

    /// 获取键盘按钮的宽度
    /// - Returns: 按钮的宽度
    private func btnWidth() -> CGFloat {
        return (Keyboard.kScreenWidth - buttonSpace * CGFloat(firstRowTitles.count)) / CGFloat(firstRowTitles.count)
    }

    /// 删除按钮的宽度
    /// - Returns: 按钮的宽度
    func deleteBtnWidth() -> CGFloat {
        // 所有字符按钮宽度
        let btnsWidth = CGFloat(thirdRowTitles.count) * buttonWidth
        // 所有空隙的宽度
        let spacesWidth = CGFloat((thirdRowTitles.count + 1)) * buttonSpace
        return Keyboard.kScreenWidth - btnsWidth - spacesWidth
    }

    /// 切换数字键盘和英文字母键盘按钮宽度
    /// - Returns: 按钮的宽度
    private func functionBtnWidth() -> CGFloat {
        // 第四行所有字符按钮的宽度
        let btnsWidth: CGFloat = CGFloat(fourthRowTitles.count) * buttonWidth
        // 第四行所有字符按钮加上空隙的宽度 7个字符按钮是8个空隙，再加上第一个功能键左边间隙，第二个功能键右边间隙，两个间隙=1个字母间隙，一共是count+2个间隙
        let btnsAndSpaceWidth: CGFloat = btnsWidth + CGFloat((fourthRowTitles.count + 2)) * buttonSpace
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
