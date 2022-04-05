//
//  LineChart.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

open class LineChartView: UIView {
    
    //MARK: Properties
    ///The Graph points
    public var graphPoints: [LineChartEntryModel] = [] {
        didSet{
            setSortedGraphPoints()
        }
    }
    
    /// Customizable properties
    public var margin: CGFloat = 8.0
    public var topBorder: CGFloat = 15.0
    public var bottomBorder: CGFloat = 20.0
    public var circleDiameter: CGFloat = 6.0
    public var lineAlpha: CGFloat = 0.3
    
    public var labelFont: UIFont = .systemFont(ofSize: 11, weight: .medium)
    public var todayFont: UIFont = .systemFont(ofSize: 11, weight: .bold)
    
    /// Height of the view
    private var height: CGFloat {
        return bounds.size.height
    }
    
    /// Width of the view
    private var width: CGFloat {
        return bounds.size.width
    }
    
    /// Sorted Graphpoints by Date with maximum 7 entries
    private(set) var sortedGraphPoints: [LineChartEntryModel] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    //initWithCode to init view from xib or storyboard
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        setupLabels()
    }
    
    //MARK: Draw
    public override func draw(_ rect: CGRect) {
        guard sortedGraphPoints.count != 0 else {return}
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        // Set up the points line
        let graphPath = UIBezierPath()
        
        // Go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(sortedGraphPoints[0].value)))
        
        UIColor.white.setStroke()
        // Add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<sortedGraphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(sortedGraphPoints[i].value))
            graphPath.addLine(to: nextPoint)
        }
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        
        // Draw vertical graph lines on the top of everything
        let linePath = UIBezierPath()
        
        for i in 0..<7 {
            linePath.move(to: CGPoint(x: columnXPoint(i), y: topBorder))
            linePath.addLine(to: CGPoint(x: columnXPoint(i), y: height - bottomBorder))
        }
        
        let lineColor = UIColor(white: 1.0, alpha: lineAlpha)
        lineColor.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        // Draw the circles on top of the graph stroke
        for i in 0..<sortedGraphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(sortedGraphPoints[i].value))
            point.x -= circleDiameter / 2
            point.y -= circleDiameter / 2
            
            let circle = UIBezierPath(
                ovalIn: CGRect(
                    origin: point,
                    size: CGSize(
                        width: circleDiameter,
                        height: circleDiameter)
                )
            )
            
            UIColor.white.setFill()
            circle.fill()
        }
        
        setNeedsLayout()
    }
}

extension LineChartView {
    /**
     Sortes the graph points by date. If there are less than 7 entries, the first entry will be duplicated
     */
    private func setSortedGraphPoints() {
        var filteredPoints = Array(graphPoints.sorted().prefix(7))
        if filteredPoints.count < 7 {
            if let first = filteredPoints.first {
                var today = first.date
                let diff = 7 - filteredPoints.count
                for _ in 0..<diff {
                    if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) {
                        today = yesterday
                        filteredPoints.insert(LineChartEntryModel(value: first.value, date: yesterday), at: 0)
                    }
                }
            }
        }
        sortedGraphPoints = filteredPoints
    }
    
    /**
     Position the labels for the Graph
     */
    private func setupLabels() {
        var weekdays: [String] = []
        for point in sortedGraphPoints {
            if point.date.isDateToday() {
                weekdays.append("Today")
                continue
            }
            weekdays.append(point.date.shortedWeekday())
        }
        
        for i in 0..<weekdays.count {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
            label.center = CGPoint(x: columnXPoint(i), y: height - 0)
            label.textAlignment = .center
            label.font = self.labelFont
            label.textColor = UIColor.white.withAlphaComponent(0.6)
            let weekday = weekdays[i]
            label.text = weekday
            if weekday == "Today" {
                label.font = self.todayFont
                label.textColor = .white
            }
            
            self.addSubview(label)
        }
        
        //addFollowerLabel()
    }
    
    /**
     Calculates the y point on the Graph
     */
    private func columnYPoint(_ graphPoint: Int) -> CGFloat{
        let graphHeight = height - topBorder - bottomBorder
        
        
        guard let maxValue = graphPoints.map({$0.value}).max() else {return graphHeight + self.topBorder}
        //guard let minValue = dataPoints.min() else {return 0}
        guard let lastValue = graphPoints.map({$0.value}).min() else {return graphHeight + self.topBorder}
        
        if graphPoint == lastValue {
            return graphHeight * 0.5 + self.topBorder
        }
        
        //        if graphPoint == minValue {
        //            return graphHeight + self.topBorder
        //        }
        
        var yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
        // yPoint can be NaN if all points (including maxValue) is zero
        if yPoint.isNaN {
            yPoint = 0.5 * graphHeight
        }
        return graphHeight + self.topBorder - yPoint // Flip the graph
    }
    
    /**
     Calculates the gap between points
     */
    private func columnXPoint(_ column: Int) -> CGFloat {
        // Calculate the gap between points
        let graphWidth = width - margin * 2 - 4
        
        let spacing = graphWidth / 6
        return CGFloat(column) * spacing + self.margin + 2
    }
    
    /**
     Returns positions for the date
     */
    private func dateColumnXPoint(_ date: Date) -> CGFloat {
        // Calculate the gap between points
        let weekday = Calendar.current.component(.weekday, from: date)
        return columnXPoint(weekday - 1)
    }
}

extension Date {
    func isDateToday() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .day)
    }
    
    func shortedWeekday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: self)
    }
}
