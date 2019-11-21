//
//  NetAccessModel.m
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/25.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "NetAccessModel.h"
#import <AdSupport/AdSupport.h>
#import "NSString+Additions.h"
#define BASE_URL @"https://aip.baidubce.com"

#define ACCESS_TOEKN_URL [NSString stringWithFormat:@"%@/oauth/2.0/token",BASE_URL]

#define IDENTIFY_URL [NSString stringWithFormat:@"%@/rest/2.0/face/v2/identify",BASE_URL]
#define LIVENESS_URL [NSString stringWithFormat:@"%@/rest/2.0/vis-faceverify/v2/faceverify/detect",BASE_URL]
#define LIVENESS_VS_IDCARD_URL [NSString stringWithFormat:@"%@/rest/2.0/face/v1/person/verify",BASE_URL]

#define REG_URL [NSString stringWithFormat:@"%@/rest/2.0/vis-faceverify/v2/faceverify/user/add",BASE_URL]
#define VERIFY_URL [NSString stringWithFormat:@"%@/rest/2.0/face/v2/verify",BASE_URL]

@interface NetAccessModel ()
@property (nonatomic, readwrite, retain) NSString *accessToken;
@property (nonatomic, readwrite, retain) NSString *groupID;
@end
@implementation NetAccessModel

+ (instancetype)sharedInstance {
    static NetAccessModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetAccessModel alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            _groupID = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        } else {
            _groupID = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
        //_groupID = @"BAIDU_AIP_GROUP";
    }
    return self;
}

- (void)getAccessTokenWithAK:(NSString *)ak SK:(NSString *)sk {
    __weak typeof(self) weakSelf = self;
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSLog(@"start = %f",start);
    [[NetManager sharedInstance] postDataWithPath:ACCESS_TOEKN_URL parameters:@{@"grant_type":@"client_credentials",@"client_id":ak,@"client_secret":sk} completion:^(NSError *error, id resultObject) {
        if (error == nil) {
            NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
            NSLog(@"end = %f",end);
            NSLog(@"Token = %f",end - start);
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
            weakSelf.accessToken = dict[@"access_token"];
            NSLog(@"%@",dict[@"access_token"]);
        }
    }];
}

- (void)detectUserLivenessWithFaceImageStr:(NSString *)imageStr  completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"group_id":self.groupID ?: @"",
                           @"image":imageStr,
                           @"face_fields":@"faceliveness"};
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",LIVENESS_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}

- (void)identifyUserLivenessWithFaceImageStr:(NSString *)imageStr  completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"group_id":self.groupID ?: @"",
                           @"image":imageStr,
                           @"face_fields":@"faceliveness"};
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",IDENTIFY_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}

- (void)verifyFaceAndIDCard:(NSString *)name idNumber:(NSString *)idnumber imageStr:(NSString *)imageStr completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"name":name ?: @"",
                           @"image":imageStr,
                           @"id_card_number":idnumber ?: @""};
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",LIVENESS_VS_IDCARD_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}
- (void)registerFaceWithImageBaseString:(NSString *)imageStr userName:(NSString *)userName completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"uid":[userName md5String],
                           @"user_info":userName,
                           @"group_id":self.groupID ?: @"",
                           @"image":imageStr};
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",REG_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}
- (void)verifyFaceWithImageBaseString:(NSString *)imageStr userName:(NSString *)userName completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"uid":[userName md5String],
                           @"image":imageStr,
                           @"ext_fields":@"faceliveness",
                           @"group_id":self.groupID ?: @""};
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",VERIFY_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}
@end
