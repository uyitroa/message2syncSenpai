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

	//MARK: Properties
	var textField = UITextField()
	var textviews = [UITextView]()
	let message = Messages()
	let scrollView = UIScrollView()

	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	
	var keyboardHidden = true
	var keyboardSize = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		scrollView.frame = CGRect(x: 0, y: screenHeight * 0.025,width: screenWidth,height: screenHeight * 0.85)
		scrollView.contentSize = CGSize(width: screenWidth,height: 0)
		scrollView.keyboardDismissMode = .onDrag
		
		view.backgroundColor = .white

		textviews = message.createTextView()

		textField = message.createTextField()
		textField.delegate = self
		
		for textview in textviews {
			self.scrollView.addSubview(textview)
			scrollView.contentSize.height += textview.frame.height
		}
		scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - screenHeight * 0.8)
		self.view.addSubview(scrollView)
		self.view.addSubview(textField)
		
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
		
	}
	
	func getPath() -> [CChar] {
		let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
		var parsed = homeDirURL.absoluteString.replacingOccurrences(of: "file://", with: "")
		parsed += "Documents/lines.txt"
		return parsed.cString(using: .utf8)!
	}

	func addTextView(_ text : String) {
		var textview = UITextView()
		message.setupTextView(&textview, text, 0, message.staticHeight)
		message.staticHeight += Int(textview.frame.height)
		
		scrollView.contentSize.height += textview.frame.height
		scrollView.contentOffset.y += textview.frame.height

		textviews.append(textview)
		self.scrollView.addSubview(textview)
	}

	func sendRequest(_ textField: UITextField) {
		let cchar = textField.text!.cString(using: .utf8)
		let cpath = getPath()
		addTextView("You: " + textField.text!)

		var response = String()
		DispatchQueue.background(background: {
			response = String(cString: sendGetRequest(cchar, cpath))
		}, completion:{
			self.addTextView("Computer: " + response)
		})

		textField.text = ""
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		sendRequest(textField)
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		sendRequest(textField)
	}
	
	
	@objc func keyboardWillShow(_ notification: Notification) {
		if let localFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardRectangle = localFrame.cgRectValue
			let keyboardHeight = keyboardRectangle.height
			self.view.frame.origin.y = -keyboardHeight
			self.keyboardHidden = false
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		self.view.frame.origin.y = 0
		self.keyboardHidden = true
	}

}

