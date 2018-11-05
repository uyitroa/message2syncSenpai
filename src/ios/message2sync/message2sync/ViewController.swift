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

extension UIView {
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
}

extension UIViewController {
	@objc func load(input: String) {
		print(input)
	}
}



class ViewController: UIViewController, UITextFieldDelegate {
	
	// MARK: viewcontrollers
	var chatVC = [ChatViewController]()
	var chatServer = [String]()
	
	var settingMenuVC: MenuTableViewController!
	var detaPointer: UnsafeMutableRawPointer!
	
	var barHeight = 0
	var swipeRight: UISwipeGestureRecognizer!
	var swipeLeft: UISwipeGestureRecognizer!
	
	// MARK: properties
	var currentIndex = 0
	private final let MENUTABLEVIEWCONTROLLER = "0"
	var settingOpened = false
	
	
	private func convertToString(cString: UnsafePointer<Int8>) -> String {
		let string = String(cString: cString)
		freeChar(cString)
		return string
	}
	
	private func getPath() -> [CChar] {
		let homeDirURL = URL(fileURLWithPath: NSHomeDirectory())
		var parsed = homeDirURL.absoluteString.replacingOccurrences(of: "file://", with: "")
		parsed += "/Documents/message2sync.db"
		return parsed.cString(using: .utf8)!
	}
	
	// MARK: setup
	private func setupNavigationBar() {
		let menuButton = UIButton(type: .system)
		menuButton.addTarget(self, action: #selector(ViewController.menuButtonTrigger), for: .touchUpInside)
		menuButton.setImage(UIImage(named: "button")?.withRenderingMode(.alwaysOriginal), for: .normal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
	}
	
	// MARK: viewDidLoad
	private func setupGesture() {
		swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.moveChat(_:)))
		swipeRight.direction = .right
		
		swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.moveChat(_:)))
		swipeLeft.direction = .left
	}
	
	private func setupChatVC() {
		let lastserver = convertToString(cString: getLastServer(detaPointer))
		chatVC.append(ChatViewController(server: lastserver))
		chatServer.append(lastserver)
		self.view.addSubview(chatVC[0].view)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		detaPointer = UnsafeMutableRawPointer(mutating: initializeDeta(getPath()))
		settingMenuVC = MenuTableViewController()
		setupNavigationBar()
		setupGesture()
		setupChatVC()
		self.view.addSubview(settingMenuVC.view)
		self.view.addGestureRecognizer(swipeRight)
		self.view.addGestureRecognizer(swipeLeft)
	}
	
	
	// Custom function

	@objc override func load(input: String) {
		let myArray = input.split(separator: ":")
		if myArray[0] == MENUTABLEVIEWCONTROLLER {
			doMenuVC(input: myArray)
		}
		
	}
	
	func doMenuVC(input: [String.SubSequence]) {
		if input[1] == "change server to" {
			chatVC[currentIndex].rmSubview()
			if let stringIndex = chatServer.firstIndex(where: { $0 == String(input[2])}) {
				currentIndex = stringIndex
			} else {
				chatVC.append(ChatViewController(server: String(input[2])))
				currentIndex = chatVC.count - 1
			}
			self.view.addSubview(chatVC[currentIndex].view)
		}
	}
	
	// MARK: action
	@objc func menuButtonTrigger() {
		if settingOpened {
			settingOpened = false
			chatVC[currentIndex].swipeLeft()
		} else {
			settingOpened = true
			chatVC[currentIndex].swipeRight()
		}
	}
	
	@objc func moveChat(_ gesture: UISwipeGestureRecognizer) {
		if gesture.direction == UISwipeGestureRecognizer.Direction.right {
			chatVC[currentIndex].swipeRight()
			settingOpened = true
		}

		if gesture.direction == UISwipeGestureRecognizer.Direction.left {
			chatVC[currentIndex].swipeLeft()
			settingOpened = false
		}
	}
}
