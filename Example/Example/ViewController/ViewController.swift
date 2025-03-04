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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWMessageBar.shared.configure(delegate: self)
    }
    
    @IBAction func displayMessage(_ sender: UIButton) {
        WWMessageBar.shared.display(message: Date(), level: .debug)
        WWMessageBar.shared.display(title: "info", message: Date(), level: .info)
        WWMessageBar.shared.display(message: Date(), level: .notice)
        WWMessageBar.shared.display(message: Date(), level: .critical)
        WWMessageBar.shared.display(title: "warning", message: Date(), level: .warning)
    }
}

// MARK: - WWMessageBar.Delegate
extension ViewController: WWMessageBar.Delegate {
 
    func messageBar(_ messageBar: WWMessageBar, didTouched info: WWMessageBar.MessageInformation?) {
        print(info)
    }
}
