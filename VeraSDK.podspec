#
# Be sure to run `pod lib lint VeraSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                = 'VeraSDK'
  s.version             = '1.1.3'
  s.summary             = 'Transform commercial buildings into intelligent environments using just your phone.'
  s.homepage            = 'https://github.com/resonai/vera-ios-sdk'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.author              = { "ResonAI" => "support@resonai.com", "Alex Culeva" => 'alexc@resonaixr.com' }
  s.source              = { :git => "https://github.com/resonai/vera-ios-sdk.git", :tag => "v#{s.version}" }
  s.swift_version       = "5.8"
  s.ios.deployment_target = "13.5"

  s.platform            = :ios, '13.5'
  s.frameworks          = 'UIKit', 'ARKit', 'CoreLocation', 'JavaScriptCore', 'WebKit', 'LocalAuthentication', 'Combine', 'SystemConfiguration'

  s.dependency            'libwebp', '1.2.4'
  s.dependency            'Cognex.cmbSDK', '2.7.1'
  s.dependency            'ScanditBarcodeCapture'

  s.vendored_frameworks = 'VeraSDK.xcframework'
end
