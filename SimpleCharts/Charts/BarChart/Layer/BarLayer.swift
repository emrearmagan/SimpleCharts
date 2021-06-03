//
//  BarLayer.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 29.05.21.
//

import UIKit

public protocol BarLayerDelegate: AnyObject {
    func didSelectLayer(bar: Bar)
    
    // Called when the animation for the Layer has been started
    func animationDidStart(bar: Bar)
    
    // Called when the animation for the Layer has been finished/stopped
    func animationDidStop(bar: Bar)
}

open class BarLayer: CALayer {
    //MARK: Public Properties
    /// Animates the bar if selected
    public var selected: Bool = false {
        didSet {
            animateSelected(selected: selected)
            if selected {
                guard let entry = barEntry else { return}
                barLayerDelegate?.didSelectLayer(bar: Bar(layer: self, data: entry))
            }
        }
    }
    
    /// Color of the Bar
    public var color = UIColor.systemBlue
    
    /// Duration of the animation
    public var animationDuration: Double = 0.5
    
    /// Delay of the animation
    public var animationDelay: Double = 0
    
    /// Rounding of the bar
    public var cornerRounding: CGFloat = 5
    
    /// Data of the bar
    public var barEntry: BarLayerData?
    open weak var barLayerDelegate: BarLayerDelegate?
    
    //MARK: Private Properties
    
    /// Width of the bar
    private var width: CGFloat = 0
    
    /// Custom animation key for animating the bounds of the bar
    @NSManaged var boundsManaged: CGRect
    
    /// A flag indicated whether or not to animate the layer
    private var disabledAnimation = false
    
    //MARK: init
    init(width: CGFloat, color: UIColor, animationDuration: Double, animationDelay: Double, cornerRounding: CGFloat) {
        super.init()
        self.width = width
        self.color = color
        self.animationDuration = animationDuration
        self.animationDelay = animationDelay
        self.cornerRounding = cornerRounding
        self.backgroundColor = color.cgColor
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        guard let barLayer = layer as? BarLayer else { return }
        color = barLayer.color
        animationDuration = barLayer.animationDuration
        animationDelay = barLayer.animationDelay
        barEntry = barLayer.barEntry
        width = barLayer.width
        boundsManaged = barLayer.boundsManaged
        cornerRounding = barLayer.cornerRounding
        disabledAnimation = barLayer.disabledAnimation
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Functions
    open override func setNeedsLayout() {
        super.setNeedsLayout()
        cornerRadius = cornerRounding
    }
    
    // If boundsManaged we need to tell the system to animate the bar
    open override class func needsDisplay(forKey key: String) -> Bool {
        if key == "boundsManaged" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    // Returns the animation for the bar
    open override func action(forKey key: String) -> CAAction? {
        if disabledAnimation {
            return NSNull()
        }
        
        // MARK: TODO: Use boundsManaged for animation: Somehow its nil.. and beginTime not working properly
        if key == "boundsManaged" {
            let animation = CABasicAnimation(keyPath: "bounds")
            if let bounds = oldLayer {
                animation.fromValue = bounds.bounds
            } else {
                animation.fromValue = CGRect(x: self.bounds.maxX, y: self.bounds.height - 0, width: width, height: 0)
            }
            animation.toValue = self.bounds
            
            animation.duration = animationDuration
            //animation.beginTime = CACurrentMediaTime() + animationDelay
            animation.delegate = self
            
            return animation
        }
        
        return super.action(forKey: key)
    }

    var oldLayer: CALayer?
    // Presents the bar based on the representation/animation
    public func present(animated: Bool, oldLayer: CALayer?) {
        self.oldLayer = oldLayer
        let bounds = CGRect(x: self.bounds.maxX, y: self.bounds.height - 0, width: width, height: 0)
        let f = {self.boundsManaged = bounds}
        if animated {
            f()
        } else {
            withDisabledAnimation {
                f()
            }
        }
    }
    
    // Disbaled temporarily the animation
    private func withDisabledAnimation(f: () -> Void) {
        disabledAnimation = true
        f()
        disabledAnimation = false
    }
    
    // Behavior for when the bar is selected
    open func animateSelected(selected: Bool) {
        backgroundColor = selected ? self.color.withAlphaComponent(0.5).cgColor : self.color.cgColor
    }
    
}


//MARK: CAAnimationDelegate
extension BarLayer: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        guard let entry = barEntry else {return}
        barLayerDelegate?.animationDidStart(bar: Bar(layer: self, data: entry))
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let entry = barEntry else {return}
        barLayerDelegate?.animationDidStop(bar: Bar(layer: self, data: entry))
    }
}
