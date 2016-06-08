/*
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

extension SnappingStepper {
  // MARK: - Managing the Components

  func initComponents() {
    self.layer.addSublayer(styleLayer)

    hintLabel.font      = thumbFont
    hintLabel.textColor = thumbTextColor

    minusSymbolLabel.text      = "−"
    minusSymbolLabel.font      = symbolFont
    minusSymbolLabel.textColor = symbolFontColor

    addSubview(minusSymbolLabel)

    plusSymbolLabel.text      = "+"
    plusSymbolLabel.font      = symbolFont
    plusSymbolLabel.textColor = symbolFontColor
    addSubview(plusSymbolLabel)

    thumbLabel.font      = thumbFont
    thumbLabel.textColor = thumbTextColor
    addSubview(thumbLabel)
  }

  func setupGestures() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SnappingStepper.sliderPanned))
    thumbLabel.addGestureRecognizer(panGesture)

    let touchGesture = UITouchGestureRecognizer(target: self, action: #selector(SnappingStepper.stepperTouched))
    touchGesture.requireGestureRecognizerToFail(panGesture)
    addGestureRecognizer(touchGesture)
  }

  func layoutComponents() {
    let thumbWidth  = bounds.width * thumbWidthRatio
    let symbolWidth = (bounds.width - thumbWidth) / 2

    minusSymbolLabel.frame = CGRect(x: 0, y: 0, width: symbolWidth, height: bounds.height)
    plusSymbolLabel.frame  = CGRect(x: symbolWidth + thumbWidth, y: 0, width: symbolWidth, height: bounds.height)
    thumbLabel.frame       = CGRect(x: symbolWidth, y: 0, width: thumbWidth, height: bounds.height)
    hintLabel.frame        = CGRect(x: symbolWidth, y: -bounds.height * 1.5, width: thumbWidth, height: bounds.height)

    snappingBehavior = SnappingStepperBehavior(item: thumbLabel, snapToPoint: CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5))

    CustomShapeLayer.createHintShapeLayer(hintLabel, fillColor: thumbBackgroundColor?.lighterColor().CGColor)

    applyThumbStyle(thumbStyle)
    applyStyle(style)
    applyHintStyle(hintStyle)
  }

  func applyThumbStyle(style: ShapeStyle) {
    thumbLabel.style       = style
    thumbLabel.borderColor = thumbBorderColor
    thumbLabel.borderWidth = thumbBorderWidth
  }

  func applyHintStyle(style: ShapeStyle) {
    hintLabel.style = style
  }

  func applyStyle(style: ShapeStyle) {
    let bgColor: UIColor = .clearColor()
    let sLayer: CAShapeLayer

    if let borderColor = borderColor {
      sLayer = CustomShapeLayer.createShape(style, bounds: bounds, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
    }
    else {
      sLayer = CustomShapeLayer.createShape(style, bounds: bounds, color: bgColor)
    }

    if styleLayer.superlayer != nil {
      layer.replaceSublayer(styleLayer, with: sLayer)
    }

    styleLayer = sLayer
  }

  // MARK: - Responding to Gesture Events

  func stepperTouched(sender: UITouchGestureRecognizer) {
    let touchLocation = sender.locationInView(self)
    let hitView       = hitTest(touchLocation, withEvent: nil)

    factorValue = hitView == minusSymbolLabel ? -1 : 1

    switch (sender.state, hitView) {
    case (.Began, .Some(let v)) where v == minusSymbolLabel || v == plusSymbolLabel:
      if autorepeat {
        startAutorepeat()
      }
      else {
        let value = _value + stepValue * factorValue

        updateValue(value, finished: true)
      }

      v.backgroundColor = backgroundColor?.darkerColor()
    case (.Changed, .Some(let v)):
      if v == minusSymbolLabel || v == plusSymbolLabel {
        v.backgroundColor = backgroundColor?.darkerColor()

        if autorepeat {
          startAutorepeat()
        }
      }
      else {
        minusSymbolLabel.backgroundColor = backgroundColor
        plusSymbolLabel.backgroundColor  = backgroundColor

        autorepeatHelper.stop()
      }
    default:
      minusSymbolLabel.backgroundColor = backgroundColor
      plusSymbolLabel.backgroundColor  = backgroundColor

      if autorepeat {
        autorepeatHelper.stop()

        factorValue = 0

        updateValue(_value, finished: true)
      }
    }
  }

  func sliderPanned(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Began:
      if case .None = hintStyle {} else {
        hintLabel.alpha  = 0
        hintLabel.center = CGPoint(x: center.x, y: center.y - bounds.height - hintLabel.bounds.height / 2)

        superview?.addSubview(hintLabel)

        UIView.animateWithDuration(0.2) {
          self.hintLabel.alpha = 1.0
        }
      }

      touchesBeganPoint = sender.translationInView(thumbLabel)
      dynamicButtonAnimator.removeBehavior(snappingBehavior)

      thumbLabel.backgroundColor = thumbBackgroundColor?.lighterColor()
      hintLabel.backgroundColor  = thumbBackgroundColor?.lighterColor()

      if autorepeat {
        startAutorepeat(autorepeatCount: Int.max)
      }
      else {
        initialValue = _value
      }
    case .Changed:
      let translationInView = sender.translationInView(thumbLabel)

      var centerX = (bounds.width * 0.5) + ((touchesBeganPoint.x + translationInView.x) * 0.4)
      centerX     = max(thumbLabel.bounds.width / 2, min(centerX, bounds.width - thumbLabel.bounds.width / 2))

      thumbLabel.center = CGPoint(x: centerX, y: thumbLabel.center.y);

      let locationRatio = (thumbLabel.center.x - CGRectGetMidX(bounds)) / ((CGRectGetWidth(bounds) - CGRectGetWidth(thumbLabel.bounds)) / 2)
      let ratio         = Double(Int(locationRatio * 10)) / 10
      let factorValue   = ((maximumValue - minimumValue) / 100) * ratio

      if autorepeat {
        self.factorValue = factorValue
      }
      else {
        _value = initialValue + stepValue * factorValue

        updateValue(_value, finished: true)
      }
    case .Ended, .Failed, .Cancelled:
      if case .None = hintStyle {} else {
        UIView.animateWithDuration(0.2, animations: {
          self.hintLabel.alpha = 0.0
        }) { _ in
          self.hintLabel.removeFromSuperview()
        }
      }

      dynamicButtonAnimator.addBehavior(snappingBehavior)

      thumbLabel.backgroundColor = thumbBackgroundColor ?? backgroundColor?.lighterColor()

      if autorepeat {
        autorepeatHelper.stop()

        factorValue = 0

        updateValue(_value, finished: true)
      }
    case .Possible:
      break
    }
  }

  // MARK: - Updating the Value

  func startAutorepeat(autorepeatCount count: Int = 0) {
    autorepeatHelper.start(autorepeatCount: count) { [weak self] in
      if let weakSelf = self {
        let value = weakSelf._value + weakSelf.stepValue * weakSelf.factorValue

        weakSelf.updateValue(value, finished: false)
      }
    }
  }

  func updateValue(value: Double, finished: Bool = true) {
    if !wraps {
      _value = max(minimumValue, min(value, maximumValue))
    }
    else if value < minimumValue {
      _value = maximumValue
    }
    else if value > maximumValue {
      _value = minimumValue
    }

    if (continuous || finished) && oldValue != _value {
      oldValue = _value

      sendActionsForControlEvents(.ValueChanged)

      if let _valueChangedBlock = valueChangedBlock {
        _valueChangedBlock(value: _value)
      }
    }
  }

  func valueAsText() -> String {
    return value % 1 == 0 ? "\(Int(value))" : "\(value)"
  }
}
