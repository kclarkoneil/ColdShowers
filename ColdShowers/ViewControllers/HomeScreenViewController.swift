//
//  HomeScreenViewController.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-20.
//  Copyright © 2018 Kit Clark-O'Neil. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
  
  //MARK: HomeScreenView Properties
  @IBOutlet weak var homeScreenSettingsButton: UIButton!
  @IBOutlet weak var streakDaysLabel: UILabel!
  @IBOutlet weak var streakDaysNumberLabel: UILabel!
  @IBOutlet weak var setupAlarmButton: UIButton!
  @IBOutlet weak var workoutButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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

}
