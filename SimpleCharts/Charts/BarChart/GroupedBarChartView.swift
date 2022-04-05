//
//  GroupedBarChartView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

public enum GroupBarChartViewOption {
    case barchartOptions([BaseBarChartViewOption])
    case groupSpacing(CGFloat)
}

public class GroupedBarChartView: BaseBarChartView {
    // MARK: Properties
    
    /// Array of bar entries. Each entry contains information about its values, color and label
    public var entries: [GroupedEntryModel] = [] {
        didSet {
            let barEntries = entries.flatMap({$0.entries})
            self.baseEntries = barEntries
            
            layoutIfNeeded()
            layoutSublayers(of: self.layer)

            container.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            self.groupedBars = self.generateBars(entries: self.entries)
           // super.notifyConstraintChanges()
        }
    }
    
    /// spacing between each group
    open var groupSpacing: CGFloat = 10
    
    /// Delegate of  SYBarChartView
    weak var delegate: BarChartDelegate?

    /// Contains all Bars from the BarLayer
    fileprivate(set) var groupedBars: [GroupBar] = [] {
        didSet {
            for (index, gb) in self.groupedBars.enumerated() {
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
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: Functions
    override public func updateEntries(entries: [BaseEntryModel], animationDuration: Double) {
        guard let entries = entries as? [GroupedEntryModel] else {
            return
        }
        self.animationDuration = animationDuration
        
        self.updatingEntries = true
        self.entries = entries
        self.updatingEntries = false
    }
    
    override func notifyConstraintChanges() {
        for (index, gb) in groupedBars.enumerated() {
            let xPos: CGFloat = calculateXPos(for: index)
            let yPos: CGFloat = translateHeightValueToYPosition(value: gb.bar.data.model?.value ?? container.bounds.size.height)
            
            let containerBound = CGRect(x: xPos, y: 0, width: barWidth, height: container.bounds.size.height)
            gb.bar.container.frame = containerBound
            gb.bar.container.setBarLayerHeight(to: yPos)
        }
        //super.notifyConstraintChanges()
        //updateEntries(entries: entries, animationDuration: 0.5)
    }
    
    override internal func computeContentSize() -> CGSize {
        var width = ((barWidth + spacing) * CGFloat(baseEntries.count)) + (CGFloat(entries.count) * groupSpacing)
        width = max(width, self.bounds.width - leftSpacing)
        return CGSize(width: width, height: self.bounds.size.height)
    }
    
    override internal func getXPostionForXAxis(for index: Int) -> CGFloat {
        guard let groupId = getGroup(for: index), let firstIndex = self.groupedBars.first(where: {$0.groupId == groupId})?.bar.data.id else {
            //TODO: What to if group is not found?
            return -100
        }
        
        let xPos =  calculateXPos(for: firstIndex)
        return xPos
    }
    
    override internal func widthForXLabel(for label: String, at index: Int) -> CGFloat{
        guard let groupId = getGroup(for: index) else {
            return super.widthForXLabel(for: label, at: index)
        }
        
        return CGFloat(self.groupedBars.filter({$0.groupId == groupId}).count) * (barWidth + spacing)
    }
    
    private func generateBars(entries: [GroupedEntryModel]) -> [GroupBar] {
        var bars: [GroupBar] = []
        
        var index = 0
        for group in 0..<_maxEntries {
            guard let groupedBars = entries[safe: group] else {continue}
            for entry in groupedBars.entries {
                let bar = generateBar(entry: entry, group: group, index: index)
                bars.append(bar)
                index += 1
            }
        }
        
        return bars
    }
    
    override func calculateXPos(for index: Int) -> CGFloat {
        guard let groupId = getGroup(for: index) else {
            //TODO: What to if group is not found?
            return -10000
        }
        
        return calculateXPos(for: groupId, with: index)
    }
    
    func calculateXPos(for group: Int, with index: Int) -> CGFloat{
        return (spacing + super.calculateXPos(for: index)) + (CGFloat(group) * groupSpacing)
    }
    
    private func generateBar(entry: BarEntryModel, group: Int, index: Int) -> GroupBar{
        let data = BarContainerData(model: entry, id: index)
        
        let bar = Bar(container: BarContainer(width: barWidth, color: entry.color, animationDuration: animationDuration, animationDelay: animationDelay, cornerRounding: cornerRounding, containerColor: containerColor), data: data)
        
        let xPos: CGFloat = calculateXPos(for: group, with: index)
        let yPos: CGFloat = translateHeightValueToYPosition(value: entry.value)
        
        let containerBound = CGRect(x: xPos, y: 0, width: barWidth, height: container.bounds.size.height)
        
        bar.container.frame = containerBound
        bar.container.setBarLayerHeight(to: yPos)
        bar.container.containerDelegate = self
        bar.container.barEntry = data
        let gb = GroupBar(id: group, bar: bar)
        return gb
    }
    
    private func getGroup(for index: Int) -> Int? {
        return self.groupedBars.first(where: {$0.bar.data.id == index})?.groupId
    }
    
}

extension GroupedBarChartView {
    open func setGroupBarChartOptions(_ chartOptions: [BaseChartViewOption], groupBarOptions: [GroupBarChartViewOption]) {
        super.setChartOptions(chartOptions)
        
        for option in groupBarOptions {
            switch option {
            case .barchartOptions(let barOptions):
                //TODO: updating chartOptions twice
                self.setBarChartOptions(chartOptions, barOptions: barOptions)
            case .groupSpacing(let value):
                self.groupSpacing = value
            }
        }
        
        
    }
}

//TODO: Probably not working
//MARK: Touch
extension GroupedBarChartView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        guard markSelected else {return}
        
        if let touch = touches.first, let touchedLayer = self.layerFor(touch) as? BarContainer
        {
            //print(touchedLayer.hashValue)
            self.groupedBars.forEach { groupedBar in
                let selected = groupedBar.bar.container.selected
                groupedBar.bar.container.selected = groupedBar.bar.container.hashValue == touchedLayer.hashValue ? !selected : false
            }

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
extension GroupedBarChartView: BarContainerDelegate {
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


