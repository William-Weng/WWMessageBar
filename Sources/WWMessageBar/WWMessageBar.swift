//
//  WWMessageBar.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit

// MARK: - 主程式
open class WWMessageBar: AnyObject {
    
    static public let shared: WWMessageBar = WWMessageBar()
    
    private var messageBarWindow: MessageBarWindow!
    
    private(set) weak var delegate: WWMessageBar.Delegate?
    
    init() {
        messageBarWindow = MessageBarWindow(frame: .zero)
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - 公開函式
public extension WWMessageBar {
    
    /// [相關數值設定](https://www.appcoda.com.tw/interactive-animation-uiviewpropertyanimator/)
    /// - Parameters:
    ///   - delegate: WWMessageBar.Delegate?
    ///   - height: 訊息列高度
    ///   - barType: 訊息框樣式
    ///   - animateDelayTime: 動畫時間
    ///   - touchDelayTime: 可以點擊的時間
    func configure(delegate: WWMessageBar.Delegate?, height: CGFloat = 128, barType: BarType = .message, animateDelayTime: TimeInterval = 0.5, touchDelayTime: TimeInterval = 1.5) {
        self.delegate = delegate
        messageBarWindow.configure(messageBar: self ,height: height, barType: barType, animateDelayTime: animateDelayTime, touchDelayTime: touchDelayTime)
    }
    
    /// [顯示文字訊息](https://github.com/JanGorman/SwiftMessageBar)
    /// - Parameters:
    ///   - title: 標題
    ///   - message: 訊息
    ///   - level: 訊息類型
    ///   - tag: 註記
    func display<T>(title: String? = nil, message: T, level: WWMessageBar.Level = .info, tag: String? = nil) {
        messageBarWindow.display(title: title, message: message, level: level, tag: tag)
    }
}

