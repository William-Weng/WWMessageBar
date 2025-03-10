//
//  MessageBarViewController.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit

// MARK: - MessageBar主畫面
final class MessageBarViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var iconImageBackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    var messageBar: WWMessageBar?
    var barType: WWMessageBar.BarType = .message
    
    private let textColor = UIColor.white
    
    private(set) var info: WWMessageBar.MessageInformation?
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        initSetting()
    }
}

// MARK: - @objc
@objc extension MessageBarViewController {
    
    func tapGestureAction(_ tap: UITapGestureRecognizer) { tapAction() }
    func swipeGestureAction(_ swipe: UISwipeGestureRecognizer) { swipeAction(swipe) }
}

// MARK: - 公用函式
extension MessageBarViewController {
    
    /// 畫面顯示相關設定
    /// - Parameters:
    ///   - info: WWMessageBar.MessageInformation
    func setting(with info: WWMessageBar.MessageInformation) {
        
        self.info = info
        titleLabel.alpha = 0.0
        messageLabel.text = info.message
        
        if let title = info.title {
            titleLabel.text = title
            titleLabel.alpha = 1.0
        }
        
        iconImageBackView.layer.cornerRadius = iconImageBackView.frame.width * 0.5
        configure(barType: barType, level: info.level)
    }
}

// MARK: - 小工具
private extension MessageBarViewController {
    
    /// 初始化設定
    func initSetting() {
        initStatusBarHeight()
        initGestureSetting()
    }
    
    /// 設定最小高度 (StatusBar)
    func initStatusBarHeight() {
        guard let statusBarManager = UIStatusBarManager._build(for: view.window) else { return }
        statusBarHeightConstraint.constant = statusBarManager.statusBarFrame.height
    }
    
    /// 初始化手勢功能
    func initGestureSetting() {
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(tapGestureAction))
        let swipeUp = UISwipeGestureRecognizer(target:self, action:#selector(swipeGestureAction))
        let swipeDown = UISwipeGestureRecognizer(target:self, action:#selector(swipeGestureAction))

        swipeUp.direction = .up
        swipeDown.direction = .down
        
        view._addGestureRecognizers([tap, swipeUp, swipeDown])
    }
    
    /// 外框樣式設定
    /// - Parameters:
    ///   - barType: 外框樣式
    ///   - icon: 圖示
    ///   - tintColor: 主色系
    func configure(barType: WWMessageBar.BarType, level: WWMessageBar.Level) {
        
        var tintColor = level.tintColor()
        var icon = level.icon()
        var textColor = self.textColor

        if let messageBar, let settings = messageBar.delegate?.levelSettings(messageBar: messageBar), let setting = settings[level] {
            textColor = setting.fontColor ?? textColor
            tintColor = setting.tintColor ?? tintColor
            icon = setting.icon ?? icon
        }
        
        iconView.backgroundColor = .clear
        messageView.backgroundColor = .clear
        view.backgroundColor = .clear
        
        iconImageView.image = icon
        iconImageBackView.tintColor = tintColor
        titleLabel.textColor = textColor
        messageLabel.textColor = textColor
        
        switch barType {
        case .message:
            view.backgroundColor = tintColor
        case .notification:
            iconView.backgroundColor = tintColor
            messageView.backgroundColor = tintColor
        }
    }
    
    /// 被點到後的動作處理
    func tapAction() {
        
        guard let messageBar = messageBar,
              let info = info
        else {
            return
        }
        
        messageBar.delegate?.messageBar(messageBar, didTouched: info)
    }
    
    /// 單指滑動的動作處理
    /// - Parameter swipe: UISwipeGestureRecognizer
    func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        
        guard let messageBar = messageBar else { return }
        
        switch swipe.direction {
        case .up: messageBar.dismiss()
        case .down: messageBar.removeDismissAnimation()
        case .left, .right: break
        default: fatalError()
        }
    }
}
