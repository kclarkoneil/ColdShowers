//
//  ActivityViewController.swift
//  ColdShowers
//
//  Created by Kit Clark-O'Neil on 2018-09-20.
//  Copyright © 2018 Kit Clark-O'Neil and Nathan Wainwright All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    //MARK: ActivityView -- Timer Overlay Properties
    @IBOutlet weak var timerOverlayView: UIView!
    @IBOutlet weak var timerOverlaylabel: UILabel!
    @IBOutlet weak var timerOverlayButton: UIButton!
    
    //MARK: ActivityView Properties
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var activityInstructionImage: UIImageView!
    @IBOutlet weak var activityStartButton: UIButton!
    @IBOutlet weak var activityCancelButton: UIButton!
    @IBOutlet weak var activityCurrentTimerLabel: UILabel!
    @IBOutlet weak var activityInstructionLabel: UILabel!
    
    
    @IBOutlet weak var activityInstructionButton: UIButton!
    @IBOutlet weak var activityInstructionTextView: UITextView!
    
    var instructionSetting = true
    
    
    //MARK: Varible Properties
    var currentActivity = CoreActivity()
    var activityList = [CoreActivity]()
    var currentActivityIndex: Int = 0
    var initialIntensity: Int = 0
    
    //MARK: SoundManager
    let soundManager = SoundManager()
    
    //MARK: Time Manager
    //let timeManager = ActivityTimeManager()
    
    //MARK: Activity Manager
    let activityManager = ActivityListManager()
    let hour = 0
    var minutes = 5
    
    var rootSeconds = 10
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false // used to ensure only one timer running at any given time
    
    let formatter = DateFormatter()
    var activityTotalTime = Date()
    
    //MARK: Local Data
    let defaults = UserDefaults.standard
    
    //MARK: getting default time allotments for activities from userdefault
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityInstructionTextView.isHidden = true
        
        
        //MARK: will keep the workout screen active.
        UIApplication.shared.isIdleTimerDisabled = true
        
        timerOverlayView.isHidden = true
        timerOverlayView.alpha = 0.0
        
        activityList = activityManager.getNewList(activityCount: 9)
        currentActivity = activityList[currentActivityIndex]
        makeBorder()
        totalTimeLabel.text = timeString(time: (TimeInterval(activityList.count * 90)))
        showActivity()
        
        //Error checking
        if initialIntensity == 3 {
        print("Initial intensity value passed")
        }
        for activity in activityList {
            print("\(activity.name)")
            print("\(activity.userPriority)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func activityInstructionButtonPressed(_ sender: UIButton) {
        
        if instructionSetting {
            activityInstructionTextView.isHidden = true
        } else {
            activityInstructionTextView.isHidden = false
        }
        instructionSetting = !instructionSetting
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // loading this here, as on plus model phones it doesn't display properly.
        makeBorder()
    }
    
    @IBAction func activityStartButtonPressed(_ sender: UIButton) {
        showActivity()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        finishActivity()
    }
    
    @IBAction func activityCancelButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backHome", sender: nil)
    }
    
    //MARK: Load Data for Labels
    func loadData() {
        activityNameLabel.text = activityList[currentActivityIndex].name
        activityInstructionImage.image = UIImage(named: activityList[currentActivityIndex].photo!)
        activityInstructionTextView.text = activityList[currentActivityIndex].instructions
        activityCurrentTimerLabel.text = "\(currentActivityIndex + 1)/\(activityList.count)"
    }
    
    //MARK: TIMER FUNCTIONS
    func runTimer() {
        seconds = Int(currentActivity.activityTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ActivityViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        self.seconds -= 1     //This will decrement(count down)the seconds.
        self.timerOverlaylabel.text = timeString(time: TimeInterval(self.seconds)) //This will update the label.
        
        if seconds == 0 {
            finishActivity()
            soundManager.doneActivity()
            finishActivity()
        }
    }
    func showActivity() {
        
        currentActivity = activityList[currentActivityIndex]
        self.timerOverlaylabel.text = self.timeString(time: TimeInterval(currentActivity.activityTime))
        self.activityCurrentTimerLabel.text = self.timeString(time: TimeInterval(currentActivity.activityTime))
        self.rootSeconds = Int(currentActivity.activityTime)
        self.seconds = Int(currentActivity.activityTime)
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations: {
            self.timerOverlayView.alpha = 1.0
        }, completion: nil)
        activityStartButton.isEnabled = false
        activityCancelButton.isEnabled = false
        activityStartButton.isHidden = true
        activityCancelButton.isHidden = true
        timerOverlayView.isHidden = false
        activityInstructionButton.isEnabled = false
        activityInstructionTextView.isHidden = true
        loadData()
        self.runTimer()
    }
    
    func finishActivity() {
        UIView.animate(withDuration: 0.8, animations: {
            self.timerOverlayView.alpha = 0.0
            self.activityStartButton.alpha = 1.0
            self.activityCancelButton.alpha = 1.0
        }) { (true) in
            
            self.timerOverlayView.isHidden = true
            self.activityStartButton.isEnabled = true
            self.activityCancelButton.isEnabled = true
            self.activityStartButton.isHidden = false
            self.activityCancelButton.isHidden = false
            self.activityInstructionButton.isEnabled = true
            self.activityInstructionTextView.isHidden = true
            
            
            self.timer.invalidate()
            if self.currentActivityIndex < self.activityList.count - 1 {
                self.currentActivityIndex += 1
                self.showActivity()
            }
            else {
                self.performSegue(withIdentifier: "postActivitySegue", sender: self)
            }
        }
    }
    func makeBorder() {
        MakeBorder.addTopBorder(inpView: activityInstructionImage, withColor: UIColor.offWhite)
        MakeBorder.addBottomBorder(inpView: activityInstructionImage, withColor: UIColor.offWhite)
        MakeBorder.addBottomBorder(inpView: timerOverlayView, withColor: UIColor.jetBlack)
        MakeBorder.addTopBorder(inpView: timerOverlayView, withColor: UIColor.jetBlack)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? PostActivityViewController {
            destinationViewController.completedActivityList = activityList
        }
    }
}
