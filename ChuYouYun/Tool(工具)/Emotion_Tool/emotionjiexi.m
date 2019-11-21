//
//  emotionjiexi.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/7.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "emotionjiexi.h"
#import "RegexKitLite.h"
#import "TextAndEnmoj.h"

@implementation emotionjiexi
+(NSMutableAttributedString*)jiexieemotion:(NSString*)string{
    NSMutableAttributedString *mutalestr=[[NSMutableAttributedString alloc]init];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options: NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        
        
    }];
    return mutalestr;
}


+(NSMutableAttributedString*)jiexienmojconent:(NSString*)text font:(UIFont*)font{
    NSMutableAttributedString *arrt=[[NSMutableAttributedString alloc]init];
//    NSString *enmojpattern=@"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
//    NSString *enmojpattern=@"\\[[biaoqing_[0-9\\d{1}]]+\\]";
//    NSString *enmojpattern=@"\\[[biaoqing_[0-9\\d{1}]+\\>]";
//      NSString *enmojpattern=@"\\[biaoqing_[0-9\\d{1}]+\\]";
    NSString *enmojpattern = @"\\[+[a-z]+\\]|\\[biaoqing_[0-9\\d{1}]+\\]|img_\\[+[a-z]+\\]";

    NSMutableArray *parts=[NSMutableArray array];
    //遍历所有特殊字符
    [text enumerateStringsMatchedByRegex:enmojpattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length==0)return ;
        TextAndEnmoj *part=[[TextAndEnmoj alloc]init];
        part.textstr=*capturedStrings;
        part.rang=*capturedRanges;
        part.isspecil=YES;
        //part.isenmoj=[part.textstr hasPrefix:@"["]&&[part.textstr hasSuffix:@"]"];
        [parts addObject:part];
    }];
    //遍历所有非特殊字符
    [text enumerateStringsSeparatedByRegex:enmojpattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length==0)return ;
        TextAndEnmoj *part=[[TextAndEnmoj alloc]init];
        part.textstr=*capturedStrings;
        part.rang=*capturedRanges;
        [parts addObject:part];
    }];
    //排序
    [parts sortUsingComparator:^NSComparisonResult(TextAndEnmoj *part1, TextAndEnmoj *part2) {
        if (part1.rang.location>part2.rang.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    for (TextAndEnmoj *part in parts) {
        NSAttributedString *substr=nil;
        NSTextAttachment *attch=[[NSTextAttachment alloc]init];
        if (part.isspecil) {
            NSString *name=[part.textstr substringWithRange:NSMakeRange(1, part.textstr.length-2)];
            attch.image=[UIImage imageNamed:name];
            if (attch.image) {
            attch.bounds=CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr=[NSAttributedString attributedStringWithAttachment:attch];
            }else{
                substr=[[NSAttributedString alloc]initWithString:part.textstr];
            }
        }else{
            substr=[[NSAttributedString alloc]initWithString:part.textstr];
        }
        [arrt appendAttributedString:substr];
    }
    
    [arrt addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, arrt.length)];
    return arrt;
    
}


@end
