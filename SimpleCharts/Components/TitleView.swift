//
//  TitleView.swift
//  SimpleCharts
//
//  Created by Emre Armagan on 03.06.21.
//

import UIKit

open class TitleView: UIView {
    public var text: String = "Title" {
        didSet {
            print("didSet")
            labelLayer.string = NSString(string: text)
        }
    }
    
    public var font: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold) {
        didSet {
            labelLayer.font = self.font
            labelLayer.fontSize = self.font.pointSize
        }
    }
    
    public var icon: UIImage? {
        didSet {
            layoutSubviews()
        }
    }
    
    open var titleXOffset: CGFloat {
        return self.bounds.width * 0.02
    }
    
    fileprivate var height: CGFloat {
        return text.heightOfString(usingFont: self.font)
    }
    
    fileprivate(set) var labelLayer: CATextLayer = CATextLayer()
    
    public init(text: String, font: UIFont) {
        self.text = text
        self.font = font
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        labelLayer.contentsScale = UIScreen.main.scale
        labelLayer.alignmentMode = .center
        
        labelLayer.fontSize = self.font.pointSize
        labelLayer.font = self.font
        labelLayer.string = NSString(string: text)
        labelLayer.foregroundColor = UIColor.black.resolvedColor(with: .current).cgColor
        
        self.layer.addSublayer(labelLayer)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        //print("layoutSublayer")
        
        let labelSize = text.sizeOfString(usingFont: self.font)
        labelLayer.frame = CGRect(origin: CGPoint(x: titleXOffset, y: self.center.y - labelSize.height / 2), size: CGSize(width: labelSize.width, height: labelSize.height))
        self.height(constant: labelSize.height + 5)

        if labelLayer.superlayer == nil {
            //self.layer.addSublayer(labelLayer)
        }
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
