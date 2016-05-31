import UIKit

var gameColorThemes = [
    [
        "name": "Black",
        "bg": UIColor.blackColor().CGColor,
        "alive": UIColor.whiteColor().CGColor,
        "dead": UIColor.grayColor().CGColor,
        "notVisited": UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor,
        "highlight": UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
    ],
    [
        "name": "Red",
        "bg": UIColor.blackColor().CGColor,
        "alive": UIColor.redColor().CGColor,
        "dead": UIColor.grayColor().CGColor,
        "notVisited": UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor,
        "highlight": UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
    ]
]

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
     
        let back = UIButton(frame: CGRect(x: 0, y: screenSize.height - 50, width: screenSize.width, height: 50))
        back.setTitle("back", forState: UIControlState.Normal)
        back.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        back.addTarget(self, action: #selector(self.back(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(back)
        
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - back.frame.height))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = self.view.backgroundColor
        tableView.scrollEnabled = false
        tableView.allowsSelection = false
        self.view.addSubview(tableView)
    }
    
    
    func back(sender:UIButton!) {
        let vc = MenuViewController()
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50))
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenSize.width, height: 50))
        if indexPath.section == 0 {
            if indexPath.row == 0{
                label.text = "Colors"
                
                let colorThemePicker: UIPickerView = UIPickerView(frame: CGRect(x: 30, y: 0, width: screenSize.width - 30, height: 50))
                
                colorThemePicker.dataSource = self
                colorThemePicker.delegate = self
                
                if userDefaults.objectForKey("colorTheme") != nil {
                    colorThemePicker.selectRow(userDefaults.integerForKey("colorTheme"), inComponent: 0, animated: true)
                }
                cell.addSubview(colorThemePicker)
            }
        }
        
        cell.addSubview(label)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    /** UIPICKER **/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gameColorThemes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gameColorThemes[row]["name"] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userDefaults.setInteger(row, forKey: "colorTheme")
        userDefaults.synchronize()
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenSize.width
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}