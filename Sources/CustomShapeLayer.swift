/*
 * CustomShapeLayer
 * Created by Martin Rehder.
 *
 * SnappingStepper
 *
 * Copyright 2015-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

final class CustomShapeLayer {
    static func createShape(style: ShapeStyle, bounds: CGRect, color: UIColor) -> CAShapeLayer {
        let shape = CAShapeLayer()

        let path        = CustomShapeLayer.shapePathForStyle(style: style, bounds: bounds)
        shape.path      = path.cgPath
        shape.fillColor = color.cgColor

        return shape
    }

    static func createShape(style: ShapeStyle, bounds: CGRect, color: UIColor, borderColor: UIColor, borderWidth: CGFloat) -> CAShapeLayer {
        let shape = CAShapeLayer()

        let path          = CustomShapeLayer.shapePathForStyle(style: style, bounds: bounds)
        shape.path        = path.cgPath
        shape.fillColor   = color.cgColor
        shape.strokeColor = borderColor.cgColor
        shape.lineWidth   = borderWidth

        return shape
    }

    static func shapePathForStyle(style: ShapeStyle, bounds: CGRect) -> UIBezierPath {
        var path = UIBezierPath()

        switch style {
        case .box, .none:
            path = UIBezierPath(rect: bounds)
        case .rounded:
            path = UIBezierPath(roundedRect: bounds, cornerRadius: max(1.0, min(bounds.size.width, bounds.size.height) * 0.2))
        case .roundedFixed(let cornerRadius):
            path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        case .thumb:
            let s    = min(bounds.size.width, bounds.size.height)
            let xOff = (bounds.size.width - s) * 0.5
            path     = UIBezierPath(ovalIn: CGRect(x: bounds.origin.x + xOff, y: bounds.origin.y, width: s, height: s))
        case .tube:
            path = UIBezierPath(roundedRect: bounds, cornerRadius: max(1.0, min(bounds.size.width, bounds.size.height) * 0.5))
        case .custom(let cpath):
            path = CustomShapeLayer.getScaledPath(path: cpath.cgPath, size: bounds.size)
        }

        return path
    }

    static func getScaledPath(path: CGPath, size: CGSize) -> UIBezierPath {
        let rect        = CGRect(origin:CGPoint(x:0, y:0), size:CGSize(width: size.width, height: size.height))
        let boundingBox = path.boundingBox

        let scaleFactorX = rect.width / boundingBox.width
        let scaleFactorY = rect.height / boundingBox.height

        var scaleTransform = CGAffineTransform.identity
        scaleTransform     = scaleTransform.scaledBy(x: scaleFactorX, y: scaleFactorY)
        scaleTransform     = scaleTransform.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)


        let scaledSize   = boundingBox.size.applying(CGAffineTransform(scaleX: scaleFactorX, y: scaleFactorY))
        let centerOffset = CGSize(width: (rect.width - scaledSize.width) / (scaleFactorX * 2.0), height:(rect.height - scaledSize.height) / (scaleFactorY * 2.0))
        scaleTransform = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)

        let scaledPath =  path.copy(using: &scaleTransform)!

        return UIBezierPath(cgPath: scaledPath)
    }

    static func createHintShapeLayer(label: StyledLabel, fillColor: CGColor?) {
        let shape = CAShapeLayer()
        let cp1   = CGPoint(x: label.bounds.width * 0.35, y: label.bounds.height)
        let cp2   = CGPoint(x: label.bounds.width * 0.65, y: label.bounds.height)
        let cpc   = CGPoint(x: label.bounds.width / 2.0, y: label.bounds.height * 1.25)
        let sp    = CGPoint(x: label.bounds.width / 2.0, y: label.bounds.height * 1.5)

        let myBezier = UIBezierPath()
        myBezier.move(to: sp)
        myBezier.addCurve(to: CGPoint(x: label.bounds.width * 0.2, y: label.bounds.height), controlPoint1: cpc, controlPoint2: cp1)
        myBezier.addLine(to: CGPoint(x: label.bounds.width * 0.8, y: label.bounds.height))
        myBezier.addCurve(to: sp, controlPoint1: cp2, controlPoint2: cpc)
        myBezier.close()

        shape.path      = myBezier.cgPath
        shape.fillColor = fillColor

        label.layer.addSublayer(shape)
    }
}

