//
//  ViewController.swift
//  message2sync
//
//  Created by yuitora . on 20/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import UIKit


extension DispatchQueue {
	
	static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
		DispatchQueue.global(qos: .background).async {
			background?()
			if let completion = completion {
				DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
					completion()
				})
			}
		}
	}
}

class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: viewcontrollers
	let chatVC = ChatViewController()
	let settingMenuVC = MenuTableViewController()
	var barHeight = 0
	var swipeRight: UISwipeGestureRecognizer!
	var swipeLeft: UISwipeGestureRecognizer!
	
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
	private func setupGesture() {
		swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.moveChat(_:)))
		swipeRight.direction = .right
		
		swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.moveChat(_:)))
		swipeLeft.direction = .left
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		
		setupGesture()
		self.view.addSubview(settingMenuVC.view)
		self.view.addSubview(chatVC.view)
		self.view.addGestureRecognizer(swipeRight)
		self.view.addGestureRecognizer(swipeLeft)
	}
	
	// MARK: action
	@objc func menuButtonTrigger() {
		if settingOpened {
			settingOpened = false
			chatVC.swipeLeft()
		} else {
			settingOpened = true
			chatVC.swipeRight()
		}
	}
	
	@objc func moveChat(_ gesture: UISwipeGestureRecognizer) {
		if gesture.direction == UISwipeGestureRecognizer.Direction.right {
			chatVC.swipeRight()
			settingOpened = true
		}

		if gesture.direction == UISwipeGestureRecognizer.Direction.left {
			chatVC.swipeLeft()
			settingOpened = false
		}
	}
}
