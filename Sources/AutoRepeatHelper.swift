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

final class AutoRepeatHelper {
  private var timer: NSTimer?
  private var autorepeatCount = 0
  private var tickBlock: (() -> Void)?

  deinit {
    stop()
  }

  // MARK: - Managing Autorepeat

  func stop() {
    timer?.invalidate()
  }

  func start(autorepeatCount count: Int = 0, tickBlock block: () -> Void) {
    if let _timer = timer where _timer.valid {
      return
    }

    autorepeatCount = count
    tickBlock       = block

    repeatTick(nil)

    let newTimer = NSTimer(timeInterval: 0.1, target: self, selector: #selector(AutoRepeatHelper.repeatTick), userInfo: nil, repeats: true)
    timer        = newTimer

    NSRunLoop.currentRunLoop().addTimer(newTimer, forMode: NSRunLoopCommonModes)
  }

  @objc func repeatTick(sender: AnyObject?) {
    let needsIncrement: Bool

    if autorepeatCount < 35 {
      if autorepeatCount < 10 {
        needsIncrement = autorepeatCount % 5 == 0
      }
      else if autorepeatCount < 20 {
        needsIncrement = autorepeatCount % 4 == 0
      }
      else if autorepeatCount < 25 {
        needsIncrement = autorepeatCount % 3 == 0
      }
      else if autorepeatCount < 30 {
        needsIncrement = autorepeatCount % 2 == 0
      }
      else {
        needsIncrement = autorepeatCount % 1 == 0
      }

      autorepeatCount += 1
    }
    else {
      needsIncrement = true
    }

    if needsIncrement {
      tickBlock?()
    }
  }
}