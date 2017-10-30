//
//  SwiftyReview.swift
//  Swifty Review
//
//  Created by Eric Conner on 10/29/17.
//  Copyright © 2017 Eric Conner Apps. All rights reserved.
//

import Foundation
import StoreKit

open class SwiftyReview: NSObject {
	// UserDefaults dictionary keys
	fileprivate let appLaunchCountSetting = "appLaunchCount"

	// Minimum number of App Launches that we should have until we ask for review
	fileprivate var minimumAppLaunchCount = 5

	open func setup(count: Int = 5) {
		minimumAppLaunchCount = count
		incrementAppLaunchCount()
	}

	fileprivate func incrementAppLaunchCount() {
		let UD = UserDefaults()
		let launches = getAppLaunchCount() + 1
		UD.setValuesForKeys([appLaunchCountSetting: launches])
		UD.synchronize()
	}

	// Reads number of plays from UserDefaults and returns it.
	fileprivate func getAppLaunchCount() -> Int {
		let UD = UserDefaults()
		let savedAppLaunchCount = UD.value(forKey: appLaunchCountSetting)

		var launches = 0
		if(savedAppLaunchCount != nil) {
			launches = savedAppLaunchCount as! Int
		}

		print("Swifty Review: App Launch Count = \(launches)")
		return launches
	}

	open func showReview() {
		let launches = getAppLaunchCount()
		print("Swifty Review: Show review")

		if(launches > minimumAppLaunchCount) {
			if #available(iOS 10.3, *) {
				print("Swifty Review: Review requested")
				SKStoreReviewController.requestReview()
			}
		} else {
			print("Swifty Review: Not enough to request review")
		}
	}
}