//
//  EventDetailViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/21/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
	
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var minPeopleLabel: UILabel!
	@IBOutlet weak var maxPeopleLabel: UILabel!
	@IBOutlet weak var buyInLabel: UILabel!
	@IBOutlet weak var blindsLabel: UILabel!
	@IBOutlet weak var additionalInfoLabel: UILabel!
	
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
	}
	
	@IBAction func countMeInTapped(sender: AnyObject) {
	}
	
	@IBAction func noGoingTapped(sender: AnyObject) {
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
