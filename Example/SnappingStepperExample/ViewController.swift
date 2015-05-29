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

    snappingStepper.backgroundColor = UIColor(hex: 0xc0392b)
    snappingStepper.thumbColor      = UIColor(hex: 0xe74c3c)
  }

  @IBAction func stepperValueChangedAction(sender: AnyObject) {
    valueLabel.text = "\(snappingStepper.value)"
  }
}

