//
//  RangeBarChartView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 04.04.22.
//

import UIKit

public class RangeBarChartView: BaseBarChartView {
    // MARK: Properties
    
    /// Array of rangeBar entries. Each entry contains information about its values, color and label
    public var entries: [RangeBarEntryModel] = [] {
        didSet {
            layoutIfNeeded()
            
            var en = [BaseEntryModel]()
            for entry in entries {
                en.append(BaseEntryModel(value: entry.min, label: entry.label))
                en.append(BaseEntryModel(value: entry.max, label: entry.label))
            }
            
            self.baseEntries = en
            container.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            self.rangeBars = self.generateBars(entries: self.entries)
        }
    }
    
    public var minBarAlphaValue: CGFloat = 0.3
    
    //TODO: Set spacing between bars
    public var minMaxspacing: CGFloat = 5
    
    public override var numberOfEntries: Int {
        return entries.count
    }
    
    /// Delegate of  SYBarChartView
    weak var delegate: BarChartDelegate?
   
    /// Contains all Bars from the BarLayer
    fileprivate(set) var rangeBars: [RangeBar] = [] {
        didSet {
            for (index, gb) in self.rangeBars.enumerated() {
                self.container.addSublayer(gb.bar.container)
                gb.bar.container.present(animated: animated, oldLayer: updatingEntries ? oldValue[safe: index]?.bar.container : nil)
            }
        }
    }
    
    //MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    //MARK: Functions
    override func notifyConstraintChanges() {
        for rb in rangeBars {
            let index = rb.bar.data.id
            let xPos: CGFloat = calculateXPos(for: index)
            let initYPos: CGFloat = translateHeightValueToYPosition(value: rb.initialValue)
            
            let yPos: CGFloat = translateHeightValueToYPosition(value: rb.bar.data.model?.value ?? 0)
            if !rb.isMax {
                rb.bar.container.frame = CGRect(x: xPos, y: yPos, width: barWidth, height: initYPos - yPos)
                rb.bar.container.setBarLayerHeight(to: 0, direction: .top)
            } else {
                rb.bar.container.frame = CGRect(x: xPos, y: yPos, width: barWidth, height: initYPos - yPos)
                rb.bar.container.setBarLayerHeight(to: 0)
            }
        }
    }
    
    override public func updateEntries(entries: [BaseEntryModel], animationDuration: Double) {
        guard let entries = entries as? [RangeBarEntryModel] else {
            return
        }
        self.animationDuration = animationDuration
        
        self.updatingEntries = true
        self.entries = entries
        self.updatingEntries = false
    }
    
    override internal func getXLabel(for index: Int) -> String? {
        guard let groupId = getGroup(for: index), let firstIndex = self.rangeBars.first(where: {$0.groupId == groupId})?.bar.data else {
            //TODO: What to if group is not found?
            return nil
        }
        
        return firstIndex.model?.label
    }
    
    override internal func getXPostionForXAxis(for index: Int) -> CGFloat {
        guard let groupId = getGroup(for: index), let firstIndex = self.rangeBars.first(where: {$0.groupId == groupId})?.bar.data.id else {
            //TODO: What to if group is not found?
            return -100
        }
        
        let xPos =  calculateXPos(for: firstIndex)
        return xPos - (spacing / 2)
    }

    
    private func generateBars(entries: [RangeBarEntryModel]) -> [RangeBar] {
        var bars: [RangeBar] = []
        for index in 0..<_maxEntries {
            if let entry = entries[safe: index] {
                let bar = generateBar(entry: entry, index: index)
                bars.append(bar.0)
                bars.append(bar.1)
            }
        }
        return bars
    }
    
    private func generateBar(entry: RangeBarEntryModel, index: Int) -> (RangeBar, RangeBar) {
        let xPos: CGFloat = calculateXPos(for: index)
        let initPos: CGFloat = translateHeightValueToYPosition(value: entry.value)
        
        
        //MinBar
        let minYPos: CGFloat = translateHeightValueToYPosition(value: entry.min)
        let minContainer = BarContainerData(model: BarEntryModel(value: entry.min, color: entry.color.withAlphaComponent(minBarAlphaValue), label: entry.label), id: index)
        let minBar = Bar(container: BarContainer(width: barWidth, color: entry.color.withAlphaComponent(minBarAlphaValue), animationDuration: animationDuration, animationDelay: animationDelay, cornerRounding: cornerRounding, containerColor: .clear), data: minContainer)
        
        minBar.container.anchorPoint = CGPoint(x: 1, y: 1)
        minBar.container.frame = CGRect(x: xPos, y: minYPos, width: barWidth, height: initPos - minYPos)
        minBar.container.setBarLayerHeight(to: 0, direction: .top)
        minBar.container.containerDelegate = self
        minBar.container.barEntry = minContainer
        
        //MaxBar
        let maxYPos: CGFloat = translateHeightValueToYPosition(value: entry.max)
        let maxContainer = BarContainerData(model: BarEntryModel(value: entry.max, color: entry.color, label: entry.label), id: index)
        let maxBar = Bar(container: BarContainer(width: barWidth, color: entry.color, animationDuration: animationDuration, animationDelay: animationDelay, cornerRounding: cornerRounding, containerColor: .clear), data: maxContainer)
        
        maxBar.container.anchorPoint = .zero
        maxBar.container.frame = CGRect(x: xPos, y: maxYPos, width: barWidth, height: initPos - maxYPos)
        maxBar.container.setBarLayerHeight(to: 0)
        maxBar.container.containerDelegate = self
        maxBar.container.barEntry = maxContainer
        
        let minGruped = RangeBar(id: index, isMax: false, initalValue: entry.value, bar: minBar)
        let maxGrouped = RangeBar(id: index, isMax: true, initalValue: entry.value, bar: maxBar)
        return (minGruped, maxGrouped)
    }

    
    private func getGroup(for index: Int) -> Int? {
        return self.rangeBars.first(where: {$0.bar.data.id == index})?.groupId
    }
}

//MARK: Touch
extension RangeBarChartView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        guard markSelected else {return}
        
        if let touch = touches.first, let touchedLayer = self.layerFor(touch) as? BarContainer
        {
            //print(touchedLayer.hashValue)
            self.rangeBars.forEach({ rb in
                let selected = rb.bar.container.selected
                rb.bar.container.selected = rb.bar.container.hashValue == touchedLayer.hashValue ? !selected : false
            })
            
        }
    }
    
    private func layerFor(_ touch: UITouch) -> Any?
    {
        let view = self
        let touchLocation = touch.location(in: view)
        let locationInView = view.convert(touchLocation, to: nil)
        
        
        let hitPresentationLayer = view.layer.presentation()?.hitTest(locationInView)
        
        return hitPresentationLayer?.model()
    }
    
}
//MARK: BarLayerDelegate
extension RangeBarChartView: BarContainerDelegate {
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


