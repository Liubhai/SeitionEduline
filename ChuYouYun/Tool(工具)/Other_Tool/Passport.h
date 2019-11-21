//
//  Passport.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"
#import <CommonCrypto/CommonDigest.h>
#import "TKProgressHUD+Add.h"

@interface Passport : NSObject

- (void)setLoggedInWithToken:(NSString *)token secrect:(NSString *)secrect uid:(NSString *)uid username:(NSString *)username password:(NSString *)password;

+ (void)saveUserPassport:(int64_t)uid andUsername:(NSString *)username andPassword:(NSString *)password andToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret;
+(void)userDataWithSavelocality:(Data *)data;
+(NSString *)filePath;
+(void)removeFile;
+(void)saveImage:(NSString *)userface;
+(NSString *)formatterDate:(NSString *)time;
+(NSDate *)formatterDateNumber:(NSString *)time;
+(NSString *)md5:(NSString *)str;
+(NSString *)formatterTime:(NSString *)time;
+(NSInteger)intervalSinceNow:(NSString *)time1 WithTime:(NSString *)time2;
+(NSString *)glformatterDate:(NSString *)time;
+(NSString *)glTime:(NSString *)time;
+ (NSString *)getTime:(NSString *)time;

+ (NSArray *)filterImage:(NSString *)html;
+ (NSString *)filterHTML:(NSString *)html;
+ (NSString *)getZZwithString:(NSString *)html;

+ (NSString *)getHexByDecimal:(NSInteger)decimal;
//ios 11适配
- (void)adapterOfIOS11With:(UITableView *)tableView;
- (void)adapterOfIOS11With:(UITableView *)tableView withHight:(NSInteger)hight;

//唯一登录
- (void)goOutLogin;
// 剔除图片后的标签
+ (NSString *)filterRemoveImageHTML:(NSString *)html;

@end
