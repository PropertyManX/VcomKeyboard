//
//  WebNumberKeyboard.swift
//  uxinproject
//
//  Created by wbx on 2020/8/27.
//  Copyright © 2020 karl. All rights reserved.
//

import UIKit

private var col: Int = 4 // 键盘有几列按钮
private let btnWidth = CGFloat(Keyboard.kScreenWidth) / CGFloat(col) // 按钮宽度
private let btnHeight = Keyboard.kNumberKeyboardBtnHeight // 按钮高度
private var firstColTitles: NSArray = ["1", "4", "7", "."] // 第一列
private var secondColTitles: NSArray = ["2", "5", "8", "0"] // 第二列
private var thirdColTitles: NSArray = ["3", "6", "9", ""] // 第三列 空字符串为 收起 按钮

/// web页使用的数字键盘
class WebNumberKeyboard: UIView {

    private var _keyboardSubmitBlock: WebKeyboardSubmitBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        // iPhoneX时键盘下部添加安全区
//        let bottom: CGFloat = iPhoneX() ? K_SAFEAREA_BOTTOM_HEIGHT() : 0
//        let height: CGFloat = Keyboard.kCustomKeyboardSafeDescrHeight + Keyboard.kCustomKeyboardHeight + bottom
//        self.frame = CGRect(x: 0, y: K_SCREEN_HEIGHT - height, width: Keyboard.kScreenWidth, height: height)
        backgroundColor = Keyboard.kKeyboardViewBackgroundColor

        initUI()
    }

    /// 确认按钮点击回调
    /// - Parameter block: 回调
    func keyboardSubmit(block: ((_ text: String) -> Void)?) {
        if let _ = block {
            _keyboardSubmitBlock = block
        }
    }

    /// 初始化键盘UI
    private func initUI() {

        addSubview(textView)
        textView.addSubview(textField)

        createFirstCol()
    }

    /// 创建第一列按钮
    private func createFirstCol() {
        for i in 0..<firstColTitles.count {
            let btn = KeyboardButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: 0, y: textView.frame.maxY + CGFloat(i % col) * btnHeight, width: btnWidth, height: btnHeight)
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchDown)
            btn.setTitle((firstColTitles.object(at: i) as! String), for: .normal)
//            btn.theme_setTitleColor(Label.titleColor, forState: .normal)
            btn.keyboardButtonType = KeyboardButtonType.Number
            addSubview(btn)
        }

        createSecondCol()
    }

    /// 创建第二列按钮
    private func createSecondCol() {
        for i in 0..<secondColTitles.count {
            let btn = KeyboardButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: btnWidth, y: textView.frame.maxY + CGFloat(i % col) * btnHeight, width: btnWidth, height: btnHeight)
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchDown)
            btn.setTitle((secondColTitles.object(at: i) as! String), for: .normal)
//            btn.theme_setTitleColor(Label.titleColor, forState: .normal)
            btn.keyboardButtonType = KeyboardButtonType.Number
            addSubview(btn)
        }

        createThirdCol()
    }

    /// 创建第三列按钮
    private func createThirdCol() {
        for i in 0..<thirdColTitles.count {
            let btn = KeyboardButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: btnWidth * 2, y: textView.frame.maxY + CGFloat(i % col) * btnHeight, width: btnWidth, height: btnHeight)
            if i == thirdColTitles.count - 1 {
                btn.keyboardButtonType = .Resign
                btn.setBackgroundImage(nil, for: .normal) // 清除功能按钮自带背景
//                btn.theme_backgroundColor = Global.backgroundColor
                btn.addTarget(self, action: #selector(resignBtnClick(sender:)), for: .touchDown)
            } else {
                btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchDown)
                btn.setTitle((thirdColTitles.object(at: i) as! String), for: .normal)
//                btn.theme_setTitleColor(Label.titleColor, forState: .normal)
                btn.keyboardButtonType = KeyboardButtonType.Number
            }
            addSubview(btn)
        }

        createFourthCol()
    }

    /// 创建第四轮按钮
    private func createFourthCol() {
        for i in 0..<2 {
            let btn = KeyboardButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: btnWidth * 3, y: textView.frame.maxY + CGFloat(i % col) * (btnHeight * 2), width: btnWidth, height: btnHeight * 2)
            btn.setBackgroundImage(nil, for: .normal) // 清除功能按钮自带背景
//            btn.theme_backgroundColor = Global.backgroundColor
            addSubview(btn)

            if i == 0 {
                btn.addTarget(self, action: #selector(deleteBtnClick(sender:)), for: .touchDown)
                btn.keyboardButtonType = KeyboardButtonType.Delete
            } else {
                btn.addTarget(self, action: #selector(submitBtnClick(sender:)), for: .touchDown)
//                btn.theme_backgroundColor = Global.tintColor
                btn.setTitle("确定", for: .normal)
//                btn.theme_setTitleColor(Label.textColor, forState: .normal)
            }

        }
    }

    /// 输入按钮点击事件
    /// - Parameter sender: 按钮
    @objc private func btnClick(sender: UIButton) {
        let text: String = textField.text!
        textField.text = "\(text)\((sender.titleLabel?.text)!)"
    }

    /// 键盘收起按钮点击事件
    /// - Parameter sender: 按钮
    @objc private func resignBtnClick(sender: UIButton) {
        dismiss()
    }
    func dismiss() {
        let bgView = UIApplication.shared.keyWindow?.viewWithTag(110)
        UIView.animate(withDuration: 0.38, animations: {
            bgView?.alpha = 0
        }) { (_) in
            if let _ = bgView {
                bgView?.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    /// 删除按钮点击事件
    /// - Parameter sender: 按钮
    @objc private func deleteBtnClick(sender: UIButton) {
        let text: NSString = textField.text! as NSString
        if text.length > 0 {
            textField.text = text.substring(to: text.length - 1)
        }
    }

    /// 确定按钮点击事件
    /// - Parameter sender: 按钮
    @objc private func submitBtnClick(sender: UIButton) {
        if let _ = _keyboardSubmitBlock {
            if textField.text!.count > 0 {
                dismiss()
                _keyboardSubmitBlock!(textField.text!)
            }
        }
    }

    /// 输入框背景
    private lazy var textView: UIView = {
        let textView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: Keyboard.kCustomKeyboardSafeDescrHeight))
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.backgroundColor = .white
        return textView
    }()

    /// 输入框
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 12, y: 0, width: textView.frame.width - 12 * 2, height: textView.frame.height))
        textField.placeholder = "输入内容"
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.isEnabled = false
        return textField
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
