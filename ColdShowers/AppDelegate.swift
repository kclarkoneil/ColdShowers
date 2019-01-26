//
//  AppDelegate.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-20.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  let defaults = UserDefaults.standard
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    setUpNotificationCenter()
    UNUserNotificationCenter.current().delegate = self
    
    if let _ = defaults.value(forKey: "appHasLaunched") {
      print("APP HAS LAUNCHED BEFORE")
    } else {
      let _ = DefaultSet()
      print("APP HAS NOT LAUNCHED")
      defaults.set(true, forKey: "appHasLaunched")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserDesiredIntensity", in: context)
        let intensity = NSManagedObject(entity: entity!, insertInto: context)
        intensity.setValue(1, forKey: "desiredIntensity")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    //    let _ = DefaultSet()
    // MARK: allows choice between login or sign up screen, depending if app used before
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    self.window = UIWindow()
    
    self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
    
    self.window?.makeKeyAndVisible()
    
    let formatter1 = DateFormatter()
    //    formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter1.dateFormat = "yyyy-MM-dd"
    formatter1.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let lastDateString = defaults.string(forKey: "lastActivityListDone"),
      let lastDate = formatter1.date(from: lastDateString) else {
        return true
    }
    
    let calendar = NSCalendar.current
    if calendar.isDateInYesterday(lastDate) {
      
    } else {
      
      defaults.set(0, forKey: "currentStreak")
    }
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    self.saveContext()
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.saveContext()
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }
  
  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "ColdShowers")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  // Mark: - Notification Setting
  
  // Responds to action response, opening activity view controller
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    
    switch response.actionIdentifier {
    case "Snooze":
      print ("Snooze case hit")
      
    case UNNotificationDismissActionIdentifier:
      print("Needs cancel function")
      
    case UNNotificationDefaultActionIdentifier:
      print("Default action")
      let storyboard = UIStoryboard(name: "Activity", bundle: nil)
    
      if let vc = storyboard.instantiateViewController(withIdentifier: "ActivityVC") as? ActivityViewController {
      vc.initialIntensity = 3
      self.window?.rootViewController = vc
      self.window?.makeKeyAndVisible()
        }
    default:
      print("default case hit")
    }
    completionHandler()
  }
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert])
  }
  
  func setUpNotificationCenter() {
    let actionShowDetails = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
    // create category with the action
    let category = UNNotificationCategory(identifier: "Actions", actions: [actionShowDetails], intentIdentifiers: [], options: [])
    UNUserNotificationCenter.current().setNotificationCategories(Set([category]))
  }
}
