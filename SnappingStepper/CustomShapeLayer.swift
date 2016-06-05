//
//  CustomShapeLayer.swift
//  SnappingStepper
//
//  Created by Martin Rehder on 04.06.16.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit

public enum CustomShapeStyle {
    case Box
    case Rounded
    case Thumb
    case Tube
    case Custom(path: UIBezierPath)
}

class CustomShapeLayer {

    static func createShape(style: CustomShapeStyle, bounds: CGRect, color: UIColor) -> CAShapeLayer {
        let shape = CAShapeLayer()
        
        let path = CustomShapeLayer.shapePathForStyle(style, bounds: bounds)
        shape.path = path.CGPath
        shape.fillColor = color.CGColor
        return shape
    }
    
    static func createShape(style: CustomShapeStyle, bounds: CGRect, color: UIColor, borderColor: UIColor, borderWidth: CGFloat) -> CAShapeLayer {
        let shape = CAShapeLayer()
        
        let path = CustomShapeLayer.shapePathForStyle(style, bounds: bounds)
        shape.path = path.CGPath
        shape.fillColor = color.CGColor
        shape.strokeColor = borderColor.CGColor
        shape.lineWidth = borderWidth
        return shape
    }
    
    static func shapePathForStyle(style: CustomShapeStyle, bounds: CGRect) -> UIBezierPath {
        var path = UIBezierPath()
        switch style {
        case .Box:
            path = UIBezierPath(rect: bounds)
        case .Rounded:
            path = UIBezierPath(roundedRect: bounds, cornerRadius: max(1.0, min(bounds.size.width, bounds.size.height) * 0.2))
        case .Thumb:
            let s = min(bounds.size.width, bounds.size.height)
            let xOff = (bounds.size.width - s) * 0.5
            path = UIBezierPath(ovalInRect: CGRectMake(bounds.origin.x + xOff, bounds.origin.y, s, s))
        case .Tube:
            path = UIBezierPath(roundedRect: bounds, cornerRadius: max(1.0, min(bounds.size.width, bounds.size.height) * 0.5))
        case .Custom(let cpath):
            path = CustomShapeLayer.getScaledPath(cpath.CGPath, size: bounds.size)
        }
        return path
    }
    
    static func getScaledPath(path: CGPathRef, size: CGSize) -> UIBezierPath {
        let rect: CGRect = CGRect(origin:CGPoint(x:0, y:0), size:CGSize(width:size.width, height:size.height))
        let boundingBox: CGRect = CGPathGetBoundingBox(path)
        
        let scaleFactorX: CGFloat = CGRectGetWidth(rect) / CGRectGetWidth(boundingBox)
        let scaleFactorY: CGFloat = CGRectGetHeight(rect) / CGRectGetHeight(boundingBox)
        
        var scaleTransform: CGAffineTransform = CGAffineTransformIdentity
        scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactorX, scaleFactorY)
        scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox))
        
        let scaledSize: CGSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactorX, scaleFactorY))
        let centerOffset: CGSize = CGSizeMake((CGRectGetWidth(rect) - scaledSize.width) / (scaleFactorX * 2.0),
                                              (CGRectGetHeight(rect) - scaledSize.height) / (scaleFactorY * 2.0))
        scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height)
        
        let scaledPath: CGPathRef = CGPathCreateCopyByTransformingPath(path, &scaleTransform)!
        let rpath: UIBezierPath = UIBezierPath()
        rpath.CGPath = scaledPath
        return rpath
    }
}
