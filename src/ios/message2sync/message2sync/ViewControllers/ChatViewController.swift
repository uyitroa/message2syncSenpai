//
//  ChatViewController.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate  {
	
	// MARK: Properties
	var textviews = [UITextView]()
	let messageManager = MessageManager()
	
	let textfield = TextField()
	let scrollView = UIScrollView()
	let scrollKeyboard = UIScrollView()
	
	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	
	var keyboardHidden = true
	var keyboardSize = CGFloat()
	
	// MARK: private function
	private func getPath() -> [CChar] {
		let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
		var parsed = homeDirURL.absoluteString.replacingOccurrences(of: "file://", with: "")
		parsed += "/Documents/lines.txt"
		return parsed.cString(using: .utf8)!
	}
	
	private func addTextView(_ text : String) {
		let message = Message("\n" + text, 0, messageManager.staticHeight)
		messageManager.staticHeight += Int(message.textview.frame.height)
		
		scrollView.contentSize.height = CGFloat(messageManager.staticHeight)
		scrollView.contentOffset.y += message.textview.frame.height
		messageManager.messages.append(message)
		self.scrollView.addSubview(message.textview)
	}
	
	private func sendRequest(_ keyboardText: UITextField) {
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
	
	// MARK: setup functions
	private func setupTextview() {
		for message in messageManager.messages {
			self.scrollView.addSubview(message.textview)
		}
		scrollView.contentSize.height = CGFloat(messageManager.staticHeight)
		scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - screenHeight * 0.8)
	}
	
	private func setupScrollview() {
		// Do any additional setup after loading the view, typically from a nib.
		
		scrollView.frame = CGRect(x: 0, y: screenHeight * 0.05, width: screenWidth, height: screenHeight * 0.8)
		scrollView.contentSize = CGSize(width: screenWidth, height: 0)
		
		scrollKeyboard.frame = CGRect(x: 0, y: screenHeight * 0.8, width: screenWidth, height: screenHeight * 0.5)
		scrollKeyboard.contentSize = CGSize(width: screenWidth, height: 0)
	}
	
	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
	}
	
	
	// MARK: public functions
	func rmSubview() {
		self.view.removeFromSuperview()
	}
	
	func swipeRight() {
		UIView.animate(withDuration: 0.1) {
			self.view.frame.origin.x = self.view.frame.width * 0.3
		}
	}
	
	func swipeLeft() {
		UIView.animate(withDuration: 0.1) {
			self.view.frame.origin.x = 0
		}
	}
	
	
	
	// MARK: viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		textfield.sampleTextField.delegate = self
		
		setupScrollview()
		setupTextview()
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
			keyboardSize = keyboardHeight
			self.view.frame.origin.y = -keyboardHeight
			scrollView.frame = CGRect(x: 0, y: screenHeight * 0.05 + keyboardHeight, width: screenWidth, height: screenHeight * 0.8 - keyboardHeight)
			scrollView.contentOffset.y += keyboardHeight
			self.keyboardHidden = false
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		self.view.frame.origin.y = 0
		scrollView.frame = CGRect(x: 0, y: screenHeight * 0.05, width: screenWidth, height: screenHeight * 0.8)
		//		scrollView.contentOffset.y -= keyboardSize
		self.keyboardHidden = true
	}
	
}
