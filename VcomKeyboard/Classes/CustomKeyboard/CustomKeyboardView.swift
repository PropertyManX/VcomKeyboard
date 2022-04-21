//
//  CustomKeyboardView.swift
//  UXin
//
//  Created by wbx on 2020/5/18.
//  Copyright © 2020 Vcom. All rights reserved.
//

import UIKit

/// 键盘视图
class CustomKeyboardView: UIView {
    private var _keyboardType: CustomKeyboardType?
    private var _stockPositionBtnClickBlock: StockPositionBtnClickBlock?
    /// 切换键盘时记录上一个键盘类型
    private var lastKeyboardType: CustomKeyboardType?

    /// 键盘类型
    var keyboardType: CustomKeyboardType? {
        get {
            return _keyboardType
        }
        set {
            _keyboardType = newValue
            showKeyboard()
        }
    }

    /// 股票数量按钮点击回调
    var stockPositionBtnClickBlock: StockPositionBtnClickBlock {
        get {
            return _stockPositionBtnClickBlock!
        }
        set {
            _stockPositionBtnClickBlock = newValue
            stockPositionKeyboard.stockPositionBtnClickBlock = _stockPositionBtnClickBlock
        }
    }
    func K_SAFEAREA_BOTTOM_HEIGHT() -> CGFloat {
        if iPhoneX() {
            if #available(iOS 11.0, *) {
                return UIApplication.shared.keyWindow!.safeAreaInsets.bottom
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    func iPhoneX() -> Bool {
        var iPhoneXSeries: Bool = false
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return iPhoneXSeries
        }
        if #available(iOS 11.0, *) {
            let window: UIWindow = UIApplication.shared.keyWindow!
            if window.safeAreaInsets.bottom > 0.0 {
                iPhoneXSeries = true
            }
        }
        return iPhoneXSeries
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        // iPhoneX时键盘下部添加安全区
        let bottom: CGFloat = iPhoneX() ? K_SAFEAREA_BOTTOM_HEIGHT() : 0
        self.frame = CGRect(x: 0, y: 0, width: Keyboard.kScreenWidth, height: Keyboard.kCustomKeyboardSafeDescrHeight + Keyboard.kCustomKeyboardHeight + bottom)

        addSubview(safeView)

        addSubview(secureKeyboard)
        addSubview(numberKeyboard)
        addSubview(asciiKeyboard)
        addSubview(stockInputKeyboard)
        addSubview(stockPositionKeyboard)
        addSubview(symbolKeyboard)

        keyboardType = .ASCII
        showKeyboard()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if let _ = newSuperview {
            if keyboardType == CustomKeyboardType.Number { // keyboardType == CustomKeyboardType.Secury ||
                secureKeyboard.resetSecureKeyboard()
            }
        }
    }

    /// 展示当前类型的键盘
    private func showKeyboard() {
        for typeNumber in typeDictionary.allKeys {
            let keyBoard = typeDictionary[typeNumber] as? UIView
            let number: Int = typeNumber as! Int
            keyBoard?.isHidden = number != keyboardType!.rawValue
        }
    }

    /// 类型和键盘对应关系
    private lazy var typeDictionary: NSDictionary = {
        let dict = [NSNumber(value: CustomKeyboardType.Secury.rawValue): secureKeyboard,
                    NSNumber(value: CustomKeyboardType.Number.rawValue): numberKeyboard,
                    NSNumber(value: CustomKeyboardType.ASCII.rawValue): asciiKeyboard,
                    NSNumber(value: CustomKeyboardType.Symbol.rawValue): symbolKeyboard,
                    NSNumber(value: CustomKeyboardType.StockInput.rawValue): stockInputKeyboard,
                    NSNumber(value: CustomKeyboardType.StockPosition.rawValue): stockPositionKeyboard]
        return dict as NSDictionary
    }()

    /// 密码键盘
    private lazy var secureKeyboard: NumberKeyboard = {
        let secureKeyboard = NumberKeyboard(frame: CGRect(x: 0, y: Keyboard.kCustomKeyboardSafeDescrHeight, width: self.frame.width, height: Keyboard.kCustomKeyboardHeight))
        secureKeyboard.keyboardType = .Secury
        return secureKeyboard
    }()

