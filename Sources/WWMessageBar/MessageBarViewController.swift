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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    var barType: WWMessageBar.BarType = .message
    
    private(set) var info: WWMessageBar.MessageInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
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
        
        if let title = info.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        messageLabel.text = info.message
        iconImageView.image = info.level.icon()
        
        configure(barType: barType, backgroundColor: info.level.backgroundColor())
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
    ///   - backgroundColor: 背景色
    func configure(barType: WWMessageBar.BarType, backgroundColor: UIColor) {
        
        switch barType {
        case .message:
            iconView.backgroundColor = .clear
            messageView.backgroundColor = .clear
            view.backgroundColor = backgroundColor
        case .notification:
            iconView.backgroundColor = backgroundColor
            messageView.backgroundColor = backgroundColor
            view.backgroundColor = .clear
        }
    }
}
