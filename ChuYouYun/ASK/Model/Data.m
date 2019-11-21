//
//  Data.m
//
//  Created by 志强 林 on 15/1/23
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Data.h"


NSString *const kDataCtime = @"ctime";
NSString *const kDataFeedEmailTime = @"feed_email_time";
NSString *const kDataUid = @"uid";
NSString *const kDataLogin = @"login";
NSString *const kDataOauthToken = @"oauth_token";
NSString *const kDataProfession = @"profession";
NSString *const kDataMyCollege = @"my_college";
NSString *const kDataFirstLetter = @"first_letter";
NSString *const kDataLastFeedId = @"last_feed_id";
NSString *const kDataUname = @"uname";

NSString *const kDataUpwd = @"upwd";

NSString *const kDataLocation = @"location";
NSString *const kDataLang = @"lang";
NSString *const kDataSendEmailTime = @"send_email_time";
NSString *const kDataRegIp = @"reg_ip";
NSString *const kDataUserface = @"userface";
NSString *const kDataIsDel = @"is_del";
NSString *const kDataIsAudit = @"is_audit";
NSString *const kDataLastPostTime = @"last_post_time";
NSString *const kDataIsInit = @"is_init";
NSString *const kDataOauthTokenSecret = @"oauth_token_secret";
NSString *const kDataIntro = @"intro";
NSString *const kDataSex = @"sex";
NSString *const kDataEmail = @"email";
NSString *const kDataArea = @"area";
NSString *const kDataSignupCollege = @"signup_college";
NSString *const kDataDomain = @"domain";
NSString *const kDataCity = @"city";
NSString *const kDataIsActive = @"is_active";
NSString *const kDataSearchKey = @"search_key";
NSString *const kDataProvince = @"province";
NSString *const kDataLastLoginTime = @"last_login_time";
NSString *const kDataInviteCode = @"invite_code";
NSString *const kDataApiKey = @"api_key";
NSString *const kDataFindStudyLevel = @"find_study_level";
NSString *const kDataPhoneActivate = @"phone_activate";
NSString *const kDataMailActivate = @"mail_activate";
NSString *const kDataIdentity = @"identity";
NSString *const kDataPhone = @"phone";
NSString *const kDataMyStudyLevel = @"my_study_level";
NSString *const kDataTimezone = @"timezone";
NSString *const kDataStudyPhase = @"study_phase";


@interface Data ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Data

