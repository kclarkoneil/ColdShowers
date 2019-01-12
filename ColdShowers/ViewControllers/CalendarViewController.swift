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
    @IBOutlet weak var scheduleSaveButton: UIButton!
    @IBOutlet weak var scheduleCancelButton: UIButton!
    
    @IBOutlet weak var tenButton: UIButton!
    @IBOutlet weak var fifteenButton: UIButton!
    @IBOutlet weak var twentyButton: UIButton!
    @IBOutlet weak var twentyFiveButton: UIButton!
    
    @IBOutlet weak var intensityOneButton: UIButton!
    @IBOutlet weak var intensityTwoButton: UIButton!
    @IBOutlet weak var intensityThreeButton: UIButton!
    @IBOutlet weak var intensityFourButton: UIButton!
    
    var daysOfTheWeek = [Int]()
    var selectedIntensity = Int()
    var selectedDuration = Int()
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
    func setActivity(alarmComponents: ([DateComponents], Bool, String, Int, Int)) {
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
                    
                    guard let day = weekDay.init(rawValue: dayNumber - 1) else { fatalError("invalid date")}
                    let dayString = day.toString()
                    let timeString = alarmComponents.2
                    let durationString = alarmComponents.3
                    let intensityString = alarmComponents.4
                    
                    notificationContent.userInfo = ["Day": dayString, "Time": timeString, "Duration": durationString, "Intensity": intensityString]
                    
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
    //Days of the week buttons helper function
    func dayOfTheWeekHelper(ButtonPressed: UIButton, dayOfTheWeek: Int) {
    ButtonPressed.isSelected = !ButtonPressed.isSelected
    if ButtonPressed.isSelected {
    daysOfTheWeek.append(dayOfTheWeek)
    }
    else {
    let index = daysOfTheWeek.index(of: dayOfTheWeek)
    daysOfTheWeek.remove(at: index!)
    }
    if daysOfTheWeek.count == 0 {
    scheduleSaveButton.isEnabled = false
    }
    else {
    scheduleSaveButton.isEnabled = true
    }
}
    
    
    @IBAction func sundayButtonPressed(_ sender: UIButton) {
       dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 1)
    }
    
    @IBAction func mondayButtonPressed(_ sender: UIButton) {
         dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 2)
    }
    
    @IBAction func tuesdayButtonPressed(_ sender: UIButton) {
         dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 3)
    }
    
    @IBAction func wednesdayButtonPressed(_ sender: UIButton) {
         dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 4)
    }
    
    @IBAction func thursdayButtonPressed(_ sender: UIButton) {
         dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 5)
    }
    
    @IBAction func fridayButtonPressed(_ sender: UIButton) {
         dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 6)
    }
    
    @IBAction func saturdayButtonPressed(_ sender: UIButton) {
        dayOfTheWeekHelper(ButtonPressed: sender, dayOfTheWeek: 7)
    }
    //Button highlighting function
    func buttonHighlight(buttons: [UIButton]) {
        for button in buttons {
            if button.isSelected {
                button.isSelected = false
            }
        }
    }
    
    //Duration selection buttons
    @IBAction func tenButtonPressed(_ sender: UIButton) {
        tenButton.isSelected = !tenButton.isSelected
        buttonHighlight(buttons: [fifteenButton, twentyButton, twentyFiveButton])
        selectedDuration = 10
    }
    @IBAction func fifteenButtonPressed(_ sender: UIButton) {
        fifteenButton.isSelected = !fifteenButton.isSelected
        buttonHighlight(buttons: [tenButton, twentyButton, twentyFiveButton])
        selectedDuration = 15
    }
    @IBAction func twentyButtonPressed(_ sender: UIButton) {
        twentyButton.isSelected = !twentyButton.isSelected
        buttonHighlight(buttons: [tenButton, fifteenButton, twentyFiveButton])
        selectedDuration = 20
    }
    @IBAction func twentyFiveButtonPressed(_ sender: UIButton) {
        twentyFiveButton.isSelected = !twentyFiveButton.isSelected
        buttonHighlight(buttons: [tenButton, fifteenButton, twentyButton])
        selectedDuration = 25
        
    }
    
    //Intensity selection buttons
    @IBAction func intensityOneButtonPressed(_ sender: UIButton) {
        intensityOneButton.isSelected = !intensityOneButton.isSelected
        buttonHighlight(buttons: [intensityTwoButton, intensityThreeButton, intensityFourButton])
        selectedIntensity = 1
    }
    @IBAction func intensityTwoButtonPressed(_ sender: UIButton) {
        intensityTwoButton.isSelected = !intensityTwoButton.isSelected
        buttonHighlight(buttons: [intensityOneButton, intensityThreeButton, intensityFourButton])
        selectedIntensity = 2
    }
    @IBAction func intensityThreeButtonPressed(_ sender: UIButton) {
        intensityThreeButton.isSelected = !intensityThreeButton.isSelected
        buttonHighlight(buttons: [intensityOneButton, intensityTwoButton, intensityFourButton])
        selectedIntensity = 3
    }
    @IBAction func intensityFourButtonPressed(_ sender: UIButton) {
        intensityFourButton.isSelected = !intensityThreeButton.isSelected
        buttonHighlight(buttons: [intensityOneButton, intensityTwoButton, intensityThreeButton])
        selectedIntensity = 4
    }
    
    
    //Create notification and store chosen date, time, intensity and duration as userinfo
    @IBAction func saveButton(_ sender: UIButton) {
        
        //Format chosen time and date
        
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
        
        
        var input: ([DateComponents], Bool, String, Int, Int)
        input.0 = [DateComponents]()
        input.1 = repeatSwitch.isOn
        input.2 = adjustedTimeString
        input.3 = selectedDuration
        input.4 = selectedIntensity
        // MARK: -- where time for notification is set.
        
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

