//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/3/3.
//

import UIKit
import WWMessageBar

// MARK: - ViewController
final class ViewController: UIViewController {
    
    private var levelIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWMessageBar.shared.delegate = self
    }
    
    @IBAction func displayMessage(_ sender: UIButton) {
        WWMessageBar.shared.display(message: Date(), level: messageLevel())
        levelIndex += 1
    }
    
    @IBAction func displayNotification(_ sender: UIButton) {
        WWMessageBar.shared.configure(barType: .notification)
        WWMessageBar.shared.display(title: "Notification", message: Date(), level: messageLevel(), tag: "[Notification]")
        levelIndex += 1
    }
    
    func messageLevel() -> WWMessageBar.Level {
        
        let levels = WWMessageBar.Level.allCases
        if levelIndex > levels.count - 1 { levelIndex = 0 }
        
        return levels[levelIndex]
    }
}

// MARK: - WWMessageBar.Delegate
extension ViewController: WWMessageBar.Delegate {
    
    func messageBar(_ messageBar: WWMessageBar, didTouched info: WWMessageBar.MessageInformation) {
        print(info)
    }
    
    func levelSettings(messageBar: WWMessageBar) -> [WWMessageBar.Level : WWMessageBar.LevelSetting]? {
        return [
            .debug: (icon: UIImage(systemName: "arrow.up.circle"), tintColor: .lightGray, fontColor: .red),
            .critical: (icon: UIImage(named: "ちいかわ"), tintColor: .magenta, fontColor: .black),
        ]
    }
}
