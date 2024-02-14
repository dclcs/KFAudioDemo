platform :ios, '13.0'
use_frameworks!

target 'AVDemo' do
  project 'AVDemo'
  supports_swift_versions '>= 5.0'
  pod 'Debugo'
  pod 'KFAVKit', :git => 'https://github.com/dclcs/KFAVKit.git', :branch => 'main', :tag => '0.0.1', :dev_env => 'beta'
  pod 'DebugTool', :git => 'https://github.com/dclcs/DebugTool.git', :branch => 'main', :tag => '0.0.1',:dev_env => 'beta'
  pod 'ToyImageLoader', :git => 'https://github.com/dclcs/ToyImageLoader.git', :branch => 'main', :tag => '0.0.2',:dev_env => 'dev'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
