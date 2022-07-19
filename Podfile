# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'

target 'EasyMediaProcDemo' do
  pod 'Masonry'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['OTHER_CFLAGS'] = '-fsanitize-coverage=func,trace-pc-guard'
      config.build_settings['OTHER_SWIFT_FLAGS'] = '-sanitize-coverage=func -sanitize=undefined'
    end
  end
end
