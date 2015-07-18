#
# Be sure to run `pod lib lint DZReadability.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ASDayPicker"
  s.version          = "1.0.0"
  s.summary          = "iOS day picker that resembles Calendar.app's week view"
  s.homepage         = "https://github.com/appscape/ASDayPicker"
  s.screenshots     = "https://github.com/appscape/ASDayPicker/raw/master/Screenshots/animation.gif"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Esad Hajdarevic" => "esad@esse.at" }
  s.source           = { :git => "https://github.com/appscape/ASDayPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'http://twitter.com/esad'

  s.ios.deployment_target = '7.0'
  
  s.requires_arc = true
  s.source_files = "*.{h,m}"
end
