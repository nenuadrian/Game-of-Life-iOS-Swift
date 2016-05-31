import UIKit



class Designer: UIViewController {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var component: EntityView!
    var game: GameView!
    var existingEntity: Int!
    var rotateButton: UIButton!
    var pickComponent: UIButton!
    var entity: [String: AnyObject]!
    var infoEditView: UIView!
    var pickComponentView: UIView!
    var entityType: String = "Level"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        
        if entity == nil {
            entity = [String: AnyObject]()
            entity["name"] = "New"
            entity["alive"] = [[Int]]()
        }
        
        let alive = entity["alive"] as! [[Int]]
        var grid = GameView.emptyGrid(200, m: 200)
        for i in 0..<alive.count {
            grid[alive[i][0]][alive[i][1]] = CellState.ALIVE
        }
        
        game = GameView(frame: screenSize, grid: grid)
        self.view.addSubview(game)
        
        initInterface()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.gameTap(_:)))
        tap.numberOfTapsRequired = 1
        game.addGestureRecognizer(tap)
    }
    
    func gameTap(recognizer:UITapGestureRecognizer) {
        let point = game.coordinatesOfAbsoluteLocation(recognizer.locationInView(game))
        game.apply([[CellState.ALIVE]], fromPoint: point)
    }
    
    func initInterface() {
        let save = UIButton(frame: CGRect(x: screenSize.width - 60, y: screenSize.height - 60, width: 40, height: 40))
        save.setImage(UIImage(named: "Save"), forState: .Normal)
        save.addTarget(self, action: #selector(self.save(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(save)
        
        rotateButton   = UIButton(frame: CGRect(x: screenSize.width - 60, y: screenSize.height - 120, width: 40, height: 40))
        rotateButton.setImage(UIImage(named: "Rotate"), forState: .Normal)
        rotateButton.addTarget(self, action: #selector(self.rotate(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        pickComponent   = UIButton(frame: CGRect(x: screenSize.width - 60, y: screenSize.height - 180, width: 40, height: 40))
        pickComponent.setImage(UIImage(named: "Blocks"), forState: .Normal)
        pickComponent.addTarget(self, action: #selector(self.pickComponent(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(pickComponent)
        
        
        pickComponentView = ComponentsView(parent: self)
        
        infoEditView = UIView(frame: screenSize)
        infoEditView.backgroundColor = UIColor.whiteColor()
        
        let closeEdit   = UIButton(frame: CGRect(x: 0, y: 100, width: screenSize.width, height: 40))
        closeEdit.setTitle("Close", forState: UIControlState.Normal)
        closeEdit.addTarget(self, action: #selector(self.closeInfoEdit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        closeEdit.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        infoEditView.addSubview(closeEdit)
        
        let openInfoEditView = UIButton(frame: CGRect(x: screenSize.width - 140, y: screenSize.height - 60, width: 40, height: 40))
        openInfoEditView.setImage(UIImage(named: "Edit"), forState: .Normal)
        openInfoEditView.addTarget(self, action: #selector(self.openInfoEdit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(openInfoEditView)
        
        
        let name = UITextField(frame: CGRectMake(0, 10, screenSize.width, 40))
        name.placeholder = "Enter text here"
        name.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        name.text = entity["name"] as? String
        name.addTarget(self, action: #selector(self.nameChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        infoEditView.addSubview(name)
    }
    
    func nameChange(sender:UITextField) {
        entity["name"] = sender.text
    }
    
    func openInfoEdit(sender:UIButton!) {
        self.view.addSubview(infoEditView)
    }
    
    func closeInfoEdit(sender:UIButton!) {
        infoEditView.removeFromSuperview()
    }
    
    func pickComponent(sender:UIButton!) {
        self.view.addSubview(pickComponentView)
    }

    func pickedComponent(grid: [[CellState]]) {
        if component != nil && component.superview != nil {
            component.removeFromSuperview()
        }
        component = EntityView(origin: CGPoint(x: 10, y: 10), grid: grid)
        self.view.addSubview(component)
        
        component.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:))))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.componentDoubleTapped(_:)))
        tap.numberOfTapsRequired = 2
        component.addGestureRecognizer(tap)
        
        self.view.addSubview(rotateButton)
    }
    
    func rotate(sender:UIButton!) {
        component.rotate()
        doHighlight()
    }
    
    func componentDoubleTapped(recognizer:UITapGestureRecognizer) {
        let x = component.center.x - component.frame.width / 2.0
        let y = component.center.y - component.frame.height / 2.0
        
        let point = game.coordinatesOfRelativeLocation(CGPoint(x: x, y: y))
        
        game.apply(component.extractGrid(), fromPoint: point)
        component.removeFromSuperview()
        rotateButton.removeFromSuperview()
    }
    
    func doHighlight() {
        let x = component.center.x - component.frame.width / 2.0
        let y = component.center.y - component.frame.height / 2.0
        
        let point = game.coordinatesOfRelativeLocation(CGPoint(x: x, y: y))
        game.highlight(component.extractGrid(), fromPoint: point)
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            
            doHighlight()
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func save(sender:UIButton!) {
        var alive = [[Int]]()
        let grid = game.extractGrid()
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if grid[i][j] == CellState.ALIVE {
                    alive.append([i, j])
                }
            }
        }
        entity["alive"] = alive
        game.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        let imageData: NSData = UIImagePNGRepresentation(game.takeSnapshot())!
        
        entity["preview"] = imageData
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.objectForKey("Custom\(entityType)s") != nil {
            var entities = userDefaults.objectForKey("Custom\(entityType)s") as! [NSDictionary]
            if existingEntity != nil {
                entities[existingEntity] = entity
            } else {
                entities.append(entity)
            }
            
            userDefaults.setObject(entities, forKey: "Custom\(entityType)s")
        } else {
            userDefaults.setObject([entity], forKey: "Custom\(entityType)s")
        }
        userDefaults.synchronize()
        
        let vc = CustomEntities()
        vc.entityType = entityType
        self.presentViewController(vc, animated: true, completion: nil)
    }
}