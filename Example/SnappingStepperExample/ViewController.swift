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
    tubeStepper.style                = .tube
    tubeStepper.thumbStyle           = .tube
    tubeStepper.backgroundColor      = UIColor(hex: 0xB2DFDB)
    tubeStepper.thumbBackgroundColor = UIColor(hex: 0x009688)
    tubeStepper.hintStyle            = .box

    assignStepperDefaultSettings(roundedStepper)
    roundedStepper.style                = .rounded
    roundedStepper.thumbStyle           = .rounded
    roundedStepper.backgroundColor      = .clear
    roundedStepper.thumbBackgroundColor = UIColor(hex: 0xFFC107)
    roundedStepper.borderColor          = UIColor(hex: 0xFFC107)
    roundedStepper.borderWidth          = 0.5
    roundedStepper.hintStyle            = .thumb

    assignStepperDefaultSettings(customStepper)
    customStepper.style                = .custom(path: customDoubleArrowPath())
    customStepper.thumbStyle           = .thumb
    customStepper.backgroundColor      = .clear
    customStepper.borderColor          = UIColor(hex: 0x607D8B)
    customStepper.thumbBackgroundColor = UIColor(hex: 0x607D8B)
    customStepper.borderWidth          = 0.5
    customStepper.hintStyle            = .rounded
    
    assignStepperDefaultSettings(verticalRoundedStepper)
    verticalRoundedStepper.style                = .rounded
    verticalRoundedStepper.thumbStyle           = .rounded
    verticalRoundedStepper.backgroundColor      = .clear
    verticalRoundedStepper.thumbBackgroundColor = UIColor(hex: 0xFFC107)
    verticalRoundedStepper.borderColor          = UIColor(hex: 0xFFC107)
    verticalRoundedStepper.borderWidth          = 0.5
    verticalRoundedStepper.hintStyle            = .thumb
    verticalRoundedStepper.direction            = .vertical
  }

  func assignStepperDefaultSettings(_ snappingStepper: SnappingStepper) {
    snappingStepper.symbolFont           = UIFont(name: "TrebuchetMS-Bold", size: 20)
    snappingStepper.symbolFontColor      = .black
    snappingStepper.backgroundColor      = UIColor(hex: 0xc0392b)
    snappingStepper.thumbWidthRatio      = 0.4
    snappingStepper.thumbText            = nil
    snappingStepper.thumbFont            = UIFont(name: "TrebuchetMS-Bold", size: 18)
    snappingStepper.thumbBackgroundColor = UIColor(hex: 0xe74c3c)
    snappingStepper.thumbTextColor       = .black

    snappingStepper.continuous   = true
    snappingStepper.autorepeat   = true
    snappingStepper.wraps        = false
    snappingStepper.minimumValue = 0
    snappingStepper.maximumValue = 1000
    snappingStepper.stepValue    = 1
  }

  func customDoubleArrowPath() -> UIBezierPath {
    let da = UIBezierPath()

    da.move(to: CGPoint(x: 232, y: 969))
    da.addLine(to: CGPoint(x: 189, y: 941))
    da.addLine(to: CGPoint(x: 189, y: 955))
    da.addLine(to: CGPoint(x: 62, y: 955))
    da.addLine(to: CGPoint(x: 62, y: 941))
    da.addLine(to: CGPoint(x: 17, y: 972))
    da.addLine(to: CGPoint(x: 62, y: 1000))
    da.addLine(to: CGPoint(x: 62, y: 986))
    da.addLine(to: CGPoint(x: 189, y: 986))
    da.addLine(to: CGPoint(x: 189, y: 1000))
    da.addLine(to: CGPoint(x: 232, y: 972))
    da.close()

    return da
  }

  func updateThumbAttributes(_ snappingStepper: SnappingStepper, index: Int) {
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

  @IBAction func stepperValueChangedAction(_ sender: SnappingStepper) {
    for stepper in [classicStepper, tubeStepper, roundedStepper, verticalRoundedStepper, customStepper] {
      if stepper != sender {
        stepper?.value = sender.value
      }
    }

    valueLabel.text = "\(sender.value)"
  }

  @IBAction func segmentedValueChangedAction(_ sender: UISegmentedControl) {
    updateThumbAttributes(classicStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(customStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(tubeStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(roundedStepper, index: sender.selectedSegmentIndex)
    updateThumbAttributes(verticalRoundedStepper, index: sender.selectedSegmentIndex)
  }
}
