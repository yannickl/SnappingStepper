//
//  ViewController.swift
//  SnappingStepperExample
//
//  Created by Yannick Loriot on 02/05/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var snappingStepper: SnappingStepper!
  @IBOutlet weak var valueLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    snappingStepper.symbolFont           = UIFont(name: "TrebuchetMS-Bold", size: 20)
    snappingStepper.symbolFontColor      = UIColor.blackColor()
    snappingStepper.backgroundColor      = UIColor(hex: 0xc0392b)
    snappingStepper.thumbWidthRatio      = 0.5
    snappingStepper.thumbText            = nil
    snappingStepper.thumbFont            = UIFont(name: "TrebuchetMS-Bold", size: 20)
    snappingStepper.thumbBackgroundColor = UIColor(hex: 0xe74c3c)
    snappingStepper.thumbTextColor       = UIColor.blackColor()

    snappingStepper.continuous   = true
    snappingStepper.autorepeat   = true
    snappingStepper.wraps        = false
    snappingStepper.minimumValue = 0
    snappingStepper.maximumValue = 1000
    snappingStepper.stepValue    = 1
  }

  @IBAction func stepperValueChangedAction(sender: AnyObject) {
    valueLabel.text = "\(snappingStepper.value)"
  }
}

