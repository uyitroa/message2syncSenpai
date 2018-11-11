//
//  MessageManager.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//
import UIKit

class MessageManager {
	var staticHeight = 0
	let manager: Manager
	var messages = [Message]()
	init(server: String) {
		manager = Manager()
		createTextView(server)
	}
	
	func createTextView(_ server: String) {
		let lines = manager.getRelevantLines(server)
		print(lines)
		var min: Int
		if lines.count > 20 {
			min = lines.count - 20
		} else {
			min = 0
		}
		for index in min...lines.count-1 {
			let message = Message(lines[index], 0, staticHeight)
			staticHeight += message.height + 10
			messages.append(message)
		}
	}
}
