//
//  StyledLabel.swift
//  SnappingStepper
//
//  Created by Martin Rehder on 04.06.16.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit

public class StyledLabel: UIView {

    var label = UILabel()
    var styleColor: UIColor? = .clearColor()
    var shapeLayer = CAShapeLayer()
    
    public var style: CustomShapeStyle = .Box {
        didSet {
            self.applyStyle()
        }
    }
    
    public var text: String? {
        didSet {
            self.label.text = text
        }
    }
    
    public var textColor: UIColor = .blackColor() {
        didSet {
            self.label.textColor = textColor
        }
    }

    public override var backgroundColor: UIColor? {
        set {
            self.styleColor = newValue
            self.applyStyle()
        }
        get {
            return .clearColor()
        }
    }
    
    public var borderColor: UIColor? {
        didSet {
            self.applyStyle()
        }
    }
    
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.applyStyle()
        }
    }
    
    public var font: UIFont? {
        didSet {
            self.label.font = font
        }
    }
    
    public var textAlignment: NSTextAlignment = .Center {
        didSet {
            self.label.textAlignment = textAlignment
        }
    }
    
    public init() {
        super.init(frame: CGRectZero)
        self.layer.addSublayer(self.shapeLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.applyStyle()
        label.removeFromSuperview()
        self.addSubview(label)
        label.frame = self.bounds
    }
    
    func applyStyle() {
        let bgColor = self.styleColor ?? UIColor.clearColor()
        let sLayer: CAShapeLayer
        if let borderColor = self.borderColor {
            sLayer = CustomShapeLayer.createShape(self.style, bounds: self.bounds, color: bgColor, borderColor: borderColor, borderWidth: self.borderWidth)
        }
        else {
            sLayer = CustomShapeLayer.createShape(self.style, bounds: self.bounds, color: bgColor)
        }
        if self.shapeLayer.superlayer != nil {
            self.layer.replaceSublayer(self.shapeLayer, with: sLayer)
        }
        self.shapeLayer = sLayer
    }
}
