//
//  PostActivityViewController.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-20.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//
import UIKit
import CoreData

class PostActivityViewController: UIViewController {
    
    //MARK: Storyboard Properties
    
    
    @IBOutlet weak var enjoymentLabel: UILabel!
    @IBOutlet weak var enjoymentButtonYes: UIButton!
    @IBOutlet weak var enjoymentButtonNo: UIButton!
    
    @IBOutlet weak var activityButtonFinish: UIButton!
    
    //MARK: properties
    let defaults = UserDefaults.standard
    var completedActivityList = [CoreActivity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // Do any additional setup after loading the view.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Button Actions
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        
        updateUserPriority(didEnjoy: true)
        addNewDashDate()
        performSegue(withIdentifier: "backHomeSegue", sender: self)
    }
    @IBAction func noButtonPressed(_ sender: UIButton) {
        updateUserPriority(didEnjoy: false)
        addNewDashDate()
        performSegue(withIdentifier: "backHomeSegue", sender: self)
    }
    
    //MARK: Dash Handling
    func addNewDashDate() {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        formatter1.timeZone = TimeZone.current
        //    formatter1.timeZone = TimeZone(secondsFromGMT: 0)
        
        let todayDateString = formatter1.string(from: Date())
        guard let todayDate = formatter1.date(from: todayDateString) else {
            fatalError("WAS NOT ABLE TO GET TODAYS DATE")
        }
        
        let calendar = NSCalendar.current
        let lastDateString = defaults.string(forKey: "lastActivityListDone")
        
        guard let lastDate = formatter1.date(from: lastDateString ?? formatter1.string(from: Date(timeIntervalSinceReferenceDate:0))) else {
            // if error triggered; check data
            fatalError("NO DATE WAS FOUND")
        }
        
        var currentStreak = defaults.integer(forKey: "currentStreak")
        var userActivityHistory = defaults.array(forKey: "userActivityHistory") as? [String] ?? []
        
        defaults.set(todayDateString, forKey: "lastActivityListDone")
        
        let dateBool = calendar.isDate(todayDate, inSameDayAs: lastDate)
        if dateBool == false {
            //update state
            userActivityHistory.append(todayDateString)
            currentStreak += 1
            
            //save state
            defaults.set(currentStreak, forKey: "currentStreak")
            defaults.set(userActivityHistory, forKey: "userActivityHistory")
            
        }
    }
    func updateUserPriority(didEnjoy: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let context = appDelegate.persistentContainer.viewContext
        for activity in completedActivityList {
            if didEnjoy {
                activity.userPriority += 1
            }
            else {
                activity.userPriority -= 1
            }
        }
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Could not save context error: \(error)")
        }
    }
}

