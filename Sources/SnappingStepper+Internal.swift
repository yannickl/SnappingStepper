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
        touchGesture.require(toFail: panGesture)
        addGestureRecognizer(touchGesture)
    }

    func layoutComponents() {
        let bw = self.direction.principalSize(size: bounds.size)
        let bh = self.direction.nonPrincipalSize(size: bounds.size)
        let thumbWidth  = bw * thumbWidthRatio
        let symbolWidth = (bw - thumbWidth) / 2

        // It makes most sense to have the + on the top of the view, when the direction is vertical
        let mpPosM: CGFloat
        let mpPosP: CGFloat
        if self.direction == .horizontal {
            mpPosM = 0
            mpPosP = symbolWidth + thumbWidth
        }
        else {
            mpPosM = symbolWidth + thumbWidth
            mpPosP = 0
        }

        let minusSymbolLabelFrame = CGRect(x: mpPosM, y: 0, width: symbolWidth, height: bh)
        let plusSymbolLabelFrame  = CGRect(x: mpPosP, y: 0, width: symbolWidth, height: bh)
        let thumbLabelFrame       = CGRect(x: symbolWidth, y: 0, width: thumbWidth, height: bh)
        let hintLabelFrame        = CGRect(x: symbolWidth, y: -bounds.height * 1.5, width: thumbWidth, height: bh)

        minusSymbolLabel.frame = CGRect(origin: self.direction.getPosition(p: minusSymbolLabelFrame.origin), size: self.direction.getSize(size: minusSymbolLabelFrame.size))
        plusSymbolLabel.frame  = CGRect(origin: self.direction.getPosition(p: plusSymbolLabelFrame.origin), size: self.direction.getSize(size: plusSymbolLabelFrame.size))
        thumbLabel.frame       = CGRect(origin: self.direction.getPosition(p: thumbLabelFrame.origin), size: self.direction.getSize(size: thumbLabelFrame.size))

        // The hint label is not direction dependent
        hintLabel.frame        = hintLabelFrame

        snappingBehavior = SnappingStepperBehavior(item: thumbLabel, snapToPoint: CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5))

        CustomShapeLayer.createHintShapeLayer(label: hintLabel, fillColor: thumbBackgroundColor?.lighter().cgColor)

        applyThumbStyle(style: thumbStyle)
        applyStyle(style: style)
        applyHintStyle(style: hintStyle)
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
        let bgColor: UIColor = .clear
        let sLayer: CAShapeLayer

        if let borderColor = borderColor {
            sLayer = CustomShapeLayer.createShape(style: style, bounds: bounds, color: bgColor, borderColor: borderColor, borderWidth: borderWidth)
        }
        else {
            sLayer = CustomShapeLayer.createShape(style: style, bounds: bounds, color: bgColor)
        }

        if styleLayer.superlayer != nil {
            layer.replaceSublayer(styleLayer, with: sLayer)
        }

        styleLayer = sLayer
    }

    // MARK: - Responding to Gesture Events

    @objc func stepperTouched(sender: UITouchGestureRecognizer) {
        let touchLocation = sender.location(in: self)
        let hitView       = hitTest(touchLocation, with: nil)

        factorValue = hitView == minusSymbolLabel ? -1 : 1

        switch (sender.state, hitView) {
        case (.began, .some(let v)) where v == minusSymbolLabel || v == plusSymbolLabel:
            if autorepeat {
                startAutorepeat()
            }
            else {
                let value = _value + stepValue * factorValue

                updateValue(value: value, finished: true)
            }

            v.backgroundColor = backgroundColor?.darkened()
        case (.changed, .some(let v)):
            if v == minusSymbolLabel || v == plusSymbolLabel {
                v.backgroundColor = backgroundColor?.darkened()

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

                updateValue(value: _value, finished: true)
            }
        }
    }

    @objc func sliderPanned(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if case .none = hintStyle {} else {
                hintLabel.alpha  = 0
                hintLabel.center = CGPoint(x: center.x, y: center.y - (bounds.size.height * 0.5 + hintLabel.bounds.height))

                superview?.addSubview(hintLabel)

                UIView.animate(withDuration: 0.2) {
                    self.hintLabel.alpha = 1.0
                }
            }

            touchesBeganPoint = self.direction.getPosition(p: sender.translation(in: thumbLabel))
            dynamicButtonAnimator.removeBehavior(snappingBehavior)

            thumbLabel.backgroundColor = thumbBackgroundColor?.lighter()
            hintLabel.backgroundColor  = thumbBackgroundColor?.lighter()

            if autorepeat {
                startAutorepeat(autorepeatCount: Int.max)
            }
            else {
                initialValue = _value
            }
        case .changed:
            let translationInView = self.direction.getPosition(p: sender.translation(in: thumbLabel))
            let bw = self.direction.principalSize(size: bounds.size)
            let tbw = self.direction.principalSize(size: thumbLabel.bounds.size)
            let tcenter = self.direction.getPosition(p: thumbLabel.center)

            var centerX = (bw * 0.5) + ((touchesBeganPoint.x + translationInView.x) * 0.4)
            centerX     = max(tbw / 2, min(centerX, bw - tbw / 2))

            thumbLabel.center = self.direction.getPosition(p: CGPoint(x: centerX, y: tcenter.y))

            let locationRatio: CGFloat
            if self.direction == .horizontal {
                locationRatio = (tcenter.x - bounds.midX) / ((bounds.width - thumbLabel.bounds.width) / 2)
            }
            else {
                // The + is on top of the control in vertical layout, so the locationRatio must be reversed!
                locationRatio = (bounds.midY - tcenter.x) / ((bounds.height - thumbLabel.bounds.height) / 2)
            }

            let ratio         = Double(Int(locationRatio * 10)) / 10
            let factorValue   = ((maximumValue - minimumValue) / 100) * ratio

            if autorepeat {
                self.factorValue = factorValue
            }
            else {
                _value = initialValue + stepValue * factorValue

                updateValue(value: _value, finished: true)
            }
        case .ended, .failed, .cancelled:
            if case .none = hintStyle {} else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.hintLabel.alpha = 0.0
                }) { _ in
                    self.hintLabel.removeFromSuperview()
                }
            }

            dynamicButtonAnimator.addBehavior(snappingBehavior)

            thumbLabel.backgroundColor = thumbBackgroundColor ?? backgroundColor?.lighter()

            if autorepeat {
                autorepeatHelper.stop()

                factorValue = 0

                updateValue(value: _value, finished: true)
            }
        case .possible:
            break
        }
    }

    // MARK: - Updating the Value

    func startAutorepeat(autorepeatCount count: Int = 0) {
        autorepeatHelper.start(autorepeatCount: count) { [weak self] in
            if let weakSelf = self {
                let value = weakSelf._value + weakSelf.stepValue * weakSelf.factorValue

                weakSelf.updateValue(value: value, finished: false)
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

            sendActions(for: .valueChanged)

            if let _valueChangedBlock = valueChangedBlock {
                _valueChangedBlock(_value)
            }
        }
    }

    func valueAsText() -> String {
        return (value.truncatingRemainder(dividingBy: 1) == 0) ? "\(Int(value))" : "\(value)"
    }
}

