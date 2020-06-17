Pod::Spec.new do |s|
  s.name             = 'TATLib'
  s.version          = '0.1.0'
  s.swift_version    = '5.0'
  s.summary          = 'TAT Library'
  s.description      = 'This is an assortment of miscellaneous tips'
  s.homepage         = 'https://github.com/cpson/TATLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cpson' => 'cpsony2k@gmail.com' }
  s.source           = { :git => 'https://github.com/cpson/TATLib.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/TATLib/Classes/**/*'
end
