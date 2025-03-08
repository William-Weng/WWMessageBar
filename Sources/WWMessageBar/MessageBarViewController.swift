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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchesBeganAction(touches, with: event)
    }
}

// MARK: - 公用函式
extension MessageBarViewController {
    
    /// 畫面顯示相關設定
    /// - Parameters:
    ///   - info: WWMessageBar.MessageInformation
    func setting(with info: WWMessageBar.MessageInformation) {
        
        self.info = info
        titleLabel.isHidden = true
        messageLabel.text = info.message
        
        if let title = info.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        iconImageBackView.layer.cornerRadius = iconImageBackView.frame.width * 0.5
        configure(barType: barType, level: info.level)
    }
}

// MARK: - 小工具
private extension MessageBarViewController {
    
    /// 設定最小高度 (StatusBar)
    func initSetting() {
        guard let statusBarManager = UIStatusBarManager._build() else { return }
        statusBarHeightConstraint.constant = statusBarManager.statusBarFrame.height
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
    
    /// 被點到時的反應
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func touchesBeganAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let messageBar = messageBar else { return }
        messageBar.delegate?.messageBar(messageBar, didTouched: info)
    }
}
