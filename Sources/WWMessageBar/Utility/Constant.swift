//
//  Constant.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit

// MARK: - typealias
public extension WWMessageBar {
    
    typealias MessageInformation = (title: String?, message: String, level: Level, tag: String?)    // (標題, 訊息, 等級, 註記)
}

// MARK: - enum
public extension WWMessageBar {
    
    /// 訊息框樣式
    public enum BarType {
        case message        // 滿版樣式
        case notification   // 推播樣式
    }
    
    /// Message的等級
    public enum Level {
        
        case debug
        case info
        case notice
        case warning
        case critical
        
        /// 圖示
        /// - Returns: UIImage?
        func icon() -> UIImage? {
            
            switch self {
            case .debug: return UIImage(named: "debug", in: .module, with: nil)
            case .info: return UIImage(named: "info", in: .module, with: nil)
            case .notice: return UIImage(named: "notice", in: .module, with: nil)
            case .warning: return UIImage(named: "warning", in: .module, with: nil)
            case .critical: return UIImage(named: "critical", in: .module, with: nil)
            }
        }
        
        /// 背景色
        /// - Returns: UIColor
        func backgroundColor() -> UIColor {
            
            switch self {
            case .debug: return UIColor(red: 209, green: 209, blue: 224, alpha: 255)
            case .info: return UIColor(red: 77, green: 166, blue: 255, alpha: 255)
            case .notice: return UIColor(red: 247, green: 247, blue: 129, alpha: 255)
            case .warning: return UIColor(red: 255, green: 153, blue: 153, alpha: 255)
            case .critical: return UIColor(red: 163, green: 102, blue: 255, alpha: 255)
            }
        }
    }
}
