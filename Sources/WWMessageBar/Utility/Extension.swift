//
//  Extension.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit

// MARK: - UIColr (init function)
extension UIColor {
    
    /// UIColor(red: 255, green: 255, blue: 255, alpha: 255)
    /// - Parameters:
    ///   - red: 紅色 => 0~255
    ///   - green: 綠色 => 0~255
    ///   - blue: 藍色 => 0~255
    ///   - alpha: 透明度 => 0~255
    convenience init(red: Int, green: Int, blue: Int, alpha: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
}

// MARK: - UIWindow (function)
extension UIWindow {
    
    /// 設定背景色
    /// - Parameter color: UIColor?
    /// - Returns: Self
    func _backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    /// 設定前後關係的Level
    /// - Parameter level: UIWindow.Level
    /// - Returns: Self
    func _windowLevel(_ level: UIWindow.Level) -> Self {
        self.windowLevel = level
        return self
    }
    
    /// 設定rootViewController
    /// - Parameter rootViewController: UIViewController
    /// - Returns: Self
    func _rootViewController(_ rootViewController: UIViewController?) -> Self {
        self.rootViewController = rootViewController
        return self
    }
    
    /// 設定成主要的，並且顯示出來
    func _makeKeyAndVisible() {
        self.makeKeyAndVisible()
    }
}

// MARK: - UIWindowScene (static function)
extension UIWindowScene {
    static var _current: UIWindowScene? { return UIApplication.shared.connectedScenes.first as? UIWindowScene }
}

// MARK: - UIWindow (static function)
extension UIWindow {
    
    /// [取得作用中的KeyWindow](https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0)
    /// - Parameter hasScene: [有沒有使用Scene ~ iOS 13](https://juejin.cn/post/6844903993496305671)
    /// - Returns: UIWindow?
    static func _keyWindow(hasScene: Bool = true) -> UIWindow? {
        
        var keyWindow: UIWindow?
        
        keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
        if (!hasScene) { keyWindow = UIApplication.shared.keyWindow }
        
        return keyWindow
    }
}

// MARK: - UIStatusBarManager (static function)
extension UIStatusBarManager {
    
    /// [取得UIStatusBarManager](https://www.jianshu.com/p/d60757f13038)
    /// - Parameter keyWindow: UIWindow?
    /// - Returns: [UIStatusBarManager?](https://www.jianshu.com/p/e401762d824b)
    static func _build(for keyWindow: UIWindow? = UIWindow._keyWindow()) -> UIStatusBarManager? {
        return keyWindow?.windowScene?.statusBarManager
    }
}
