Pod::Spec.new do |s|
    s.name             = 'GuidePageView'
    s.version          = '1.2.0'
    
    s.summary          = 'App启动引导页，支持播放gif/png/jpg等类型的资源数组。'
    s.homepage         = 'https://cigitlab.slan-health.com/app-template/GuidePageView.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { "wangwei" => "1091695310@qq.com" }
    s.source           = { :git => 'https://cigitlab.slan-health.com/app-template/GuidePageView.git', :tag => s.version.to_s }
    s.source_files     = 'GuidePageView/Classes/**/*'
    s.resources        = "GuidePageView/GuideImage.bundle"
    
    s.description      = <<-DESC
    App启动引导页，支持播放gif/png/jpg等类型的资源数组，及手动滑入主题。（建议引导页的图片都不要放在Assets文件中，因为使用imageName方法加载时，系统会缓存图片，造成内存暴增）
    DESC
    
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
    s.frameworks = 'Foundation', 'UIKit'
end
