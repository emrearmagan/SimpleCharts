//
//  TitleView.swift
//  SimpleChart
//
//  Created by Emre Armagan on 05.04.22.
//

import UIKit

//TODO: Add title view to charts
open class ChartTitleView: UIView {
    /// X offset of the TitleView
    open var titleXOffset: CGFloat = 10 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    /// Text of the title
    public var titleText: String = "Title" {
        didSet {
            labelLayer.string = NSString(string: titleText)
        }
    }
    
    /// Font of the title
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold) {
        didSet {
            labelLayer.font = self.titleFont
            labelLayer.fontSize = self.titleFont.pointSize
        }
    }
    
    /// Text of the subtitle
    public var subTitleText: String? {
        didSet {
            setupSubTitle()
            self.subTitleLayer.removeFromSuperlayer()
            self.layer.addSublayer(subTitleLayer)
        }
    }
    
    /// Font of the subtitle
    public var subtitleFont = UIFont.systemFont(ofSize: 10, weight: .medium) {
        didSet {
            subTitleLayer.font = self.subtitleFont
            subTitleLayer.fontSize = self.subtitleFont.pointSize
        }
    }
    
    /// Layer for the title
    fileprivate(set) var labelLayer: CATextLayer = CATextLayer()
    /// Layer for the subtitle
    fileprivate(set) var subTitleLayer: CATextLayer = CATextLayer()
    
    //MARK: Init
    convenience init(titleText: String, titleFont: UIFont, subTitleText: String, subTitleFont: UIFont) {
        self.init(text: titleText, font: titleFont)
        
        self.subTitleText = subTitleText
        self.subtitleFont = subtitleFont
        
        commonInit()
    }
    
    public init(text: String) {
        self.titleText = text
        
        super.init(frame: .zero)
        commonInit()
    }
    
    public init(text: String, font: UIFont) {
        self.titleText = text
        self.titleFont = font
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func commonInit() {
        backgroundColor = .clear
        
        labelLayer.contentsScale = UIScreen.main.scale
        labelLayer.alignmentMode = .left
        
        labelLayer.fontSize = self.titleFont.pointSize
        labelLayer.font = self.titleFont
        labelLayer.string = NSString(string: titleText)
        labelLayer.foregroundColor = UIColor.label.cgColor
        
        
        subTitleLayer.contentsScale = UIScreen.main.scale
        subTitleLayer.alignmentMode = .left
        
        self.layer.addSublayer(labelLayer)
        setupSubTitle()
    }
    
    //MARK: Functions
    private func setupSubTitle() {
        guard let subtitle = subTitleText else {
            return
        }

        subTitleLayer.string = subtitle
        
        subTitleLayer.fontSize = self.subtitleFont.pointSize
        subTitleLayer.font = self.subtitleFont
        subTitleLayer.string = NSString(string: subtitle)
        subTitleLayer.foregroundColor = UIColor.label.cgColor
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        let titleSize = titleText.sizeOfString(usingFont: self.titleFont)
        let subTitleSize = subTitleText?.sizeOfString(usingFont: self.subtitleFont) ?? CGSize(width: 0, height: 0)
        labelLayer.frame = CGRect(origin: CGPoint(x: titleXOffset, y: 0), size: CGSize(width: titleSize.width, height: titleSize.height))
        
        subTitleLayer.frame = CGRect(origin: CGPoint(x: titleXOffset, y: titleSize.height), size: CGSize(width: subTitleSize.width, height: subTitleSize.height))
        
        
        
        self.height(constant: subTitleSize.height + titleSize.height)
        super.layoutSublayers(of: layer)
    }
    
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach({
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        })
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        self.addConstraint(constraint)
    }
}
