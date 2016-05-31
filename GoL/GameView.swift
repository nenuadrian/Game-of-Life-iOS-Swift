import Foundation
import UIKit

enum CellState: Int {
    case ALIVE, DEAD
}

class GameView: UIScrollView, UIScrollViewDelegate {
    var bgColor = UIColor.blackColor()
    var aliveColor = UIColor.init(red: 35, green: 207, blue: 95, alpha: 1).CGColor
    var deadColor = UIColor.grayColor().CGColor
    var notVisitedColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
    var highlightColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor

    var drawTimer: NSTimer!
    var cellSize = 11.5
    var cellMargin = 0.5
    var parent: MainViewController!
    var stats = Stats()
    
    class Stats {
        var alive: Int = 0
        var died: Int = 0
        var born: Int = 0
        var oldest: Int = 1
    }
    
    
    var running: Bool {
        get {
            if let drawTimer = drawTimer {
                return drawTimer.valid
            } else {
                return false
            }
        }
    }
    
    struct Cell {
        var visited = false
        var generation = 1
        var highlight = false
        
        var state: CellState {
            didSet {
                if self.state == CellState.ALIVE {
                    if !self.visited {
                        self.visited = true
                    }
                } else {
                    self.generation = 1
                }
            }
        }
        var neighs: Int = 0
        var rect: CGRect
        init(neighs: Int, state: CellState, rect: CGRect) {
            self.state = state
            self.rect = rect
            self.neighs = neighs
        }
    }
    
    private var grid = [[Cell]]()
    
    private func CellStateToCell(grid: [[CellState]]?, state: CellState, i: Int, j: Int) -> Cell {
        let y = Double(j) * cellSize + Double(j) * cellMargin
        let x = Double(i) * cellSize + Double(i) * cellMargin
        let neighs = grid == nil ? 0 : aliveNeighboursCount(grid!, i: i, j: j)
        
        return Cell(neighs: neighs, state: state, rect: CGRect(x: x, y: y, width: cellSize, height: cellSize))
    }
    
    init(frame: CGRect, grid: [[CellState]]) {
        super.init(frame: frame)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let theme = gameColorThemes[userDefaults.integerForKey("colorTheme")]
        bgColor = UIColor(CGColor: theme["bg"] as! CGColor)
        aliveColor = theme["alive"] as! CGColor
        deadColor = theme["dead"] as! CGColor
        highlightColor = theme["highlight"] as! CGColor
        notVisitedColor = theme["notVisited"] as! CGColor
        
        self.delegate = self
        self.backgroundColor = bgColor
        self.bounces = false
        let width = cellSize * Double(grid.count) + cellMargin * Double(grid.count)
        let height = cellSize * Double(grid[0].count) + cellMargin * Double(grid[0].count)
        self.contentSize = CGSizeMake(CGFloat(width), CGFloat(height))
        
        for i in 0..<grid.count {
            self.grid.append([Cell]())
            for j in 0..<grid[i].count {
                if (grid[i][j] == CellState.ALIVE) {
                    stats.alive += 1
                }
                
                self.grid[i].append(CellStateToCell(grid, state: grid[i][j], i: i, j: j))
            }
        }
       
       
        self.setNeedsDisplay()
    }
    
    func play(rate: Double = 0.1) {
        drawTimer = NSTimer.scheduledTimerWithTimeInterval(rate, target: self, selector: #selector(GameView.live), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(drawTimer, forMode: NSRunLoopCommonModes)
    }
    
    func pause() {
        drawTimer.invalidate()
    }
    
    @objc private func live() {
        self.setNeedsDisplay()
        if !lifeCycle() {
            pause()
            self.parent.endOfGame()
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        var rects_alive = [CGRect]()
        var rects_dead = [CGRect]()
        var rects_not_vis = [CGRect]()
        var rects_highlight = [CGRect]()
        
        for cell in grid.flatten() {
            if cell.highlight {
                rects_highlight.append(cell.rect)
            } else if cell.state == CellState.ALIVE {
                rects_alive.append(cell.rect)
            } else if !cell.visited {
                rects_not_vis.append(cell.rect)
            } else {
                rects_dead.append(cell.rect)
            }
        }
        
        CGContextSetFillColorWithColor(context, aliveColor)
        CGContextFillRects(context, rects_alive, rects_alive.count)
        CGContextSetFillColorWithColor(context, deadColor)
        CGContextFillRects(context, rects_dead, rects_dead.count)
        CGContextSetFillColorWithColor(context, notVisitedColor)
        CGContextFillRects(context, rects_not_vis, rects_not_vis.count)
        CGContextSetFillColorWithColor(context, highlightColor)
        CGContextFillRects(context, rects_highlight, rects_highlight.count)
    }
    
    func lifeCycle() -> Bool {
        var grid2 = grid
        var changed = false
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if (grid[i][j].neighs == 0) { continue; }
                if grid[i][j].state == CellState.ALIVE {
                    if grid[i][j].neighs < 2 || grid[i][j].neighs > 3 {
                        grid2[i][j].state = CellState.DEAD
                        stats.died += 1
                        stats.alive -= 1
                        updateNeighs(&grid2, i: i, j: j, by: -1)
                        changed = true
                    }
                } else if grid[i][j].neighs == 3 {
                    grid2[i][j].state = CellState.ALIVE
                    stats.born += 1
                    stats.alive += 1
                    updateNeighs(&grid2, i: i, j: j, by: 1)
                    changed = true
                }
                
                if grid[i][j].state == grid2[i][j].state {
                    grid2[i][j].generation += 1
                    if grid2[i][j].generation > stats.oldest {
                        stats.oldest = grid2[i][j].generation
                    }
                }
            }
        }

        grid = grid2
        return changed
    }
    
