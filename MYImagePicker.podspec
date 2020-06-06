#
# Be sure to run `pod lib lint MYImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MYImagePicker'
  s.version          = '0.0.2'
  s.summary          = '图片选择器，可以选择视频和图片'

  s.description      = <<-DESC
  MYImagePicker，图片选择器，可以支持选择视频和图片
                       DESC

  s.homepage         = 'https://github.com/CoderLawrence/MYImagePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CoderLawrence' => 'coderlawrence@163.com' }
  s.source           = { :git => 'https://github.com/CoderLawrence/MYImagePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MYImagePicker/Classes/**/*'
  s.resource = 'MYImagePicker/Resource/*.bundle'
#  s.resource_bundles = {
#    'MYImagePicker' => ['MYImagePicker/Resource/*.bundle']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Photos'
  s.dependency 'Masonry'
end
