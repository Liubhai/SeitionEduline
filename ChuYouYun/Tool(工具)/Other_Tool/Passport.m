//
//  Passport.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "Passport.h"
#import "ReMD.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "RegexKitLite.h"

@implementation Passport
+ (void)saveUserPassport:(int64_t)uid andUsername:(NSString *)username andPassword:(NSString *)password andToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret
{
    NSDictionary *passport = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lld", uid], @"uid",tokenSecret, @"oauthTokenSecret",token, @"oauthToken",username, @"username",password, @"password",nil];
    [[NSUserDefaults standardUserDefaults] setObject:passport forKey:@"UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)userDataWithSavelocality:(Data *)data
{
    NSString *userInfo = [self filePath];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userInfo" ofType:@"plist"];
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    dataDic = [data dictionaryRepresentation];
    [dataDic writeToFile:userInfo atomically:YES];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:userInfo];
    NSLog(@"plist   %@",dic);
}

+(NSString *)filePath
{
    NSFileManager *m = [NSFileManager defaultManager];
    
    NSString* Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *filePath = [Path stringByAppendingPathComponent:@"userInfo.plist"];
    
    if (![m fileExistsAtPath:filePath]) {
        [m createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

+(void)removeFile
{
    NSFileManager *m = [NSFileManager defaultManager];
    
    NSString* Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
    NSString *filePath = [Path stringByAppendingPathComponent:@"userInfo.plist"];
    
    if ([m fileExistsAtPath:filePath]) {
        [m removeItemAtPath:filePath error:nil];
    }
}
+(NSString *)glformatterDate:(NSString *)time{

    if ([time isEqual:[NSNull null]]) {
        
    } else {
        NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy.MM.dd"];
        
        NSString *regStr = [df stringFromDate:dt];
        NSTimeInterval  timeInterval = [dt timeIntervalSinceNow];
        timeInterval = -timeInterval;
        long temp = 0;
        NSString *date;
        if (timeInterval < 60) {
            
            date = [NSString stringWithFormat:@"刚刚"];
            
        }
        else if((temp = timeInterval/60) <60){
            
            date = [NSString stringWithFormat:@"%ld分前",temp];
            
        }
        else if((temp = temp/60) <24){
            
            date = [NSString stringWithFormat:@"%ld小时前",temp];
            
        }
        else if((temp = temp/24) <30){
            
            date = [NSString stringWithFormat:@"%ld天前",temp];
            
        }
        else {
            
            date = regStr;
        }
        return regStr;
        
    }
    return nil;

}

+(NSString *)formatterDate:(NSString *)time
{
    if ([time isEqual:[NSNull null]]) {
        
    } else {
        NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        NSString *regStr = [df stringFromDate:dt];
        NSTimeInterval  timeInterval = [dt timeIntervalSinceNow];
        timeInterval = -timeInterval;
        long temp = 0;
        NSString *date;
        if (timeInterval < 60) {
            
            date = [NSString stringWithFormat:@"刚刚"];
            
        }
        else if((temp = timeInterval/60) <60){
            
            date = [NSString stringWithFormat:@"%ld分前",temp];
            
        }
        else if((temp = temp/60) <24){
            
            date = [NSString stringWithFormat:@"%ld小时前",temp];
            
        }
        else if((temp = temp/24) <30){
            
            date = [NSString stringWithFormat:@"%ld天前",temp];
            
        }
        else {
            
            date = regStr;
        }
         return regStr;

    }
    return nil;
}

+(NSDate *)formatterDateNumber:(NSString *)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *defaultVauleModleOfCar=[dateFormatter stringFromDate:date];
    NSDate *onlyDate = [dateFormatter dateFromString:defaultVauleModleOfCar];

    return onlyDate;
}
+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//+ (NSString *) md5_encode:(NSString *)string{
//
//    const char *cstr = [string UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(cstr, strlen(cstr), result);
//
//    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1],
//            result[2], result[3],
//            result[4], result[5],
//            result[6], result[7],
//            result[8], result[9],
//            result[10], result[11],
//            result[12], result[13],
//            result[14], result[15]];
//}

//十进制变成16进制
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}




+(NSString *)formatterTime:(NSString *)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *defaultVauleModleOfCar=[dateFormatter stringFromDate:date];
//    NSDate *onlyDate = [dateFormatter dateFromString:defaultVauleModleOfCar];
    
    return defaultVauleModleOfCar;
}
+(NSString *)glTime:(NSString *)time{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *defaultVauleModleOfCar=[dateFormatter stringFromDate:date];
    //    NSDate *onlyDate = [dateFormatter dateFromString:defaultVauleModleOfCar];
    
    return defaultVauleModleOfCar;
}

+ (NSString *)getTime:(NSString *)time {
    NSTimeInterval _interval=[time doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSLog(@"%@", [objDateformat stringFromDate: date]);
    return [objDateformat stringFromDate: date];
}

+ (NSInteger)intervalSinceNow:(NSString *)time1 WithTime:(NSString *)time2
{
//    NSString *timeString=@"";
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:time1];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
//    NSDate *adate = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: adate];
//    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];

    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate1=[format1 dateFromString:time2];
    NSTimeZone *fromzone1 = [NSTimeZone systemTimeZone];
    NSInteger frominterval1 = [fromzone secondsFromGMTForDate: fromdate1];
    NSDate *fromDate1 = [fromdate1  dateByAddingTimeInterval: frominterval1];
    
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [fromDate1 timeIntervalSinceReferenceDate];
    long lTime = fabs((long)intervalTime);
    NSInteger iSeconds =  lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = fabs(lTime/3600);
    NSInteger iDays = lTime/60/60/24;
    NSInteger iMonth =lTime/60/60/24/12;
    NSInteger iYears = lTime/60/60/24/384;
    
    
    NSLog(@"相差%d年%d月 或者 %d日%d时%d分%d秒", iYears,iMonth,iDays,iHours,iMinutes,iSeconds);
    
    //计算出秒
    NSInteger Yseconds = iYears * 360 * 24 * 60 * 60;
    
    NSInteger MSeconds = iMonth * 30 * 24 * 60 * 60;
    
    NSInteger DSeconds = iDays * 24 * 60 * 60;
    
    NSInteger HSeconds = iHours * 60 * 60;
    
    NSInteger MinSeconds = iMinutes * 60;
    
    NSInteger SSeconds = iSeconds;
    
    NSInteger sumSeconds = Yseconds + MSeconds + DSeconds + HSeconds + MinSeconds + SSeconds;
    
    NSLog(@"--------%ld",sumSeconds);

    return sumSeconds;
}

+ (NSArray *)filterImage:(NSString *)html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
}



