#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = '${POD_NAME}'
  s.version          = '0.0.1'
  s.summary          = 'A short description of ${POD_NAME}.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://47.111.155.56:8800/smcaiot/IOS/${POD_NAME}'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'developermichael' => '${USER_EMAIL}' }
  s.source           = { :git => 'http://47.111.155.56:8800/smcaiot/IOS/${POD_NAME}.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = '${POD_NAME}/Classes/**/*.{h,m}'
  s.resources = '${POD_NAME}/Assets/${POD_NAME}.xcassets'

  s.dependency 'ZJModuleService'
  s.dependency 'ZJNetwork'
  s.dependency 'WPKit'
  s.dependency 'ZJFoundation'
  s.dependency 'WPGlobal'
  s.dependency 'ZJAppConfig'
  s.dependency 'WPRequestManager'

  s.requires_arc = true
  
end