@synthesize ctime = _ctime;
@synthesize feedEmailTime = _feedEmailTime;
@synthesize uid = _uid;
@synthesize login = _login;
@synthesize oauthToken = _oauthToken;
@synthesize profession = _profession;
@synthesize myCollege = _myCollege;
@synthesize firstLetter = _firstLetter;
@synthesize lastFeedId = _lastFeedId;
@synthesize uname = _uname;
@synthesize upwd = _upwd;
@synthesize location = _location;
@synthesize lang = _lang;
@synthesize sendEmailTime = _sendEmailTime;
@synthesize regIp = _regIp;
@synthesize userface = _userface;
@synthesize isDel = _isDel;
@synthesize isAudit = _isAudit;
@synthesize lastPostTime = _lastPostTime;
@synthesize isInit = _isInit;
@synthesize oauthTokenSecret = _oauthTokenSecret;
@synthesize intro = _intro;
@synthesize sex = _sex;
@synthesize email = _email;
@synthesize area = _area;
@synthesize signupCollege = _signupCollege;
@synthesize domain = _domain;
@synthesize city = _city;
@synthesize isActive = _isActive;
@synthesize searchKey = _searchKey;
@synthesize province = _province;
@synthesize lastLoginTime = _lastLoginTime;
@synthesize inviteCode = _inviteCode;
@synthesize apiKey = _apiKey;
@synthesize findStudyLevel = _findStudyLevel;
@synthesize phoneActivate = _phoneActivate;
@synthesize mailActivate = _mailActivate;
@synthesize identity = _identity;
@synthesize phone = _phone;
@synthesize myStudyLevel = _myStudyLevel;
@synthesize timezone = _timezone;
@synthesize studyPhase = _studyPhase;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.ctime = [self objectOrNilForKey:kDataCtime fromDictionary:dict];
            self.feedEmailTime = [self objectOrNilForKey:kDataFeedEmailTime fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kDataUid fromDictionary:dict];
            self.login = [self objectOrNilForKey:kDataLogin fromDictionary:dict];
            self.oauthToken = [self objectOrNilForKey:kDataOauthToken fromDictionary:dict];
            self.profession = [self objectOrNilForKey:kDataProfession fromDictionary:dict];
            self.myCollege = [self objectOrNilForKey:kDataMyCollege fromDictionary:dict];
            self.firstLetter = [self objectOrNilForKey:kDataFirstLetter fromDictionary:dict];
            self.lastFeedId = [self objectOrNilForKey:kDataLastFeedId fromDictionary:dict];
            self.uname = [self objectOrNilForKey:kDataUname fromDictionary:dict];
        
            self.upwd = [self objectOrNilForKey:kDataUpwd fromDictionary:dict];
        
            self.location = [self objectOrNilForKey:kDataLocation fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kDataLang fromDictionary:dict];
            self.sendEmailTime = [self objectOrNilForKey:kDataSendEmailTime fromDictionary:dict];
            self.regIp = [self objectOrNilForKey:kDataRegIp fromDictionary:dict];
            self.userface = [self objectOrNilForKey:kDataUserface fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kDataIsDel fromDictionary:dict];
            self.isAudit = [self objectOrNilForKey:kDataIsAudit fromDictionary:dict];
            self.lastPostTime = [self objectOrNilForKey:kDataLastPostTime fromDictionary:dict];
            self.isInit = [self objectOrNilForKey:kDataIsInit fromDictionary:dict];
            self.oauthTokenSecret = [self objectOrNilForKey:kDataOauthTokenSecret fromDictionary:dict];
            self.intro = [self objectOrNilForKey:kDataIntro fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kDataSex fromDictionary:dict];
            self.email = [self objectOrNilForKey:kDataEmail fromDictionary:dict];
            self.area = [self objectOrNilForKey:kDataArea fromDictionary:dict];
            self.signupCollege = [self objectOrNilForKey:kDataSignupCollege fromDictionary:dict];
            self.domain = [self objectOrNilForKey:kDataDomain fromDictionary:dict];
            self.city = [self objectOrNilForKey:kDataCity fromDictionary:dict];
            self.isActive = [self objectOrNilForKey:kDataIsActive fromDictionary:dict];
            self.searchKey = [self objectOrNilForKey:kDataSearchKey fromDictionary:dict];
            self.province = [self objectOrNilForKey:kDataProvince fromDictionary:dict];
            self.lastLoginTime = [self objectOrNilForKey:kDataLastLoginTime fromDictionary:dict];
            self.inviteCode = [self objectOrNilForKey:kDataInviteCode fromDictionary:dict];
            self.apiKey = [self objectOrNilForKey:kDataApiKey fromDictionary:dict];
            self.findStudyLevel = [self objectOrNilForKey:kDataFindStudyLevel fromDictionary:dict];
            self.phoneActivate = [self objectOrNilForKey:kDataPhoneActivate fromDictionary:dict];
            self.mailActivate = [self objectOrNilForKey:kDataMailActivate fromDictionary:dict];
            self.identity = [self objectOrNilForKey:kDataIdentity fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kDataPhone fromDictionary:dict];
            self.myStudyLevel = [self objectOrNilForKey:kDataMyStudyLevel fromDictionary:dict];
            self.timezone = [self objectOrNilForKey:kDataTimezone fromDictionary:dict];
            self.studyPhase = [self objectOrNilForKey:kDataStudyPhase fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ctime forKey:kDataCtime];
    [mutableDict setValue:self.feedEmailTime forKey:kDataFeedEmailTime];
    [mutableDict setValue:self.uid forKey:kDataUid];
    [mutableDict setValue:self.login forKey:kDataLogin];
