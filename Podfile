# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ALMA3ROOF DRIVER' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

# Pods for EberDriver

pod 'Alamofire'
pod 'Charts'
#pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'

pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/RemoteConfig'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'
pod 'Firebase/Crashlytics'
pod 'Firebase/Analytics'
pod 'Firebase/Core'

pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'GoogleSignIn'

pod 'IQKeyboardManager'
pod 'libPhoneNumber-iOS'
pod 'SDWebImage'
pod 'Socket.IO-Client-Swift'
pod 'Stripe','~> 22.8.2'
pod 'PayPalCheckout'

end
# Disable signing for pods
post_install do |installer|

    installer.pods_project.targets.each do |target|
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end

  end
