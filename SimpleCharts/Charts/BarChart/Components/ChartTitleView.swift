//
//  ChartTitleView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

// TODO: Add title view to charts
open class ChartTitleView: UIView {
    /// X offset of the TitleView
    open var titleXOffset: CGFloat = 10 {
        didSet {
            layoutIfNeeded()
        }
    }

    /// Text of the title
    public var titleText: String = "Title" {
        didSet {
            labelLayer.string = NSString(string: titleText)
        }
    }

    /// Font of the title
    public var titleFont: UIFont = .systemFont(ofSize: 18, weight: .bold) {
        didSet {
            labelLayer.font = titleFont
            labelLayer.fontSize = titleFont.pointSize
        }
    }

    /// Text of the subtitle
    public var subTitleText: String? {
        didSet {
            setupSubTitle()
            subTitleLayer.removeFromSuperlayer()
            layer.addSublayer(subTitleLayer)
        }
    }

    /// Font of the subtitle
    public var subtitleFont = UIFont.systemFont(ofSize: 10, weight: .medium) {
        didSet {
            subTitleLayer.font = subtitleFont
            subTitleLayer.fontSize = subtitleFont.pointSize
        }
    }

    /// Layer for the title
    fileprivate(set) var labelLayer: CATextLayer = .init()
    /// Layer for the subtitle
    fileprivate(set) var subTitleLayer: CATextLayer = .init()

    // MARK: Init

    convenience init(titleText: String, titleFont: UIFont, subTitleText: String, subTitleFont _: UIFont) {
        self.init(text: titleText, font: titleFont)

        self.subTitleText = subTitleText
        subtitleFont = subtitleFont

        commonInit()
    }

    public init(text: String) {
        titleText = text

        super.init(frame: .zero)
        commonInit()
    }

    public init(text: String, font: UIFont) {
        titleText = text
        titleFont = font

        super.init(frame: CGRect.zero)
        commonInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        backgroundColor = .clear

        labelLayer.contentsScale = UIScreen.main.scale
        labelLayer.alignmentMode = .left

        labelLayer.fontSize = titleFont.pointSize
        labelLayer.font = titleFont
        labelLayer.string = NSString(string: titleText)
        labelLayer.foregroundColor = UIColor.label.cgColor

        subTitleLayer.contentsScale = UIScreen.main.scale
        subTitleLayer.alignmentMode = .left

        layer.addSublayer(labelLayer)
        setupSubTitle()
    }

    // MARK: Functions

    private func setupSubTitle() {
        guard let subtitle = subTitleText else {
            return
        }

        subTitleLayer.string = subtitle

        subTitleLayer.fontSize = subtitleFont.pointSize
        subTitleLayer.font = subtitleFont
        subTitleLayer.string = NSString(string: subtitle)
        subTitleLayer.foregroundColor = UIColor.label.cgColor
    }

    override open func layoutSublayers(of layer: CALayer) {
        let titleSize = titleText.sizeOfString(usingFont: titleFont)
        let subTitleSize = subTitleText?.sizeOfString(usingFont: subtitleFont) ?? CGSize(width: 0, height: 0)
        labelLayer.frame = CGRect(origin: CGPoint(x: titleXOffset, y: 0), size: CGSize(width: titleSize.width, height: titleSize.height))

        subTitleLayer.frame = CGRect(origin: CGPoint(x: titleXOffset, y: titleSize.height), size: CGSize(width: subTitleSize.width, height: subTitleSize.height))

        height(constant: subTitleSize.height + titleSize.height)
        super.layoutSublayers(of: layer)
    }

    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }

    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        for constraint in constraints {
            if constraint.firstAttribute == attribute {
                removeConstraint(constraint)
            }
        }
    }

    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        addConstraint(constraint)
    }
}
