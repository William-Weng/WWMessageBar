//
//  MessageBarViewController.swift
//  WWMessageBar
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit

// MARK: - MessageBar主畫面
final class MessageBarViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - 公用函式
extension MessageBarViewController {
    
    /// 畫面顯示相關設定
    /// - Parameter info: WWMessageBar.MessageInformation
    func setting(info: WWMessageBar.MessageInformation) {
        
        titleLabel.isHidden = true
        
        if let title = info.title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        messageLabel.text = info.message
        iconImageView.image = info.level.icon()
        view.backgroundColor = info.level.backgroundColor()
    }
}

// MARK: - 小工具
private extension MessageBarViewController {
    
    /// 設定最小高度 (StatusBar)
    func initSetting() {
        guard let statusBarManager = UIStatusBarManager._build() else { return }
        statusBarHeightConstraint.constant = statusBarManager.statusBarFrame.height
    }
}
