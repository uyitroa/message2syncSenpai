//
//  TextField.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import Foundation
import UIKit

class TextField {
	let screenHeight = UIScreen.main.bounds.height
	let screenWidth = UIScreen.main.bounds.width
	
	var sampleTextField = UITextField()
	init(placeholder: String, x: Int, y: Int) {
		self.createTextField(placeholder: placeholder, x: x, y: y)
	}
	
	func createTextField(placeholder: String, x: Int, y: Int) {
		sampleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 30))
		sampleTextField.placeholder = placeholder
		sampleTextField.font = UIFont.systemFont(ofSize: 15)
		sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
		sampleTextField.autocorrectionType = UITextAutocorrectionType.no
		sampleTextField.keyboardType = UIKeyboardType.default
		sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
		sampleTextField.enablesReturnKeyAutomatically = true
		sampleTextField.autocapitalizationType = .none
		sampleTextField.smartQuotesType = .no
		
//		let y = screenHeight * 0.9
//		let x = screenWidth/2
		sampleTextField.center = CGPoint(x: x, y: y)
	}
}
