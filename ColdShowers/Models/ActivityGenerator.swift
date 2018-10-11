//
//  ActivityGenerator.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-10-01.
//  Copyright © 2018 Kit Clark-O'Neil. All rights reserved.
//

import UIKit
import CoreData
class ActivityGenerator: NSObject {
    
    var baseArray = [CoreActivity]()
    var initialIntensity = Int64()
    var context: NSManagedObjectContext?
    override init() {

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        context = appDelegate.persistentContainer.viewContext
        let intensityRequest = NSFetchRequest<UserDesiredIntensity>(entityName: "UserDesiredIntensity")
        let activityRequest = NSFetchRequest<CoreActivity>(entityName: "CoreActivity")


        do {
            let activity = (try context?.fetch(activityRequest))!
            let intensity = (try context?.fetch(intensityRequest))!

            baseArray = activity
            initialIntensity = intensity[0].desiredIntensity
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func addToArrayByName (firstArray: [CoreActivity], secondArray: inout [CoreActivity], name: String) {
        
        for activity in firstArray {
            guard let activityName = activity.name else {
                return
            }
            if activityName == name {
                secondArray.append(activity)
                return
            }
            
        }
        
    }
    
    
    func generateActivity(previousActivities: inout [CoreActivity], activityCount: Int) {
        
        if previousActivities.count <= activityCount {
            var dynamicPreference: Int64
            
    //Generate array with adjusted preferences based on desired intensity
    var firstArray = [(String?, NSArray?, Int64)]()
        
        for activity in baseArray {
            dynamicPreference = activity.userPriority
            let intensityDifference = abs(activity.intensity - initialIntensity)
            var previousActivityPreference:Int64 = 0
            
            //Check previous activities to favour activities with new areas of the body
            for previousActivity in previousActivities {
                guard let previousBodyArea = previousActivity.areaOfBody as? [String], let currentBodyArea = activity.areaOfBody as? [String] else {return}
                for pBodyArea in previousBodyArea {
                    for cBodyArea in currentBodyArea {
                        if pBodyArea == cBodyArea {
                            previousActivityPreference += 1
                        }
                    }
                    
                }
                }
            //Apply differences to new preference rating
            dynamicPreference -= intensityDifference
            dynamicPreference -= previousActivityPreference
            
            //Populate an array with a number of versions, equal to dynamic preference score, of each potential element.
            let firstElement = (activity.name, activity.areaOfBody, dynamicPreference)
            let count = Int(firstElement.2)
            print("\(String(describing: firstElement.0))")
            print("\(String(describing: firstElement.1))")
            print("\(firstElement.2)")
            if count > 0 && count <= 20 {
            for _ in 0..<count {
                
                firstArray.append(firstElement)
            }
            }
                else if count < 1 {
                
                    firstArray.append(firstElement)
                }
            else if count > 20 {
                for _ in 0..<20 {
                    
                    firstArray.append(firstElement)
                }
            }
            }
        
            //Select element at random from this new array, add it to activity array, and run activity again
        let randomNumber = Int(arc4random_uniform(UInt32(firstArray.count)))
        if let firstActivityName = firstArray[randomNumber].0 {
        addToArrayByName(firstArray: baseArray, secondArray: &previousActivities, name: firstActivityName)
            }
        generateActivity(previousActivities: &previousActivities, activityCount: activityCount)
        }
        else {
            return
    }
}
}