    /// 数字键盘
    private lazy var numberKeyboard: NumberKeyboard = {
        let numberKeyboard = NumberKeyboard(frame: CGRect(x: 0, y: Keyboard.kCustomKeyboardSafeDescrHeight, width: self.frame.width, height: Keyboard.kCustomKeyboardHeight))
        numberKeyboard.keyboardType = .Number
        numberKeyboard.changeASCIIKeyboardBlock = {
            self.keyboardType = .ASCII
            self.showKeyboard()
            self.lastKeyboardType = .Number
        }
        return numberKeyboard
    }()

    /// 字母键盘
    private lazy var asciiKeyboard: ASCIIKeyboard = {
        let asciiKeyboard = ASCIIKeyboard(frame: CGRect(x: 0, y: Keyboard.kCustomKeyboardSafeDescrHeight, width: self.frame.width, height: Keyboard.kCustomKeyboardHeight))
        asciiKeyboard.changeNumberBlock = {
            // 切换到数字
            if self.lastKeyboardType == .StockInput {
                self.keyboardType = .StockInput
            } else {
                self.keyboardType = .Number
            }
            self.numberKeyboard.needChangeASCIIKeyboard = true
            self.showKeyboard()
            self.lastKeyboardType = .ASCII
        }

        asciiKeyboard.changeSymbolBlock = {
            self.keyboardType = .Symbol
            self.showKeyboard()
            self.lastKeyboardType = .ASCII
        }
        return asciiKeyboard
    }()

    /// 特殊字符键盘
    private lazy var symbolKeyboard: SymbolKeyboard = {
        let symbolKeyboard = SymbolKeyboard(frame: CGRect(x: 0, y: Keyboard.kCustomKeyboardSafeDescrHeight, width: self.frame.width, height: Keyboard.kCustomKeyboardHeight))
        symbolKeyboard.changeASCIIBlock = {
            self.keyboardType = .ASCII
            self.showKeyboard()
            self.lastKeyboardType = .Symbol
        }

        symbolKeyboard.changeNumberBlock = {
            self.keyboardType = .Number
            self.numberKeyboard.needChangeASCIIKeyboard = true
            self.showKeyboard()
            self.lastKeyboardType = .Symbol
        }
        return symbolKeyboard
    }()

    /// 股票代码输入键盘
    private lazy var stockInputKeyboard: NumberKeyboard = {
        let stockInputKeyboard = NumberKeyboard(frame: CGRect(x: 0, y: Keyboard.kCustomKeyboardSafeDescrHeight, width: self.frame.width, height: Keyboard.kCustomKeyboardHeight))
        stockInputKeyboard.keyboardType = .StockInput
        stockInputKeyboard.changeASCIIKeyboardBlock = {
            self.keyboardType = .ASCII
            self.showKeyboard()
            self.lastKeyboardType = .StockInput
        }
        return stockInputKeyboard
    }()

    /// 买入迈出股票数量输入键盘
    private lazy var stockPositionKeyboard: NumberKeyboard = {
        let stockPositionKeyboard = NumberKeyboard(frame: CGRect(x: 0, y: Keyboard.kCustomKeyboardSafeDescrHeight, width: self.frame.width, height: Keyboard.kCustomKeyboardHeight))
        stockPositionKeyboard.keyboardType = .StockPosition
        return stockPositionKeyboard
    }()

    /// 键盘安全描述视图
    private lazy var safeView: UIView = {
        let safeView = UIView()
        safeView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: Keyboard.kCustomKeyboardSafeDescrHeight)
        safeView.backgroundColor = Keyboard.kKeyboardBtnDefaultColor

        let button = UIButton(type: .custom)
        button.frame = safeView.bounds
        button.setImage(UIImage(named: "Keyboard.bundle/keyboard_safe"), for: .normal)
        let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String //App 名称

        let title = "\(appDisplayName)安全键盘"
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 29, green: 137, blue: 209, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        safeView.addSubview(button)

        return safeView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
