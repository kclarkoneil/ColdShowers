//
//  CalendarViewController.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-20.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit
import UserNotifications

enum weekDay:Int {
  case Sunday = 0,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday

    func toString() -> String {
        
        switch self {
        case .Sunday:
            return "Sunday"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        }
    }
}


class CalendarViewController: UIViewController {
  
  //MARK: CalenderView Properties
  @IBOutlet weak var timePicker: UIDatePicker!
  
  @IBOutlet weak var sundayButton: UIButton!
  @IBOutlet weak var mondayButton: UIButton!
  @IBOutlet weak var tuesdayButton: UIButton!
  @IBOutlet weak var wednesdayButton: UIButton!
  @IBOutlet weak var thursdayButton: UIButton!
  @IBOutlet weak var fridayButton: UIButton!
  @IBOutlet weak var saturdayButton: UIButton!
  
  @IBOutlet weak var repeatSwitch: UISwitch!
  @IBOutlet weak var calenderViewDoneButton: UIButton!
  @IBOutlet weak var scheduleSaveButton: UIButton!
  @IBOutlet weak var scheduleCancelButton: UIButton!
  
  var daysOfTheWeek = [Int]()
  
  let timeManager = ActivityTimeManager()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    daysOfTheWeek.removeAll()
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Notification date setting
  func requestUserPermission(completionHandler: @escaping (_ success :Bool) -> ()) {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
      if let error = error {
        print("Request Authorization Failed (\(error)")
      }
      completionHandler(success)
    }
  }
  func checkUserPermission(request: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
      switch notificationSettings.authorizationStatus {
      case .notDetermined:
        self.requestUserPermission(completionHandler: { _ in
          self.checkUserPermission(request: request)
        })
        
      case .authorized:
        request(true)
        
      case .denied:
        request(false)
        
        let alert = UIAlertController(title: "Permission Denied",
                                      message: "Notification access denied, enable in settings to use schedule function",
                                      preferredStyle: UIAlertControllerStyle.alert);
        self.present(alert, animated: true, completion: nil)
        
      }
    }
  }
  func setActivity(alarmComponents: ([DateComponents], Bool, String, Int)) {
    //For testing only
//    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
    checkUserPermission { (res) in
      if res {
        for dateComponents in alarmComponents.0 {
          let notificationContent = UNMutableNotificationContent()
          
          notificationContent.title = "Wake up?"
          notificationContent.subtitle = ""
          notificationContent.categoryIdentifier = "Actions"

            guard let dayNumber = dateComponents.weekday else { fatalError("invalid day")}
            
            guard let day = weekDay.init(rawValue: dayNumber - 1) else { fatalError("invalide date")}
            let dayString = day.toString()
            let timeString = alarmComponents.2
            let durationString = alarmComponents.3
            
            notificationContent.userInfo = ["Day": dayString, "Time": timeString, "Duration": durationString]
          //          notificationContent.userInfo = ["Day" : "TEST"] // doesn't change the 'daystring' output at all
          
          let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: alarmComponents.1)
          let request = UNNotificationRequest(identifier: "\(dateComponents)", content: notificationContent, trigger: trigger)
          UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
              print(error)
            }
          })
          UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (request) in
            print("\(notificationContent.userInfo)")
          })
          
        }
      }
    }
  }
  
  func setUpNotificationCenter() {
    let actionShowDetails = UNNotificationAction(identifier: "Go", title: "Jump In", options: [.foreground])
    let notActionShowDetails = UNNotificationAction(identifier: "Don't", title: "Call it off", options: [])
    
    // create category with the action
    let category = UNNotificationCategory(identifier: "Actions", actions: [actionShowDetails, notActionShowDetails], intentIdentifiers: [], options: [])
    
    UNUserNotificationCenter.current().setNotificationCategories(Set([category]))
  }
  
  

  
  
  
  
  // MARK: - Button operation
  @IBAction func scheduleCancelButtonAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func scheduleSaveButtonAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func sundayButtonPressed(_ sender: UIButton) {
    sundayButton.isSelected = !sundayButton.isSelected
    if sundayButton.isSelected {
      daysOfTheWeek.append(1)
    }
    else {
      let index = daysOfTheWeek.index(of: 1)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  
  @IBAction func mondayButtonPressed(_ sender: UIButton) {
    mondayButton.isSelected = !mondayButton.isSelected
    if mondayButton.isSelected {
      daysOfTheWeek.append(2)
    }
    else {
      let index = daysOfTheWeek.index(of: 2)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  
  @IBAction func tuesdayButtonPressed(_ sender: UIButton) {
    tuesdayButton.isSelected = !tuesdayButton.isSelected
    if tuesdayButton.isSelected {
      daysOfTheWeek.append(3)
    }
    else {
      let index = daysOfTheWeek.index(of: 3)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  
  @IBAction func wednesdayButtonPressed(_ sender: UIButton) {
    wednesdayButton.isSelected = !wednesdayButton.isSelected
    if wednesdayButton.isSelected {
      daysOfTheWeek.append(4)
    }
    else {
      let index = daysOfTheWeek.index(of: 4)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  @IBAction func thursdayButtonPressed(_ sender: UIButton) {
    thursdayButton.isSelected = !thursdayButton.isSelected
    if thursdayButton.isSelected {
      daysOfTheWeek.append(5)
    }
    else {
      let index = daysOfTheWeek.index(of: 5)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  @IBAction func fridayButtonPressed(_ sender: UIButton) {
    fridayButton.isSelected = !fridayButton.isSelected
    if fridayButton.isSelected {
      daysOfTheWeek.append(6)
    }
    else {
      let index = daysOfTheWeek.index(of: 6)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  @IBAction func saturdayButtonPressed(_ sender: UIButton) {
    saturdayButton.isSelected = !saturdayButton.isSelected
    if saturdayButton.isSelected {
      daysOfTheWeek.append(7)
    }
    else {
      let index = daysOfTheWeek.index(of: 7)
      daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
        scheduleSaveButton.isEnabled = false
    }
    else {
        scheduleSaveButton.isEnabled = true
    }
  }
  
  @IBAction func saveButton(_ sender: UIButton) {
    let myTimePicker = DateFormatter()
    myTimePicker.dateFormat = "HH:mm"
    
    let timeString = myTimePicker.string(from: timePicker.date)
    let time = timeString.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
    let minuteString = String(time[1])
    let hourString = String(time[0])
    guard let minute = Int(minuteString), let hour = Int(hourString) else {
      fatalError()
    }
    var adjustedTimeString = String()
    
    
    
    switch hour {
    case 0:
        adjustedTimeString = String(format: "12:%02d AM", minute) // String(format: "12:%02d", minute)
    case 12:
      adjustedTimeString = String(format: "12:%02d PM", minute) // String(format: "12:%02d", minute)
    case ..<12:
        adjustedTimeString = String(format: "%2d:%02d AM", hour, minute) // String(format: "%02d:%02d", hour, minute)
    case ..<24:
        adjustedTimeString = String(format: "%2d:%02d PM", hour - 12, minute) // String(format: "%02d:%02d", hour - 12, minute)
    default:
        adjustedTimeString = "Invalid Time"
    }
    
    
    var input: ([DateComponents], Bool, String, Int)
    input.0 = [DateComponents]()
    input.1 = repeatSwitch.isOn
    input.2 = adjustedTimeString
    input.3 = 15 // MARK: -- where time for notification is set.

    for day in daysOfTheWeek {
      
      var newDate = DateComponents()
      newDate.calendar = Calendar.current
      newDate.weekday = day
      newDate.minute = minute
      newDate.hour = hour
      input.0.append(newDate)
      
    }
    setActivity(alarmComponents: input)
    //    self.navigationController?.popViewController(animated: true)
    dismiss(animated: true, completion: nil)
  }
}

extension CalendarViewController: UNUserNotificationCenterDelegate {
  
  
  // currently does not get called at all, should be where notification is set to delivered.
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    switch response.notification.request.content.categoryIdentifier {
    case "accept":
      print("accepted")
    default:
      //      fatalError(response.notification.request.content.categoryIdentifier)
      print("DEFAULTED \(response.notification.request.content.categoryIdentifier)")
      break
    }

  }
  
  
  
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert])
  }
}

