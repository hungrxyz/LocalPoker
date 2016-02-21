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
	@IBOutlet weak var minPeopleLabel: UILabel!
	@IBOutlet weak var maxPeopleLabel: UILabel!
	@IBOutlet weak var buyInTextField: UITextField!
	@IBOutlet weak var blindsTextField: UITextField!
	@IBOutlet weak var additionalInfoTextView: UITextView!
	@IBOutlet weak var selectedDateLabel: UILabel!
	
	var eventDate: NSDate! {
		didSet {
			selectedDateLabel.text = "\(eventDate)"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	@IBAction func minPeopleStepperValueChanged(sender: UIStepper) {
		minPeopleLabel.text = "\(Int(sender.value))"
	}
	
	@IBAction func maxPeopleStepperValueChanged(sender: UIStepper) {
		maxPeopleLabel.text = "\(Int(sender.value))"
	}
	
	@IBAction func createEventTapped(sender: AnyObject) {
		
	}
	
	@IBAction func unwindToNewGame(segue: UIStoryboardSegue) {
		if let datePickerViewController = segue.sourceViewController as? DatePickerViewController {
			if let selectedDate = datePickerViewController.selectedDate {
				eventDate = selectedDate
			}
		}
	}
	
	
}
