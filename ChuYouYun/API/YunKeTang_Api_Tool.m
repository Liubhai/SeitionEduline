//
//  YunKeTang_Api_Tool.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/17.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

//临时
//#define EncryptUrl @"En-Params"

#import "YunKeTang_Api_Tool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "AESCrypt.h"
#import "NSData+CommonCrypto.h"
#import "NSString+AESSecurity.h"
#import "SYG.h"
#import "NSString+SBJSON.h"
#import "SBJsonParser.h"
#import <sys/utsname.h>

// kUUIDKey尽量改成便于区分App的（有简友说如果一个手机上两个App都这样用相同的kUUIDKey可能会存在bug，我测试几次没发现，但是还是建议尽量要区分开）
NSString * const kUUIDKey = @"com.myApp.uuid";


@implementation YunKeTang_Api_Tool
static YunKeTang_Api_Tool *_sharedInstance;

- (id)init
{
    if ((self = [super init]))
    {
        _data  = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (YunKeTang_Api_Tool *)sharedInstance
{
    if (!_sharedInstance)
    {
        _sharedInstance = [[YunKeTang_Api_Tool alloc] init];
    }
    return _sharedInstance;
}

//加密
+ (NSString *)YunKeTang_Api_Tool_GetEncryptStr:(NSDictionary *)dict {
    
    if (dict == nil) {
        return nil;
    }
    
    NSLog(@"%@",Only_Login_Key);
    //处理唯一登录
//    [dict setValue:Only_Login_Key forKey:@"only_login_key"];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *newStr = nil;
    NSError *error;
    if (@available(iOS 11.0, *)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&error];
        
        if (!jsonData) {
            NSLog(@"%@",error);
        }else{
            newStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    } else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            NSLog(@"%@",error);
        }else{
            newStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    NSString *keyStr = [NSString stringWithFormat:@"%@|%@",timeSp,newStr];
    NSString *encryptStr = [NSString encrypyAES:keyStr key:NetKey];
    //替换特殊符号
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return encryptStr;
}

//解密
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr:(id)responseObject {
    
    NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData * receiveData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    
    if ([[jsonDict stringValueForKey:@"code"] integerValue] == 0) {
        return jsonDict;
    }
    
    NSString *dataStr = [jsonDict stringValueForKey:@"data"];
    if (dataStr == nil) {
        return nil;
    }
    if ([dataStr isKindOfClass:[NSArray class]]) {
        return (NSArray *)dataStr;
    }
    if ([dataStr isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)dataStr;
    }
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    
    NSString *decodeStr = [NSString descryptAES:dataStr key:NetKey];
    NSString *fromStr = [decodeStr substringFromIndex:11];
    SBJsonParser* json =[[SBJsonParser alloc]init];
    NSMutableDictionary* dic =[json objectWithString:fromStr];
    
    return dic;
}

//解密之前的判断
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr_Before:(id)responseObject {
    
    NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData * receiveData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    return jsonDict;
}

//
+ (NSDictionary *)YunKeTang_Api_Tool_WithJson:(NSString *)dataStr {
    NSString *dataString = nil;
    dataString = [dataStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

    NSString *decodeStr = [NSString descryptAES:dataString key:NetKey];
    NSString *fromStr = [decodeStr substringFromIndex:11];
    SBJsonParser* json =[[SBJsonParser alloc]init];
    NSMutableDictionary* dic =[json objectWithString:fromStr];

    return dic;
}

#pragma mark ---- Tool

- (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    NSError *error;
    // 注
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&error];
    
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:nil error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

#pragma mark --- 拼接字符串的方法
+ (NSString *)YunKeTang_GetFullUrl:(NSString *)string {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",EncryptUrl,string];
    return urlStr;
}

+ (id)YunKeTang_Api_Tool_GetDecodeStrFromData:(id)responseObject {
    NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData * receiveData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    
    if ([[jsonDict stringValueForKey:@"code"] integerValue] == 0) {
        return jsonDict;
    }
    
    NSString *dataStr = [jsonDict stringValueForKey:@"data"];
    if (dataStr == nil) {
        return nil;
    }
    if ([dataStr isKindOfClass:[NSArray class]]) {
        return (NSArray *)dataStr;
    }
    if ([dataStr isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)dataStr;
    }
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    
    NSString *decodeStr = [NSString descryptAES:dataStr key:NetKey];
    NSString *fromStr = [decodeStr substringFromIndex:11];
    SBJsonParser* json =[[SBJsonParser alloc]init];
    NSMutableDictionary* dic =[json objectWithString:fromStr];
    
    return dic;
}

// iPhoneX底部安全区
+ (float)safeAreaWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 34.0;
    } else {
        return 0;
    }
}

// iPhoneX底部视图高度
+ (float)bottomHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 49.0+34.0;
    } else {
        return 49.0;
    }
}

// iPhoneX顶部视图高度
+ (float)upHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 64.0+24.0;
    } else {
        return 64.0;
    }
}

// iPhoneX顶部视图高度
+ (float)liuhaiHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 30.0;
    } else {
        return 0;
    }
}

// iPhoneX状态栏高出的距离
+ (float)statusBarAddHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 24.0;
    } else {
        return 0;
    }
}

// iPhoneX状态栏高度
+ (float)statusBarHeightWithIPhoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return 44.0;
    } else {
        return 20.0;
    }
}

+ (BOOL)isIPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // 模拟器下采用屏幕的高度来判断
        return [UIScreen mainScreen].bounds.size.height >= 812;
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}

