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

/// A stepper control provides a user interface for incrementing or decrementing a value. The `SnappingStepper` addings a thumb in the middle to allow the user to update the value by sliding it either to the left or the right side.
@IBDesignable public final class SnappingStepper: UIControl {
  let minusLabel = UILabel()
  let plusLabel  = UILabel()
  let thumbView  = UIView()

  var timer: NSTimer?

  let dynamicButtonAnimator = UIDynamicAnimator()
  var snappingBehavior: SnappingStepperBehavior?

  // MARK: - Configuring the Stepper

  /**
  The continuous vs. noncontinuous state of the stepper.

  :discussion:
  If true, value change events are sent immediately when the value changes during user interaction. If false, a value change event is sent when user interaction ends.

  The default value for this property is true.
  */
  @IBInspectable public var continuous: Bool = true

  /**
  The automatic vs. nonautomatic repeat state of the stepper.

  :discussion:
  If true, the user pressing and holding on the stepper repeatedly alters value.

  The default value for this property is true.
  */
  @IBInspectable public var autorepeat: Bool = true

  /**
  The wrap vs. no-wrap state of the stepper.

  :discussion:
  If true, incrementing beyond maximumValue sets value to minimumValue; likewise, decrementing below minimumValue sets value to maximumValue. If false, the stepper does not increment beyond maximumValue nor does it decrement below minimumValue but rather holds at those values.

  The default value for this property is false.
  */
  @IBInspectable public var wraps: Bool = false

  /**
  The lowest possible numeric value for the stepper.

  :discussion:
  Must be numerically less than maximumValue. If you attempt to set a value equal to or greater than maximumValue, the system raises an NSInvalidArgumentException exception.

  The default value for this property is 0.
  */
  @IBInspectable public var minimumValue: Double = 0

  /**
  The highest possible numeric value for the stepper.

  :discussion:
  Must be numerically greater than minimumValue. If you attempt to set a value equal to or lower than minimumValue, the system raises an NSInvalidArgumentException exception.

  The default value of this property is 100.
  */
  @IBInspectable public var maximumValue: Double = 100

  /**
  The step, or increment, value for the stepper.

  :discussion:
  Must be numerically greater than 0. If you attempt to set this property’s value to 0 or to a negative number, the system raises an NSInvalidArgumentException exception.

  The default value for this property is 1.
  */
  @IBInspectable public var stepValue: Double = 1

  // MARK: - Accessing the Stepper’s Value

  /**
  The numeric value of the snapping stepper.

  :discussion:
  When the value changes, the stepper sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.

  The default value for this property is 0. This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.
  */
  @IBInspectable public var value: Double {
    get {
      return _value
    }
    set (newValue) {
      _value = newValue

      sendActionsForControlEvents(.ValueChanged)
    }
  }
  var _value: Double = 0

  // MARK: - Configuring the Stepper Visual Appearance

  /// The font of the texts (`minus` and `plus` labels)
  @IBInspectable public var font = UIFont(name: "TrebuchetMS-Bold", size: 20) {
    didSet {
      minusLabel.font = font
      plusLabel.font  = font
    }
  }

  /// The view’s background color.
  override public var backgroundColor: UIColor? {
    didSet {
      minusLabel.backgroundColor = backgroundColor
      plusLabel.backgroundColor  = backgroundColor

      if thumbColor == nil {
        thumbView.backgroundColor = backgroundColor?.lighterColor()
      }
    }
  }

  /// The thumb's color
  @IBInspectable public var thumbColor: UIColor? {
    didSet {
      thumbView.backgroundColor = thumbColor
    }
  }

  // MARK: - Deallocating Snappinf Stepper

  deinit {
    timer?.invalidate()
  }

  // MARK: - Initializing a Snapping Stepper

  /// Initializes and returns a newly allocated view object with the specified frame rectangle.
  override public init(frame: CGRect) {
    super.init(frame: frame)

    initComponents()
    setupGestures()
  }

