//
//  NewGameTableViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/17/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class NewGameTableViewController: UITableViewController {
	
	@IBOutlet weak var eventNameTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var maxPeopleTextField: UITextField!
	@IBOutlet weak var buyInTextField: UITextField!
	@IBOutlet weak var blindsTextField: UITextField!
	@IBOutlet weak var additionalInfoTextView: UITextView!
	
	var eventDate: NSDate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	@IBAction func createEventTapped(sender: AnyObject) {
		
	}
	
	
}
