import UIKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //MARK: PreferencesView Properties
    @IBOutlet weak var preferencesTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    let activityManager = ActivityListManager()
    
    let timeManager = ActivityTimeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        preferencesTableView.delegate = self
        preferencesTableView.dataSource = self
        
        preferencesTableView.rowHeight = UITableViewAutomaticDimension
        preferencesTableView.estimatedRowHeight = 140
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: preferencesTableView functions
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Average Activity Intensity"
        case 1:
            return "Strength"
        case 2:
            return "Mindful"
        case 3:
            return "Yoga"
        default:
            return "OUT OF BOUNDS"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //    return defaultSet.categories.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell2 = preferencesTableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! ActivityTimePreferenceTableViewCell
        
        
        
        switch indexPath.section {
        case 0:
            
            
            
            
            cell2.activityCategoryNameLabel.text = "Average Intensity"
            cell2.activityTimeSliderLabel.text = "\(timeManager.getTime("Average Intensity"))"
            cell2.activityCategoryTimeSlider.value = timeManager.getTime("Average Intensity")
            
            return cell2
            
        default:
            fatalError("currectionSection Value out of bounds.")
        }
    }
    
    //MARK: Button Actions
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
