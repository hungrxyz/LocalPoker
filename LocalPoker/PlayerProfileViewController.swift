//
//  PlayerProfileViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/22/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CloudKit

class PlayerProfileViewController: UIViewController {
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var pokerNameTextField: UITextField!
	
	var pokerName: String?
	var userRecord: CKRecord? {
		didSet {
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.nameTextField.text = self.userRecord!["name"] as? String
				self.pokerNameTextField.text = self.userRecord!["pokerName"] as? String
			})
		}
	}
	let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pokerName = NSUserDefaults.standardUserDefaults().valueForKey("pokerName") as? String
		
		if pokerName == nil {
			CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { userRecord, error in
				if let error = error {
					print(error)
				} else if let userRecord = userRecord {
					print(userRecord.recordName)
					let query = CKQuery(recordType: "Player", predicate: NSPredicate(format: "createdBy == %@", userRecord.recordName))
					self.publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { (records, error) -> Void in
						if let error = error {
							print(error)
							print("Player not registered yet")
						} else if let records = records {
							if let record = records.first {
								self.userRecord = record
								self.pokerName = record.recordID.recordName
							}
						}
					})
				}
			}
		} else if let pokerName = pokerName {
			pokerNameTextField.enabled = false
			let recordID = CKRecordID(recordName: pokerName)
			publicDatabase.fetchRecordWithID(recordID) { record, error in
				if let error = error {
					print(error)
				} else if let record = record {
					self.userRecord = record
					print(record)
				}
			}
		}
	}
	
	@IBAction func saveTapped(sender: AnyObject) {
		if let userRecord = userRecord {
			userRecord.setValue(nameTextField.text, forKey: "name")
			saveUserRecord(userRecord)
		} else if let text = pokerNameTextField.text {
			let record = CKRecord(recordType: "Player", recordID: CKRecordID(recordName: text))
			record.setValue(nameTextField.text, forKey: "name")
			record.setValue(pokerNameTextField.text, forKey: "pokerName")
			saveUserRecord(record)
		} else {
			let alertController = UIAlertController(title: "Incomplete Profile", message: "Poker Name is required", preferredStyle: .Alert)
			alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
			presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	func saveUserRecord(record: CKRecord) {
		publicDatabase.saveRecord(record) { record, error in
			if let error = error {
				print(error)
			} else if let record = record {
				if self.pokerName == nil {
					NSUserDefaults.standardUserDefaults().setValue(record.recordID.recordName, forKey: "pokerName")
				}
				print(record)
			}
		}
	}
	
	@IBAction func dismissTapped(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
