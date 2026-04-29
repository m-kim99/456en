platform :ios, '15.0'

target 'Traystorage' do
  use_frameworks!

  # Networking
  pod 'Alamofire', '~> 5.9'
  pod 'SwiftyJSON', '~> 5.0'

  # Image
  pod 'Kingfisher', '~> 7.12'
  pod 'TOCropViewController'
  pod 'SKPhotoBrowser'
  pod 'ImageSlideshow'
  pod 'WXImageCompress'
  pod 'SwiftyGif'

  # UI
  pod 'Material'
  pod 'SnapKit'
  pod 'SVProgressHUD'
  pod 'DropDown'
  pod 'KMPlaceholderTextView'
  pod 'PullToRefresher'
  pod 'GrowingTextView'
  pod 'Toast-Swift'
  pod 'TouchAreaInsets'
  pod 'IQKeyboardManagerSwift'
  pod 'ActionSheetController'
  pod 'REFrostedViewController', '~> 2.4'

  # Auth & SNS
  pod 'SwiftKeychainWrapper'
  # pod 'naveridlogin-sdk-ios', '~> 4.2'
  pod 'GoogleSignIn', '~> 7.1'

  # Firebase (pinned to 10.x to keep DynamicLinks which was removed in 11+)
  pod 'Firebase/Core', '~> 10.0'
  pod 'Firebase/Messaging'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Auth'

  # Kakao SDK (replacing legacy KakaoOpenSDK manual frameworks)
  # pod 'KakaoSDKCommon'
  # pod 'KakaoSDKAuth'
  # pod 'KakaoSDKUser'

  # Utils
  pod 'AEXML'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      config.build_settings.delete('EXCLUDED_ARCHS[sdk=iphonesimulator*]')
      config.build_settings.delete('EXCLUDED_ARCHS')
    end
  end

  # Also clean xcconfig files that CocoaPods generates
  installer.generated_aggregate_targets.each do |aggregate_target|
    aggregate_target.xcconfigs.each do |config_name, config|
      config.attributes.delete('EXCLUDED_ARCHS[sdk=iphonesimulator*]')
      xcconfig_path = aggregate_target.xcconfig_path(config_name)
      config.save_as(xcconfig_path)
    end
  end
end
