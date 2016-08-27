//
//  ViewController.swift
//  SnappingStepperExample
//
//  Created by Yannick Loriot on 02/05/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

import DynamicColor
import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var classicStepper: SnappingStepper!
  @IBOutlet weak var valueLabel: UILabel!

  @IBOutlet weak var tubeStepper: SnappingStepper!
  @IBOutlet weak var roundedStepper: SnappingStepper!
  @IBOutlet weak var customStepper: SnappingStepper!
  @IBOutlet weak var verticalRoundedStepper: SnappingStepper!
    
  override func viewDidLoad() {
    super.viewDidLoad()

    assignStepperDefaultSettings(classicStepper)

    assignStepperDefaultSettings(tubeStepper)
    tubeStepper.style                = .Tube
    tubeStepper.thumbStyle           = .Tube
    tubeStepper.backgroundColor      = UIColor(hex: 0xB2DFDB)
    tubeStepper.thumbBackgroundColor = UIColor(hex: 0x009688)
    tubeStepper.hintStyle            = .Box

    assignStepperDefaultSettings(roundedStepper)
    roundedStepper.style                = .Rounded
    roundedStepper.thumbStyle           = .Rounded
    roundedStepper.backgroundColor      = .clearColor()
    roundedStepper.thumbBackgroundColor = UIColor(hex: 0xFFC107)
    roundedStepper.borderColor          = UIColor(hex: 0xFFC107)
    roundedStepper.borderWidth          = 0.5
    roundedStepper.hintStyle            = .Thumb

    assignStepperDefaultSettings(customStepper)
    customStepper.style                = .Custom(path: customDoubleArrowPath())
    customStepper.thumbStyle           = .Thumb
    customStepper.backgroundColor      = .clearColor()
    customStepper.borderColor          = UIColor(hex: 0x607D8B)
    customStepper.thumbBackgroundColor = UIColor(hex: 0x607D8B)
    customStepper.borderWidth          = 0.5
    customStepper.hintStyle            = .Rounded
    
    assignStepperDefaultSettings(verticalRoundedStepper)
    verticalRoundedStepper.style                = .Rounded
    verticalRoundedStepper.thumbStyle           = .Rounded
    verticalRoundedStepper.backgroundColor      = .clearColor()
    verticalRoundedStepper.thumbBackgroundColor = UIColor(hex: 0xFFC107)
    verticalRoundedStepper.borderColor          = UIColor(hex: 0xFFC107)
    verticalRoundedStepper.borderWidth          = 0.5
    verticalRoundedStepper.hintStyle            = .Thumb
    verticalRoundedStepper.direction            = .Vertical
  }

  func assignStepperDefaultSettings(snappingStepper: SnappingStepper) {
    snappingStepper.symbolFont           = UIFont(name: "TrebuchetMS-Bold", size: 20)
    snappingStepper.symbolFontColor      = .blackColor()
    snappingStepper.backgroundColor      = UIColor(hex: 0xc0392b)
    snappingStepper.thumbWidthRatio      = 0.4
    snappingStepper.thumbText            = nil
    snappingStepper.thumbFont            = UIFont(name: "TrebuchetMS-Bold", size: 18)
    snappingStepper.thumbBackgroundColor = UIColor(hex: 0xe74c3c)
    snappingStepper.thumbTextColor       = .blackColor()

    snappingStepper.continuous   = true
    snappingStepper.autorepeat   = true
    snappingStepper.wraps        = false
    snappingStepper.minimumValue = 0
    snappingStepper.maximumValue = 1000
    snappingStepper.stepValue    = 1
  }

  func customDoubleArrowPath() -> UIBezierPath {
    let da = UIBezierPath()

    da.moveToPoint(CGPoint(x: 232, y: 969))
    da.addLineToPoint(CGPoint(x: 189, y: 941))
    da.addLineToPoint(CGPoint(x: 189, y: 955))
    da.addLineToPoint(CGPoint(x: 62, y: 955))
    da.addLineToPoint(CGPoint(x: 62, y: 941))
    da.addLineToPoint(CGPoint(x: 17, y: 972))
    da.addLineToPoint(CGPoint(x: 62, y: 1000))
    da.addLineToPoint(CGPoint(x: 62, y: 986))
    da.addLineToPoint(CGPoint(x: 189, y: 986))
    da.addLineToPoint(CGPoint(x: 189, y: 1000))
    da.addLineToPoint(CGPoint(x: 232, y: 972))
    da.closePath()

    return da
  }

  func updateThumbAttributes(snappingStepper: SnappingStepper, index: Int) {
    switch index {
    case 1:
      snappingStepper.thumbText = ""
    case 2:
      snappingStepper.thumbText = "Move Me"
      snappingStepper.thumbFont = UIFont(name: "TrebuchetMS-Bold", size: 10)
    default:
      snappingStepper.thumbText = nil
      snappingStepper.thumbFont = UIFont(name: "TrebuchetMS-Bold", size: 20)
    }
  }

  @IBAction func stepperValueChangedAction(sender: SnappingStepper) {
    for stepper in [classicStepper, tubeStepper, roundedStepper, verticalRoundedStepper, customStepper] {
      if stepper != sender {
        stepper.value = sender.value
      }
    }

    valueLabel.text = "\(sender.value)"
  }

  @IBAction func segmentedValueChangedAction(sender: UISegmentedControl) {
    updateThumbAttributes(classicStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(customStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(tubeStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(roundedStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(verticalRoundedStepper, index: sender.selectedSegmentIndex)
  }
}
