//
//  UIAlertView+OtherInfo.m
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//
#import <objc/runtime.h>

#import "UIAlertView+OtherInfo.h"
static char const * const nomolTablewKey = "OtherInfoUIAlertView";

@implementation UIAlertView (OtherInfo)
-(NSDictionary *)otherInfo
{
    return objc_getAssociatedObject(self, nomolTablewKey);
}

-(void)setOtherInfo:(NSDictionary *)otherInfo
{
    objc_setAssociatedObject(self, nomolTablewKey, otherInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
@end
