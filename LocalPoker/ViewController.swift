//
//  ViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/17/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var events = [Event]() {
		didSet {
			dispatch_async(dispatch_get_main_queue()) { () -> Void in
				self.tableView.reloadData()
			}
		}
	}
	var selectedEvent: Event!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let container = CKContainer.defaultContainer()
		let publicDB = container.publicCloudDatabase
		
		let query = CKQuery(recordType: "Event", predicate: NSPredicate(value: true))
		publicDB.performQuery(query, inZoneWithID: nil) { result, error in
			if let error = error {
				print(error)
			} else if let result = result {
				var results = [Event]()
				for record in result {
					let event = Event(id: record.recordID.recordName,
						host: record["host"] as! String,
						name: record["name"] as! String,
						date: record["date"] as! NSDate,
						location: record["location"] as! String,
						minPeople: record["minPlayers"] as! Int,
						maxPeople: record["maxPlayers"] as! Int,
						buyIn: record["buyIn"] as! String,
						blinds: record["blinds"] as! String,
						additionalInfo: record["additionalInfo"] as! String)
					results.append(event)
				}
				self.events = results
			}
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let eventDetailViewController = segue.destinationViewController as? EventDetailViewController {
			eventDetailViewController.event = selectedEvent
		}
	}
}

extension ViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if events.isEmpty {
			return 1
		}
		return events.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath)
		
		if events.isEmpty {
			cell.textLabel?.text = "No events scheduled"
			cell.detailTextLabel?.hidden = true
		} else {
			let event = events[indexPath.row]
			cell.textLabel?.text = event.name
		}
		
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedEvent = events[indexPath.row]
		performSegueWithIdentifier("segueEventDetail", sender: self)
	}
}

