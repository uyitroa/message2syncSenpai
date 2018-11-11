//
//  Messages.swift
//  testboi
//
//  Created by yuitora . on 24/10/2018.
//  Copyright © 2018 yuitora . All rights reserved.
//

import Foundation
import UIKit

class Message {
	let normalWidth = UIScreen.main.bounds.width * 0.9
	let normalHeight = UIScreen.main.bounds.height * 0.9
	let screenWidth = UIScreen.main.bounds.width
	let screenHeight = UIScreen.main.bounds.height
	var height = 0
	var image: UIImageView!
	var hasImage = false
	
	
	let textview = UITextView()
	init(_ text: String, _ x: Int, _ y: Int) {
		setupTextView(text, x, y)
	}
	
	private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
	
	private func downloadImage(from url: URL) {
		print("Download Started")
		getData(from: url) { data, response, error in
			guard let data = data, error == nil else { return }
			print(response?.suggestedFilename ?? url.lastPathComponent)
			DispatchQueue.main.async() {
				self.image.image = UIImage(data: data)
				print("Download Finished")

				// first superview is scrollView
				// second superview is ChatView
				self.image.superview?.superview?.parentViewController?.load(input: "loaded image; ")
				self.height += Int(self.image.frame.height)
			}
		}
	}
	
	func validURL(string: String) -> Bool {
		return string.contains("http")
	}

	func setupTextView(_ text: String, _ x: Int, _ y: Int) {
		textview.isScrollEnabled = false
		textview.font = UIFont.preferredFont(forTextStyle: .footnote)
		textview.textColor = .black
		textview.textAlignment = .center
		textview.isEditable = false
		textview.dataDetectorTypes = .all
		textview.textAlignment = .justified
		textview.text = text
		textview.center = CGPoint(x: 0, y: y)
		let fixedWidth = UIScreen.main.bounds.width
		let newSize = textview.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		textview.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		height += Int(textview.frame.height)
		
		if validURL(string: text) {
			hasImage = true
			image = UIImageView()
			image.contentMode = .scaleAspectFit
			let text = text.components(separatedBy: ": ")[1] // to separate Computer and url
			downloadImage(from: URL(string: text)!)
		}
	}
}

