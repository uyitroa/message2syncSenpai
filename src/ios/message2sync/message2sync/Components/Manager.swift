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
	init(filename: String = "lines.txt") {
		self.filename = filename
	}
	
	func readData() -> String {
		var text = String()
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let fileURL = dir.appendingPathComponent(filename)
			print(fileURL.absoluteString)
			do {
				text = try String(contentsOf: fileURL, encoding: .utf8)
			}
			catch {
				print("Error info: \(error)")
			}
		}
		
		return text
	}
	
	func getRelevantLines() -> [String] {
		let text = readData()
		var myList = text.components(separatedBy: "\\\\\\\\")
		myList.insert("", at: 0) // to prevent empty myList which leads error of `for`
		var result = [String]()
		// get the 5 last elements of list
		for arrayIndex in (myList.count-1) * -1...0 {
			result.append(String(myList[-arrayIndex]))
		}

		return result
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
