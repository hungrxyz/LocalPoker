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
	var players = [PlayerRSVP]() {
		didSet {
			dispatch_async(dispatch_get_main_queue()) { () -> Void in
				self.playersTableView.reloadData()
			}
		}
	}
	
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
//				var recordIDs = [CKRecordID]()
				for record in records {
//					recordIDs.append((record["player"] as! CKReference).recordID)
//					print((record["player"] as! CKReference).recordID.recordName)
					CKContainer.defaultContainer().publicCloudDatabase.fetchRecordWithID((record["player"] as! CKReference).recordID, completionHandler: { (player, error) -> Void in
						if let error = error {
							print(error)
						} else if let player = player {
							let playerRSVP = PlayerRSVP(id: record.recordID.recordName, pokerName: player["pokerName"] as! String, going: record["going"] as! Bool)
							self.players.append(playerRSVP)
						}
					})
				}
//				for recordID in recordIDs {
//				}
//				dispatch_async(dispatch_get_main_queue(), { () -> Void in
//					self.playersTableView.reloadData()
//				})
//				let fetchOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
//				fetchOperation.perRecordCompletionBlock = { playerRecord, playerRecordID, error in
//					if let error = error {
//						print(error)
//					} else if let playerRecord = playerRecord {
//						print(playerRecord)
//						let playerRSVP = PlayerRSVP(id: playerRecord.recordID.recordName, pokerName: playerRecord["pokerName"] as! String, going: playerRecord["going"] as! Bool)
//						self.players.append(playerRSVP)
//					}
//				}
//				fetchOperation.completionBlock = {
//					print("Finished")
//				}
//				fetchOperation.start()
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
//
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
		return players.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath) as! EventPlayerCell
		let player = players[indexPath.row]
		cell.pokerNameLabel.text = player.pokerName
		cell.rsvpStatusLabel.text = player.going ? "GOING" : "NOT GOING"
		
		return cell
	}
}

class PlayerRSVP {
	var id: String
	var pokerName: String
	var going: Bool
	
	init(id: String, pokerName: String, going: Bool) {
		self.id = id
		self.pokerName = pokerName
		self.going = going
	}
}
