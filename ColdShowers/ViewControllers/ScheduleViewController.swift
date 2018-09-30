//
//  ScheduleViewController.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-27.
//  Copyright © 2018 Kit Clark-O'Neil. All rights reserved.
//

import UIKit
import UserNotifications
class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBOutlet weak var doneButton: UIButton!
  
  
  
  
  
  var myAlarms = [UNNotificationRequest]()
  override func viewDidLoad() {
    //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
    //        let keys = ["minute"]
    let request = self.myAlarms[indexPath.row] as UNNotificationRequest
    //        let dates = request.dictionaryWithValues(forKeys: keys)
    ////        let minute = dates["minute"]
    //////        let hour = dates["hour"]
    //////        let day = dates["day"]
    
    let timeString = request.content.userInfo["Time"] as? String
    let dayString = request.content.userInfo["Day"] as? String
    
    //let time = "\(hour):\(minute)"
    
    ////
    
    
    cell.dateLabel.text = timeString
    cell.timeLabel.text = dayString
    print(request.content.userInfo)
    
    return cell
  }
  
  
  
  
  
  // MARK: Button Actions
  @IBAction func saveButtonSegue(_ sender: UIButton) {
    
  }
  
  @IBAction func doneButtonPressed(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    
  }
  
  
  
  
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
