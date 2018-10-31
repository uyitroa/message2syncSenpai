//
//  settingMenuViewController.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
import UIKit


class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	private let myArray: NSArray = ["server1", "server2", "server3", "server4", "server5", "Add server +"]
	private var myTableView: UITableView!
	private var toolBar: UIToolbar!
	
	private var screenWidth: CGFloat!
	private var screenHeight: CGFloat!
	
	private let settingVC = SettingViewController()

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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupToolBar()
		setupButton()
	}
	
	
	
	// MARK: table view functions
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(myArray[indexPath.row])
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

	// MARK: rm subview
	func rmSubview() {
		self.view.removeFromSuperview()
	}
}