    func updateNeighs(inout grid: [[Cell]], i: Int, j: Int, by: Int) {
        for k in max(0, i - 1)...min(i + 1, grid.count - 1) {
            for q in max(0, j - 1)...min(j + 1, grid[k].count - 1) {
                if k != i || q != j {
                    grid[k][q].neighs += by
                }
            }
        }
    }
    
    func aliveNeighboursCount(grid: [[CellState]], i: Int, j: Int) -> Int {
        var neighs = 0
        for k in max(0, i - 1)...min(i + 1, grid.count - 1) {
            for q in max(0, j - 1)...min(j + 1, grid[k].count - 1) {
                if k != i || q != j {
                    if grid[k][q] == CellState.ALIVE {
                        neighs += 1
                    }
                }
            
            }
        }
        return neighs
    }
    
    internal func scrollViewDidScroll(scrollView: UIScrollView) {
        clearHighlight()
        self.setNeedsDisplay()
    }
    
    static func emptyGrid(n: Int, m: Int) -> [[CellState]] {
        var grid = [[CellState]]()
        for _ in 0..<n {
            grid.append(Array.init(count: m, repeatedValue: CellState.DEAD))
        }
        return grid
    }
    
    static func randomGrid(n: Int, m: Int) -> [[CellState]] {
        var grid = [[CellState]]()
        for i in 0..<n {
            grid.append([CellState]())
            for _ in 0..<m {
                if (Int(arc4random_uniform(100)) % 2 == 0) {
                    grid[i].append(CellState.DEAD)
                } else {
                    grid[i].append(CellState.ALIVE)
                }
            }
        }
        return grid
    }
    
    
    func coordinatesOfAbsoluteLocation(point: CGPoint) -> CGPoint {
        let x = Double(point.x) / (cellSize + cellMargin)
        let y = Double(point.y) / (cellSize + cellMargin)
        return CGPoint(x: floor(x), y: floor(y))
    }
    
    func coordinatesOfRelativeLocation(point: CGPoint) -> CGPoint {
        let x = Double(self.contentOffset.x + point.x)
        let y = Double(self.contentOffset.y + point.y)
        return coordinatesOfAbsoluteLocation(CGPoint(x: x, y: y))
    }
    
    func apply(applyGrid: [[CellState]], fromPoint: CGPoint) {
        let fromX = Int(fromPoint.x)
        let fromY = Int(fromPoint.y)
        
        for i in max(fromX, 0)..<min(fromX + applyGrid.count, grid.count) {
            for j in max(fromY, 0)..<min(fromY + applyGrid[0].count, grid[0].count) {
                if i - fromX >= 0 && i - fromX < grid.count && j - fromY >= 0 && j - fromY < grid[0].count {
                    if applyGrid[i - fromX][j - fromY] == CellState.ALIVE {
                        grid[i][j].state = applyGrid[i - fromX][j - fromY]
                    }
                }
            }
           
        }
        
        clearHighlight()
        self.setNeedsDisplay()
    }
    
    private func clearHighlight() {
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if grid[i][j].highlight {
                    grid[i][j].highlight = false
                }
            }
        }
    }
    
    func highlight(highlightGrid: [[CellState]], fromPoint: CGPoint) {
        let fromX = Int(fromPoint.x)
        let fromY = Int(fromPoint.y)
        clearHighlight()
        for i in max(0, fromX)..<min(fromX + highlightGrid.count, grid.count) {
            for j in max(0, fromY)..<min(fromY + highlightGrid[0].count, grid.count) {
                if i - fromX >= 0 && i - fromX < grid.count && j - fromY >= 0 && j - fromY < grid[0].count {
                    if highlightGrid[i - fromX][j - fromY] != CellState.DEAD {
                        grid[i][j].highlight = true
                    }
                }
            }
            
        }
        self.setNeedsDisplay()
    }
    
    func extractGrid() -> [[CellState]] {
        var extractedGrid = [[CellState]]()
        for i in 0..<grid.count {
            extractedGrid.append([CellState]())
            for j in 0..<grid[i].count {
                extractedGrid[i].append(grid[i][j].state)
            }
        }
        return extractedGrid
    }
    
    static func gridFromList(list: [[Int]]) -> [[CellState]] {
        
        var grid = GameView.emptyGrid(200, m: 200)
        for i in 0..<list.count {
            grid[list[i][0]][list[i][1]] = CellState.ALIVE
        }
        return grid
    }
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

