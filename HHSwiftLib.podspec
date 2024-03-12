
Pod::Spec.new do |spec|

  spec.name         = "HHSwiftLib"
  spec.version      = "0.0.1"
  spec.summary      = "工具类组件."
  spec.description  = <<-DESC
                     工具类组件
                   DESC
  spec.homepage     = "https://github.com/HavenWWH/HHSwiftLib.git"
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { "Haven" => "513433750@qq.com" }
  spec.ios.deployment_target = "13.0"
  spec.swift_versions     = ['5.5','5.4','5.3','5.2','5.1','5.0','4.2']
  spec.source           = { :git => 'https://github.com/HavenWWH/HHSwiftLib.git', :tag => spec.version}
  spec.requires_arc = true
  spec.frameworks   = "UIKit", "Foundation" 
  
  spec.resource_bundles = {
    'HHSwiftBundle' => ['Sources/Resources/*.xcassets']
  }
  spec.source_files  = 'Sources/HHSwiftLib/**/*'
  spec.dependency 'SnapKit'
end
