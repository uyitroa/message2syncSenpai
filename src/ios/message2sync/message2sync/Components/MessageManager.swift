//
//  MessageManager.swift
//  message2sync
//
//  Created by yuitora . on 28/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import Foundation
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
		var max: Int
		if lines.count > 20 {
			max = 20
		} else {
			max = lines.count - 1
		}
		for index in 0...max{
			let message = Message(lines[index], 0, staticHeight)
			staticHeight += Int(message.textview.frame.height) + 10
			messages.append(message)
		}
	}
}
