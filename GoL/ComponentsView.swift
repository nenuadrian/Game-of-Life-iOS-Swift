import UIKit

class ComponentsView: UIView, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var components = [[String: AnyObject]]()
    var scrollView: UIScrollView!
    var tableView: UITableView!
    var parent: Designer!
    
    init(parent: Designer) {
        super.init(frame: screenSize)
        self.parent = parent
        self.backgroundColor = UIColor.grayColor()
        
        scrollView = UIScrollView(frame: screenSize)
        scrollView.delegate = self
        
        self.addSubview(scrollView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 30 ))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let button1 = UIButton(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 30))
        button1.setTitle("close", forState: UIControlState.Normal)
        button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.close), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(button1)
        
        tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = self.backgroundColor
        tableView.scrollEnabled = false
        scrollView.addSubview(tableView)
        
        componentsUpdate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func componentsUpdate() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("CustomComponents") != nil) {
            components = userDefaults.objectForKey("CustomComponents") as! [[String: AnyObject]]
        }
        
        tableView.reloadData()
        tableView.sizeToFit()
        scrollView.sizeToFit()
    }
    
    func close() {
        self.removeFromSuperview()
    }
    
    func gridFromList(list: [[Int]]) -> [[CellState]] {
        var minI = 9999, maxI = -1, minJ = 9999, maxJ = -1
        
        for i in 0..<list.count {
            minI = min(minI, list[i][0])
            minJ = min(minJ, list[i][1])
            maxI = max(maxI, list[i][0])
            maxJ = max(maxJ, list[i][1])
        }
        var grid = GameView.emptyGrid(maxI + 1 - minI, m: maxJ + 1 - minJ)
        for i in 0..<list.count {
            grid[list[i][0] - minI][list[i][1] - minJ] = CellState.ALIVE
        }
        
        return grid
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 100))
        
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: screenSize.width, height: 30))
        label.text = "Component \(components[indexPath.row]["name"] as! String)"
        cell.addSubview(label)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        parent.pickedComponent(self.gridFromList(components[indexPath.row]["alive"] as! [[Int]]))
        self.close()
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
