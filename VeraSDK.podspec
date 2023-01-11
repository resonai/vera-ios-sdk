#
# Be sure to run `pod lib lint VeraSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VeraSDK'
  s.version          = '0.1.6'
  s.summary          = 'Transform commercial buildings into intelligent environments using just your phone.'
  s.homepage         = 'https://github.com/resonai/vera-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "ResonAI" => "support@resonai.com" }
  s.source           = { :http => "https://github.com/resonai/vera-ios-sdk/releases/download/v#{s.version.to_s}/VeraSDK.xcframework.zip" }

  s.platform         = :ios, '13.5'
  s.frameworks       = 'UIKit', 'ARKit', 'CoreLocation', 'JavaScriptCore', 'WebKit', 'LocalAuthentication', 'Combine', 'SystemConfiguration'
  s.vendored_frameworks = 'VeraSDK.xcframework'
end
