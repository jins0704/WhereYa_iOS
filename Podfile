# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WhereYa' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WhereYa
  pod 'Alamofire', '~> 5.2' 
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'AlamofireNetworkActivityIndicator', '~> 3.1'
  pod 'lottie-ios' 
  pod 'Kingfisher', '~> 6.0'
  pod 'FSCalendar'
  pod 'JJFloatingActionButton'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end
