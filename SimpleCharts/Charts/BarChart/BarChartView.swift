//
//  BarChartView.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 29.05.21.
//

import UIKit

public protocol BarChartViewDelegate: AnyObject {
    func didSelect(selectedBar: Bar)
    
    func animationDidStartFor(bar: Bar)
    
    func animationDidStopFor(bar: Bar)
}

public class BarChartView: UIView {
    // MARK: Public Properties
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
    
    
    open var animationDuration: Double = 0.5
    open var animationDelay: Double = 1
    
    public var showLegendary = true {
        didSet {
            setupView()
        }
    }
    
    public weak var delegate: BarChartViewDelegate?
    public var maxValue: Double {
        return entries.reduce(Double(Int.min)){max($0, $1.value)}
    }
    
    
    //MARK: Private Properties
    fileprivate(set) var container: CALayer = CALayer()
    fileprivate(set) var bars: [Bar] = []
    fileprivate(set) lazy var legend: LegendLayer = {
        let layer =  LegendLayer()
        return layer
    }()
    
    private var height: CGFloat {
        return container.bounds.size.height
    }
    
    private var width: CGFloat {
        return container.bounds.size.width
    }
    
    private var animated: Bool {
        return animationDuration > 0
    }
    
    public var barWidth: CGFloat {
        return width / CGFloat(entries.count + 1)
    }
    
    //Space between each bar
    private var spacing: CGFloat {
        return barWidth * (0.8 / CGFloat(entries.count - 1))
    }
    
    //Space at the bottom of the bar to show the title
    private let bottomSpace: CGFloat = 0
    
    //Space at the top of each bar to show the value
    private let topSpace: CGFloat = 0
    
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
        container.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
    }
    
    //MARK: Functions
    public override func layoutSublayers(of layer: CALayer) {
        if (layer == self.layer) {
            //print("here")
            print(legend.bounds.height)
            container.frame = CGRect(x: 0, y:0, width: self.bounds.width, height: self.bounds.height - legend.bounds.height)
            //legend.frame = layer.bounds
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
        
        let bounds = CGRect(x: xPos, y: yPos, width: barWidth, height: height - bottomSpace - yPos)
        
        bar.layer.anchorPoint = CGPoint(x: 1, y: 1)
        bar.layer.frame = bounds
        bar.layer.barLayerDelegate = self
        bar.layer.barEntry = data
        
        return bar
    }
    
    private func translateHeightValueToYPosition(value: Double) -> CGFloat {
        let nValue = value / entries.reduce(0){max($0, $1.value)}
        let height: CGFloat = CGFloat(nValue) * (self.height - bottomSpace - topSpace)
        return self.height - bottomSpace - height
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
        print(height)
    }
}
