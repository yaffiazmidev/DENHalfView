Pod::Spec.new do |s|
  s.name             = 'DENHalfView'
  s.version          = '1.0.0'
  s.summary          = 'DENHalfView is a lightweight Swift library designed to display Half Views easily.'
  s.description      = 'By using DENHalfView, you can display half view and design it to your own liking.'
  
  s.homepage         = 'https://github.com/yaffiazmidev/DENHalfView.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yaffi Azmi' => 'yaffiazmi.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/yaffiazmidev/DENHalfView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*.{swift,h,m}'
end
