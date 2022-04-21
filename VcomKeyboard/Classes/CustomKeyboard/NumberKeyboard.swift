//
//  NumberKeyboard.swift
//  UXin
//
//  Created by wbx on 2020/5/18.
//  Copyright © 2020 Vcom. All rights reserved.
//  swiftlint:disable cyclomatic_complexity

import UIKit

/// 数字键盘
class NumberKeyboard: UIView {
    private var _keyboardType: CustomKeyboardType?
    private var _needChangeASCIIKeyboard: Bool?
    var changeASCIIKeyboardBlock: ChangeASCIIKeyboardBlock?
    var stockPositionBtnClickBlock: StockPositionBtnClickBlock?

    /// 键盘类型
    var keyboardType: CustomKeyboardType? {
        get {
            return _keyboardType
        }
        set {
            _keyboardType = newValue
            createKeyboard()
            // 默认的数字键盘不展示切换字母键盘按钮
            needChangeASCIIKeyboard = false
        }
    }

    /// 是否需要切换字母键盘，纯数字键盘是不需要切换字母键盘按钮的，
    /// 但是字母键盘切换到了数字键盘，是需要有切换字母键盘按钮
    var needChangeASCIIKeyboard: Bool? {
        get {
            return _needChangeASCIIKeyboard
        }
        set {
            _needChangeASCIIKeyboard = newValue
            for view in subviews {
                if view.isKind(of: KeyboardButton.self) {
                    let button: KeyboardButton = view as! KeyboardButton
                    if button.keyboardButtonType == KeyboardButtonType.ABC && keyboardType == CustomKeyboardType.Number {
                        button.isHidden = !_needChangeASCIIKeyboard!
                    }
                }
            }
        }
    }

