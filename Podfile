#Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'AVDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  pod 'Debugo'
  pod 'KFAVKit', :git => 'https://github.com/dclcs/KFAVKit.git', :branch => 'main', :tag => '0.0.1',:dev_env => 'dev'
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
