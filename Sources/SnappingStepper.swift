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

import DynamicColor
import UIKit

/**
 A stepper control provides a user interface for incrementing or decrementing a value.

 The `SnappingStepper` addings a thumb in the middle to allow the user to update the value by sliding it either to the left or the right side. It can also be customizable to display the current value or custom text.
 */
@IBDesignable public final class SnappingStepper: UIControl {
  // MARK: - Preparing and Sending Messages using Blocks

  /**
   Block to be notify when the value of the stepper change.

   This is a convenient alternative to the `addTarget:Action:forControlEvents:` method of the `UIControl`.
   */
  public var valueChangedBlock: ((value: Double) -> Void)?

  // MARK: - Configuring the Stepper

  /**
   The continuous vs. noncontinuous state of the stepper.

   If true, value change events are sent immediately when the value changes during user interaction. If false, a value change event is sent when user interaction ends.

   The default value for this property is true.
   */
  @IBInspectable public var continuous: Bool = true

  /**
   The automatic vs. nonautomatic repeat state of the stepper.

   If true, the user pressing and holding on the stepper repeatedly alters value.

   The default value for this property is true.
   */
  @IBInspectable public var autorepeat: Bool = true

  /**
   The wrap vs. no-wrap state of the stepper.

   If true, incrementing beyond maximumValue sets value to minimumValue; likewise, decrementing below minimumValue sets value to maximumValue. If false, the stepper does not increment beyond maximumValue nor does it decrement below minimumValue but rather holds at those values.

   The default value for this property is false.
   */
  @IBInspectable public var wraps: Bool = false

  /**
   The lowest possible numeric value for the stepper.

   Must be numerically less than maximumValue. If you attempt to set a value equal to or greater than maximumValue, the system raises an NSInvalidArgumentException exception.

   The default value for this property is 0.
   */
  @IBInspectable public var minimumValue: Double = 0 {
    didSet {
      if minimumValue > maximumValue {
        maximumValue = minimumValue
      }

      updateValue(max(_value, minimumValue), finished: true)
    }
  }

  /**
   The highest possible numeric value for the stepper.

   Must be numerically greater than minimumValue. If you attempt to set a value equal to or lower than minimumValue, the system raises an NSInvalidArgumentException exception.

   The default value of this property is 100.
   */
  @IBInspectable public var maximumValue: Double = 100 {
    didSet {
      if maximumValue < minimumValue {
        minimumValue = maximumValue
      }

      updateValue(min(_value, maximumValue), finished: true)
    }
  }

  /**
   The step, or increment, value for the stepper.

   Must be numerically greater than 0. If you attempt to set this property’s value to 0 or to a negative number, the system raises an NSInvalidArgumentException exception.

   The default value for this property is 1.
   */
  @IBInspectable public var stepValue: Double = 1

  // MARK: - Accessing the Stepper’s Value

  /**
   The numeric value of the snapping stepper.

   When the value changes, the stepper sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.

   The default value for this property is 0. This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.
   */
  @IBInspectable public var value: Double {
    get {
      return _value
    }
    set (newValue) {
      updateValue(newValue, finished: true)
    }
  }

  var _value: Double = 0 {
    didSet {
      if thumbText == nil {
        thumbLabel.text = valueAsText()
      }

      hintLabel.text = valueAsText()
    }
  }

  // MARK: - Setting the Stepper Visual Appearance

