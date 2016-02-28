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
	
	@IBOutlet weak var hostLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var minPeopleLabel: UILabel!
	@IBOutlet weak var maxPeopleLabel: UILabel!
	@IBOutlet weak var buyInLabel: UILabel!
	@IBOutlet weak var blindsLabel: UILabel!
	@IBOutlet weak var additionalInfoLabel: UILabel!
	@IBOutlet weak var playersTableView: UITableView!
	
	var event: Event!
	var rsvps = [RSVP]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = event.name
		hostLabel.text = event.host
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
//				print(records)
				for record in records {
					let rsvp = RSVP(rsvpId: record.recordID.recordName, event: record["event"] as! CKReference, player: record["player"] as! CKReference, going: record["going"] as! Bool)
					self.rsvps.append(rsvp)
				}
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.playersTableView.reloadData()
				})
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
		if let pokerName = NSUserDefaults.standardUserDefaults().stringForKey("pokerName") {
			if rsvps.contains({ $0.player.recordID.recordName == NSUserDefaults.standardUserDefaults().stringForKey("pokerName")! }) {
				let rsvp = rsvps[rsvps.indexOf({ $0.player.recordID.recordName == pokerName })!]
				CKContainer.defaultContainer().publicCloudDatabase.fetchRecordWithID(CKRecordID(recordName: rsvp.rsvpId), completionHandler: { (record, error) -> Void in
					if let error = error {
						print(error)
					} else if let record = record {
						record["going"] = going
						
						CKContainer.defaultContainer().publicCloudDatabase.saveRecord(record, completionHandler: { (savedRecord, savedError) -> Void in
							if let saveError = savedError {
								print(saveError)
							} else if let _ = savedRecord {
								dispatch_async(dispatch_get_main_queue(), { () -> Void in
									rsvp.going = going
									self.playersTableView.reloadData()
								})
							}
						})
					}
				})
			} else {
				let rsvp = CKRecord(recordType: "RSVP")
				let eventReference = CKReference(recordID: CKRecordID(recordName: event.id), action: .DeleteSelf)
				let playerReference = CKReference(recordID: CKRecordID(recordName: NSUserDefaults.standardUserDefaults().valueForKey("pokerName") as! String), action: .DeleteSelf)
				rsvp["rsvpId"] = rsvp.recordID.recordName
				rsvp["event"] = eventReference
				rsvp["player"] = playerReference
				rsvp["going"] = going
				
				CKContainer.defaultContainer().publicCloudDatabase.saveRecord(rsvp, completionHandler: { (record, error) -> Void in
					if let error = error {
						print(error)
					} else if let record = record {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							let rsvp = RSVP(rsvpId: record.recordID.recordName, event: record["event"] as! CKReference, player: record["player"] as! CKReference, going: record["going"] as! Bool)
							self.rsvps.append(rsvp)
							self.playersTableView.reloadData()
						})
					}
				})
			}
		}
	}
}

extension EventDetailViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if rsvps.isEmpty {
			return 1
		}
		return rsvps.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath) as! EventPlayerCell
		
		if rsvps.isEmpty {
			cell.pokerNameLabel.text = "No one RSVPed yet"
			cell.rsvpStatusLabel.hidden = true
		} else {
			let rsvp = rsvps[indexPath.row]
			cell.pokerNameLabel.text = rsvp.player.recordID.recordName
			cell.rsvpStatusLabel.text = rsvp.going ? "GOING" : "NOT GOING"
			cell.rsvpStatusLabel.hidden = false
		}
		
		return cell
	}
}
