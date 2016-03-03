//
//  SharedCode.swift
//  LocalPoker
//
//  Created by Zel Marko on 3/3/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation

func formatDate(date: NSDate) -> String {
	let dateFormatter = NSDateFormatter()
	dateFormatter.dateFormat = "EEEE, d. MMM - H:mm"
	return dateFormatter.stringFromDate(date)
}