//
//  HUD.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/28/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import MBProgressHUD

class HUD {
	class var sharedHUD: HUD {
		struct Static {
			static let instance = HUD()
		}
		return Static.instance
	}
	
	let window: UIWindow
	let hud: MBProgressHUD
	
	init() {
		self.window = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
		self.hud = MBProgressHUD(window: window)
		self.hud.color = UIColor.darkGrayColor()
	}
	
	func show(text: String?) {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.window.addSubview(self.hud)
			if let text = text {
				self.hud.labelText = text
			}
			self.hud.show(true)
		}
	}
	
	func hide() {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.hud.hide(true)
		}
	}
}
