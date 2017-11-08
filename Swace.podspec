#
# Be sure to run `pod lib lint swace.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Swace'
  s.version          = '0.0.11'
  s.summary          = 'Common components used that can be re-used in multiple apps'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This pod exists to be able to re-use and add code that is commonly shared among multiple projects.
                       DESC

  s.homepage         = 'https://github.com/orgs/swacedigital/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'andreas.ostman@swace.se' => 'andreas.ostman@swace.se' }
  s.source           = { :git => 'https://github.com/swacedigital/swace-ios.git', :tag => s.version.to_s, branch: 'master' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Swace/Classes/**/*'

  
  # s.resource_bundles = {
  #   'swace' => ['swace/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
