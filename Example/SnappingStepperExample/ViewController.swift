//
//  ViewController.swift
//  SnappingStepperExample
//
//  Created by Yannick Loriot on 02/05/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var classicStepper: SnappingStepper!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var tubeStepper: SnappingStepper!
    @IBOutlet weak var roundedStepper: SnappingStepper!
    @IBOutlet weak var customStepper: SnappingStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.assignStepperDefaultSettings(self.classicStepper)
        
        self.assignStepperDefaultSettings(self.tubeStepper)
        self.tubeStepper.style = .Tube
        self.tubeStepper.thumbStyle = .Tube
        self.tubeStepper.backgroundColor = UIColor(hex: 0xB2DFDB)
        self.tubeStepper.thumbBackgroundColor = UIColor(hex: 0x009688)

        self.assignStepperDefaultSettings(self.roundedStepper)
        self.roundedStepper.style = .Rounded
        self.roundedStepper.thumbStyle = .Rounded
        self.roundedStepper.backgroundColor = UIColor.clearColor()
        self.roundedStepper.thumbBackgroundColor = UIColor(hex: 0xFFC107)
        self.roundedStepper.borderColor = UIColor(hex: 0xFFC107)
        self.roundedStepper.borderWidth = 0.5
        
        self.assignStepperDefaultSettings(self.customStepper)
        self.customStepper.style = .Custom(path: self.customDoubleArrowPath())
        self.customStepper.thumbStyle = .Tube
        self.customStepper.backgroundColor = UIColor.clearColor()
        self.customStepper.borderColor = UIColor(hex: 0x607D8B)
        self.customStepper.thumbBackgroundColor = UIColor(hex: 0x607D8B)
        self.customStepper.borderWidth = 0.5
        self.customStepper.showHint = true
        self.customStepper.hintStyle = .Rounded
    }
    
    func assignStepperDefaultSettings(snappingStepper: SnappingStepper) {
        snappingStepper.symbolFont           = UIFont(name: "TrebuchetMS-Bold", size: 20)
        snappingStepper.symbolFontColor      = UIColor.blackColor()
        snappingStepper.backgroundColor      = UIColor(hex: 0xc0392b)
        snappingStepper.thumbWidthRatio      = 0.4
        snappingStepper.thumbText            = nil
        snappingStepper.thumbFont            = UIFont(name: "TrebuchetMS-Bold", size: 18)
        snappingStepper.thumbBackgroundColor = UIColor(hex: 0xe74c3c)
        snappingStepper.thumbTextColor       = UIColor.blackColor()

        snappingStepper.continuous   = true
        snappingStepper.autorepeat   = true
        snappingStepper.wraps        = false
        snappingStepper.minimumValue = 0
        snappingStepper.maximumValue = 1000
        snappingStepper.stepValue    = 1
    }
    
    func customDoubleArrowPath() -> UIBezierPath {
        let da = UIBezierPath()
        da.moveToPoint(CGPointMake(232.441, 969.449))
        da.addLineToPoint(CGPointMake(189.921, 941.102))
        da.addLineToPoint(CGPointMake(189.921, 955.276))
        da.addLineToPoint(CGPointMake(62.362, 955.276))
        da.addLineToPoint(CGPointMake(62.362, 941.102))
        da.addLineToPoint(CGPointMake(17.008, 972.449))
        da.addLineToPoint(CGPointMake(62.362, 1000.63))
        da.addLineToPoint(CGPointMake(62.362, 986.622))
        da.addLineToPoint(CGPointMake(189.921, 986.622))
        da.addLineToPoint(CGPointMake(189.921, 1000.63))
        da.addLineToPoint(CGPointMake(232.441, 972.449))
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
    
    @IBAction func stepperValueChangedAction(sender: AnyObject) {
        valueLabel.text = "\(self.classicStepper.value)"
    }
    
    @IBAction func segmentedValueChangedAction(sender: UISegmentedControl) {
        self.updateThumbAttributes(self.classicStepper, index: sender.selectedSegmentIndex)
        self.updateThumbAttributes(self.customStepper, index: sender.selectedSegmentIndex)
        self.updateThumbAttributes(self.tubeStepper, index: sender.selectedSegmentIndex)
        self.updateThumbAttributes(self.roundedStepper, index: sender.selectedSegmentIndex)
    }
}

