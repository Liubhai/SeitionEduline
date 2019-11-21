//
//  SYG.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/5.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
#import "NSDictionary+Json.h"
#import "Passport.h"
#import "TKProgressHUD+Add.h"
#import "SYGTextField.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Passport.h"
//#import "AppDelegate.h"
//#import "rootViewController.h"
#import "YunKeTang_Api_Tool.h"
#import "Api_Config.h"
#import "YYKit.h"
#import "SDImageCache.h"
#import "UIViewController+HUD.h"
#import "UIView+HUD.h"

//配置单机构或者多机构 (1,单机构、2,多机构)
#define MoreOrSingle ([Institution_Id isEqualToString:@"0"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"institutionId"] == nil) ? @"2" : @"1"
#define MoreOrSingle_HeaderUrl @"2"

#ifndef ChuYouYun_SYG_h
#define ChuYouYun_SYG_h

#define MainScreenHeight [YunKeTang_Api_Tool sharedInstance].tsShowWindowsHeight
#define MainScreenWidth [YunKeTang_Api_Tool sharedInstance].tsShowWindowsWidth
#define SpaceBaside 10

//# define ORIGIN_HEIGHT  568.f
//# define ORIGIN_WIDTH   320.f

#define WideEachUnit MainScreenWidth / 375
#define HigtEachUnit  MainScreenHeight / 667

//#define WideEachUnit MainScreenWidth / 320.f
//#define HigtEachUnit MainScreenHeight / 568.f
#define NavigationBarHeight MainScreenHeight >= 812 ? 88 : 64
#define NavigationBarSubViewHeight  MainScreenHeight >= 812 ? 40 : 25
#define TabBarHeight MainScreenHeight >= 812 ? 83 : 49
#define kButtomHeightIphoneX (MainScreenHeight >= 812 ? 34 : 0)


//阿里播放相关
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

//内购
#define IAPPurchID @"com.bb.helper_eduline"
#define IAPPurchID_20 @"com.bb.helper_eduline_20"
#define IAPPurchID_50 @"com.bb.helper_eduline_50"
#define IAPPurchID_100 @"com.bb.helper_eduline_100"
#define IAPPurchID_200 @"com.bb.helper_eduline_200"
#define IAPPurchID_500 @"com.bb.helper_eduline_500"



#define NetKey [[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil ? @"2506957b1ea89b71" : [[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"]
#define HeaderKey @"En-Params"

#define HASALIPAY [[NSUserDefaults standardUserDefaults] objectForKey:@"hasAlipay"] == nil ? @"0" : [[NSUserDefaults standardUserDefaults] objectForKey:@"hasAlipay"]

#define Show_Config [[NSUserDefaults standardUserDefaults] objectForKey:@"show_config"] == nil ? @"0" : [[NSUserDefaults standardUserDefaults] objectForKey:@"show_config"]

#define Institution_Id [[NSUserDefaults standardUserDefaults] objectForKey:@"institutionId"] == nil ? @"0" : [[NSUserDefaults standardUserDefaults] objectForKey:@"institutionId"]



#define currentIOS [[[UIDevice currentDevice] systemVersion] floatValue]

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define iPhoneX [YunKeTang_Api_Tool judgeIphoneX]//([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)//iphoneX屏幕


//本地保存
#define UserOathToken [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"]
#define UserOathTokenSecret [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"]
#define UserID [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"]
#define APPID [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"]
#define AppName [[NSUserDefaults standardUserDefaults] objectForKey:@"appName"]
#define Only_Login_Key [[NSUserDefaults standardUserDefaults] objectForKey:@"only_login_key"]


#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//#define EncryptUrl @"https://t.v4.51eduline.com/service/"
//#define EncryptHeaderUrl @"https://t.v4.51eduline.com"

/// 测试服(d单机构和多机构)
#define EncryptUrl [MoreOrSingle_HeaderUrl integerValue] == 1 ? @"https://single.51eduline.com/service/" : @"https://t.v4.51eduline.com/service/"
#define EncryptHeaderUrl [MoreOrSingle_HeaderUrl integerValue] == 1 ? @"https://single.51eduline.com" : @"https://t.v4.51eduline.com"

#define basidUrl [MoreOrSingle_HeaderUrl integerValue] == 1 ? @"https://single.51eduline.com/service" : @"https://t.v4.51eduline.com/service"

/// 正式服(单机构和多机构)
//#define EncryptUrl [MoreOrSingle_HeaderUrl integerValue] == 1 ? @"https://demo.51eduline.com/service/" : @"https://v4.51eduline.com/service/"
//#define EncryptHeaderUrl [MoreOrSingle_HeaderUrl integerValue] == 1 ? @"https://demo.51eduline.com" : @"https://v4.51eduline.com"
//
//#define basidUrl [MoreOrSingle_HeaderUrl integerValue] == 1 ? @"https://demo.51eduline.com/service" : @"https://v4.51eduline.com/service"




#define Image(name) [UIImage imageNamed:name]
#define PriceColor [UIColor redColor]
#define BasidColor [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]
#define PartitionColor [UIColor colorWithRed:225.f / 255 green:225.f / 255 blue:225.f / 255 alpha:1]
#define BackColor [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]
#define XXColor [UIColor colorWithRed:153.f / 255 green:153.f / 255 blue:153.f / 255 alpha:1]
#define JHColor [UIColor colorWithRed:255.f / 255 green:127.f / 255 blue:0.f / 255 alpha:1]

