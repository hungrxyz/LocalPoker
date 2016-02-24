//
//  EventPlayerCell.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/24/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class EventPlayerCell: UITableViewCell {
	
	@IBOutlet weak var pokerNameLabel: UILabel!
	@IBOutlet weak var rsvpStatusLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
