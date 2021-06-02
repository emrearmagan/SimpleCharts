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

public class BarChartView: UIView {
    // MARK: Public Properties
    
    /// Array of bar entries. Each entry contains information about its values, color and label
    public var entries: [BarEntryModel] = [] {
        didSet {
            addLegend()
            layoutIfNeeded()
            
            container.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            self.bars = self.generateBars(models: self.entries)
            for bar in self.bars {
                self.container.addSublayer(bar.layer)
                bar.layer.present(animated: animated)
            }
        }
    }
    
    /// Returns the highest value of every entry in the BarChart
    public var maxValue: Double {
        return entries.reduce(Double(0)){max($0, $1.value)}
    }
    
    /// Duration of the animation for every Bar inside the BarChartView
    open var animationDuration: Double = 0.5
    
    /// Delay of the animation for every Bar inside the BarChartView
    open var animationDelay: Double = 1
    
    /// Flag tha indicates of the legendary should be shown
    public var showLegendary = true {
        didSet {
            setupView()
        }
    }
    
    open weak var delegate: BarChartViewDelegate?
    
    //MARK: Private Properties
    /// Contains all BarLayers
    fileprivate(set) var container: CALayer = CALayer()
    /// Contains all Bars from the BarLayer
    fileprivate(set) var bars: [Bar] = []
    
    /// LegendLayer of the BarChart
    fileprivate(set) lazy var legend: LegendLayer = {
        let layer =  LegendLayer()
        return layer
    }()
    
    /// Flag indicated whether to animate the Bars inside the BarChart
    private var animated: Bool {
        return animationDuration > 0
    }
    
    /// Width of every Bar inside the BarChart
    public var barWidth: CGFloat {
        return container.bounds.size.width / CGFloat(entries.count + 1)
    }
    
    /// Spacing between each bar
    private var spacing: CGFloat {
        return barWidth * (0.8 / CGFloat(entries.count - 1))
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
        self.layer.addSublayer(legend)
        self.layer.addSublayer(container)
        legend.frame = layer.bounds
        container.frame = layer.bounds
        //legend.backgroundColor = UIColor.red.cgColor
        //container.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
    }
    
    //MARK: Functions
    public override func layoutSublayers(of layer: CALayer) {
        if (layer == self.layer) {
            if showLegendary {
            container.frame = CGRect(x: 0, y:0, width: self.bounds.width, height: self.bounds.height - legend.bounds.height)
            }
        }
        
        super.layoutSublayers(of: layer)
    }
    
    private func generateBars(models: [BarEntryModel]) -> [Bar] {
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
        
        return bar
    }
    
    private func translateHeightValueToYPosition(value: Double) -> CGFloat {
        let nValue = value / maxValue
        let height: CGFloat = CGFloat(nValue) * (container.bounds.size.height - bottomSpace - topSpace)
        return container.bounds.size.height - bottomSpace - height
    }
    
    private func addLegend() {
        if !showLegendary {
            return
        }
        
        var legends: [LegendEntry] = []
        for e in entries {
            legends.append(LegendEntry(color: e.color, label: e.label))
        }
        
        legend.entries = legends
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        
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

extension BarChartView: LegendLayerDelegate {
    public func didDetermineSize(height: CGFloat) {
    }
}
