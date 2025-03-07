//
//  MessageBarWindow.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit

// MARK: - 產生UIWindow
class MessageBarWindow: UIWindow {
    
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    private(set) var messageQueue: [WWMessageBar.MessageInformation] = []
    
    private var isDisplay = false
    private var height = 128.0
    private var animateDelayTime: TimeInterval = 0.5
    private var touchDelayTime: TimeInterval = 1.5
    private var displayFrame: CGRect = .zero
    private var dismissFrame: CGRect = .zero
    private var barType: WWMessageBar.BarType = .message
    
    private var dismissAnimator: UIViewPropertyAnimator?
    
    private lazy var messageBarViewController = UIStoryboard(name: "Storyboard", bundle: .module).instantiateViewController(withIdentifier: "MessageBar") as? MessageBarViewController
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 公用函式
extension MessageBarWindow {
    
    /// 相關數值設定
    /// - Parameters:
    ///   - height: CGFloat
    ///   - barType: WWMessageBar.BarType
    ///   - animateDelayTime: TimeInterval
    ///   - dismissDelayTime: TimeInterval
    func configure(messageBar: WWMessageBar, height: CGFloat, barType: WWMessageBar.BarType, animateDelayTime: TimeInterval, touchDelayTime: TimeInterval) {
        
        self.height = height
        self.barType = barType
        self.animateDelayTime = animateDelayTime
        self.touchDelayTime = touchDelayTime
        
        messageBarViewController?.barType = barType
        messageBarViewController?.messageBar = messageBar
    }
    
    /// 顯示文字
    /// - Parameters:
    ///   - title: String?
    ///   - message: T
    ///   - level: WWMessageBar.Level
    ///   - tag: String?
    func display<T>(title: String? = nil, message: T, level: WWMessageBar.Level, tag: String?) {
        messageQueue.append(WWMessageBar.MessageInformation(title: title, message: "\(message)", level: level, tag: tag))
        displayText(level: level)
    }
    
    /// 隱藏訊息
    /// - Parameters:
    ///   - completion: ((UIViewAnimatingPosition) -> Void)?
    func dismiss(Sendable completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        dismissAnimator?.stopAnimation(true)
        dismissAnimator = nil
        dismiss(animatorDuration: animateDelayTime, afterDelay: 0, Sendable: completion)
    }
}

// MARK: - 小工具
private extension MessageBarWindow {
    
    /// 初始化設定
    func initSetting() {
        
        guard let currentWindowScene = UIWindowScene._current else { return }
        
        let screenBounds = currentWindowScene.screen.bounds
        let size = CGSize(width: screenBounds.width, height: height)
        
        windowScene = currentWindowScene
        frameSetting(size: size, height: height)
        frame = dismissFrame
                
        self._backgroundColor(.clear)
            ._windowLevel(.alert + 1000)
            ._rootViewController(messageBarViewController)
            ._makeKeyAndVisible()
    }
    
    /// 設定顯示 / 隱藏的Frame大小
    /// - Parameters:
    ///   - size: CGSize
    ///   - height: CGFloat
    func frameSetting(size: CGSize, height: CGFloat) {
        displayFrameSetting(size: size)
        dismissFrameSetting(size: size, height: height)
    }
    
    /// 設定顯示的Frame大小 (在畫面正上方)
    /// - Parameter size: CGSize
    func displayFrameSetting(size: CGSize) {
        displayFrame = CGRect(origin: .zero, size: size)
    }
    
    /// 設定隱藏的Frame大小 (在畫面正上方的外面)
    /// - Parameters:
    ///   - size: CGSize
    ///   - height: CGFloat
    func dismissFrameSetting(size: CGSize, height: CGFloat) {
        dismissFrame = CGRect(origin: .init(x: 0, y: -height * 2), size: size)
    }
    
    /// 顯示訊息
    /// - Parameter level: WWMessageBar.Level
    func displayText(level: WWMessageBar.Level) {
        
        guard !isDisplay,
              let info = messageQueue.first
        else {
            return
        }
        
        isDisplay = true
        messageBarViewController?.setting(with: info)
        
        let animator = UIViewPropertyAnimator(duration: animateDelayTime, curve: .easeInOut) { [unowned self] in
            frame = displayFrame
        }
        
        animator.addCompletion { [unowned self] displayPosition in
            
            switch displayPosition {
            case .start: break
            case .current: break
            case .end: touchAction(level: level, delayTime: animateDelayTime + touchDelayTime)
            }
        }
        
        animator.startAnimation()
    }
    
    /// 隱藏訊息
    /// - Parameters:
    ///   - delayTime: TimeInterval
    ///   - completion: ((UIViewAnimatingPosition) -> Void)?
    func dismiss(animatorDuration: TimeInterval, afterDelay afterDelay: TimeInterval, Sendable completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        
        let dismissAnimator = UIViewPropertyAnimator(duration: animatorDuration, curve: .easeInOut) { [unowned self] in
            frame = dismissFrame
        }
        
        dismissAnimator.addCompletion { completion?($0) }
        dismissAnimator.startAnimation(afterDelay: afterDelay)
        
        self.dismissAnimator = dismissAnimator
    }
    
    /// 在非動畫時間的點擊處理 => 延遲動畫執行
    /// - Parameters:
    ///   - level: WWMessageBar.Level
    ///   - delayTime: TimeInterval
    func touchAction(level: WWMessageBar.Level, delayTime: TimeInterval) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) { [unowned self] in
            
            dismiss(animatorDuration: animateDelayTime, afterDelay: animateDelayTime) { dismissPosition in
                
                if (messageQueue.isEmpty) { return }
                
                messageQueue.removeFirst()
                isDisplay = false
                displayText(level: level)
            }
        }
    }
}