    /// 初始化
    /// - Parameter frame: frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Keyboard.kKeyboardViewBackgroundColor
    }

    /// 重置密码键盘
    func resetSecureKeyboard() {
        if keyboardType != CustomKeyboardType.Number { // keyboardType != CustomKeyboardType.Secury &&
            return
        }
        let numArray = NSMutableArray(array: shuffle(array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0])!)
        for subView in subviews {
            if subView.isKind(of: KeyboardButton.self) {
                let subBtn: KeyboardButton = subView as! KeyboardButton
                if subBtn.keyboardButtonType == KeyboardButtonType.Number {
                    // 随机键盘上的数字
                    let loc: Int = Int(arc4random_uniform(UInt32(numArray.count)))
                    let value: NSNumber = numArray[loc] as! NSNumber
                    subBtn.setTitle(value.stringValue, for: .normal)
                    numArray.removeObject(at: loc)
                }
            }
        }
    }

    /// 洗牌算法
    /// - Parameter array: 原始数组
    /// - Returns: 结果数组
    private func shuffle(array: NSArray?) -> NSArray? {
        if array == nil || array!.count < 1 {
            return nil
        }
        let resultArray = NSMutableArray(array: array!)
        var value: Int
        var median: NSNumber?
        for i in 0..<array!.count {
            value = Int(arc4random()) % resultArray.count
            median = (resultArray[i] as! NSNumber)

            resultArray[i] = resultArray[value]
            resultArray[value] = median as Any
        }
        return resultArray
    }

    /// 创建键盘
    private func createKeyboard() {
        let numArray: NSMutableArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        var col: Int = 0
        var keyboards: NSArray = []
        switch keyboardType {
        case .Number:
            col = 4
            keyboards = [NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Delete.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Underline.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Decimal.rawValue),
                         NSNumber(value: KeyboardButtonType.ABC.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Resign.rawValue),
                         NSNumber(value: KeyboardButtonType.Complete.rawValue)]
        case .StockInput:
            col = 5
            keyboards = [NSNumber(value: KeyboardButtonType.StockHeader600.rawValue), 1, 2, 3, NSNumber(value: KeyboardButtonType.Delete.rawValue),
                         NSNumber(value: KeyboardButtonType.StockHeader601.rawValue), 4, 5, 6, NSNumber(value: KeyboardButtonType.StockHeader002.rawValue),
                         NSNumber(value: KeyboardButtonType.StockHeader000.rawValue), 7, 8, 9, NSNumber(value: KeyboardButtonType.StockHeader300.rawValue),
                         NSNumber(value: KeyboardButtonType.ABC.rawValue), NSNumber(value: KeyboardButtonType.StockHeader00.rawValue), 0, NSNumber(value: KeyboardButtonType.Resign.rawValue), NSNumber(value: KeyboardButtonType.Complete.rawValue)]
        case .StockPosition:
            col = 5
            keyboards = [NSNumber(value: KeyboardButtonType.StockPositionFull.rawValue), 1, 2, 3, NSNumber(value: KeyboardButtonType.Delete.rawValue),
                         NSNumber(value: KeyboardButtonType.StockPositionHalf.rawValue), 4, 5, 6, NSNumber(value: KeyboardButtonType.None.rawValue),
                         NSNumber(value: KeyboardButtonType.StockPositionOneThird.rawValue), 7, 8, 9, NSNumber(value: KeyboardButtonType.Complete.rawValue),
                         NSNumber(value: KeyboardButtonType.StockPositionQuartern.rawValue), NSNumber(value: KeyboardButtonType.StockHeader00.rawValue), 0, NSNumber(value: KeyboardButtonType.Resign.rawValue), NSNumber(value: KeyboardButtonType.None.rawValue)]
        case .Secury:
            col = 3
            keyboards = [NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Resign.rawValue),
                         NSNumber(value: KeyboardButtonType.Number.rawValue),
                         NSNumber(value: KeyboardButtonType.Delete.rawValue)]
        default:
            break
        }

        let btnWidth = Int(Keyboard.kScreenWidth) / col
        for i in 0..<keyboards.count {
            //let keyBoardType: KeyboardButtonType = keyboards[i] as! KeyboardButtonType
            let keyBoardType: Int = keyboards[i] as! Int
            let btn = KeyboardButton(type: UIButton.ButtonType.custom)
            btn.frame = CGRect(x: i % col * btnWidth, y: i / col * Int(Keyboard.kNumberKeyboardBtnHeight), width: btnWidth, height: Int(Keyboard.kNumberKeyboardBtnHeight))
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchDown)
            addSubview(btn)

            if keyBoardType < KeyboardButtonType.None.rawValue {
                btn.keyboardButtonType = KeyboardButtonType.Number
                btn.setTitle(String(format: "%zd", keyBoardType), for: .normal)
            } else {
                btn.keyboardButtonType = KeyboardButtonType(rawValue: keyBoardType)
            }

            // 页面上特殊处理
            switch keyboardType {
            case .Number: // 普通数字键盘特殊处理
                // 删除按钮占两格
                if keyBoardType == KeyboardButtonType.Delete.rawValue {
                    btn.frame = CGRect(x: i % col * btnWidth, y: i / col * Int(Keyboard.kNumberKeyboardBtnHeight), width: btnWidth, height: Int(Keyboard.kNumberKeyboardBtnHeight))
                    btn.setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnWhiteColor), for: .normal)
                } else if keyBoardType == KeyboardButtonType.None.rawValue {
                    btn.frame = .zero
                }
                if btn.keyboardButtonType == KeyboardButtonType.Number {
                    // 随机键盘上的数字
                    let loc: Int = Int(arc4random_uniform(UInt32(numArray.count)))
                    btn.setTitle((numArray.object(at: loc) as! String), for: .normal)
                    numArray.removeObject(at: loc)
                }
            case .StockInput: // 股票输入键盘特殊处理
                if keyBoardType == KeyboardButtonType.Delete.rawValue {
                    btn.setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnWhiteColor), for: .normal)
                }
            case .StockPosition: // 股票数量输入特殊处理
                // 删除按钮和完成占两格
                if keyBoardType == KeyboardButtonType.Delete.rawValue {
                    btn.frame = CGRect(x: i % col * btnWidth, y: i / col * Int(Keyboard.kNumberKeyboardBtnHeight), width: btnWidth, height: Int(Keyboard.kNumberKeyboardBtnHeight) * 2)
                    btn.setBackgroundImage(UIImage.image(color: Keyboard.kKeyboardBtnWhiteColor), for: .normal)
                } else if keyBoardType == KeyboardButtonType.Complete.rawValue {
                    btn.frame = CGRect(x: i %  col * btnWidth, y: i / col * Int(Keyboard.kNumberKeyboardBtnHeight), width: btnWidth, height: Int(Keyboard.kNumberKeyboardBtnHeight) * 2)
                } else if keyBoardType == KeyboardButtonType.None.rawValue {
                    btn.frame = .zero
                }
            case .Secury: // 密码键盘特殊处理
                if keyBoardType == KeyboardButtonType.Number.rawValue {
                    btn.keyboardButtonType = .Number
                    // 随机键盘上的数字
                    //let loc: Int = Int(arc4random_uniform(UInt32(numArray.count)))
                    //btn.setTitle((numArray.object(at: loc) as! String), for: .normal)
                    //numArray.removeObject(at: loc)

                    if i <= 8 {
                        btn.setTitle((numArray.object(at: i) as! String), for: .normal)
                    } else if i == 10 {
                        btn.setTitle((numArray.object(at: 9) as! String), for: .normal)
                    }

                } else if keyBoardType == KeyboardButtonType.Delete.rawValue {
                    btn.frame = CGRect(x: i % col * btnWidth, y: i / col * Int(Keyboard.kNumberKeyboardBtnHeight), width: btnWidth, height: Int(Keyboard.kNumberKeyboardBtnHeight))
                } else if keyBoardType == KeyboardButtonType.Resign.rawValue {
                    btn.frame = CGRect(x: i % col * btnWidth, y: i / col * Int(Keyboard.kNumberKeyboardBtnHeight), width: btnWidth, height: Int(Keyboard.kNumberKeyboardBtnHeight))
                }
            default:
                break
            }
        }
    }

    @objc private func btnClick(sender: KeyboardButton) {
        weak var textView = UIResponder.firstResponderTextView()
        switch sender.keyboardButtonType {
        case .Number:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .Decimal:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .Underline:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .StockHeader00:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .StockHeader600:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .StockHeader601:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .StockHeader300:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .StockHeader000:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .StockHeader002:
            inputNumber(text: (sender.titleLabel?.text)!)
        case .Delete:
            textView?.deleteBackward()
        case .Complete:
            textView?.resignFirstResponder()
        case .Resign:
            textView?.resignFirstResponder()
        case .ABC:
            if let block = changeASCIIKeyboardBlock {
                block()
            }
        case .StockPositionFull:
            if let block = stockPositionBtnClickBlock {
                block(sender.keyboardButtonType!)
            }
        case .StockPositionHalf:
            if let block = stockPositionBtnClickBlock {
                block(sender.keyboardButtonType!)
            }
        case .StockPositionOneThird:
            if let block = stockPositionBtnClickBlock {
                block(sender.keyboardButtonType!)
            }
        case .StockPositionQuartern:
            if let block = stockPositionBtnClickBlock {
                block(sender.keyboardButtonType!)
            }
        default:
            break
        }
    }

    /// 输入文字
    /// - Parameter text: text
    private func inputNumber(text: String) {
        UIResponder.inputText(text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
