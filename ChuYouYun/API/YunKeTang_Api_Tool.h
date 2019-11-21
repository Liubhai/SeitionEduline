//
//  YunKeTang_Api_Tool.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/17.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YunKeTang_Api_Tool : NSObject {
@private
    NSMutableDictionary *_data;
}

// 需要展示的屏幕高度
@property (assign, nonatomic) CGFloat tsShowWindowsHeight;
// 需要展示的屏幕宽度
@property (assign, nonatomic) CGFloat tsShowWindowsWidth;
// 屏幕高度
@property (assign, nonatomic) CGFloat tsMainScreenHeight;
// 屏幕宽度
@property (assign, nonatomic) CGFloat tsMainScreenWidth;

+ (NSString *)YunKeTang_Api_Tool_GetEncryptStr:(NSDictionary *)dict;
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr:(id)responseObject;
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr_Before:(id)responseObject;
+ (NSDictionary *)YunKeTang_Api_Tool_WithJson:(NSString *)dataStr;
+ (NSString *)YunKeTang_GetFullUrl:(NSString *)string;
+ (id)YunKeTang_Api_Tool_GetDecodeStrFromData:(id)responseObject;

+ (YunKeTang_Api_Tool *)sharedInstance;
/********************* iPhoneX 高度判断 **********************/
+ (float)safeAreaWithIPhoneX;
+ (float)bottomHeightWithIPhoneX;
+ (float)upHeightWithIPhoneX;
+ (float)liuhaiHeightWithIPhoneX;
+ (float)statusBarAddHeightWithIPhoneX;
+ (float)statusBarHeightWithIPhoneX;
+ (BOOL)isIPhoneX;
+ (BOOL)judgeIphoneX;

// 字符串 高度
+ (float) heightForString:(NSString *)value fontSize:(UIFont*)font andWidth:(float)width;

// 字符串 宽度
+ (float) widthForString:(NSString *)value fontSize:(UIFont*)font andHeight:(float)height;

+ (NSString*)timeChangeWithSeconds:(NSInteger)seconds;
+ (NSString*)timeChangeWithSecondsFormat:(NSInteger)seconds;
+ (NSString *)getLocalTime;
+ (NSString *)formateTime:(NSString *)time;
+ (NSString *)timeForHHmm:(NSString *)time;
+ (NSString *)timeForYYYYMMDD:(NSString *)time;
@end
