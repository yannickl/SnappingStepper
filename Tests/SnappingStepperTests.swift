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

  func testMinimumValue() {
    let stepper = SnappingStepper()

    XCTAssert(stepper.minimumValue <= stepper.maximumValue, "'minimum' value should always be lower or equal than the 'maximum' value")

    stepper.maximumValue = 50
    stepper.minimumValue = 50

    XCTAssert(stepper.minimumValue <= stepper.maximumValue, "'minimum' value should always be lower or equal than the 'maximum' value")

    stepper.maximumValue = -10

    XCTAssert(stepper.minimumValue <= stepper.maximumValue, "'minimum' value should always be lower or equal than the 'maximum' value")
    XCTAssert(stepper.minimumValue == -10, "'minimum' value should be equal to -10")
  }

  func testMaximumValue() {
    let stepper = SnappingStepper()

    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be greater or equal than the 'minimum' value")

    stepper.maximumValue = 50
    stepper.minimumValue = 50

    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be greater or equal than the 'minimum' value")

    stepper.minimumValue = 200

    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be greater or equal than the 'minimum' value")
    XCTAssert(stepper.maximumValue == 200, "'maximum' value should be equal to 200")
  }

  func testWrap() {
    let stepper = SnappingStepper()

    stepper.wraps        = false
    stepper.maximumValue = 100
    stepper.minimumValue = 0
    stepper.value        = 105

    XCTAssert(stepper.value == 100, "'value' should be equal to the 'maximum' value")

    stepper.value = -4

    XCTAssert(stepper.value == 0, "'value' should be equal to the 'minimum' value")

    stepper.wraps = true
    stepper.value = 105

    XCTAssert(stepper.value == 0, "'value' should be equal to the 'minimum' value")

    stepper.value = -4

    XCTAssert(stepper.value == 100, "'value' should be equal to the 'maximum' value")
  }
}