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

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		view.backgroundColor = .white

		textviews = message.createTextView()
		
		textField = message.createTextField()
		textField.delegate = self
		
		for textview in textviews {
			self.view.addSubview(textview)
		}
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
		message.setupTextView(&textview, text, 0, Int(UIScreen.main.bounds.height * 0.8))
		for element in textviews {
			element.center.y -= 50
		}
		textviews.append(textview)
		self.view.addSubview(textview)
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
		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardRectangle = keyboardFrame.cgRectValue
			let keyboardHeight = keyboardRectangle.height
			self.view.frame.origin.y -= keyboardHeight
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		self.view.frame.origin.y = 0
	}

}

