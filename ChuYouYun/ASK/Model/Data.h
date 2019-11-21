//
//  Data.h
//
//  Created by 志强 林 on 15/1/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Data : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *ctime;
@property (nonatomic, strong) NSString *feedEmailTime;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, assign) id oauthToken;
@property (nonatomic, strong) NSString *profession;
@property (nonatomic, strong) NSString *myCollege;
@property (nonatomic, assign) id firstLetter;
@property (nonatomic, strong) NSString *lastFeedId;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *upwd;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, assign) id sendEmailTime;
@property (nonatomic, strong) NSString *regIp;
@property (nonatomic, strong) NSString *userface;
@property (nonatomic, strong) NSString *isDel;
@property (nonatomic, strong) NSString *isAudit;
@property (nonatomic, strong) NSString *lastPostTime;
@property (nonatomic, strong) NSString *isInit;
@property (nonatomic, assign) id oauthTokenSecret;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *signupCollege;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *lastLoginTime;
@property (nonatomic, assign) id inviteCode;
@property (nonatomic, assign) id apiKey;
@property (nonatomic, strong) NSString *findStudyLevel;
@property (nonatomic, strong) NSString *phoneActivate;
@property (nonatomic, strong) NSString *mailActivate;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *myStudyLevel;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *studyPhase;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
