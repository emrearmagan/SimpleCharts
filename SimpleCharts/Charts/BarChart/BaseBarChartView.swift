//
//  BarChartView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 04.04.22.
//

import UIKit

public enum BaseBarChartViewOption {
    case minBarWidth(CGFloat)
    case markSelected(Bool)
    case containerColor(UIColor)
    case cornerRounding(CGFloat)
}

open class BaseBarChartView: BaseChartView {
    
    /// Minimum width of each bar
    var minBarWidth: CGFloat?
    
    /// Width of every Bar inside the BarChart
    // TODO: Is Nan because of minEntry count
    open var barWidth: CGFloat {
        //return container.bounds.size.width / CGFloat(entries.count + 1)
        return minBarWidth ?? self.bounds.size.width / CGFloat(_minEntryCount) - spacing
    }

    /// Flag whether the entry should be marked as selected
    public var markSelected: Bool = true
    
    /// If set the barcontainer will have a background color
    public var containerColor: UIColor?
    
    /// Rounding of each Bar
    open var cornerRounding: CGFloat = 5
    
    //MARK: Lifecycle
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: Functions
    override internal func calculateXPos(for index: Int) -> CGFloat{
        return CGFloat(index) * (barWidth + spacing)
    }
    
    override internal func computeContentSize() -> CGSize {
        var width = ((barWidth + spacing) * CGFloat(numberOfEntries)) - spacing
        width = (width.isNaN) ? 0 : width
        return CGSize(width: width, height: self.bounds.size.height)
    }
    
    override internal func getXPostionForXAxis(for index: Int) -> CGFloat {
        return calculateXPos(for: index) - (spacing / 2)
    }
    
    override internal func widthForXLabel(for label: String, at index: Int) -> CGFloat{
        return barWidth + spacing
    }
}

extension BaseBarChartView {
    open func setBarChartOptions(_ chartOptions: [BaseChartViewOption], barOptions: [BaseBarChartViewOption]) {
        super.setChartOptions(chartOptions)
        
        for option in barOptions {
            switch option {
            case .minBarWidth(let value):
                self.minBarWidth = value
            case .markSelected(let value):
                self.markSelected = value
            case .containerColor(let value):
                self.containerColor = value
            case .cornerRounding(let value):
                self.cornerRounding = value
            }
        }
    }
}
