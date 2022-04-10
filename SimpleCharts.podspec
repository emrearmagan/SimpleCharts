Pod::Spec.new do |spec|
  spec.name             = 'SimpleCharts'
  spec.version          = '0.0.1'
  spec.summary          = 'A simple charting library for iOS.'
  spec.homepage         = 'https://github.com/emrearmagan/SimpleCharts'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Emre Armagan' => 'emrearmagan.dev@gmail.com' }
  spec.source           = { :git => 'https://github.com/emrearmagan/SimpleCharts.git', :tag => spec.version }
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '13.0'
  spec.source_files = 'SimpleCharts/**/*'
end
