platform :ios ,'9.0'

target 'YunKeTang' do

    source 'https://github.com/CocoaPods/Specs.git'
    source 'http://git.baijiashilian.com/open-ios/specs.git'
    pod 'BJLiveUI', '~> 2.2.0'
    # 用于动态引入 Framework，避免冲突问题
    script_phase \
    :name => '[BJLiveCore] Embed Frameworks',
    :script => 'Pods/BJLiveCore/frameworks/EmbedFrameworks.sh',
    :execution_position => :after_compile

end
