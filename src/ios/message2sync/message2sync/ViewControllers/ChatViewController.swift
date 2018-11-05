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
	var messageManager: MessageManager!

	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	
	let textfield = TextField(placeholder: "Enter text here",
					x: Int(UIScreen.main.bounds.width/2), y: Int(UIScreen.main.bounds.height * 0.9))
	let scrollView = UIScrollView()
	let scrollKeyboard = UIScrollView()
	
	var keyboardHidden = true
	var keyboardSize = CGFloat()
	
	var detaPointer: UnsafeMutableRawPointer!
	
	var server: String!
	
	// MARK: function
	func getPath() -> [CChar] {
		let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
		var parsed = homeDirURL.absoluteString.replacingOccurrences(of: "file://", with: "")
		parsed += "/Documents/message2sync.db"
		return parsed.cString(using: .utf8)!
	}
	
	func addTextView(_ text : String) {
		writeLine(detaPointer, text, server)

		let message = Message("\n" + text, 0, messageManager.staticHeight)
		messageManager.staticHeight += Int(message.textview.frame.height)
		
		scrollView.contentSize.height = CGFloat(messageManager.staticHeight)
		scrollView.contentOffset.y += message.textview.frame.height
		messageManager.messages.append(message)
		self.scrollView.addSubview(message.textview)
	}
	
	func sendRequest(_ keyboardText: UITextField) {
		let cchar = keyboardText.text!.cString(using: .utf8)
		let cpath = getPath()
		addTextView("You: " + keyboardText.text!)
		
		var response = String()
		DispatchQueue.background(background: {
			response = String(cString: sendGetRequest(cchar, cpath, self.server.cString(using: .utf8)))
		}, completion:{
			self.addTextView("Computer: " + response)
		})
		
		keyboardText.text = ""
	}

	// MARK: setup functions
	func setupTextview() {
		for message in messageManager.messages {
			self.scrollView.addSubview(message.textview)
		}
		scrollView.contentSize.height = CGFloat(messageManager.staticHeight)
		scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - screenHeight * 0.8)
	}
	
	func setupScrollview() {
		// Do any additional setup after loading the view, typically from a nib.
		
		scrollView.frame = CGRect(x: 0, y: screenHeight * 0.05, width: screenWidth, height: screenHeight * 0.8)
		scrollView.contentSize = CGSize(width: screenWidth, height: 0)
		
		scrollKeyboard.frame = CGRect(x: 0, y: screenHeight * 0.8, width: screenWidth, height: screenHeight * 0.5)
		scrollKeyboard.contentSize = CGSize(width: screenWidth, height: 0)
	}
	
	func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
		NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
	}
	
	fileprivate func setupDeta() {
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent("message2sync.db")
			print(fileURL.absoluteString)
			detaPointer = UnsafeMutableRawPointer(mutating: initializeDeta(fileURL.absoluteString.cString(using: .utf8)))
			messageManager = MessageManager(server: server)
		}
	}
	
	
	// MARK: public functions
	func rmSubview() {
		self.view.removeFromSuperview()
	}
	
	func swipeRight() {
		UIView.animate(withDuration: 0.1) {
			self.view.frame.origin.x = self.view.frame.width * 0.5
		}
	}
	
	func swipeLeft() {
		UIView.animate(withDuration: 0.1) {
			self.view.frame.origin.x = 0
		}
	}
	
	
	
	convenience init(server: String) {
		self.init(nibName: nil, bundle: nil)
		self.server = server
	}
	
	// MARK: viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		textfield.sampleTextField.delegate = self
		setupDeta()
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
