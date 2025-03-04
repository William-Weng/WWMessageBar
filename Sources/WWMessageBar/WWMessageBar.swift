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
        
    init() {
        messageBarWindow = MessageBarWindow(frame: .zero)
        messageBarWindow.messageBar = self
    }
}

// MARK: - 公開函式
public extension WWMessageBar {
    
    /// [相關數值設定](https://www.appcoda.com.tw/interactive-animation-uiviewpropertyanimator/)
    /// - Parameters:
    ///   - delegate: WWMessageBar.Delegate?
    ///   - height: 訊息列高度
    ///   - displayDelayTime: 顯示的時間
    ///   - dismissDelayTime: 隱藏的時間
    func configure(delegate: WWMessageBar.Delegate?, height: CGFloat = 128, displayDelayTime: TimeInterval = 0.5, dismissDelayTime: TimeInterval = 1.5) {
        messageBarWindow.configure(delegate: delegate, height: height, displayDelayTime: displayDelayTime, dismissDelayTime: dismissDelayTime)
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

