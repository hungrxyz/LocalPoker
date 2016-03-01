//
//  NewGameTableViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/17/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CloudKit

class NewGameTableViewController: UITableViewController {
	
	@IBOutlet weak var eventNameTextField: UITextField!
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var minPeopleLabel: UILabel!
	@IBOutlet weak var maxPeopleLabel: UILabel!
	@IBOutlet weak var buyInTextField: UITextField!
	@IBOutlet weak var blindsTextField: UITextField!
	@IBOutlet weak var additionalInfoTextView: UITextView!
	@IBOutlet weak var selectedDateLabel: UILabel!
	@IBOutlet var requiredFields: [UITextField]!
	
	var eventDate: NSDate! {
		didSet {
			selectedDateLabel.text = "\(eventDate)"
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getPokerName()
	}
	
	@IBAction func minPeopleStepperValueChanged(sender: UIStepper) {
		minPeopleLabel.text = "\(Int(sender.value))"
	}
	
	@IBAction func maxPeopleStepperValueChanged(sender: UIStepper) {
		maxPeopleLabel.text = "\(Int(sender.value))"
	}
	
	@IBAction func createEventTapped(sender: AnyObject) {
		for field in requiredFields {
			if field.text!.isEmpty {
				showAlert("Missing Information", message: "All fields have to be filled out")
				return
			}
		}
		if eventDate != nil {
			if let pokerName = getPokerName() {
				HUD.sharedHUD.show("Creating New Event...")
				let newEvent = CKRecord(recordType: "Event")
				newEvent.setValue(pokerName, forKey: "host")
				newEvent.setValue(eventNameTextField.text, forKey: "name")
				newEvent.setValue(eventDate, forKey: "date")
				newEvent.setValue(locationTextField.text, forKey: "location")
				newEvent.setValue(Int(minPeopleLabel.text!), forKey: "minPlayers")
				newEvent.setValue(Int(maxPeopleLabel.text!), forKey: "maxPlayers")
				newEvent.setValue(buyInTextField.text, forKey: "buyIn")
				newEvent.setValue(blindsTextField.text, forKey: "blinds")
				newEvent.setValue(additionalInfoTextView.text, forKey: "additionalInfo")
				
				CKContainer.defaultContainer().publicCloudDatabase.saveRecord(newEvent) { record, error in
					HUD.sharedHUD.hide()
					if let error = error {
						print(error)
					} else if let record = record {
						print(record)
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							self.navigationController!.popViewControllerAnimated(true)
							NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "NewEventNotification", object: nil))
						})
					}
				}
			}
		} else {
			showAlert("Missing Information", message: "Select a date of the event to proceed")
		}
	}
	
	func getPokerName() -> String? {
		if let pokerName = NSUserDefaults.standardUserDefaults().valueForKey("pokerName") as? String {
			return pokerName
		} else {
			let alert = UIAlertController(title: "No Player Account", message: "You need to have a poker name to create a new event.\nCreate it under Profile", preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "Profile", style: .Default, handler: { (action) -> Void in
				self.performSegueWithIdentifier("newEventProfileSegue", sender: self)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
		return nil
	}
	
	func showAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
	}
	
	@IBAction func unwindToNewGame(segue: UIStoryboardSegue) {
		if let datePickerViewController = segue.sourceViewController as? DatePickerViewController {
			if let selectedDate = datePickerViewController.selectedDate {
				eventDate = selectedDate
			}
		}
	}
}

extension NewGameTableViewController {
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 5
	}
}
