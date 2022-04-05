//
//  BarContainer.swift.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit


public class BarContainerData {
    public let model: BarEntryModel?
    public internal(set) var id: Int
    
    public init(model: BarEntryModel?, id: Int) {
        self.model = model
        self.id = id
    }
}


public protocol BarContainerDelegate: AnyObject {
    func didSelectLayer(bar: Bar)
    
    // Called when the animation for the Layer has been started
    func animationDidStart(bar: Bar)
    
    // Called when the animation for the Layer has been finished/stopped
    func animationDidStop(bar: Bar)
    
}

open class BarContainer: CALayer {
    //MARK: Properties

    enum AnimationDirection {
        case top
        case bottom
    }
    
    /// Animates the bar if selected
    public var selected: Bool = false {
        didSet {
            guard selected != oldValue else {return}
            self.barLayer?.animateSelected(selected: selected)
            
            if selected {
                guard let entry = barEntry else { return}
                containerDelegate?.didSelectLayer(bar: Bar(container: self, data: entry))
            }
        }
    }

    /// The actual bar
    public var barLayer: BarLayer?
    
    /// Color of the background bar
    private var containerColor: UIColor?
    
    /// Rounding of the bar
    private var cornerRounding: CGFloat = 5
    
    /// Data of the bar
    public var barEntry: BarContainerData?
    /// Delegate
    weak var containerDelegate: BarContainerDelegate?
        
    /// Width of the bar
    public var width: CGFloat {
        return self.bounds.width
    }
    
    //MARK: init
    init(width: CGFloat, color: UIColor, animationDuration: Double, animationDelay: Double, cornerRounding: CGFloat, containerColor: UIColor?) {
        super.init()
        self.barLayer = BarLayer(width: width, color: color, animationDuration: animationDuration, animationDelay: animationDelay, cornerRounding: cornerRounding)
        self.barLayer?.barLayerDelegate = self
        self.containerColor = containerColor
        self.cornerRounding = cornerRounding
        self.backgroundColor = containerColor?.cgColor
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        guard let barContainer = layer as? BarContainer else { return }
        barLayer = barContainer.barLayer
        barEntry = barContainer.barEntry
        cornerRounding = barContainer.cornerRounding
        containerColor = barContainer.containerColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    open override func setNeedsLayout() {
        super.setNeedsLayout()
        cornerRadius = cornerRounding
        masksToBounds = true
    }
    
    internal func setBarLayerHeight(to height: CGFloat, direction: AnimationDirection = .bottom) {
        let bounds =  CGRect(x: 0 , y: direction == .bottom ? height : 0, width: width, height: self.bounds.size.height - height)
        self.barLayer?.anchorPoint = direction == .bottom ? CGPoint(x: 1, y: 1) : .zero
        self.barLayer?.frame = bounds
    }
    
    
    // Presents the bar based on the representation/animation
    public func present(animated: Bool, oldLayer: CALayer?) {
        guard let barLayer = barLayer else {
            return
        }
        self.addSublayer(barLayer)
        
        guard let layer = oldLayer as? BarContainer else {
            barLayer.present(animated: animated, oldLayer: nil)
            return
        }
        barLayer.present(animated: animated, oldLayer: layer.barLayer)
    }
}

extension BarContainer: BarLayerDelegate {
    public func animationDidStart() {
        guard let entry = barEntry else {return}
        self.containerDelegate?.animationDidStart(bar: Bar(container: self, data: entry))
    }
    
    public func animationDidStop() {
        guard let entry = barEntry else {return}
        self.containerDelegate?.animationDidStop(bar: Bar(container: self, data: entry))
    }
    
}
