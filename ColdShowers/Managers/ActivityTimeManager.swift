//
//  TimerManager.swift
//  ColdShowers
//
//  Created by Nathan Wainwright on 2018-09-28.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit
import CoreData

class ActivityTimeManager: NSObject {

    var context:NSManagedObjectContext?
    var desiredIntensity: [UserDesiredIntensity] = []
  
  override init() {
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    
    context = appDelegate.persistentContainer.viewContext
    
    let intensityRequest = NSFetchRequest<UserDesiredIntensity>(entityName: "UserDesiredIntensity")
   // let allTimes = NSFetchRequest<ActivityTimes>(entityName: "ActivityTimes")
    
    do {
        guard let intensity = (try context?.fetch(intensityRequest)) else {
            desiredIntensity[0].desiredIntensity = 1
            do {
                try context?.save()
            } catch {
                fatalError("Failed saving")
            }
            return
        }
        desiredIntensity = intensity
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    }
 // func all() -> Int {
   // return Int(times[0].timeMindfulValue) + Int(times[0].timeStrengthValue) + Int(times[0].timeYogaValue)


  
  func getTime(_ category: String) -> Float {
    var timeValue:Float = 0.0
    if category == "Average Intensity" {
        timeValue = Float(desiredIntensity[0].desiredIntensity)
    }
    
    else {
      timeValue = 666.0
    }
    return timeValue
  }
  
  func setTime(_ category: String, value: Float) {
    
    if category == "Average Intensity" {
        desiredIntensity[0].desiredIntensity = Int64(value)
    }
    else {
      fatalError("ERROR WITH CATEGORY OR VALUE")
    }
    
    do {
      try context?.save()
    } catch {
      fatalError("Failed saving")
    }
  }
}

