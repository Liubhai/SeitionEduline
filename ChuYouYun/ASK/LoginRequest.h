//
//  LoginRequest.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginRequest : NSObject


+(id)loginWithRequests:(NSString *)userName withPassword:(NSString *)password;
-(void)response:(id)responseObject;
@end
