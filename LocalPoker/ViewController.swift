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

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let container = CKContainer.defaultContainer()
		let publicDB = container.publicCloudDatabase
		
		let query = CKQuery(recordType: "Event", predicate: NSPredicate(value: true))
		publicDB.performQuery(query, inZoneWithID: nil) { result, error in
			if let error = error {
				print(error)
			} else if let result = result {
				print(result)
			}
		}
		
		
//		container.fetchUserRecordIDWithCompletionHandler { userRecord, error in
//			if let error = error {
//				print(error)
//			} else if let userRecord = userRecord {
//				print(userRecord.recordName)
//			}
//			
//		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

