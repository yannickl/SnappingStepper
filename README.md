![SnappingStepper](http://yannickloriot.com/resources/snappingstepper-header.png)

[![Supported Plateforms](https://cocoapod-badges.herokuapp.com/p/SnappingStepper/badge.svg)](http://cocoadocs.org/docsets/SnappingStepper/) [![Version](https://cocoapod-badges.herokuapp.com/v/SnappingStepper/badge.svg)](http://cocoadocs.org/docsets/SnappingStepper/) [![Build Status](https://travis-ci.org/yannickl/SnappingStepper.png?branch=master)](https://travis-ci.org/yannickl/SnappingStepper)

An elegant alternative to the `UIStepper` enhanced with a thumb slider to control the value update with more flexibility.

<p align="center">
  <img src="http://yannickloriot.com/resources/snappingstepper.gif" alt=screenshot" />
</p>

*Note: the control is inspired by this control: [SnappingSlider](https://github.com/rehatkathuria/SnappingSlider)*

#### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _SnappingStepper_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!
pod 'SnappingStepper', '~> 1.1.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file):

``` bash
$ open MyProject.xcworkspace
```

You can now `import SnappingStepper` framework into your files.

#### Manually

[Download](https://github.com/YannickL/SnappingStepper/archive/master.zip) the project and copy the `SnappingStepper` folder into your project to use it in.

## Usage

```swift
let stepper = SnappingStepper(frame: CGRectMake(0, 0, 100, 40))

override func viewDidLoad() {
  super.viewDidLoad()
  
  // Configure the stepper like any other UIStepper. For example:
  //
  // stepper.continuous   = true
  // stepper.autorepeat   = true
  // stepper.wraps        = false
  // stepper.minimumValue = 0
  // stepper.maximumValue = 100
  // stepper.stepValue    = 1

  stepper.font            = UIFont(name: "TrebuchetMS-Bold", size: 20)
  stepper.fontColor       = UIColor.blackColor()
  stepper.backgroundColor = UIColor.redColor()
  stepper.thumbColor      = UIColor.orangeColor()

  stepper.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
  
  // If you don't want using the traditional `addTarget:action:` pattern you can use
  // the `valueChangedBlock`
  // snappingStepper.valueChangeBlock = { (value: Double) in
  //    println("value: \(value)")
  // }

  view.addSubview(stepper)
}
  
func valueChanged(sender: AnyObject) {
  // Retrieve the value: stepper.value
}
```

To go further, take a look at the example project. 
    
## Contact

Yannick Loriot
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)
 - [contact@yannickloriot.com](mailto:contact@yannickloriot.com)


## License (MIT)

Copyright (c) 2015-present - Yannick Loriot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
