//
//  BarLegend.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 01.06.21.
//

import UIKit

public class LegendEntry {
    public let color: UIColor
    public let label: String
    
    public init(color: UIColor, label: String) {
        self.color = color
        self.label = label
    }
}

public protocol LegendLayerDelegate {
    func didDetermineSize(height: CGFloat)
}

class LegendLayer: CALayer {
    //MARK: Public Properties
    public var entries: [LegendEntry] = [] {
        didSet{
            self.sublayers?.forEach({$0.removeFromSuperlayer()})
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: 10)
    var legendDelegate: LegendLayerDelegate?
    
    //MARK: Private Propterties
    private var midY: CGFloat {
        return 0
    }
    
    // Returns the witdh of the longest label
    private var maxLabelWidth: CGFloat {
        return entries.reduce(0){
            let width = $1.label.widthOfString(usingFont: self.font)
            return max($0, width)
        }
    }
    
    // Returns the whole width for a given entry
    private var legendWidth: CGFloat {
        return circleDiameter + labelSpacing + maxLabelWidth + spacing
    }
    
    // The width of the LegenLayer
    private var width: CGFloat {
        return self.bounds.width
    }
    
    // Size of circle
    private var circleDiameter: CGFloat = 10
    
    // Spacing between each legend entry
    private var spacing: CGFloat = 10
    
    // Spacing between each point and label
    private var labelSpacing: CGFloat = 14
    
    // Margin at x-Axis
    private var marginX: CGFloat = 20
    
    // Space between each each
    private var rowSpacing: CGFloat = 20
    
    // Determines how many entries can fit in one row
    private var maxEntryPerRow: Int {
        return Int(floor(self.width / legendWidth))
    }
    
    // The number of rows
    private var totalNumberOfRows: Int {
        return  Int(floor((legendWidth * CGFloat(entries.count - 1) + legendWidth) / self.width))
    }
    
    //MARK: Init
    public override init() {
        super.init()
        contentsScale = UIScreen.main.scale
        //backgroundColor = UIColor.systemRed.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init()
        contentsScale = UIScreen.main.scale
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        guard let legendLayer = layer as? LegendLayer else { return }
        
        circleDiameter = legendLayer.circleDiameter
        marginX = legendLayer.marginX
        labelSpacing = legendLayer.labelSpacing
        entries = legendLayer.entries
        font = legendLayer.font
    }
    
    //MARK: Functions
    open override func draw(in ctx: CGContext) {
        ctx.beginPath()
        
        //var lastEntry: LegendEntry?
        for(index, entry) in entries.enumerated() {
            let point = getPoint(at: index)
            
          /*  if let lastEntry = lastEntry {
                // add margin
            } */
            
            ctx.addEllipse(in: CGRect(origin: point,
                                      size: CGSize(width: circleDiameter, height: circleDiameter)))
            ctx.setFillColor(entry.color.cgColor)
            ctx.drawPath(using: CGPathDrawingMode.fill)
            addLabel(for: entry, at: point)
            
            //lastEntry = entry
        }
        
        /*ctx.addLines(between: [CGPoint(x: 0, y: midY), CGPoint(x: self.bounds.width, y: midY)])
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.drawPath(using: .stroke)*/
    }
    
    override func layoutIfNeeded() {
        let height = CGFloat(CGFloat(totalNumberOfRows) * rowSpacing + rowSpacing)
        self.frame = CGRect(x: 0, y: (superlayer?.bounds.height)! - height, width: (superlayer?.bounds.width)!, height: height)
        super.layoutIfNeeded()
    }
    
    private func getPoint(at index: Int) -> CGPoint {
        let xPos = legendWidth * CGFloat(index % maxEntryPerRow)
        let row = getRowNumber(for: index)
        
        let yPos = midY + (rowSpacing * CGFloat(row))
        return CGPoint(x: xPos, y: yPos)
    }
    
    private func getRowNumber(for index: Int) -> Int{
        let trueXPos = legendWidth * CGFloat(index)
        let row =  Int(floor((trueXPos + legendWidth) / self.width))
        //print("Index: \(index % entryPerRow) - Row: \(row) - True: \((trueXPos + legendWidth + spacing) / self.width) - Value: \(trueXPos + legendWidth + spacing)")
        return row
        //return Int(floor(((legendWidth) * CGFloat(index) + legendWidth + labelSpacing + spacing) / self.trueWidth))
    }
    private func addLabel(for entry: LegendEntry, at point: CGPoint) {
        let label = CATextLayer()
        label.fontSize = font.pointSize
        
        label.frame = CGRect(x: point.x + labelSpacing, y: point.y, width: entry.label.widthOfString(usingFont: font), height: font.pointSize + 2)
        label.string = NSString(string: entry.label)
        label.alignmentMode = .left
        label.foregroundColor = UIColor.black.resolvedColor(with: .current).cgColor
        label.contentsScale = UIScreen.main.scale
        self.addSublayer(label)
    }

}
