Pod::Spec.new do |s|
  s.name             = 'SnappingStepper'
  s.module_name      = 'SnappingStepper'
  s.version          = '1.0.5'
  s.license          = 'MIT'
  s.summary          = 'An alternative to UIStepper with a snapping slider in the middle written in Swift'
  s.homepage         = 'https://github.com/yannickl/SnappingStepper.git'
  s.social_media_url = 'https://twitter.com/yannickloriot'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.source           = { :git => 'https://github.com/yannickl/SnappingStepper.git', :tag => s.version }
  s.screenshot       = 'http://yannickloriot.com/resources/snappingstepper-screenshot.png'

  s.ios.deployment_target = '8.0'

  s.framework    = 'UIKit'
  s.source_files = 'SnappingStepper/*.swift'
  s.requires_arc = true
end
