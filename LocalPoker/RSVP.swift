//
//  RSVP.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/26/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import CloudKit

class RSVP {
	var rsvpId: String
	var event: CKReference
	var player: CKReference
	var going: Bool
	
	init(rsvpId: String, event: CKReference, player: CKReference, going: Bool) {
		self.rsvpId = rsvpId
		self.event = event
		self.player = player
		self.going = going
	}
}