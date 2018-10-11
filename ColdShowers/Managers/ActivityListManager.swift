//
//  ActivityListManager.swift
//  ColdShowers
//
//  Created by Nathan Wainwright on 2018-09-23.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit
import CoreData

class ActivityListManager: NSObject {
  
  var activities: [CoreActivity] = []
  
  
  // MARK: activity list function
    func getNewList(activityCount: Int) -> [CoreActivity] {
    var activityArray = [CoreActivity]()
    let activityGenerator = ActivityGenerator()
    activityGenerator.generateActivity(previousActivities: &activityArray, activityCount: activityCount)
    return activityArray
    

  }
}
