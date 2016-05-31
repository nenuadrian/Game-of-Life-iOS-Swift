import Foundation
import UIKit


class EntityView: UIView {
    private var grid = [[CellState]]()
    
    static var cellSize = 11.5
    static var cellMargin = 0.5
    
    init(origin: CGPoint, grid: [[CellState]]) {
        self.grid = grid
        super.init(frame: EntityView.setup(origin, grid: grid))
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
    }
    
    static func setup(origin: CGPoint, grid: [[CellState]]) -> CGRect {
        let width = Double(grid.count) * cellSize + Double(grid.count) * cellMargin
        let height = Double(grid[0].count) * cellSize + Double(grid[0].count) * cellMargin
        let frame =  CGRect(x: origin.x, y: origin.y, width: CGFloat(width), height: CGFloat(height))
        return frame
    }
    
    func rotate() {
        var rotated = [[CellState]]()
        var jj = grid.count, ii = 0
        for j in 0..<grid[0].count {
            rotated.append([CellState]())
            for _ in 0..<jj {
                rotated[ii].append(CellState.DEAD)
            }
            for i in 0..<grid.count {
                jj -= 1
                rotated[ii][jj] = grid[i][j]
            }
            jj = grid.count
            ii += 1
        }
        self.frame = EntityView.setup(self.frame.origin, grid: rotated)
        self.grid = rotated
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        CGContextSetFillColorWithColor(context, UIColor.blackColor().colorWithAlphaComponent(0).CGColor)
        
        CGContextFillRect(context, rect)
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let x = Double(i) * EntityView.cellSize + Double(i) * EntityView.cellMargin
                let y = Double(j) * EntityView.cellSize + Double(j) * EntityView.cellMargin
                
                if grid[i][j] == CellState.ALIVE {
                    CGContextSetFillColorWithColor(context, UIColor.greenColor().colorWithAlphaComponent(0.2).CGColor)
                    CGContextFillRect(context, CGRect(x: x, y: y, width: EntityView.cellSize, height: EntityView.cellSize))
                }
                
            }
        }
    }
    
    func extractGrid() -> [[CellState]] {
        return grid
    }
  
}
