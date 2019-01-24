//
//  ActivityTimePreferenceTableViewCell.swift
//  ColdShowers
//
//  Created by Nathan Wainwright on 2018-09-30.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit

class ActivityTimePreferenceTableViewCell: UITableViewCell {
  
  @IBOutlet weak var activityCategoryNameLabel: UILabel!
  @IBOutlet weak var activityTimeSliderLabel: UILabel!
  @IBOutlet weak var activityCategoryTimeSlider: UISlider!
  
  //to save output
  let defaults = UserDefaults.standard
  let timeManager = ActivityTimeManager()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
