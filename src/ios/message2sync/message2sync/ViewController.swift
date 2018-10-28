//
//  ViewController.swift
//  message2sync
//
//  Created by yuitora . on 20/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: viewcontrollers
	let chatVC = ChatViewController()
	let settingMenuVC = MenuViewController()
	
	// MARK: properties
	var settingOpened = false
	
	// MARK: setup
	private func setupNavigationBar() {
		let menuButton = UIButton(type: .system)
		menuButton.addTarget(self, action: #selector(ViewController.menuButtonTrigger), for: .touchUpInside)
		menuButton.setImage(UIImage(named: "button")?.withRenderingMode(.alwaysOriginal), for: .normal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
	}
	
	// MARK: viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		self.view.addSubview(chatVC.view)
	}
	
	// MARK: action
	@objc func menuButtonTrigger() {
		if settingOpened {
			settingOpened = false
			settingMenuVC.rmSubview()
		} else {
			settingOpened = true
			self.view.addSubview(settingMenuVC.view)
		}
	}
}

