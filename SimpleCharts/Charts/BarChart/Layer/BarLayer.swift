//
//  BarLayer.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

public protocol BarLayerDelegate: AnyObject {
    // Called when the animation for the Layer has been started
    func animationDidStart()

    // Called when the animation for the Layer has been finished/stopped
    func animationDidStop()
}

open class BarLayer: CALayer {
    // MARK: Properties

    /// Color of the Bar
    public var color = UIColor.systemBlue

    /// Duration of the animation
    public var animationDuration: Double = 0.5

    /// Delay of the animation
    public var animationDelay: Double = 0

    /// Rounding of the bar
    public var cornerRounding: CGFloat = 5

    /// Delegate
    weak var barLayerDelegate: BarLayerDelegate?

    /// Width of the bar
    private(set) var width: CGFloat = 10

    /// A flag indicated whether or not to animate the layer
    private(set) var disabledAnimation = false

    /// Custom animation key for animating the bounds of the bar
    @NSManaged private var boundsManaged: CGRect

    // MARK: Lifecycle

    init(width: CGFloat, color: UIColor, animationDuration: Double, animationDelay: Double, cornerRounding: CGFloat) {
        super.init()
        self.width = width
        self.color = color
        self.animationDuration = animationDuration
        self.animationDelay = animationDelay
        self.cornerRounding = cornerRounding
        backgroundColor = color.cgColor
        maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    override init(layer: Any) {
        super.init(layer: layer)
        guard let barLayer = layer as? BarLayer else { return }
        color = barLayer.color
        animationDuration = barLayer.animationDuration
        animationDelay = barLayer.animationDelay
        width = barLayer.width
        boundsManaged = barLayer.boundsManaged
        cornerRounding = barLayer.cornerRounding
        disabledAnimation = barLayer.disabledAnimation
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    override open func setNeedsLayout() {
        super.setNeedsLayout()
        /// Set cornerRounding based on height
        cornerRadius = min(bounds.height / 2, cornerRounding)
    }

    /**
     If boundsManaged change we need to tell the system to animate the bar
     */
    override open class func needsDisplay(forKey key: String) -> Bool {
        if key == "boundsManaged" {
            return true
        }

        return super.needsDisplay(forKey: key)
    }

    /**
     Returns the animation for the bar
     */
    override open func action(forKey key: String) -> CAAction? {
        if disabledAnimation {
            return NSNull()
        }

        // MARK: TODO: beginTime not working properly

        if key == "boundsManaged" {
            let animation = CABasicAnimation(keyPath: "bounds")
            if let bounds = oldLayer {
                animation.fromValue = bounds.bounds
            } else {
                animation.fromValue = CGRect(x: bounds.maxX, y: bounds.height - 0, width: width, height: 0)
            }

            animation.toValue = bounds

            animation.duration = animationDuration
            animation.beginTime = CACurrentMediaTime() + animationDelay
            animation.delegate = self

            return animation
        }

        return super.action(forKey: key)
    }

    /// previous layer to animate from
    var oldLayer: CALayer?

    /**
     Presents the bar based on the representation/animation
     */
    public func present(animated: Bool, oldLayer: CALayer?) {
        self.oldLayer = oldLayer
        let bounds = CGRect(x: self.bounds.maxX, y: self.bounds.height - 0, width: width, height: 0)
        let f = { self.boundsManaged = bounds }
        if animated {
            f()
        } else {
            withDisabledAnimation {
                f()
            }
        }
    }

    /**
     Returns nil to disable interactions. Interactions should only happen through the parent
     */
    override open func hitTest(_: CGPoint) -> CALayer? {
        return nil
    }

    /**
     Disbaled temporarily the animation
     */
    private func withDisabledAnimation(f: () -> Void) {
        disabledAnimation = true
        f()
        disabledAnimation = false
    }

    /**
     Behavior for when the bar is selected
     */
    open func animateSelected(selected: Bool) {
        backgroundColor = selected ? color.withAlphaComponent(0.5).cgColor : color.cgColor
    }
}

// MARK: CAAnimationDelegate

extension BarLayer: CAAnimationDelegate {
    public func animationDidStart(_: CAAnimation) {
        barLayerDelegate?.animationDidStart()
    }

    public func animationDidStop(_: CAAnimation, finished _: Bool) {
        barLayerDelegate?.animationDidStop()
    }
}
