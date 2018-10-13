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
class StyledLabel: UIView {
  var label                = UILabel()
  var styleColor: UIColor? = .clear
  var shapeLayer           = CAShapeLayer()

    var style: ShapeStyle = .box {
    didSet {
      applyStyle()
    }
  }

  var text: String? {
    didSet {
      label.text = text
    }
  }

  var textColor: UIColor = .black {
    didSet {
      label.textColor = textColor
    }
  }

  override var backgroundColor: UIColor? {
    get {
      return .clear
    }
    set {
      styleColor = newValue

      applyStyle()
    }
  }

  var borderColor: UIColor? {
    didSet {
      applyStyle()
    }
  }

  var borderWidth: CGFloat = 1.0 {
    didSet {
      applyStyle()
    }
  }

  var font: UIFont? {
    didSet {
      self.label.font = font
    }
  }

  var textAlignment: NSTextAlignment = .center {
    didSet {
      label.textAlignment = textAlignment
    }
  }
    
  var rotationInRadians: CGFloat = 0 {
    didSet {
      self.setNeedsLayout()
    }
  }
    
  init() {
    super.init(frame: CGRect.zero)
        
    self.layer.addSublayer(self.shapeLayer)
  }
    
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func layoutSubviews() {
    super.layoutSubviews()
        
    self.applyStyle()
    label.removeFromSuperview()
        
    self.label.frame = bounds
    self.label.transform = CGAffineTransform(rotationAngle: self.rotationInRadians)
    self.label.frame = bounds
    self.addSubview(label)
  }

  func applyStyle() {
    let bgColor = styleColor ?? UIColor.clear
    let sLayer: CAShapeLayer

    if let borderColor = borderColor {
        sLayer = CustomShapeLayer.createShape(style: style, bounds: bounds, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
    }
    else {
        sLayer = CustomShapeLayer.createShape(style: style, bounds: bounds, color: bgColor)
    }

    if self.shapeLayer.superlayer != nil {
      self.layer.replaceSublayer(shapeLayer, with: sLayer)
    }

    self.shapeLayer = sLayer
  }
}
