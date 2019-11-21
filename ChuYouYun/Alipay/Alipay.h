//
//  Alipay.h
//  iDaoYoo
//
//  Created by ZhiYiForMac on 15/3/14.
//  Copyright (c) 2015年 Johnbenjamin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Alipay : NSObject
@property(strong, nonatomic)NSString *sourceStr;
@property(strong, nonatomic)NSString *orderName;
@property(strong, nonatomic)NSString *orderTitle;
@property(strong, nonatomic)NSString *orderPrice;
-(void)reloadAlipay;
-(id)initWithOrder:(NSString *)order Cname:(NSString *)cname ctitle:(NSString *)ctitle Cprice:(NSString *)cprice;
@end
