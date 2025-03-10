//
//  Protocol.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/4.
//

import Foundation

// MARK: - WWMessageBar.Delegate
public extension WWMessageBar {
    
    public protocol Delegate: AnyObject {
        
        /// 訊息Bar被點到
        /// - Parameters:
        ///   - messageBar: WWMessageBar
        ///   - info: MessageInformation
        func messageBar(_ messageBar: WWMessageBar, didTouched info: MessageInformation)
        
        /// 等級相關設定
        /// - Parameter messageBar: WWMessageBar
        /// - Returns: [Level: LevelSetting]?
        func levelSettings(messageBar: WWMessageBar) -> [Level: LevelSetting]?
    }
}