  /// Returns an object initialized from data in a given unarchiver.
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    initComponents()
    setupGestures()
  }

  // MARK: - Laying out Subviews

  /// Lays out subviews
  public override func layoutSubviews() {
    super.layoutSubviews()

    layoutComponents()
  }

  // MARK: - Managing the Components

  func initComponents() {
    minusLabel.text                   = "-"
    minusLabel.font                   = font
    minusLabel.textAlignment          = .Center
    minusLabel.userInteractionEnabled = true
    addSubview(minusLabel)

    plusLabel.text                   = "+"
    plusLabel.font                   = font
    plusLabel.textAlignment          = .Center
    plusLabel.userInteractionEnabled = true
    addSubview(plusLabel)

    thumbView.userInteractionEnabled = true
    addSubview(thumbView)
  }

  func setupGestures() {
    let panGesture = UIPanGestureRecognizer(target: self, action: "sliderPanned:")
    thumbView.addGestureRecognizer(panGesture)

    let touchGesture = UITouchGestureRecognizer(target: self, action: "stepperTouched:")
    touchGesture.requireGestureRecognizerToFail(panGesture)
    addGestureRecognizer(touchGesture)
  }

  func layoutComponents() {
    minusLabel.frame = CGRectMake(0, 0, bounds.width / 3, bounds.height)
    plusLabel.frame  = CGRectMake(bounds.width / 3 * 2, 0, bounds.width / 3, bounds.height)
    thumbView.frame = CGRectMake(bounds.width / 3, 0, bounds.width / 3, bounds.height)

    snappingBehavior = SnappingStepperBehavior(item: thumbView, snapToPoint: CGPointMake(bounds.size.width * 0.5, bounds.size.height * 0.5))
  }

  // MARK: - Responding to Gesture Events

  func stepperTouched(sender: UITouchGestureRecognizer) {
    let touchLocation = sender.locationInView(self)
    let hitView       = hitTest(touchLocation, withEvent: nil)

    _factorValue = hitView == minusLabel ? -1 : 1

    switch (sender.state, hitView) {
    case (.Began, let v) where v == minusLabel || v == plusLabel:
      if autorepeat {
        startAutorepeat()
      }
      else {
        let value = _value + stepValue * _factorValue

        updateValue(value, finished: true)
      }

      v!.backgroundColor = backgroundColor?.darkerColor()
    case (.Changed, let v):
      if v == minusLabel || v == plusLabel {
        v!.backgroundColor = backgroundColor?.darkerColor()

        if autorepeat {
          startAutorepeat()
        }
      }
      else {
        minusLabel.backgroundColor = backgroundColor
        plusLabel.backgroundColor  = backgroundColor

        stopAutorepeat()
      }
    default:
      minusLabel.backgroundColor = backgroundColor
      plusLabel.backgroundColor  = backgroundColor

      if autorepeat {
        stopAutorepeat()

        _factorValue = 0

        updateValue(_value, finished: true)
      }
    }
  }

  /// Initial touch location
  var touchesBeganPoint    = CGPointZero
  var initialValue: Double = -1

  func sliderPanned(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Began:
      touchesBeganPoint = sender.translationInView(thumbView)
      dynamicButtonAnimator.removeBehavior(snappingBehavior)

      thumbView.backgroundColor = thumbColor?.lighterColor()

      if autorepeat {
        startAutorepeat()
      }
      else {
        initialValue = _value
      }
    case .Changed:
      let translationInView = sender.translationInView(thumbView)

      var centerX = (bounds.width * 0.5) + ((touchesBeganPoint.x + translationInView.x) * 0.35)
      centerX     = max(thumbView.bounds.width / 2, min(centerX, bounds.width - thumbView.bounds.width / 2))

      thumbView.center = CGPointMake(centerX, thumbView.center.y);

      if autorepeat {
        if centerX < bounds.width / 2 - 5 {
          _factorValue = -1
        }
        else if centerX > bounds.width / 2 + 5 {
          _factorValue = 1
        }
        else {
          _factorValue = 0
        }
      }
      else {
        _value = initialValue + stepValue * Double(Int((thumbView.center.x - CGRectGetMidX(bounds)) * 0.35))

        updateValue(_value, finished: true)
      }
    case .Ended, .Failed, .Cancelled:
      dynamicButtonAnimator.addBehavior(snappingBehavior)

      thumbView.backgroundColor = thumbColor ?? backgroundColor?.lighterColor()

      if autorepeat {
        stopAutorepeat()

        _factorValue = 0

        updateValue(_value, finished: true)
      }
    case .Possible:
      break
    }
  }

  // MARK: - Updating the Value

  var _autorepeatCount: Int = 0
  var _factorValue: Double  = 0

  func startAutorepeat() {
    if let _timer = timer where _timer.valid {
      return
    }

    _autorepeatCount = 0

    repeatTick(nil)

    let newTimer = NSTimer(timeInterval: 0.1, target: self, selector: "repeatTick:", userInfo: nil, repeats: true)
    timer        = newTimer

    NSRunLoop.currentRunLoop().addTimer(newTimer, forMode: NSRunLoopCommonModes)
  }

  func stopAutorepeat() {
    timer?.invalidate()
  }

  func repeatTick(sender: AnyObject?) {
    let needsIncrement: Bool

    if _autorepeatCount < 10 {
      needsIncrement = _autorepeatCount % 5 == 0
    }
    else if _autorepeatCount < 20 {
      needsIncrement = _autorepeatCount % 4 == 0
    }
    else if _autorepeatCount < 25 {
      needsIncrement = _autorepeatCount % 3 == 0
    }
    else if _autorepeatCount < 30 {
      needsIncrement = _autorepeatCount % 2 == 0
    }
    else if _autorepeatCount < 35 {
      needsIncrement = _autorepeatCount % 1 == 0
    }
    else {
      needsIncrement = true
    }

    _autorepeatCount++

    if needsIncrement {
      let value = _value + stepValue * _factorValue

      updateValue(value, finished: false)
    }
  }

  func updateValue(value: Double, finished: Bool = true) {
    if !wraps {
      _value = max(minimumValue, min(value, maximumValue))
    }
    else {
      if value < minimumValue {
        _value = maximumValue
      }
      else if value > maximumValue {
        _value = minimumValue
      }
    }

    if continuous || finished {
      sendActionsForControlEvents(.ValueChanged)
    }
  }
}
