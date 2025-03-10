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
    private var dismissWorkItem = DispatchWorkItem {}
    
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
    ///   - animateDelayTime: TimeInterval
    ///   - dismissDelayTime: TimeInterval
    func configure(height: CGFloat, barType: WWMessageBar.BarType, animateDelayTime: TimeInterval, touchDelayTime: TimeInterval) {
        
        self.height = height
        self.animateDelayTime = animateDelayTime
        self.touchDelayTime = touchDelayTime
        
        messageBarViewController?.barType = barType
    }
    
    /// 顯示文字
    /// - Parameters:
    ///   - title: String?
    ///   - message: T
    ///   - level: WWMessageBar.Level
    ///   - tag: String?
    func display<T>(title: String? = nil, message: T, level: WWMessageBar.Level, tag: String?) {
        messageQueue.append(WWMessageBar.MessageInformation(title: title, message: "\(message)", level: level, tag: tag))
        displayText()
    }
    
    /// 隱藏訊息
    /// - Parameters:
    ///   - completion: ((UIViewAnimatingPosition) -> Void)?
    func dismiss(completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        removeDismissAnimation()
        dismissAction()
    }
    
    /// 把WWMessageBar帶過來 => 統一由WWMessageBar處理
    /// - Parameter messageBar: WWMessageBar
    func messageBarSetting(_ messageBar: WWMessageBar) {
        messageBarViewController?.messageBar = messageBar
    }
    
    /// 移除Dismiss動畫
    func removeDismissAnimation() {
        dismissWorkItem.cancel()
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
    
    /// 顯示訊息 => 延遲 (畫面可點擊) => 隱藏訊息
    func displayText() {
        
        guard !isDisplay,
              let info = messageQueue.first
        else {
            return
        }
        
        isDisplay = true
        messageBarViewController?.setting(with: info)
                
        let animator = UIViewPropertyAnimator(duration: animateDelayTime, curve: .easeInOut) { [unowned self] in frame = displayFrame }
        
        animator.addCompletion { [unowned self] displayPosition in
            
            switch displayPosition {
            case .start: break
            case .current: break
            case .end:
                dismissWorkItem = DispatchWorkItem { dismissAction() }
                DispatchQueue.main.asyncAfter(deadline: .now() + animateDelayTime + touchDelayTime, execute: dismissWorkItem)
            }
        }
        
        animator.startAnimation()
    }
    
    /// 隱藏訊息的相關動作
    func dismissAction() {
        
        dismiss(animatorDuration: animateDelayTime, afterDelay: animateDelayTime) { [unowned self] dismissPosition in
            
            if (messageQueue.isEmpty) { return }
            
            messageQueue.removeFirst()
            isDisplay = false
            displayText()
        }
    }
    
    /// 隱藏訊息
    /// - Parameters:
    ///   - delayTime: TimeInterval
    ///   - animatorDuration: TimeInterval
    ///   - afterDelay: TimeInterval
    ///   - completion: ((UIViewAnimatingPosition) -> Void)?
    /// - Returns: UIViewPropertyAnimator
    func dismiss(animatorDuration: TimeInterval, afterDelay afterDelay: TimeInterval, completion: ((UIViewAnimatingPosition) -> Void)? = nil) -> UIViewPropertyAnimator {
        
        let dismissAnimator = UIViewPropertyAnimator(duration: animatorDuration, curve: .easeInOut) { [unowned self] in frame = dismissFrame }
        
        dismissAnimator.addCompletion { [unowned self] in isDisplay = false; completion?($0) }
        dismissAnimator.startAnimation(afterDelay: afterDelay)
                
        return dismissAnimator
    }
}
