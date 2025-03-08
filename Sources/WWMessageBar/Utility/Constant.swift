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
    typealias LevelSetting = (icon: UIImage?, tintColor: UIColor?, fontColor: UIColor?)             // (圖示, 主色調, 字體顏色)
}

// MARK: - enum
public extension WWMessageBar {
    
    /// 訊息框樣式
    enum BarType: CaseIterable {
        case message        // 滿版樣式
        case notification   // 推播樣式
    }
    
    /// Message的等級
    enum Level: CaseIterable {
        
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
        
        /// [主色調](https://www.bootcss.com/p/websafecolors/)
        /// - Returns: UIColor
        func tintColor() -> UIColor {
            
            switch self {
            case .debug: return UIColor(red: 85, green: 85, blue: 85, alpha: 255)
            case .info: return UIColor(red: 77, green: 166, blue: 255, alpha: 255)
            case .notice: return UIColor(red: 0, green: 153, blue: 102, alpha: 255)
            case .warning: return UIColor(red: 255, green: 26, blue: 26, alpha: 255)
            case .critical: return UIColor(red: 153, green: 102, blue: 255, alpha: 255)
            }
        }
    }
}
