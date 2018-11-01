//
//  settingMenuViewController.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
import UIKit


class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
	private var myArray: [String] = ["Add server +"]
	private var myTableView: UITableView!
	private var toolBar: UIToolbar!
	
	private var screenWidth: CGFloat!
	private var screenHeight: CGFloat!
	
	public var needHideNavBar = false
	
	// MARK: view controller
	private let settingVC = SettingViewController()
	
	// MARK: Views
	var textfield: TextField!
	var myview: UIView!
	
	// MARK: setup functions
	private func setupAddTextField() {
		let xServerField = UIScreen.main.bounds.width/2
		let yServerField = UIScreen.main.bounds.height * 0.2
		textfield = TextField(placeholder: "Enter server address here",
								  x: Int(xServerField), y: Int(yServerField))
		textfield.sampleTextField.delegate = self
		self.myview.addSubview(textfield.sampleTextField)
	}
	
	private func setupAddView() {
		myview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
		myview.backgroundColor = .white
	}
	
	private func setupTableView() {
		let barHeight: CGFloat = UIScreen.main.bounds.height * 0.05
		screenWidth = self.view.frame.width
		screenHeight = self.view.frame.height
		
		myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: screenWidth * 0.5, height: screenHeight - barHeight),
								  style: .grouped)
		myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
		myTableView.dataSource = self
		myTableView.delegate = self
		myTableView.backgroundColor = .white
		self.view.addSubview(myTableView)
	}
	
	private func setupToolBar() {
		let barHeight: CGFloat = UIScreen.main.bounds.height * 0.075
		toolBar = UIToolbar(frame: CGRect(x: 0, y: screenHeight * 0.925, width: screenWidth * 0.5, height: barHeight))
		toolBar.backgroundColor = .white
		self.view.addSubview(toolBar)
	}
	
	private func setupButton() {
		let settingButton = UIButton(type: .system)
		settingButton.addTarget(self, action: #selector(MenuTableViewController.openSetting), for: .touchUpInside)
		settingButton.setImage(UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal), for: .normal)
		
		let items: [UIBarButtonItem] = [UIBarButtonItem(customView: settingButton)]
		toolBar.items = items
	}
	
	private func setupArray() {
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.absoluteString + "/message2sync/serverChat/"
			let input = fileURL.cString(using: .utf8)
			let output = getServers(input)
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupToolBar()
		setupButton()
		
		setupAddView()
		setupAddTextField()
	}
	
	
	
	// MARK: functions implemented
	func updateCell(text: String) {
		// Update Table Data
		myArray.insert(text, at: 0)
		myTableView.beginUpdates()
		myTableView.insertRows(at: [
			NSIndexPath(row: 0, section: 0) as IndexPath], with: .automatic)
		myTableView.endUpdates()
	}
	
	
	
	// MARK: table view functions
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == myArray.count - 1 {
			self.view.superview?.addSubview(myview)
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
		cell.textLabel!.text = "\(myArray[indexPath.row])"
		cell.backgroundColor = UIColor.white
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	
	
	
	
	// MARK: actions
	@objc func openSetting() {
		self.view.superview?.addSubview(settingVC.view)
	}

	func textFieldShouldReturn(_ keyboardText: UITextField) -> Bool {
		updateCell(text: keyboardText.text!)
		myview.removeFromSuperview()
		return true
	}
	
	
	
	// MARK: rm subview
	func rmSubview() {
		self.view.removeFromSuperview()
	}
	
}
