# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Traystorage' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Traystorage

  pod 'Alamofire', '~> 4.9.0'
  pod 'SwiftyJSON'
  pod 'Kingfisher', '~> 5.15.8'
  pod 'SwiftKeychainWrapper'
  pod 'Material'
  pod 'TOCropViewController'
  pod 'Toast-Swift'
  pod 'GrowingTextView'
  pod 'SnapKit'
  pod 'SVProgressHUD'
  pod 'DropDown'
  pod 'KMPlaceholderTextView'
  pod 'PullToRefresher'
  pod 'SKPhotoBrowser'
  pod 'TouchAreaInsets'
  pod 'GrowingTextView'
  pod 'TOCropViewController'
  pod 'WXImageCompress'
  pod 'ImageSlideshow'
  pod 'IQKeyboardManagerSwift'
  pod 'ActionSheetController'
  pod 'SwiftyGif'
  pod 'REFrostedViewController', '~> 2.4'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'AEXML'
  pod 'naveridlogin-sdk-ios'
  pod 'GoogleSignIn'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Auth'
end

post_install do |installer|
  require 'fileutils'

  # bitcode_strip 경로 찾기
  bitcode_strip_path = `xcrun --find bitcode_strip`.strip

  # bitcode 제거 함수
  def strip_bitcode_from_framework(bitcode_strip_path, framework_relative_path)
    framework_path = File.join(Dir.pwd, framework_relative_path)
    executable_name = File.basename(framework_path, ".framework")
    executable_path = File.join(framework_path, executable_name)

    if File.exist?(executable_path)
      puts "Stripping bitcode from: #{executable_path}"
      system("#{bitcode_strip_path} #{executable_path} -r -o #{executable_path}")
    else
      puts "Executable not found at #{executable_path}"
    end
  end

  # NaverThirdPartyLogin.framework 대상으로 실행
  Dir.glob('Pods/**/NaverThirdPartyLogin.framework').each do |framework|
    strip_bitcode_from_framework(bitcode_strip_path, framework)
  end

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
