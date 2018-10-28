//
//  Messages.swift
//  testboi
//
//  Created by yuitora . on 24/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import Foundation
import UIKit

class Message {
	let normalWidth = UIScreen.main.bounds.width * 0.9
	let normalHeight = UIScreen.main.bounds.height * 0.9
	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	
	let textview = UITextView()
	init(_ text: String, _ x: Int, _ y: Int) {
		setupTextView(text, x, y)
	}
	
	func setupTextView(_ text: String, _ x: Int, _ y: Int) {
		textview.isScrollEnabled = false
		textview.font = UIFont.preferredFont(forTextStyle: .footnote)
		textview.textColor = .black
		textview.textAlignment = .center
		textview.isEditable = false
		textview.text = text
		textview.center = CGPoint(x: 0, y: y)
		let fixedWidth = UIScreen.main.bounds.width
		let newSize = textview.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		textview.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
	}
}

