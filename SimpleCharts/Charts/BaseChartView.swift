//
//  BaseChartView.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 02.06.21.
//

import UIKit

open class BaseChartView: UIView {
    
    /// Flag indicated whether to animate the Bars inside the BarChart
    internal var animated: Bool {
        return animationDuration > 0
    }
    
    /// Duration of the animation for every Bar inside the BarChartView
    open var animationDuration: Double = 0.5
    
    /// Delay of the animation for every Bar inside the BarChartView
    open var animationDelay: Double = 1
    
    /// Flag whether to add a showow on the view
    open var dropShadow: Bool = true {
        didSet {
            layer.shadowOpacity = dropShadow ? 0.5 : 0
        }
    }
    /// Color of the shadow
    open var shadowColor: UIColor = .black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    /// Flag whether the entry should be marked as selected
    public var markSelected: Bool = true
    
    /// Flag that indicates of the legendary should be shown
    public var showLegendary = true {
        didSet {
            //setupView()
        }
    }
    
    /// Contains all BarLayers
    fileprivate(set) var container: CALayer = CALayer()
    
    /// LegendLayer of the BarChart
    weak var legend: LegendLayer?
    
    public var titleView: TitleView? {
        didSet {
            //layoutIfNeeded()
            if titleView == nil {
                oldValue?.removeFromSuperview()
                return
            }
            print("adding title")
            self.addSubview(titleView!)
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    
    private func comminInit(){
        self.layer.addSublayer(container)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        /*layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
         layer.shadowColor = shadowColor.cgColor
         layer.shadowOpacity = 0.3
         layer.shadowRadius = 5
         layer.shadowOffset = .zero
         layer.shouldRasterize = true
         layer.rasterizationScale = UIScreen.main.scale*/
        
        if let titleView = titleView {
            print("setting constraints")
            titleView.translatesAutoresizingMaskIntoConstraints = false
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            titleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        }
    }
    
    internal func notifyConstraintChanges() {
        fatalError("notifyConstraintChanges(): has not been implemented for BaseChartView")
    }
    
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if (layer == self.layer) {
            print("setting container")
            let h = titleView?.bounds.height
            container.frame = CGRect(x: 0, y: (h != nil) ? h! : 0, width: self.bounds.width, height: self.bounds.height - ((h != nil) ? h! : 0))
            container.masksToBounds = true
            notifyConstraintChanges()
        }
        
    }
    
    
    func addLegend() {
        /*        if !showLegendary {
         return
         }
         
         let entries: [BarEntryModel] = []
         var legends: [LegendEntry] = []
         for e in entries {
         //legends.append(LegendEntry(color: e.color, label: e.label))
         }
         
         legend.entries = legends*/
    }
}
