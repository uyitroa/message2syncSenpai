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

	// MARK: Properties
	var textField = UITextField()
	var textviews = [UITextView]()
	let messageManager = MessageManager()
	let textfield = TextField()
	let scrollView = UIScrollView()
	let scrollKeyboard = UIScrollView()

	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	
	var keyboardHidden = true
	var keyboardSize = 0
	
	// MARK: private function
	fileprivate func setupTextview() {
		for message in messageManager.mytextviews {
			self.scrollView.addSubview(message.textview)
			scrollView.contentSize.height += message.textview.frame.height
		}
	}

	fileprivate func setupScrollview() {
		// Do any additional setup after loading the view, typically from a nib.
		
		scrollView.frame = CGRect(x: 0, y: screenHeight * 0.025, width: screenWidth, height: screenHeight * 0.85)
		scrollView.contentSize = CGSize(width: screenWidth, height: 0)
		
		scrollKeyboard.frame = CGRect(x: 0, y: screenHeight * 0.8, width: screenWidth, height: screenHeight * 0.5)
		scrollKeyboard.contentSize = CGSize(width: screenWidth, height: 0)
	}
	
	fileprivate func getPath() -> [CChar] {
		let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
		var parsed = homeDirURL.absoluteString.replacingOccurrences(of: "file://", with: "")
		parsed += "Documents/lines.txt"
		return parsed.cString(using: .utf8)!
	}
	
	fileprivate func addTextView(_ text : String) {
		let message = Message(text, 0, messageManager.staticHeight)
		messageManager.staticHeight += Int(message.textview.frame.height)
		
		scrollView.contentSize.height += message.textview.frame.height
		scrollView.contentOffset.y += message.textview.frame.height
		
		messageManager.mytextviews.append(message)
		self.scrollView.addSubview(message.textview)
	}
	
	fileprivate func sendRequest(_ keyboardText: UITextField) {
		let cchar = keyboardText.text!.cString(using: .utf8)
		let cpath = getPath()
		addTextView("You: " + keyboardText.text!)
		
		var response = String()
		DispatchQueue.background(background: {
			response = String(cString: sendGetRequest(cchar, cpath))
		}, completion:{
			self.addTextView("Computer: " + response)
		})
		
		keyboardText.text = ""
	}
	
	fileprivate func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
	}
	
	
	// MARK: viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupScrollview()
		
		
		view.backgroundColor = .white
		textfield.sampleTextField.delegate = self
		
		setupTextview()
		scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - screenHeight * 0.8)
		
		
		setupKeyboard()
		
		
		self.view.addSubview(scrollKeyboard)
		self.view.addSubview(scrollView)
		self.view.addSubview(textfield.sampleTextField)
		
	}
	

	// MARK: Actions
	func textFieldShouldReturn(_ keyboardText: UITextField) -> Bool {
		sendRequest(keyboardText)
		return true
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

