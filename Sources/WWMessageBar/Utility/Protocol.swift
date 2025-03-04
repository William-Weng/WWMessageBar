//
//  Protocol.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/4.
//

import Foundation

public extension WWMessageBar {
    
    public protocol Delegate: AnyObject {
        
        /// 訊息Bar被點到
        /// - Parameters:
        ///   - messageBar: WWMessageBar
        ///   - info: MessageInformation?
        func messageBar(_ messageBar: WWMessageBar, didTouched info: MessageInformation?)
    }
}
