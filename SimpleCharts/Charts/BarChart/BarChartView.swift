//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 29.05.21.
//

import UIKit

public protocol BarChartViewDelegate: AnyObject {
    // Called when a Bar has been selected inside the BarChartView
    func didSelect(selectedBar: Bar)
    
    // Called when the animation for a Bar has started
    func animationDidStartFor(bar: Bar)
    
    // Called when the animation for a Bar has finished/stopped
    func animationDidStopFor(bar: Bar)
}

public class BarChartView: BaseChartView {
    // MARK: Public Properties
    
    /// Array of bar entries. Each entry contains information about its values, color and label
    public var entries: [BarEntryModel] = [] {
        didSet {
            //addLegend()
            layoutIfNeeded()
            container.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            self.bars = self.generateBars(entry: self.entries)
        }
    }
    
    /// Returns the highest value of every entry in the BarChart
    public var maxValue: Double {
        return entries.reduce(Double(0)){max($0, $1.value)}
    }
    
    
    /// Rounding of the corners
    open var cornerRadius: CGFloat {
        return (50.0 / CGFloat(entries.count))
    }
    
    /// Spacing between each bar
    open var spacing: CGFloat {
        return barWidth * (0.8 / CGFloat(entries.count - 1))
    }
    
    /// Width of every Bar inside the BarChart
    public var barWidth: CGFloat {
        return container.bounds.size.width / CGFloat(entries.count + 1)
    }
    
    open weak var delegate: BarChartViewDelegate?
    
    //MARK: Private Properties
    /// Contains all BarLayers
    fileprivate(set) var container: CALayer = CALayer()
    
    /// A flag indicated whether the entries have been updated or set
    private(set) var updatingEntries = false
    
    /// Contains all Bars from the BarLayer
    fileprivate(set) var bars: [Bar] = [] {
        didSet {
            for (index, bar) in self.bars.enumerated() {
                self.container.addSublayer(bar.layer)
                bar.layer.present(animated: animated, oldLayer: updatingEntries ? oldValue[safe: index]?.layer : nil)
            }
        }
    }
    
    /// Space at the bottom of the bar to show the title
    private let bottomSpace: CGFloat = 0
    
    /// Space at the top of each bar to show the value
    private let topSpace: CGFloat = 50
    
    /// Rounding of each Bar based on the number of entries
    private var cornerRounding: CGFloat {
        return CGFloat(50 / entries.count)
    }
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        self.layer.addSublayer(container)
    }
    
    //MARK: Functions
    public override func layoutSublayers(of layer: CALayer) {
        if (layer == self.layer) {
            /*if showLegendary {
             container.frame = CGRect(x: 0, y:0, width: self.bounds.width, height: self.bounds.height - legend.bounds.height)
             }*/
            container.frame = self.bounds
            container.masksToBounds = true
        }
        
        super.layoutSublayers(of: layer)
    }
    
    
    public func updateEntries(entries: [BarEntryModel], animationDuration: Double) {
        self.animationDuration = animationDuration
        
        self.updatingEntries = true
        self.entries = entries
        self.updatingEntries = true
    }
    
    private func generateBars(entry: [BarEntryModel]) -> [Bar] {
        var bars: [Bar] = []
        
        for(index, entry) in entries.enumerated() {
            let bar = generateBar(entry: entry, index: index)
            bars.append(bar)
        }
        return bars
    }
    
    
    private func generateBar(entry: BarEntryModel, index: Int) -> Bar{
        
        let data = BarLayerData(model: entry, id: index)
        let bar = Bar(layer: BarLayer(width: barWidth, color: entry.color, animationDuration: animationDuration, animationDelay: animationDelay, cornerRounding: cornerRounding), data: data)
        
        
        let xPos: CGFloat = CGFloat(index) * (barWidth + spacing)
        let yPos: CGFloat = translateHeightValueToYPosition(value: entry.value)
        
        let bounds = CGRect(x: xPos, y: yPos, width: barWidth, height: container.bounds.size.height - bottomSpace - yPos)
        
        bar.layer.anchorPoint = CGPoint(x: 1, y: 1)
        bar.layer.frame = bounds
        bar.layer.barLayerDelegate = self
        bar.layer.barEntry = data
        
        /*        let label = CATextLayer()
         label.fontSize = 12
         label.font = UIFont.systemFont(ofSize: 12)
         
         let w = String(entry.value).widthOfString(usingFont: UIFont.systemFont(ofSize: 12))
         label.frame = CGRect(x: (xPos + barWidth / 2) - w / 2, y: yPos - topSpace, width: String(entry.value).widthOfString(usingFont: UIFont.systemFont(ofSize: 12)), height: String(entry.value).heightOfString(usingFont: UIFont.systemFont(ofSize: 12)))
         label.string = NSString(string: String(Int(entry.value)))
         label.alignmentMode = .left
         label.foregroundColor = UIColor.black.resolvedColor(with: .current).cgColor
         label.contentsScale = UIScreen.main.scale
         container.addSublayer(label)*/
        
        return bar
    }
    
    private func translateHeightValueToYPosition(value: Double) -> CGFloat {
        let nValue = value / maxValue
        let height: CGFloat = CGFloat(nValue) * (container.bounds.size.height - bottomSpace - topSpace)
        return container.bounds.size.height - bottomSpace - height
    }

}

//MARK: Touch
extension BarChartView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        guard markSelected else {return}
        
        if let touch = touches.first, let touchedLayer = self.layerFor(touch) as? BarLayer
        {
            
            self.bars.forEach({ bar in
                let selected = bar.layer.selected
                bar.layer.selected = bar.layer.hashValue == touchedLayer.hashValue ? !selected : false
            })
            
        }
    }
    
    private func layerFor(_ touch: UITouch) -> CALayer?
    {
        let view = self
        let touchLocation = touch.location(in: view)
        let locationInView = view.convert(touchLocation, to: nil)
        
        
        let hitPresentationLayer = view.layer.presentation()?.hitTest(locationInView)
        
        return hitPresentationLayer?.model()
    }
    
}
//MARK: BarLayerDelegate
extension BarChartView: BarLayerDelegate {
    public func animationDidStart(bar: Bar){
        delegate?.animationDidStartFor(bar: bar)
    }
    
    public func animationDidStop(bar: Bar){
        delegate?.animationDidStopFor(bar: bar)
    }
    
    public func didSelectLayer(bar: Bar){
        delegate?.didSelect(selectedBar: bar)
    }
}

//MARK: LegendLayerDelegate
extension BarChartView: LegendLayerDelegate {
    public func didDetermineSize(height: CGFloat) {
    }
}
