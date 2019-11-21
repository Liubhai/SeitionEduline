//
//  TextAndEnmoj.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/7.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAndEnmoj : NSTextAttachment
@property (strong ,nonatomic)NSString *textstr;
@property (assign ,nonatomic)NSRange   rang;
@property (assign ,nonatomic)BOOL isspecil;
@end
