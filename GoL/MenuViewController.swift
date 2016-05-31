import UIKit

class MenuViewController: UIViewController {
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
        
        let button1 = UIButton(frame: CGRect(x: 0, y:100, width: screenSize.width, height: 30))
        button1.setTitle("Just play", forState: UIControlState.Normal)
        button1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button1.addTarget(self, action: #selector(self.button1(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 0, y:150, width: screenSize.width, height: 30))
        button2.setTitle("God Mode", forState: UIControlState.Normal)
        button2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button2.addTarget(self, action: #selector(self.button2(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
        
        
        let button3 = UIButton(frame: CGRect(x: 0, y:200, width: screenSize.width, height: 30))
        button3.setTitle("Settings", forState: UIControlState.Normal)
        button3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button3.addTarget(self, action: #selector(self.button3(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button3)
    }
    
    
    func button1(sender:UIButton!) {
        let vc = MainViewController()
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

    func button2(sender:UIButton!) {
        let vc = GodModeViewController()
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func button3(sender:UIButton!) {
        let vc = SettingsViewController()
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
}