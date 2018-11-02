//
//  Manager.swift
//  testboi
//
//  Created by yuitora . on 24/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import Foundation

class Manager {
	var filename = String()
	var detaPointer: UnsafeMutableRawPointer!

	init(filename: String = "message2sync.db") {
		self.filename = filename
		openDeta()
	}
	
	func openDeta() {
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(filename)
			detaPointer = UnsafeMutableRawPointer(mutating: initializeDeta(fileURL.absoluteString.cString(using: .utf8)))
		}
	}
	
	func getRelevantLines(_ server: String) -> [String] {
		var myList: [String] = [""]
 
		let maxID = getNumberLines(detaPointer, server.cString(using: .utf8))
		if maxID == -1 {
			return myList
		}
		for id in 0...maxID {
			myList.append(String(cString: readLine(detaPointer, id, server.cString(using: .utf8))))
		}
		return myList
	}
	
	func removeFile() {
		let filemgr = FileManager.default
		let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
		var docsURL = dirPaths[0].path
		docsURL += "/\(filename)"
		do {
			try filemgr.removeItem(atPath: docsURL)
		} catch let error {
			print("Error: \(error.localizedDescription)")
		}
	}

	
}
