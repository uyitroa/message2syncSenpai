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
	let normalWidth = UIScreen.main.bounds.width * 0.9
	let normalHeight = UIScreen.main.bounds.height * 0.9
	
	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	init() {
		manager = Manager()
	}
	
	func setupTextView(_ textview: inout UITextView, _ text: String, _ x: Int, _ y: Int) {
		// CGRectMake has been deprecated - and should be let, not var
		textview.isScrollEnabled = false
//		let fixedWidth = UIScreen.main.bounds.width
//		let newSize = textview.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//		textview.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		textview.translatesAutoresizingMaskIntoConstraints = true
		textview.font = UIFont.preferredFont(forTextStyle: .footnote)
		textview.textColor = .black
		textview.center = CGPoint(x: 0, y: y)
		textview.textAlignment = .center
		textview.isEditable = false
		textview.text = text
		let fixedWidth = UIScreen.main.bounds.width
		let newSize = textview.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		textview.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
	}
	
	func createTextView() -> [UITextView] {
		let lines = manager.getRelevantLines()
		var mytextviews = [UITextView]()
		var y = 0
		for index in stride(from: lines.count - 1, to: 0, by: -1) {
			var textview = UITextView()
			setupTextView(&textview, lines[index], 0, y)
			mytextviews.append(textview)
			y += Int(textview.frame.height)
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
		
		let y = normalHeight
		let x = screenWidth/2
		sampleTextField.center = CGPoint(x: x, y: y)
		return sampleTextField
	}
}

