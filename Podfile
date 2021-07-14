# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
inhibit_all_warnings!

dynamic_frameworks = []

pre_install do |installer|
    installer.pod_targets.each do |pod|
        if !dynamic_frameworks.include?(pod.name)
            puts "Overriding the static_framework? method for #{pod.name}"
            def pod.static_framework?
                true
            end
            def pod.build_as_static_framework?
                true
            end
            def pod.build_as_dynamic_framework?
                false
            end
        end
    end
end

target 'WishBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WishBook
  # Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  
  # Add the pods for any other Firebase products you want to use in your app
  # For example, to use Firebase Authentication and Cloud Firestore
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '~> 7.1.0-beta'

  target 'WishBookTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WishBookUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end