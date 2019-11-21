//
//  User.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,copy)NSString *Login;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,assign)int *phone;
@property(nonatomic,assign)int *sex;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,assign)int *is_audit;
@property(nonatomic,assign)int *is_active;
@property(nonatomic,assign)int *is_init;
@property(nonatomic,copy)NSString *ctime;
@property(nonatomic,assign)int *identity;
@property(nonatomic,assign)int *province;
@property(nonatomic,assign)int *city;
@property(nonatomic,assign)int *area;
@property(nonatomic,assign)int *reg_ip;
@property(nonatomic,assign)int *is_del;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *profession;
@property(nonatomic,copy)NSString *last_login_time;
@property(nonatomic,copy)NSString *search_key;
@property(nonatomic,copy)NSString *mail_activate;
@property(nonatomic,copy)NSString *phone_activate;
@property(nonatomic,copy)NSString *userface;
@property(nonatomic,copy)NSString *oauth_token;
@property(nonatomic,copy)NSString *oauth_token_secret;



@end