//    [mutableDict setValue:self.oauthToken forKey:kDataOauthToken];
    [mutableDict setValue:self.profession forKey:kDataProfession];
    [mutableDict setValue:self.myCollege forKey:kDataMyCollege];
//    [mutableDict setValue:self.firstLetter forKey:kDataFirstLetter];
    [mutableDict setValue:self.lastFeedId forKey:kDataLastFeedId];
    [mutableDict setValue:self.uname forKey:kDataUname];
    
    [mutableDict setValue:self.upwd forKey:kDataUpwd];
    
    [mutableDict setValue:self.location forKey:kDataLocation];
    [mutableDict setValue:self.lang forKey:kDataLang];
    [mutableDict setValue:self.sendEmailTime forKey:kDataSendEmailTime];
    [mutableDict setValue:self.regIp forKey:kDataRegIp];
    [mutableDict setValue:self.userface forKey:kDataUserface];
    [mutableDict setValue:self.isDel forKey:kDataIsDel];
    [mutableDict setValue:self.isAudit forKey:kDataIsAudit];
    [mutableDict setValue:self.lastPostTime forKey:kDataLastPostTime];
    [mutableDict setValue:self.isInit forKey:kDataIsInit];
//    [mutableDict setValue:self.oauthTokenSecret forKey:kDataOauthTokenSecret];
    [mutableDict setValue:self.intro forKey:kDataIntro];
    [mutableDict setValue:self.sex forKey:kDataSex];
    [mutableDict setValue:self.email forKey:kDataEmail];
    [mutableDict setValue:self.area forKey:kDataArea];
    [mutableDict setValue:self.signupCollege forKey:kDataSignupCollege];
    [mutableDict setValue:self.domain forKey:kDataDomain];
    [mutableDict setValue:self.city forKey:kDataCity];
    [mutableDict setValue:self.isActive forKey:kDataIsActive];
    [mutableDict setValue:self.searchKey forKey:kDataSearchKey];
    [mutableDict setValue:self.province forKey:kDataProvince];
    [mutableDict setValue:self.lastLoginTime forKey:kDataLastLoginTime];
    [mutableDict setValue:self.inviteCode forKey:kDataInviteCode];
    [mutableDict setValue:self.apiKey forKey:kDataApiKey];
    [mutableDict setValue:self.findStudyLevel forKey:kDataFindStudyLevel];
    [mutableDict setValue:self.phoneActivate forKey:kDataPhoneActivate];
    [mutableDict setValue:self.mailActivate forKey:kDataMailActivate];
    [mutableDict setValue:self.identity forKey:kDataIdentity];
    [mutableDict setValue:self.phone forKey:kDataPhone];
    [mutableDict setValue:self.myStudyLevel forKey:kDataMyStudyLevel];
    [mutableDict setValue:self.timezone forKey:kDataTimezone];
    [mutableDict setValue:self.studyPhase forKey:kDataStudyPhase];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.ctime = [aDecoder decodeObjectForKey:kDataCtime];
    self.feedEmailTime = [aDecoder decodeObjectForKey:kDataFeedEmailTime];
    self.uid = [aDecoder decodeObjectForKey:kDataUid];
    self.login = [aDecoder decodeObjectForKey:kDataLogin];
    self.oauthToken = [aDecoder decodeObjectForKey:kDataOauthToken];
    self.profession = [aDecoder decodeObjectForKey:kDataProfession];
    self.myCollege = [aDecoder decodeObjectForKey:kDataMyCollege];
    self.firstLetter = [aDecoder decodeObjectForKey:kDataFirstLetter];
    self.lastFeedId = [aDecoder decodeObjectForKey:kDataLastFeedId];
    self.uname = [aDecoder decodeObjectForKey:kDataUname];
    
    self.upwd = [aDecoder decodeObjectForKey:kDataUpwd];

    self.location = [aDecoder decodeObjectForKey:kDataLocation];
    self.lang = [aDecoder decodeObjectForKey:kDataLang];
    self.sendEmailTime = [aDecoder decodeObjectForKey:kDataSendEmailTime];
    self.regIp = [aDecoder decodeObjectForKey:kDataRegIp];
    self.userface = [aDecoder decodeObjectForKey:kDataUserface];
    self.isDel = [aDecoder decodeObjectForKey:kDataIsDel];
    self.isAudit = [aDecoder decodeObjectForKey:kDataIsAudit];
    self.lastPostTime = [aDecoder decodeObjectForKey:kDataLastPostTime];
    self.isInit = [aDecoder decodeObjectForKey:kDataIsInit];
    self.oauthTokenSecret = [aDecoder decodeObjectForKey:kDataOauthTokenSecret];
    self.intro = [aDecoder decodeObjectForKey:kDataIntro];
    self.sex = [aDecoder decodeObjectForKey:kDataSex];
    self.email = [aDecoder decodeObjectForKey:kDataEmail];
    self.area = [aDecoder decodeObjectForKey:kDataArea];
    self.signupCollege = [aDecoder decodeObjectForKey:kDataSignupCollege];
    self.domain = [aDecoder decodeObjectForKey:kDataDomain];
    self.city = [aDecoder decodeObjectForKey:kDataCity];
    self.isActive = [aDecoder decodeObjectForKey:kDataIsActive];
    self.searchKey = [aDecoder decodeObjectForKey:kDataSearchKey];
    self.province = [aDecoder decodeObjectForKey:kDataProvince];
    self.lastLoginTime = [aDecoder decodeObjectForKey:kDataLastLoginTime];
    self.inviteCode = [aDecoder decodeObjectForKey:kDataInviteCode];
    self.apiKey = [aDecoder decodeObjectForKey:kDataApiKey];
    self.findStudyLevel = [aDecoder decodeObjectForKey:kDataFindStudyLevel];
    self.phoneActivate = [aDecoder decodeObjectForKey:kDataPhoneActivate];
    self.mailActivate = [aDecoder decodeObjectForKey:kDataMailActivate];
    self.identity = [aDecoder decodeObjectForKey:kDataIdentity];
    self.phone = [aDecoder decodeObjectForKey:kDataPhone];
    self.myStudyLevel = [aDecoder decodeObjectForKey:kDataMyStudyLevel];
    self.timezone = [aDecoder decodeObjectForKey:kDataTimezone];
    self.studyPhase = [aDecoder decodeObjectForKey:kDataStudyPhase];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ctime forKey:kDataCtime];
    [aCoder encodeObject:_feedEmailTime forKey:kDataFeedEmailTime];
    [aCoder encodeObject:_uid forKey:kDataUid];
    [aCoder encodeObject:_login forKey:kDataLogin];
    [aCoder encodeObject:_oauthToken forKey:kDataOauthToken];
    [aCoder encodeObject:_profession forKey:kDataProfession];
    [aCoder encodeObject:_myCollege forKey:kDataMyCollege];
    [aCoder encodeObject:_firstLetter forKey:kDataFirstLetter];
    [aCoder encodeObject:_lastFeedId forKey:kDataLastFeedId];
    [aCoder encodeObject:_uname forKey:kDataUname];
    
    [aCoder encodeObject:_upwd forKey:kDataUpwd];
    
    [aCoder encodeObject:_location forKey:kDataLocation];
    [aCoder encodeObject:_lang forKey:kDataLang];
    [aCoder encodeObject:_sendEmailTime forKey:kDataSendEmailTime];
    [aCoder encodeObject:_regIp forKey:kDataRegIp];
    [aCoder encodeObject:_userface forKey:kDataUserface];
    [aCoder encodeObject:_isDel forKey:kDataIsDel];
    [aCoder encodeObject:_isAudit forKey:kDataIsAudit];
    [aCoder encodeObject:_lastPostTime forKey:kDataLastPostTime];
    [aCoder encodeObject:_isInit forKey:kDataIsInit];
    [aCoder encodeObject:_oauthTokenSecret forKey:kDataOauthTokenSecret];
    [aCoder encodeObject:_intro forKey:kDataIntro];
    [aCoder encodeObject:_sex forKey:kDataSex];
    [aCoder encodeObject:_email forKey:kDataEmail];
    [aCoder encodeObject:_area forKey:kDataArea];
    [aCoder encodeObject:_signupCollege forKey:kDataSignupCollege];
    [aCoder encodeObject:_domain forKey:kDataDomain];
    [aCoder encodeObject:_city forKey:kDataCity];
    [aCoder encodeObject:_isActive forKey:kDataIsActive];
    [aCoder encodeObject:_searchKey forKey:kDataSearchKey];
    [aCoder encodeObject:_province forKey:kDataProvince];
    [aCoder encodeObject:_lastLoginTime forKey:kDataLastLoginTime];
    [aCoder encodeObject:_inviteCode forKey:kDataInviteCode];
    [aCoder encodeObject:_apiKey forKey:kDataApiKey];
    [aCoder encodeObject:_findStudyLevel forKey:kDataFindStudyLevel];
    [aCoder encodeObject:_phoneActivate forKey:kDataPhoneActivate];
    [aCoder encodeObject:_mailActivate forKey:kDataMailActivate];
    [aCoder encodeObject:_identity forKey:kDataIdentity];
    [aCoder encodeObject:_phone forKey:kDataPhone];
    [aCoder encodeObject:_myStudyLevel forKey:kDataMyStudyLevel];
    [aCoder encodeObject:_timezone forKey:kDataTimezone];
    [aCoder encodeObject:_studyPhase forKey:kDataStudyPhase];
}