  /// The font of the text symbols (`minus` and `plus`).
  @IBInspectable public var symbolFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
    didSet {
      minusSymbolLabel.font = symbolFont
      plusSymbolLabel.font  = symbolFont
    }
  }

  /// The color of the text symbols (`minus` and `plus`).
  @IBInspectable public var symbolFontColor: UIColor = .blackColor() {
    didSet {
      minusSymbolLabel.textColor = symbolFontColor
      plusSymbolLabel.textColor  = symbolFontColor
    }
  }

  /// The thumb width represented as a ratio of the component width. For example if the width of the stepper is 30px and the ratio is 0.5, the thumb width will be equal to 15px. Defaults to 0.5.
  @IBInspectable public var thumbWidthRatio: CGFloat = 0.5 {
    didSet {
      layoutComponents()
    }
  }

  /// The font of the thumb label.
  @IBInspectable public var thumbFont = UIFont(name: "TrebuchetMS-Bold", size: 20) {
    didSet {
      thumbLabel.font = thumbFont
    }
  }

  /// The thumb's background color. If nil the thumb color will be lighter than the background color. Defaults to nil.
  @IBInspectable public var thumbBackgroundColor: UIColor? {
    didSet {
      thumbLabel.backgroundColor = thumbBackgroundColor
    }
  }

  /// The thumb's text color. Default's to black
  @IBInspectable public var thumbTextColor: UIColor = .blackColor() {
    didSet {
      thumbLabel.textColor = thumbTextColor
    }
  }

  /// The thumb's style. Default's to box
  @IBInspectable public var thumbStyle: ShapeStyle = .Box {
    didSet {
      self.applyThumbStyle(thumbStyle)
    }
  }

  /// The view's style. Default's to box.
  @IBInspectable public var style: ShapeStyle = .Box {
    didSet {
      self.applyStyle(style)
    }
  }

  /// The hint's style. Default's to none, so no hint will be displayed.
  @IBInspectable public var hintStyle: ShapeStyle = .None {
    didSet {
      self.applyHintStyle(hintStyle)
    }
  }

  /// The view's border color.
  @IBInspectable public var borderColor: UIColor? {
    didSet {
      self.applyStyle(style)
    }
  }

  /// The thumbs's border color.
  @IBInspectable public var thumbBorderColor: UIColor? {
    didSet {
      self.applyThumbStyle(thumbStyle)
    }
  }

  /// The view's border width. Default's to 1.0
  @IBInspectable public var borderWidth: CGFloat = 1.0 {
    didSet {
      self.applyStyle(style)
    }
  }

  /// The thumbs's border width. Default's to 1.0
  @IBInspectable public var thumbBorderWidth: CGFloat = 1.0 {
    didSet {
      self.applyThumbStyle(thumbStyle)
    }
  }

  /// The view’s background color.
  override public var backgroundColor: UIColor? {
    didSet {
      self.styleColor = backgroundColor
      self.applyStyle(self.style)

      if thumbBackgroundColor == nil {
        thumbLabel.backgroundColor = backgroundColor?.lighterColor()
      }
    }
  }

  // MARK: - Displaying Thumb Text

  /// The thumb text to display. If the text is nil it will display the current value of the stepper. Defaults with empty string.
  @IBInspectable public var thumbText: String? = "" {
    didSet {
      if thumbText == nil {
        thumbLabel.text = valueAsText()
      }
      else {
        thumbLabel.text = thumbText
      }

      hintLabel.text = valueAsText()
    }
  }

  // MARK: - Deallocating Snappinf Stepper

  deinit {
    autorepeatHelper.stop()
  }

  // MARK: - Initializing a Snapping Stepper

  /// Initializes and returns a newly allocated view object with the specified frame rectangle.
  override public init(frame: CGRect) {
    super.init(frame: frame)

    initComponents()
    setupGestures()
  }

  /// Returns an object initialized from data in a given unarchiver.
  required public init?(coder aDecoder: NSCoder) {
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

  // MARK: - Internal Properties

  /// The value label that represents the thumb button
  lazy var thumbLabel: StyledLabel = UIBuilder.defaultStyledLabel()

  /// The hint label
  lazy var hintLabel: StyledLabel = UIBuilder.defaultStyledLabel()

  /// The minus label
  lazy var minusSymbolLabel: UILabel = UIBuilder.defaultLabel()

  /// The plus label
  lazy var plusSymbolLabel: UILabel = UIBuilder.defaultLabel()

  let autorepeatHelper      = AutoRepeatHelper()
  let dynamicButtonAnimator = UIDynamicAnimator()
  var snappingBehavior      = SnappingStepperBehavior(item: nil, snapToPoint: CGPointZero)

  var styleLayer = CAShapeLayer()
  var styleColor: UIColor? = .clearColor()

  var touchesBeganPoint    = CGPointZero
  var initialValue: Double = -1
  var factorValue: Double  = 0
  var oldValue = Double.infinity * -1
}
