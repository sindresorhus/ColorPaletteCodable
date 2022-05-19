//
//  ColorGroupHeaderView.swift
//  ASEQuickLookPlugin
//
//  Created by Darren Ford on 17/5/2022.
//

import Cocoa

class ColorGroupHeaderView: NSView {

	@IBOutlet var groupNameTextField: NSTextField!
	@IBOutlet var separator: NSBox!

	var showSeparator: Bool = true {
		didSet {
			self.separator.isHidden = !showSeparator
		}
	}

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}

	func setup() {
		self.wantsLayer = true
	}

	override func layout() {
		super.layout()
		//self.layer!.backgroundColor = NSColor.tertiaryLabelColor.cgColor
	}
}
