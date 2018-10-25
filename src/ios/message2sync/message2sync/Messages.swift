//
//  Messages.swift
//  testboi
//
//  Created by yuitora . on 24/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import Foundation
import UIKit

class Messages {
	let manager: Manager
	init() {
		manager = Manager()
	}
	
	func setupTextView(_ textview: inout UITextView, _ text: String, _ x: Int, _ y: Int) {
		// CGRectMake has been deprecated - and should be let, not var
		textview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 30)
		textview.font = UIFont.preferredFont(forTextStyle: .footnote)
		textview.textColor = .black
		textview.center = CGPoint(x: Int(UIScreen.main.bounds.width / 2), y: y)
		textview.textAlignment = .center
		textview.isEditable = false
		
		textview.text = text
	}
	
	func createTextView() -> [UITextView] {
		let lines = manager.getRelevantLines()
		var mytextviews = [UITextView]()
		var y = Int(UIScreen.main.bounds.height * 0.9)
		for text in lines {
			var textview = UITextView()
			setupTextView(&textview, text, 0, y)
			mytextviews.append(textview)
			y -= 50
		}
		
		return mytextviews
	}
	
	func createTextField() -> UITextField {
		let sampleTextField =  UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: 30))
		sampleTextField.placeholder = "Enter text here"
		sampleTextField.font = UIFont.systemFont(ofSize: 15)
		sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
		sampleTextField.autocorrectionType = UITextAutocorrectionType.no
		sampleTextField.keyboardType = UIKeyboardType.default
		sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing;
		sampleTextField.enablesReturnKeyAutomatically = true
		
		let y = UIScreen.main.bounds.height * 0.9
		let x = UIScreen.main.bounds.width/2
		sampleTextField.center = CGPoint(x: x, y: y)
		return sampleTextField
	}
}

