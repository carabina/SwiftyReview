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
	/// UserDefaults dictionary keys
	fileprivate var appLaunchCountSetting = ""

	/// Minimum number of App Launches that we should have until we ask for review
	fileprivate var minimumAppLaunchCount = 0
	
	/// Setup SwiftyReview
	/// - parameter count: Show the review dialog every # of app launches if allowed.
	open func setup(count: Int = 5) {
		minimumAppLaunchCount = count
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
		appLaunchCountSetting = "appLaunchCount-"+version!
		incrementAppLaunchCount()
	}

	/// Incerment the app launch count, called by `setup()`.
	fileprivate func incrementAppLaunchCount() {
		let UD = UserDefaults()
		let launches = getAppLaunchCount() + 1
		print("\(Date()) [Swifty Review] - App Launch Count: \(launches) / Minimum Launch Count: \(minimumAppLaunchCount)")
		UD.setValuesForKeys([appLaunchCountSetting: launches])
		UD.synchronize()
	}

	// Reads number of plays from UserDefaults and returns it.
	fileprivate func getAppLaunchCount() -> Int {
		let UD = UserDefaults()
		let savedAppLaunchCount = UD.value(forKey: appLaunchCountSetting)

		var launches = 0
		if (savedAppLaunchCount != nil) {
			launches = savedAppLaunchCount as! Int
		}

		return launches
	}

	/// Show the review dialog if the app has been launched enough times and it is allowed.
	open func showReview() {
		let launches = getAppLaunchCount()
		let countMatch = launches % minimumAppLaunchCount

		if (countMatch == 0) {
			if #available(iOS 10.3, *) {
				print("\(Date()) [Swifty Review] - Review requested")
				SKStoreReviewController.requestReview()
			}
		} else {
			print("\(Date()) [Swifty Review] - Not enough launches to request review")
		}
	}
}
