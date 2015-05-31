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
    XCTAssert(stepper.minimumValue <= stepper.value, "value should not be lower than the 'minimum' value")

    stepper.maximumValue = -10

    XCTAssert(stepper.minimumValue <= stepper.maximumValue, "'minimum' value should always be lower or equal than the 'maximum' value")
    XCTAssert(stepper.minimumValue == -10, "'minimum' value should be equal to -10")
    XCTAssert(stepper.minimumValue <= stepper.value, "value should not be lower than the 'minimum' value")

    stepper.value = -200

    XCTAssert(stepper.minimumValue <= stepper.value, "value should not be lower than the 'minimum' value")

    stepper.minimumValue = 0

    XCTAssert(stepper.minimumValue <= stepper.value, "value should not be lower than the 'minimum' value")
  }

  func testMaximumValue() {
    let stepper = SnappingStepper()

    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be greater or equal than the 'minimum' value")

    stepper.minimumValue = 50
    stepper.maximumValue = 40

    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be greater or equal than the 'minimum' value")
    XCTAssert(stepper.value <= stepper.maximumValue, "value should not be greater than the 'maximum' value")

    stepper.minimumValue = 200

    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'maximum' value should always be greater or equal than the 'minimum' value")
    XCTAssert(stepper.maximumValue == 200, "'maximum' value should be equal to 200")
    XCTAssert(stepper.value <= stepper.maximumValue, "value should not be greater than the 'maximum' value")

    stepper.value = 300

    XCTAssert(stepper.value <= stepper.maximumValue, "value should not be greater than the 'maximum' value")

    stepper.maximumValue = -10

    XCTAssert(stepper.value <= stepper.maximumValue, "value should not be greater than the 'maximum' value")
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

  func testContinuous() {
    let expectation = expectationWithDescription("Value changed")

    let stepper     = SnappingStepper()
    var changeCount = 0

    stepper.continuous        = true
    stepper.valueChangedBlock = { (value) in
      changeCount++

      if changeCount == 2 {
        expectation.fulfill()
      }
    }

    stepper.value = 10
    stepper.value = 10
    stepper.value = 11

    waitForExpectationsWithTimeout(0.1) { (error) in }
  }

  func testNonContinuous() {
    let expectation = expectationWithDescription("Value changed")

    let stepper     = SnappingStepper()
    var changeCount = 0

    stepper.continuous        = false
    stepper.valueChangedBlock = { (value) in
      changeCount++

      if changeCount == 2 {
        expectation.fulfill()
      }
    }

    stepper.updateValue(10, finished: false)
    stepper.updateValue(10, finished: true)
    stepper.updateValue(11, finished: false)
    stepper.updateValue(12, finished: false)
    stepper.updateValue(13, finished: false)
    stepper.updateValue(14, finished: true)
    
    waitForExpectationsWithTimeout(0.1) { (error) in }
  }
}