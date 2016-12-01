# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

project 'RealmManager.xcodeproj'

def shared_pods

pod 'RealmSwift'

pod 'Alamofire', '3.5.0'

pod 'ObjectMapper', '1.1.5'

end

target 'RealmManager' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
