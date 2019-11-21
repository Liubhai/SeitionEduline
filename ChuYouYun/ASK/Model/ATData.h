//
//  ATData.h
//
//  Created by 志强 林 on 15/2/14
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATCountInfo, ATFollowState;

@interface ATData : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) id intro;
@property (nonatomic, strong) NSArray *profile;
@property (nonatomic, strong) NSString *followId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) ATCountInfo *countInfo;
@property (nonatomic, strong) NSString *avatarBig;
@property (nonatomic, strong) NSString *avatarMiddle;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *spaceUrl;
@property (nonatomic, strong) NSDictionary *followState;
@property (nonatomic, strong) NSString *avatarSmall;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
