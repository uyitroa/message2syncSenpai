//
//  SettingViewController.swift
//  message2sync
//
//  Created by yuitora . on 30/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {
	
	let xServerField = 0
	let yServerField = UIScreen.main.bounds.height * 0.2
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let textfield = TextField(placeholder: "Enter server address here",
						x: Float(xServerField), y: Float(yServerField))
		textfield.sampleTextField.delegate = self
		self.view.addSubview(textfield.sampleTextField)
	}
	
	func rmSubview() {
		self.view.removeFromSuperview()
	}
}
