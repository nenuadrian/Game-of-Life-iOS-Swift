import UIKit

class CustomEntities: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var entityType = "Level"
    var entities = [[String: AnyObject]]()
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: screenSize.width, height: screenSize.height - 100))
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        scrollView.addSubview(tableView)
        
        
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50))
        button1.setTitle("Create", forState: UIControlState.Normal)
        button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.button1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button1.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(button1)
        
        let back = UIButton(frame: CGRect(x: 0, y: screenSize.height - 50, width: screenSize.width, height: 50))
        back.setTitle("back", forState: UIControlState.Normal)
        back.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        back.addTarget(self, action: #selector(self.back(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(back)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = self.view.backgroundColor
        tableView.scrollEnabled = false
        scrollView.addSubview(tableView)
        
        updateEntities()
    }
    
    func updateEntities() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("Custom\(entityType)s") != nil) {
            entities = userDefaults.objectForKey("Custom\(entityType)s") as! [[String: AnyObject]]
        }

        tableView.reloadData()
        tableView.sizeToFit()
        scrollView.sizeToFit()
    }
    
    func back(sender:UIButton!) {
        let vc = GodModeViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func button1(sender:UIButton!) {
        let vc = Designer()
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 100))
        
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: screenSize.width, height: 30))
        label.text = "\(Utils.toRoman(indexPath.row + 1)). \(entities[indexPath.row]["name"] as! String) "
        
        cell.addSubview(label)
        if entities[indexPath.row]["preview"] != nil {
            let preview = UIImage(data: entities[indexPath.row]["preview"] as! NSData)
            let previewElem = UIImageView(frame: CGRect(x: screenSize.width - 110, y: 10, width: 90, height: 90))
            previewElem.image = preview
            cell.addSubview(previewElem)
        }
        return cell
    }
    
    // MARK:- Table view delegate
    func gridFromLevel(index: Int) -> [[CellState]] {
        let level = self.entities[index]["alive"] as! [[Int]]
        
        var grid = GameView.emptyGrid(200, m: 200)
        for i in 0..<level.count {
            grid[level[i][0]][level[i][1]] = CellState.ALIVE
        }
        return grid
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       
        // Create the alert controller
        let alertController = UIAlertController(title: "What to do?", message: "Hmmm", preferredStyle: .Alert)
        
        // Create the actions
        let edit = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let vc = Designer()
            vc.entity = self.entities[indexPath.row]
            vc.entityType = self.entityType
            vc.existingEntity = indexPath.row
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
        if entityType == "Level" {
            let play = UIAlertAction(title: "Play", style: UIAlertActionStyle.Default) {
                UIAlertAction in
               
                let vc = MainViewController()
                vc.grid = GameView.gridFromList(self.entities[indexPath.row]["alive"] as! [[Int]])
                self.presentViewController(vc, animated: true, completion: nil)
            }
            alertController.addAction(play)
        }
        alertController.addAction(edit)
        
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    
    
}