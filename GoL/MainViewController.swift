import UIKit



class MainViewController: UIViewController {
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var scrollView: UIScrollView!
    var scoreLabel: UILabel!
    var game: GameView!
    var grid: [[CellState]]!
    var pauseButton: UIButton!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        if (grid == nil) {
            grid = GameView.randomGrid(200, m: 200)
        }
        
        game = GameView(frame: screenSize, grid: grid)
        game.parent = self
        self.view.addSubview(game)
        
        scoreLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 200, height: 100))
        scoreLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        scoreLabel.textColor = UIColor.redColor()
        scoreLabel.numberOfLines = 4
        scoreLabel.font = UIFont(name: "Calibri", size: 8)

        self.view.addSubview(scoreLabel)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(self.updateScore), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        pauseButton = UIButton(frame: CGRect(x: 10, y: screenSize.height - 50, width: 40, height: 40))
        pauseButton.setImage(UIImage(named: "Pause"), forState: .Normal)
        pauseButton.addTarget(self, action: #selector(self.pauseAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(pauseButton)
        
        let stopButton = UIButton(frame: CGRect(x: screenSize.width - 50, y: screenSize.height - 50, width: 40, height: 40))
        stopButton.setImage(UIImage(named: "Stop"), forState: .Normal)
        stopButton.addTarget(self, action: #selector(self.endOfGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stopButton)
        
        game.play()
    }
    
    func endOfGame() {
        let vc = EndOfGame()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func pauseAction(sender:UIButton!) {
        if game.running {
            game.pause()
            pauseButton.setImage(UIImage(named: "Play"), forState: .Normal)
        } else {
            game.play()
            pauseButton.setImage(UIImage(named: "Pause"), forState: .Normal)
        }
    }
    
    func updateScore() {
        let nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        scoreLabel.text = "Alive: \(nf.stringFromNumber(game.stats.alive)!)\n" +
            "Born: \(nf.stringFromNumber(game.stats.born)!)\n" +
            "Died: \(nf.stringFromNumber(game.stats.died)!)\n" +
            "Oldest: \(nf.stringFromNumber(game.stats.oldest)!)"
    }
    
    
}