+ (float) heightForString:(NSString *)value fontSize:(UIFont*)font andWidth:(float)width
{
    
    if ( [[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:0.001];
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rectToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return rectToFit.size.height;
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
#pragma clang diagnostic pop
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return sizeToFit.height;
        }
        
    }
}

+ (BOOL)judgeIphoneX {
    if ([UIScreen mainScreen].bounds.size.width >= 375.f &&
        [UIScreen mainScreen].bounds.size.height >= 812.f) {
        return YES;
    } else {
        return NO;
    }
}

+ (float) widthForString:(NSString *)value fontSize:(UIFont*)font andHeight:(float)height
{
    
    if ( [[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        [paragraphStyle setLineSpacing:0.001];
        NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGRect rectToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return rectToFit.size.width;
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX,height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
#pragma clang diagnostic pop
        if (value.length==0||[value isEqual:[NSNull null]]||value==nil) {
            return 0.0;
        }else{
            return sizeToFit.width;
        }
        
    }
    
}

+ (NSString*)timeChangeWithSeconds:(NSInteger)seconds {
    NSInteger temp1 = seconds/60;
    NSInteger temp2 = temp1/ 60;
    NSInteger d = temp2 / 24;
    NSInteger h = temp2 % 24;
    NSInteger m = temp1 % 60;
    NSInteger s = seconds %60;
    NSString * hour = h< 9 ? [NSString stringWithFormat:@"0%ld",(long)h] :[NSString stringWithFormat:@"%ld",(long)h];
    NSString *day = d < 9 ? [NSString stringWithFormat:@"%ld",(long)d] : [NSString stringWithFormat:@"%ld",(long)d];
    NSString *minite = m < 9 ? [NSString stringWithFormat:@"0%ld",(long)m] : [NSString stringWithFormat:@"%ld",(long)m];
    NSString *second = s < 9 ? [NSString stringWithFormat:@"0%ld",(long)s] : [NSString stringWithFormat:@"%ld",(long)s];
    if ([day integerValue]>0) {
        return [NSString stringWithFormat:@"%@天%@小时%@分%@秒",day,hour,minite,second];
    }
    return [NSString stringWithFormat:@"%@小时%@分%@秒",hour,minite,second];
}

-(CGFloat)tsShowWindowsWidth{
    
    if (_tsShowWindowsWidth == 0) {
        _tsShowWindowsWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _tsShowWindowsWidth;
}

- (CGFloat)tsShowWindowsHeight{
    
    if (_tsShowWindowsHeight == 0) {
        _tsShowWindowsHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _tsShowWindowsHeight;
}

- (CGFloat)tsMainScreenWidth{
    
    if (_tsMainScreenWidth == 0) {
        _tsMainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _tsMainScreenWidth;
}


- (CGFloat)tsMainScreenHeight{
    
    if (_tsMainScreenHeight == 0) {
        _tsMainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _tsMainScreenHeight;
}

+ (NSString *)getLocalTime {
    //获取本地时间
    
    NSDate *date = [NSDate date];                            //实际上获得的是：UTC时间，协调世界时，亚州的时间与UTC的时差均为+8
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];                  //zone为当前时区信息  在我的程序中打印的是@"Asia/Shanghai"
    
    NSInteger interval = [zone secondsFromGMTForDate: date];      //28800 //所在地区时间与协调世界时差距
    
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];  //加上时差，得到本地时间
    
    //get seconds since 1970
    
    NSTimeInterval intervalWith1970 = [localeDate timeIntervalSince1970];     //本地时间与1970年的时间差（秒数）
    
    int daySeconds = 24 * 60 * 60;                                            //每天秒数
    
    NSInteger allDays = intervalWith1970 / daySeconds;                        //这一步是为了舍去后面的时分秒
    
    localeDate = [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";   //创建日期格式（年-月-日）
    
    NSString *temp = [fmt stringFromDate:localeDate];       //得到当地当时的时间（年月日）
    
    return temp;
}

#pragma mark - 获取到UUID后存入系统中的keychain中

+ (NSString *)getUUIDInKeychain {
    // 1.直接从keychain中获取UUID
    NSString *getUDIDInKeychain = (NSString *)[YunKeTang_Api_Tool load:kUUIDKey];
    NSLog(@"从keychain中获取UUID%@", getUDIDInKeychain);
    
    // 2.如果获取不到，需要生成UUID并存入系统中的keychain
    if (!getUDIDInKeychain || [getUDIDInKeychain isEqualToString:@""] || [getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        // 2.1 生成UUID
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
        NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        NSLog(@"生成UUID：%@",result);
        // 2.2 将生成的UUID保存到keychain中
        [YunKeTang_Api_Tool save:kUUIDKey data:result];
        // 2.3 从keychain中获取UUID
        getUDIDInKeychain = (NSString *)[YunKeTang_Api_Tool load:kUUIDKey];
    }
    
    return getUDIDInKeychain;
}


#pragma mark - 删除存储在keychain中的UUID

+ (void)deleteKeyChain {
    [self delete:kUUIDKey];
}


#pragma mark - 私有方法

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,service,(id)kSecAttrService,service,(id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

// 从keychain中获取UUID
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", service, exception);
        }
        @finally {
            NSLog(@"finally");
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    NSLog(@"ret = %@", ret);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

// 将生成的UUID保存到keychain中
+ (void)save:(NSString *)service data:(id)data {
    // Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    // Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

@end
