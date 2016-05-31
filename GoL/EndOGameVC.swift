import UIKit

class EndOfGame: UIViewController {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.whiteColor()
        
        let back = UIButton(frame: CGRect(x: 0, y: screenSize.height - 50, width: screenSize.width, height: 50))
        back.setTitle("back", forState: UIControlState.Normal)
        back.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        back.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        back.addTarget(self, action: #selector(self.back(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(back)
    }
    
    
    func back(sender:UIButton!) {
        let vc = MenuViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
