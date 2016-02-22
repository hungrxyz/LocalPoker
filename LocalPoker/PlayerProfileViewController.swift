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
	
	var userRecordID: String?
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
		
		if !playerProfileExists() {
			CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { userRecord, error in
				if let error = error {
					print(error)
				} else if let userRecord = userRecord {
					self.userRecordID = String(userRecord.recordName.characters.dropFirst())
					print(userRecord.recordName)
				}
			}
		} else {
			let recordID = CKRecordID(recordName: NSUserDefaults.standardUserDefaults().valueForKey("userRecordID") as! String)
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
		if !pokerNameTextField.text!.isEmpty {
			if playerProfileExists() {
				saveUserRecord(userRecord!)
			} else {
				let record = CKRecord(recordType: "Player", recordID: CKRecordID(recordName: userRecordID!))
				saveUserRecord(record)
			}
		} else {
			let alertController = UIAlertController(title: "Incomplete Profile", message: "Poker Name is required", preferredStyle: .Alert)
			alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
			presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	func saveUserRecord(record: CKRecord) {
		record.setValue(nameTextField.text, forKey: "name")
		record.setValue(pokerNameTextField.text, forKey: "pokerName")
		publicDatabase.saveRecord(record) { record, error in
			if let error = error {
				print(error)
			} else if let record = record {
				if !self.playerProfileExists() {
					NSUserDefaults.standardUserDefaults().setValue(record.recordID.recordName, forKey: "userRecordID")
				}
				print(record)
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func playerProfileExists() -> Bool {
		return NSUserDefaults.standardUserDefaults().valueForKey("userRecordID") == nil ? false : true
	}
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
