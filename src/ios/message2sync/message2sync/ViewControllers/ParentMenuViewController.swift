//
//  ParentSettingViewController.swift
//  message2sync
//
//  Created by yuitora . on 30/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import UIKit

class ParentMenuViewController: UIViewController, UITextFieldDelegate {
	
	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	let menuView = UIView()
	
	private func setupView() {
		menuView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
		menuView.backgroundColor = .white
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(menuView)
	}
	
	func rmSubview() {
		self.view.removeFromSuperview()
	}
}
