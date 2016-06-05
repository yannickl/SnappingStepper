/*
 * StyledLabel
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

/// The `StyledLabel` object is an `UILabel` with a custom shape.
public final class StyledLabel: UIView {
  var label                = UILabel()
  var styleColor: UIColor? = UIColor.clearColor()
  var shapeLayer           = CAShapeLayer()

  public var style: ShapeStyle = .Box {
    didSet {
      applyStyle()
    }
  }

  public var text: String? {
    didSet {
      label.text = text
    }
  }

  public var textColor: UIColor = .blackColor() {
    didSet {
      label.textColor = textColor
    }
  }

  public override var backgroundColor: UIColor? {
    get {
      return .clearColor()
    }
    set {
      styleColor = newValue

      applyStyle()
    }
  }

  public var borderColor: UIColor? {
    didSet {
      applyStyle()
    }
  }

  public var borderWidth: CGFloat = 1.0 {
    didSet {
      applyStyle()
    }
  }

  public var font: UIFont? {
    didSet {
      label.font = font
    }
  }

  public var textAlignment: NSTextAlignment = .Center {
    didSet {
      label.textAlignment = textAlignment
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

    label.frame = bounds
  }

  func applyStyle() {
    let bgColor = styleColor ?? .clearColor()
    let sLayer: CAShapeLayer

    if let borderColor = borderColor {
      sLayer = CustomShapeLayer.createShape(style, bounds: bounds, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
    }
    else {
      sLayer = CustomShapeLayer.createShape(style, bounds: bounds, color: bgColor)
    }

    if self.shapeLayer.superlayer != nil {
      self.layer.replaceSublayer(shapeLayer, with: sLayer)
    }

    self.shapeLayer = sLayer
  }
}
