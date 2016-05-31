import UIKit

class GodModeViewController: UIViewController {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let grid = GameView.randomGrid(50, m: 70)
        let game = GameView(frame: screenSize, grid: grid)
        game.alpha = 0.2
        game.userInteractionEnabled = false
        self.view.addSubview(game)
        game.play(0.4)
        
        let button1 = UIButton(frame: CGRect(x: 0, y: screenSize.height / 2 - 15, width: screenSize.width / 2, height: 30))
        button1.setTitle("Levels", forState: UIControlState.Normal)
        button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.button1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: screenSize.width / 2, y: screenSize.height / 2 - 15, width: screenSize.width / 2, height: 30))
        button2.setTitle("Components", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button2.addTarget(self, action: #selector(self.button2(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
        
        let back = UIButton(frame: CGRect(x: 0, y: screenSize.height - 50, width: screenSize.width, height: 50))
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        back.setTitle("back", forState: UIControlState.Normal)
        back.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        back.addTarget(self, action: #selector(self.back(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(back)
    }
    
    func back(sender:UIButton!) {
        let vc = MenuViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func button1(sender:UIButton!) {
        let vc = CustomEntities()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func button2(sender:UIButton!) {
        let vc = CustomEntities()
        vc.entityType = "Component"
        self.presentViewController(vc, animated: true, completion: nil)
    }
}