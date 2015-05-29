//
//  SnappingStepperTests.swift
//  SnappingStepperExample
//
//  Created by Yannick LORIOT on 29/05/15.
//  Copyright (c) 2015 Yannick Loriot. All rights reserved.
//

import UIKit
import XCTest

class SnappingStepperTests: XCTestCase {
  func testDefaultValues() {
    let stepper = SnappingStepper()

    XCTAssert(stepper.continuous, "'continuous' attributes should be false by default")
    XCTAssert(stepper.autorepeat, "'autorepeat' attributes should be false by default")
    XCTAssert(!stepper.wraps, "'wraps' attributes should be false by default")
    XCTAssert(stepper.minimumValue == 0, "'minimumValue' attributes should be equal to 0 by default")
    XCTAssert(stepper.maximumValue == 100, "'maximumValue' attributes should be equal to 100 by default")
    XCTAssert(stepper.stepValue == 1, "'stepValue' attributes should be equal to 1 by default")
    XCTAssert(stepper.value == 0, "'value' attributes should be equal to 0 by default")
  }

  func testMaximumValue() {
    let stepper = SnappingStepper()


    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be AlwaysGreaterOrEqual than the 'minimum' value")
  }
}