- (id)copyWithZone:(NSZone *)zone
{
    Data *copy = [[Data alloc] init];
    
    if (copy) {

        copy.ctime = [self.ctime copyWithZone:zone];
        copy.feedEmailTime = [self.feedEmailTime copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.login = [self.login copyWithZone:zone];
        copy.oauthToken = [self.oauthToken copyWithZone:zone];
        copy.profession = [self.profession copyWithZone:zone];
        copy.myCollege = [self.myCollege copyWithZone:zone];
        copy.firstLetter = [self.firstLetter copyWithZone:zone];
        copy.lastFeedId = [self.lastFeedId copyWithZone:zone];
        copy.uname = [self.uname copyWithZone:zone];
        
        copy.upwd = [self.upwd copyWithZone:zone];
        
        copy.location = [self.location copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.sendEmailTime = [self.sendEmailTime copyWithZone:zone];
        copy.regIp = [self.regIp copyWithZone:zone];
        copy.userface = [self.userface copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.isAudit = [self.isAudit copyWithZone:zone];
        copy.lastPostTime = [self.lastPostTime copyWithZone:zone];
        copy.isInit = [self.isInit copyWithZone:zone];
        copy.oauthTokenSecret = [self.oauthTokenSecret copyWithZone:zone];
        copy.intro = [self.intro copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
        copy.signupCollege = [self.signupCollege copyWithZone:zone];
        copy.domain = [self.domain copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.isActive = [self.isActive copyWithZone:zone];
        copy.searchKey = [self.searchKey copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.lastLoginTime = [self.lastLoginTime copyWithZone:zone];
        copy.inviteCode = [self.inviteCode copyWithZone:zone];
        copy.apiKey = [self.apiKey copyWithZone:zone];
        copy.findStudyLevel = [self.findStudyLevel copyWithZone:zone];
        copy.phoneActivate = [self.phoneActivate copyWithZone:zone];
        copy.mailActivate = [self.mailActivate copyWithZone:zone];
        copy.identity = [self.identity copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.myStudyLevel = [self.myStudyLevel copyWithZone:zone];
        copy.timezone = [self.timezone copyWithZone:zone];
        copy.studyPhase = [self.studyPhase copyWithZone:zone];
    }
    
    return copy;
}


@end
