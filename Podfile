# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Noljanolja' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Noljanolja
  pod 'Natrium'
  pod 'AnyImageKit'
  pod 'Google-Mobile-Ads-SDK'
  pod "youtube-ios-player-helper", :git => 'https://github.com/HyunjoonKo/youtube-ios-player-helper'
  pod 'naveridlogin-sdk-ios', '4.1.5'
  pod 'shared', :path => './shared'

  target 'NoljanoljaTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NoljanoljaUITests' do
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
