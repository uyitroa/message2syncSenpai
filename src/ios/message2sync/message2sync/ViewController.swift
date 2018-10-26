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
	var currentVelocity = 0

	let scrollView = UIScrollView()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		scrollView.frame = CGRect(x: 0, y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height * 0.85)
		scrollView.contentSize = CGSize(width: self.view.frame.size.width ,height: 0)
		
		view.backgroundColor = .white

		textviews = message.createTextView()

		textField = message.createTextField()
		textField.delegate = self
		
		for textview in textviews {
			self.scrollView.addSubview(textview)
			scrollView.contentSize.height += textview.frame.height
		}
		scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - self.view.frame.height + self.view.frame.height * 0.2)
		self.view.addSubview(scrollView)
		self.view.addSubview(textField)
		
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: self.view.window)
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: self.view.window)
		
//		pan.addTarget(self, action: #selector(ViewController.handlePan))
//		self.view.addGestureRecognizer(pan)
	}
	
	func getPath() -> [CChar] {
		let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
		var parsed = homeDirURL.absoluteString.replacingOccurrences(of: "file://", with: "")
		parsed += "Documents/lines.txt"
		return parsed.cString(using: .utf8)!
	}

	func addTextView(_ text : String) {
		var textview = UITextView()
		let reference = textviews[textviews.count - 1]
		message.setupTextView(&textview, text, 0, Int(scrollView.contentSize.height))
		textviews.append(textview)
		scrollView.contentSize.height += reference.frame.height
		scrollView.contentOffset.y += reference.frame.height
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
		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardRectangle = keyboardFrame.cgRectValue
			let keyboardHeight = keyboardRectangle.height
			self.view.frame.origin.y -= keyboardHeight
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		self.view.frame.origin.y = 0
	}
	
//	func scrollTextView(velocity: CGFloat) {
//		for textview in textviews {
//			textview.center.y += velocity
//		}
//	}
//	@objc func handlePan(sender: UIPanGestureRecognizer) {
//		if sender.state == .changed {
//			let velocity = sender.velocity(in: self.view)
//			if textviews[0].center.y + velocity.y/10 >= message.normalHeight - 50 {
//				scrollTextView(velocity: velocity.y/10)
//				currentVelocity = Int(velocity.y/10)
//			}
//		} else if sender.state == .ended {
//			UIView.animate(withDuration: TimeInterval(currentVelocity/100), animations: {
//				self.currentVelocity -= self.currentVelocity/100
//				if Int(self.textviews[0].center.y) + self.currentVelocity/10 >= Int(self.message.normalHeight - 50) {
//					self.scrollTextView(velocity: CGFloat(self.currentVelocity/10))
//				}
//
//				if sender.state == .began {
//					return
//				}
//			})
//		}
//	}

}

