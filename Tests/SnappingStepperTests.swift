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

    XCTAssert(stepper.autorepeat, "'Autorepeat' attributes should be false by default")
    XCTAssert(!stepper.wraps, "'Wraps' attributes should be false by default")
  }

  func testMaximumValue() {
    let stepper = SnappingStepper()


    XCTAssert(stepper.maximumValue >= stepper.minimumValue, "'Maximum' value should always be AlwaysGreaterOrEqual than the 'minimum' value")
  }
}