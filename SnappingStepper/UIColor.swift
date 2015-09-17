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

import Foundation
import UIKit

/// Extension to manage hexa-decimal colors.
internal extension UIColor {
  /**
  Creates a color from an hex string.

  - parameter hexString: A hexa-decimal color string representation.
  */
  convenience init(hexString: String) {
    let hexString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    let scanner            = NSScanner(string: hexString)

    if (hexString.hasPrefix("#")) {
      scanner.scanLocation = 1
    }

    var color:UInt32 = 0
    scanner.scanHexInt(&color)

    self.init(hex: color)
  }

  /**
  Creates a color from an hex int.

  - parameter hexString: A hexa-decimal color number representation.
  */
  convenience init(hex: UInt32) {
    let mask = 0x000000FF

    let r = Int(hex >> 16) & mask
    let g = Int(hex >> 8) & mask
    let b = Int(hex) & mask

    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0

    self.init(red:red, green:green, blue:blue, alpha:1)
  }

  // MARK: - Lighter/Darker Colors

  /// Returns a lighter a color from the current one
  func lighterColor() -> UIColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return UIColor(hue: h, saturation: s, brightness: min(b * 1.3, 1.0), alpha: a)
    }

    return self
  }

  /// Returns a darker a color from the current one
  func darkerColor() -> UIColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0

    if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      return UIColor(hue: h, saturation: s, brightness: b * 0.75, alpha: a)
    }

    return self
  }
}