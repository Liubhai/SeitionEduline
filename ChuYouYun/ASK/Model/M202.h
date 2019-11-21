//
//  M202.h
//
//  Created by 志强 林 on 15/2/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface M202 : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *feedEmailTime;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *profession;
@property (nonatomic, strong) NSArray *medals;
@property (nonatomic, strong) NSString *myCollege;
@property (nonatomic, strong) NSString *firstLetter;
@property (nonatomic, strong) NSString *lastFeedId;
@property (nonatomic, strong) NSArray *userGroup;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *loginSalt;
@property (nonatomic, strong) NSString *groupIcon;
@property (nonatomic, assign) id sendEmailTime;
@property (nonatomic, strong) NSString *regIp;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *isAudit;
@property (nonatomic, strong) NSArray *apiUserGroup;
@property (nonatomic, strong) NSString *isInit;
@property (nonatomic, strong) NSString *avatarOriginal;
@property (nonatomic, strong) NSString *lastPostTime;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *avatarSmall;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *spaceLink;
@property (nonatomic, strong) NSString *signupCollege;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *spaceUrl;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *avatarBig;
@property (nonatomic, strong) NSString *lastLoginTime;
@property (nonatomic, assign) id inviteCode;
@property (nonatomic, assign) id apiKey;
@property (nonatomic, strong) NSString *findStudyLevel;
@property (nonatomic, strong) NSString *phoneActivate;
@property (nonatomic, strong) NSString *mailActivate;
@property (nonatomic, strong) NSString *avatarTiny;
@property (nonatomic, strong) NSString *spaceLinkNo;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *myStudyLevel;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *studyPhase;
@property (nonatomic, strong) NSString *avatarMiddle;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
