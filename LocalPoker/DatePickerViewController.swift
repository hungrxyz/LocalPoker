//
//  DatePickerViewController.swift
//  LocalPoker
//
//  Created by Zel Marko on 2/17/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
	
	@IBOutlet weak var selectedDateLabel: UILabel!
	
	var selectedDate: NSDate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	@IBAction func datePickerValueChanged(sender: UIDatePicker) {
		print(sender.date)
		selectedDateLabel.text = "\(sender.date)"
		selectedDate = sender.date
	}
	
}
