//
//  ScheduleViewController.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-27.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit
import UserNotifications
class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneButton: UIButton!
  
  var myAlarms = [UNNotificationRequest]()
  override func viewDidLoad() {
    
    UNUserNotificationCenter.current().removeAllDeliveredNotifications() //  notifications arent being marked delivered
    
    //    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["localNotification"])
    //    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    
    UNUserNotificationCenter.current().getPendingNotificationRequests { (myRequests) in
      self.myAlarms = myRequests
      print(self.myAlarms.count)
      if self.myAlarms.count > 0 {
        print("here")
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  // MARK: - Table view data source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.myAlarms.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmCell else { fatalError("could not make cell") }
    
    let request = self.myAlarms[indexPath.row] as UNNotificationRequest
    
    let timeString = request.content.userInfo["Time"] as? String
    let dayString = request.content.userInfo["Day"] as? String
    let durationInt = request.content.userInfo["Duration"] as? Int
    let durationString = "\(durationInt!) Minutes"
    let intensityInt = request.content.userInfo["Intensity"] as? Int
    let intensityString = "\(intensityInt!)"
    
    
    cell.dateLabel.text = timeString
    cell.timeLabel.text = dayString
    cell.durationLabel.text = durationString
    
    
    print(request.content.userInfo)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    // currently deletes from screen, but not actually from notification center items.
    
    let identifierString = myAlarms[indexPath.row].identifier
    
    if editingStyle == .delete {
      self.myAlarms.remove(at: indexPath.row)
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifierString])
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  // MARK: Button Actions
  @IBAction func saveButtonSegue(_ sender: UIButton) {
    
  }
  
  @IBAction func doneButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
