platform :ios, '8.0'
#use_frameworks!个别需要用到它，比如reactiveCocoa

target ‘scanreader’ do
  pod 'AFNetworking', '~> 3.0’
  # 主模块(必须)
  pod 'ShareSDK3'
  # Mob 公共库(必须) 如果同时集成SMSSDK iOS2.0:
  pod 'MOBFoundation'
 
  # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
  pod 'ShareSDK3/ShareSDKUI'
 
  # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
  pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
end














