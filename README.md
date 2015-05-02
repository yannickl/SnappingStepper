# SnappingStepper

A beautiful alternative to the `UIStepper` with a snapping slider in the middle written in Swift.

*Note: the control is inspired by a very beautiful control: [SnappingSlider](https://github.com/rehatkathuria/SnappingSlider)*

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
pod 'SnappingStepper', '~> 1.0.0'
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
  
  snappingStepper.addTarget(self, action: "stepperValueChangedAction:", forControlEvents: .ValueChanged)
  
  view.addSubview(snappingStepper)
}
  
func stepperValueChangedAction(sender: AnyObject) {
  // Retrieve the value: snappingStepper.value
}
```
    
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