+ (NSString *)filterHTML:(NSString *)html
{
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //        //找到标签的起始位置
        //        [scanner scanUpToString:@"<" intoString:nil];
        //        //找到标签的结束位置
        //        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        
    }
    return html;
}


//正则去标签
+ (NSString *)getZZwithString:(NSString *)html{
    html = [html stringByReplacingOccurrencesOfString:@"<p style=\"white-space: normal;\">" withString:@"\n"];
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //        //找到标签的起始位置
        //        [scanner scanUpToString:@"<" intoString:nil];
        //        //找到标签的结束位置
        //        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        
    }
    return html;
}



//iOS的适配 （tableView）
//iOS 11 适配
//if (currentIOS >= 11.0) {
//    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.scrollIndicatorInsets = _tableView.contentInset;
//
//    _tableView.estimatedRowHeight = 0;
//    _tableView.estimatedSectionHeaderHeight = 0;
//    _tableView.estimatedSectionFooterHeight = 0;
//}

- (void)adapterOfIOS11With:(UITableView *)tableView {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.scrollIndicatorInsets = tableView.contentInset;
    }
#else
#endif
//    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    tableView.scrollIndicatorInsets = tableView.contentInset;
//
//    tableView.estimatedRowHeight = 0;
//    tableView.estimatedSectionHeaderHeight = 0;
//    tableView.estimatedSectionFooterHeight = 0;
}


- (void)adapterOfIOS11With:(UITableView *)tableView withHight:(NSInteger)hight {
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    tableView.contentInset = UIEdgeInsetsMake(-hight, 0, 0, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
}


//退出登录处理
- (void)goOutLogin {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userface"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthTokenSecret"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthToken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"avatar_small"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uname"];
    [defaults removeObjectForKey:@"balance"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fans"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"follow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"schoolID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Video_Face"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"only_login_key"];
    
    [Passport removeFile];
}

+ (NSString *)filterRemoveImageHTML:(NSString *)html {
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<p><img" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"></p>" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}

@end