//几个类型相同的时候 选中与未选中的颜色
#define sameColor [UIColor colorWithRed:89.f / 255 green:89.f / 255 blue:89.f / 255 alpha:1]

//考试系统正确答案
#define FalseColor [UIColor colorWithRed:246.f / 255 green:62.f / 255 blue:51.f / 255 alpha:1]

//考试系统错误答案
#define TrueColor [UIColor colorWithRed:96.f / 255 green:181.f / 255 blue:23.f / 255 alpha:1]

//一般分类里面的字的颜色(不是纯黑的颜色)
#define BlackNotColor [UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1]


#define Font(number) [UIFont systemFontOfSize:number]
#define Color(color) [UIColor color]

//#define basidUrl @"https://t.v4.51eduline.com/service"

//下载保存视频的Key
#define YunKeTang_EdulineOssCnShangHai @"eduline.oss-cn-shanghai"
#define YunKeTang_VideoDataSource @"YunKeTang_VideoDataSource"
#define YunKeTang_CurrentDownCount @"YunKeTang_CurrentDownCount"
#define YunKeTang_CurrentDownList @"YunKeTang_CurrentDownList"
#define YunKeTang_CurrentDownTitleList @"YunKeTang_CurrentDownTitleList"
#define YunKeTang_CurrentDownExit @"YunKeTang_CurrentDownExit"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 新增内容
//判断是否是ios7系统
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f
#define IOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.f
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.f)
//判断是否是iphone5的设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define UPHEIGHT 64.0

//RBG color
#define RGBA(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
// 从16进制生成颜色 用法 RGBHex(0xBC1128)
#define RGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define GBLINECOLOR RGBA(237,237,237)
#define EdulineLineColor RGBHex(0xF1F1F1)
#define SWNOTEmptyArr(X) (NOTNULL(X)&&[X isKindOfClass:[NSArray class]]&&[X count])
#define SWNOTEmptyDictionary(X) (NOTNULL(X)&&[X isKindOfClass:[NSDictionary class]]&&[[X allKeys]count])
#define SWNOTEmptyStr(X) (NOTNULL(X)&&[X isKindOfClass:[NSString class]]&&((NSString *)X).length)
#define NOTNULL(x) ((![x isKindOfClass:[NSNull class]])&&x)

#define ShowNetError    [self showHudInView:self.view showHint:TEXT_NETWORK_ERROR]
#define ShowHud(X) [self showHudInView:self.view hint:(X)]
#define ShowMissHid(X) [self showHudInView:self.view showHint:(X)]
#define ShowInViewHud(X) [self showHudInView:self hint:(X)]
#define ShowInViewMiss(X) [self showHint:(X)]

// iPhoneX状态栏增加的高度
#define MACRO_UI_STATUSBAR_ADD_HEIGHT [YunKeTang_Api_Tool statusBarAddHeightWithIPhoneX]
// iPhoneX状态栏高度
#define MACRO_UI_STATUSBAR_HEIGHT [YunKeTang_Api_Tool statusBarHeightWithIPhoneX]
// 判断iPhoneX 并返回顶部高度
#define MACRO_UI_UPHEIGHT [YunKeTang_Api_Tool upHeightWithIPhoneX]
// 判断iPhoneX 并返回刘海高度(30dp)
#define MACRO_UI_LIUHAI_HEIGHT [YunKeTang_Api_Tool liuhaiHeightWithIPhoneX]
// 判断iPhoneX 并返回底部高度
#define MACRO_UI_TABBAR_HEIGHT [YunKeTang_Api_Tool bottomHeightWithIPhoneX]
// 判断iPhoneX 并返回安全区高度
#define MACRO_UI_SAFEAREA [YunKeTang_Api_Tool safeAreaWithIPhoneX]

// 微信分享
#define WXAppId @"wxbbb961a0b0bf577a"
#define WXAppSecret @"7ea0101aeabd53bc32859370cde278cc"
// QQ分享
#define QQAppId @"101400042"
#define QQAppSecret @"a85c2fcd67839693d5c0bf13bec84779"
// 新浪分享
#define SinaAppId @"3997129963"
#define SinaAppSecret @"da07bcf6c9f30281e684f8abfd0b4fca"

// 支付宝h5支付之后需要回到app
#define AlipayBundleId @"com.saixin.eduline"

// TKYUN
#import "TKHelperUtil.h"
#import "TKTheme.h"

#import "TKMacro.h"
#import "TKEnumHeader.h"

#import "TKAlertView.h"

#import "TKEduNetManager.h"
#import "TKUtil.h"
#import "TXSakuraKit.h"


#import <TKRoomSDK/TKRoomSDK.h>

#import <TKWhiteBoard/TKWhiteBoard.h>

#import "UIView+TKExtension.h"
#import "UIImageView+TKExtension.h"
#import "UIImage+TKExtension.h"
#import "UIView+TKRedDot.h"
#import "UIControl+TKClickedOnce.h"
#import "TKModelToJson.h"
#import "TKSortTool.h"
#import "TKNotificationHeader.h"
#import "Masonry.h"
#import "TKRoomJsonModel.h"
#define ScreenFitWidth [UIScreen mainScreen].bounds.size.width / 375
#define ScreenFitHeight [UIScreen mainScreen].bounds.size.height / 667

#endif
