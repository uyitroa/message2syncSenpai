//
//  settingMenuViewController.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
import UIKit


class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	private let myArray: NSArray = ["", "Setting"]
	private let arrayVC: [ParentMenuViewController] = [SettingViewController()]
	private var myTableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
		let displayWidth: CGFloat = self.view.frame.width * 0.3
		let displayHeight: CGFloat = self.view.frame.height
		
		myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
		myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
		myTableView.dataSource = self
		myTableView.delegate = self
		myTableView.backgroundColor = UIColor.black
		self.view.addSubview(myTableView)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.view.superview?.addSubview(arrayVC[indexPath.row - 1].view)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
		cell.textLabel!.text = "\(myArray[indexPath.row])"
		cell.backgroundColor = UIColor.gray
		return cell
	}
	// MARK: rm subview
	func rmSubview() {
		self.view.removeFromSuperview()
	}
}
