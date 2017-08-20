#
# Be sure to run `pod lib lint iOSUtils-Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "iOSUtils-Swift"
  s.version          = "1.5.4"
  s.summary          = "Lib de iOS da Livetouch em Swift."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        "Lib de iOS da Livetouch em Swift para facilitar desenvolvimento de aplicativos na plataforma iOS."
                       DESC

  s.homepage         = "https://bitbucket.org/livetouchdev/iosutils-swift"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Gregory Sholl e Santos" => "gregorysholl@livetouch.com.br" }
  s.source           = { :git => "https://bitbucket.org/livetouchdev/iosutils-swift", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

# s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Resources/**/*'
#  s.resource_bundles = {
#   'iOSUtils-Swift' => ['Pod/Assets/*.png']
#  }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.public_header_files = 'Pod/Classes/Db/Obj-C/iOSUtils-Bridging-Header.h'
# s.frameworks = 'UIKit', 'MapKit'

 s.dependency 'DCKeyValueObjectMapping'
 s.dependency 'sqlite3'
# s.dependency 'CryptoSwift'
 s.dependency 'SwiftDate', '~> 4.0'
 s.dependency 'SimpleExif'
 s.dependency 'Kingfisher'


end
