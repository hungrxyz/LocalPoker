//
//  EventDetailViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/21/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CloudKit

class EventDetailViewController: UIViewController {
	
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var minPeopleLabel: UILabel!
	@IBOutlet weak var maxPeopleLabel: UILabel!
	@IBOutlet weak var buyInLabel: UILabel!
	@IBOutlet weak var blindsLabel: UILabel!
	@IBOutlet weak var additionalInfoLabel: UILabel!
	@IBOutlet weak var playersTableView: UITableView!
	
	var event: Event!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = event.name
		dateLabel.text = "\(event.date)"
		locationLabel.text = event.location
		minPeopleLabel.text = event.minPeople.description
		maxPeopleLabel.text = event.maxPeople.description
		buyInLabel.text = event.buyIn
		blindsLabel.text = event.blinds
		additionalInfoLabel.text = event.additionalInfo
		
		let eventReference = CKReference(recordID: CKRecordID(recordName: event.id), action: .DeleteSelf)
		let predicate = NSPredicate(format: "event == %@", eventReference)
		let sort = NSSortDescriptor(key: "creationDate", ascending: true)
		let query = CKQuery(recordType: "RSVP", predicate: predicate)
		query.sortDescriptors = [sort]
		
		CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
			if let error = error {
				print(error)
			} else if let records = records {
				print(records)
			}
		}
	}
	
	@IBAction func countMeInTapped(sender: AnyObject) {
		saveRsvp(true)
	}
	
	@IBAction func noGoingTapped(sender: AnyObject) {
		saveRsvp(false)
	}
	
	func saveRsvp(going: Bool) {
		if registeredPlayer() {
			let rsvp = CKRecord(recordType: "RSVP")
			let eventReference = CKReference(recordID: CKRecordID(recordName: event.id), action: .DeleteSelf)
			let playerReference = CKReference(recordID: CKRecordID(recordName: NSUserDefaults.standardUserDefaults().valueForKey("userRecordID") as! String), action: .DeleteSelf)
			rsvp["event"] = eventReference
			rsvp["player"] = playerReference
			rsvp["going"] = going
			
			CKContainer.defaultContainer().publicCloudDatabase.saveRecord(rsvp, completionHandler: { (record, error) -> Void in
				if let error = error {
					print(error)
				} else if let record = record {
					print(record)
				}
			})
		} else {
			print("No player registered")
		}
	}
	
	func registeredPlayer() -> Bool {
		return NSUserDefaults.standardUserDefaults().valueForKey("userRecordID") == nil ? false : true
	}
}

extension EventDetailViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath) as! EventPlayerCell
		
		return cell
	}
}
