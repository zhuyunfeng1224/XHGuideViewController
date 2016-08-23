Pod::Spec.new do |s|
s.name             = "XHGuideViewController"
s.version          = "0.0.3"
s.summary          = "A guide controller used on iOS."
s.description      = <<-DESC
It is a segment controller, which implement by swift.
DESC
s.homepage         = "https://github.com/zhuyunfeng1224/XHGuideViewController"
# s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author           = { "羲和" => "leitianshi2009@163.com" }
s.source           = { :git => "https://github.com/zhuyunfeng1224/XHGuideViewController.git", :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/NAME'

s.platform     = :ios, '8.0'
# s.ios.deployment_target = '5.0'
# s.osx.deployment_target = '10.7'
s.requires_arc = true

s.source_files = 'XHGuideViewController/*'
# s.resources = 'Assets'

# s.ios.exclude_files = 'Classes/osx'
# s.osx.exclude_files = 'Classes/ios'
# s.public_header_files = 'Classes/**/*.h'
s.frameworks = 'Foundation', 'UIKit'

end