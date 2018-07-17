Pod::Spec.new do |s|
  s.name             = 'AKMonthYearPickerView'
  s.version          = '1.0.3'
  s.summary          = 'AKMonthYearPickerView is a lightweight, clean and easy-to-use Month/ year picker control in iOS written purely in Swift language.'
 
  s.description      = <<-DESC
AKMonthYearPickerView is a lightweight, clean and easy-to-use Month/ year picker control in iOS written purely in Swift language. This library is written in Swift 4.
                       DESC
 
  s.homepage         = 'https://github.com/ali-cs/AKMonthYearPickerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '<ALI KHAN>' => '<ali.cs@outlook.com>' }
  s.source           = { :git => 'https://github.com/ali-cs/AKMonthYearPickerView.git', :tag => s.version.to_s }
  s.source_files     = 'AKMonthYearPickerView/AKMonthYearPickerView.swift'
 
  s.ios.deployment_target = '10.0'
 
end