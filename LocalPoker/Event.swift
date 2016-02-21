//
//  Event.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/21/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation

class Event {
	var name: String
	var date: NSDate
	var location: String
	var minPeople: Int
	var maxPeople: Int
	var buyIn: String
	var blinds: String
	var additionalInfo: String
	
	init(name: String, date: NSDate, location: String, minPeople: Int, maxPeople: Int, buyIn: String, blinds: String, additionalInfo: String) {
		self.name = name
		self.date = date
		self.location = location
		self.minPeople = minPeople
		self.maxPeople = maxPeople
		self.buyIn = buyIn
		self.blinds = blinds
		self.additionalInfo = additionalInfo
	}
}
