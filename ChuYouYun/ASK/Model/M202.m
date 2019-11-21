//
//  M202.m
//
//  Created by 志强 林 on 15/2/11
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "M202.h"


NSString *const kM202Ctime = @"ctime";
NSString *const kM202FeedEmailTime = @"feed_email_time";
NSString *const kM202Uid = @"uid";
NSString *const kM202Login = @"login";
NSString *const kM202Profession = @"profession";
NSString *const kM202Medals = @"medals";
NSString *const kM202MyCollege = @"my_college";
NSString *const kM202FirstLetter = @"first_letter";
NSString *const kM202LastFeedId = @"last_feed_id";
NSString *const kM202UserGroup = @"user_group";
NSString *const kM202Uname = @"uname";
NSString *const kM202Location = @"location";
NSString *const kM202Lang = @"lang";
NSString *const kM202LoginSalt = @"login_salt";
NSString *const kM202GroupIcon = @"group_icon";
NSString *const kM202SendEmailTime = @"send_email_time";
NSString *const kM202RegIp = @"reg_ip";
NSString *const kM202IsDel = @"is_del";
NSString *const kM202IsAudit = @"is_audit";
NSString *const kM202ApiUserGroup = @"api_user_group";
NSString *const kM202IsInit = @"is_init";
NSString *const kM202AvatarOriginal = @"avatar_original";
NSString *const kM202LastPostTime = @"last_post_time";
NSString *const kM202Intro = @"intro";
NSString *const kM202AvatarUrl = @"avatar_url";
NSString *const kM202AvatarSmall = @"avatar_small";
NSString *const kM202Sex = @"sex";
NSString *const kM202Email = @"email";
NSString *const kM202Area = @"area";
NSString *const kM202SpaceLink = @"space_link";
NSString *const kM202SignupCollege = @"signup_college";
NSString *const kM202Domain = @"domain";
NSString *const kM202City = @"city";
NSString *const kM202SpaceUrl = @"space_url";
NSString *const kM202IsActive = @"is_active";
NSString *const kM202SearchKey = @"search_key";
NSString *const kM202Province = @"province";
NSString *const kM202AvatarBig = @"avatar_big";
NSString *const kM202LastLoginTime = @"last_login_time";
NSString *const kM202InviteCode = @"invite_code";
NSString *const kM202ApiKey = @"api_key";
NSString *const kM202FindStudyLevel = @"find_study_level";
NSString *const kM202PhoneActivate = @"phone_activate";
NSString *const kM202MailActivate = @"mail_activate";
NSString *const kM202AvatarTiny = @"avatar_tiny";
NSString *const kM202SpaceLinkNo = @"space_link_no";
NSString *const kM202Identity = @"identity";
NSString *const kM202Phone = @"phone";
NSString *const kM202MyStudyLevel = @"my_study_level";
NSString *const kM202Timezone = @"timezone";
NSString *const kM202StudyPhase = @"study_phase";
NSString *const kM202AvatarMiddle = @"avatar_middle";


@interface M202 ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation M202

@synthesize ctime = _ctime;
@synthesize feedEmailTime = _feedEmailTime;
@synthesize uid = _uid;
@synthesize login = _login;
@synthesize profession = _profession;
@synthesize medals = _medals;
@synthesize myCollege = _myCollege;
@synthesize firstLetter = _firstLetter;
@synthesize lastFeedId = _lastFeedId;
@synthesize userGroup = _userGroup;
@synthesize uname = _uname;
@synthesize location = _location;
@synthesize lang = _lang;
@synthesize loginSalt = _loginSalt;
@synthesize groupIcon = _groupIcon;
@synthesize sendEmailTime = _sendEmailTime;
@synthesize regIp = _regIp;
@synthesize isDel = _isDel;
@synthesize isAudit = _isAudit;
@synthesize apiUserGroup = _apiUserGroup;
@synthesize isInit = _isInit;
@synthesize avatarOriginal = _avatarOriginal;
@synthesize lastPostTime = _lastPostTime;
@synthesize intro = _intro;
@synthesize avatarUrl = _avatarUrl;
@synthesize avatarSmall = _avatarSmall;
@synthesize sex = _sex;
@synthesize email = _email;
@synthesize area = _area;
@synthesize spaceLink = _spaceLink;
@synthesize signupCollege = _signupCollege;
@synthesize domain = _domain;
@synthesize city = _city;
@synthesize spaceUrl = _spaceUrl;
@synthesize isActive = _isActive;
@synthesize searchKey = _searchKey;
@synthesize province = _province;
@synthesize avatarBig = _avatarBig;
@synthesize lastLoginTime = _lastLoginTime;
@synthesize inviteCode = _inviteCode;
@synthesize apiKey = _apiKey;
@synthesize findStudyLevel = _findStudyLevel;
@synthesize phoneActivate = _phoneActivate;
@synthesize mailActivate = _mailActivate;
@synthesize avatarTiny = _avatarTiny;
@synthesize spaceLinkNo = _spaceLinkNo;
@synthesize identity = _identity;
@synthesize phone = _phone;
@synthesize myStudyLevel = _myStudyLevel;
@synthesize timezone = _timezone;
@synthesize studyPhase = _studyPhase;
@synthesize avatarMiddle = _avatarMiddle;


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
            self.ctime = [self objectOrNilForKey:kM202Ctime fromDictionary:dict];
            self.feedEmailTime = [self objectOrNilForKey:kM202FeedEmailTime fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kM202Uid fromDictionary:dict];
            self.login = [self objectOrNilForKey:kM202Login fromDictionary:dict];
            self.profession = [self objectOrNilForKey:kM202Profession fromDictionary:dict];
            self.medals = [self objectOrNilForKey:kM202Medals fromDictionary:dict];
            self.myCollege = [self objectOrNilForKey:kM202MyCollege fromDictionary:dict];
            self.firstLetter = [self objectOrNilForKey:kM202FirstLetter fromDictionary:dict];
            self.lastFeedId = [self objectOrNilForKey:kM202LastFeedId fromDictionary:dict];
            self.userGroup = [self objectOrNilForKey:kM202UserGroup fromDictionary:dict];
            self.uname = [self objectOrNilForKey:kM202Uname fromDictionary:dict];
            self.location = [self objectOrNilForKey:kM202Location fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kM202Lang fromDictionary:dict];
            self.loginSalt = [self objectOrNilForKey:kM202LoginSalt fromDictionary:dict];
            self.groupIcon = [self objectOrNilForKey:kM202GroupIcon fromDictionary:dict];
            self.sendEmailTime = [self objectOrNilForKey:kM202SendEmailTime fromDictionary:dict];
            self.regIp = [self objectOrNilForKey:kM202RegIp fromDictionary:dict];
            self.isDel = [self objectOrNilForKey:kM202IsDel fromDictionary:dict];
            self.isAudit = [self objectOrNilForKey:kM202IsAudit fromDictionary:dict];
            self.apiUserGroup = [self objectOrNilForKey:kM202ApiUserGroup fromDictionary:dict];
            self.isInit = [self objectOrNilForKey:kM202IsInit fromDictionary:dict];
            self.avatarOriginal = [self objectOrNilForKey:kM202AvatarOriginal fromDictionary:dict];
            self.lastPostTime = [self objectOrNilForKey:kM202LastPostTime fromDictionary:dict];
            self.intro = [self objectOrNilForKey:kM202Intro fromDictionary:dict];
            self.avatarUrl = [self objectOrNilForKey:kM202AvatarUrl fromDictionary:dict];
            self.avatarSmall = [self objectOrNilForKey:kM202AvatarSmall fromDictionary:dict];
            self.sex = [self objectOrNilForKey:kM202Sex fromDictionary:dict];
            self.email = [self objectOrNilForKey:kM202Email fromDictionary:dict];
            self.area = [self objectOrNilForKey:kM202Area fromDictionary:dict];
            self.spaceLink = [self objectOrNilForKey:kM202SpaceLink fromDictionary:dict];
            self.signupCollege = [self objectOrNilForKey:kM202SignupCollege fromDictionary:dict];
            self.domain = [self objectOrNilForKey:kM202Domain fromDictionary:dict];
            self.city = [self objectOrNilForKey:kM202City fromDictionary:dict];
            self.spaceUrl = [self objectOrNilForKey:kM202SpaceUrl fromDictionary:dict];
            self.isActive = [self objectOrNilForKey:kM202IsActive fromDictionary:dict];
            self.searchKey = [self objectOrNilForKey:kM202SearchKey fromDictionary:dict];
            self.province = [self objectOrNilForKey:kM202Province fromDictionary:dict];
            self.avatarBig = [self objectOrNilForKey:kM202AvatarBig fromDictionary:dict];
            self.lastLoginTime = [self objectOrNilForKey:kM202LastLoginTime fromDictionary:dict];
            self.inviteCode = [self objectOrNilForKey:kM202InviteCode fromDictionary:dict];
            self.apiKey = [self objectOrNilForKey:kM202ApiKey fromDictionary:dict];
            self.findStudyLevel = [self objectOrNilForKey:kM202FindStudyLevel fromDictionary:dict];
            self.phoneActivate = [self objectOrNilForKey:kM202PhoneActivate fromDictionary:dict];
            self.mailActivate = [self objectOrNilForKey:kM202MailActivate fromDictionary:dict];
            self.avatarTiny = [self objectOrNilForKey:kM202AvatarTiny fromDictionary:dict];
            self.spaceLinkNo = [self objectOrNilForKey:kM202SpaceLinkNo fromDictionary:dict];
            self.identity = [self objectOrNilForKey:kM202Identity fromDictionary:dict];
            self.phone = [self objectOrNilForKey:kM202Phone fromDictionary:dict];
            self.myStudyLevel = [self objectOrNilForKey:kM202MyStudyLevel fromDictionary:dict];
            self.timezone = [self objectOrNilForKey:kM202Timezone fromDictionary:dict];
            self.studyPhase = [self objectOrNilForKey:kM202StudyPhase fromDictionary:dict];
            self.avatarMiddle = [self objectOrNilForKey:kM202AvatarMiddle fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ctime forKey:kM202Ctime];
    [mutableDict setValue:self.feedEmailTime forKey:kM202FeedEmailTime];
    [mutableDict setValue:self.uid forKey:kM202Uid];
    [mutableDict setValue:self.login forKey:kM202Login];
    [mutableDict setValue:self.profession forKey:kM202Profession];
    NSMutableArray *tempArrayForMedals = [NSMutableArray array];
    for (NSObject *subArrayObject in self.medals) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMedals addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMedals addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMedals] forKey:kM202Medals];
    [mutableDict setValue:self.myCollege forKey:kM202MyCollege];
    [mutableDict setValue:self.firstLetter forKey:kM202FirstLetter];
    [mutableDict setValue:self.lastFeedId forKey:kM202LastFeedId];
    NSMutableArray *tempArrayForUserGroup = [NSMutableArray array];
    for (NSObject *subArrayObject in self.userGroup) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForUserGroup addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForUserGroup addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUserGroup] forKey:kM202UserGroup];
    [mutableDict setValue:self.uname forKey:kM202Uname];
    [mutableDict setValue:self.location forKey:kM202Location];
    [mutableDict setValue:self.lang forKey:kM202Lang];
    [mutableDict setValue:self.loginSalt forKey:kM202LoginSalt];
    [mutableDict setValue:self.groupIcon forKey:kM202GroupIcon];
    [mutableDict setValue:self.sendEmailTime forKey:kM202SendEmailTime];
    [mutableDict setValue:self.regIp forKey:kM202RegIp];
    [mutableDict setValue:self.isDel forKey:kM202IsDel];
    [mutableDict setValue:self.isAudit forKey:kM202IsAudit];
    NSMutableArray *tempArrayForApiUserGroup = [NSMutableArray array];
    for (NSObject *subArrayObject in self.apiUserGroup) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForApiUserGroup addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForApiUserGroup addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForApiUserGroup] forKey:kM202ApiUserGroup];
    [mutableDict setValue:self.isInit forKey:kM202IsInit];
    [mutableDict setValue:self.avatarOriginal forKey:kM202AvatarOriginal];
    [mutableDict setValue:self.lastPostTime forKey:kM202LastPostTime];
    [mutableDict setValue:self.intro forKey:kM202Intro];
    [mutableDict setValue:self.avatarUrl forKey:kM202AvatarUrl];
    [mutableDict setValue:self.avatarSmall forKey:kM202AvatarSmall];
    [mutableDict setValue:self.sex forKey:kM202Sex];
    [mutableDict setValue:self.email forKey:kM202Email];
    [mutableDict setValue:self.area forKey:kM202Area];
    [mutableDict setValue:self.spaceLink forKey:kM202SpaceLink];
    [mutableDict setValue:self.signupCollege forKey:kM202SignupCollege];
    [mutableDict setValue:self.domain forKey:kM202Domain];
    [mutableDict setValue:self.city forKey:kM202City];
    [mutableDict setValue:self.spaceUrl forKey:kM202SpaceUrl];
    [mutableDict setValue:self.isActive forKey:kM202IsActive];
    [mutableDict setValue:self.searchKey forKey:kM202SearchKey];
    [mutableDict setValue:self.province forKey:kM202Province];
    [mutableDict setValue:self.avatarBig forKey:kM202AvatarBig];
    [mutableDict setValue:self.lastLoginTime forKey:kM202LastLoginTime];
    [mutableDict setValue:self.inviteCode forKey:kM202InviteCode];
    [mutableDict setValue:self.apiKey forKey:kM202ApiKey];
    [mutableDict setValue:self.findStudyLevel forKey:kM202FindStudyLevel];
    [mutableDict setValue:self.phoneActivate forKey:kM202PhoneActivate];
    [mutableDict setValue:self.mailActivate forKey:kM202MailActivate];
    [mutableDict setValue:self.avatarTiny forKey:kM202AvatarTiny];
    [mutableDict setValue:self.spaceLinkNo forKey:kM202SpaceLinkNo];
    [mutableDict setValue:self.identity forKey:kM202Identity];
    [mutableDict setValue:self.phone forKey:kM202Phone];
    [mutableDict setValue:self.myStudyLevel forKey:kM202MyStudyLevel];
    [mutableDict setValue:self.timezone forKey:kM202Timezone];
    [mutableDict setValue:self.studyPhase forKey:kM202StudyPhase];
    [mutableDict setValue:self.avatarMiddle forKey:kM202AvatarMiddle];

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

    self.ctime = [aDecoder decodeObjectForKey:kM202Ctime];
    self.feedEmailTime = [aDecoder decodeObjectForKey:kM202FeedEmailTime];
    self.uid = [aDecoder decodeObjectForKey:kM202Uid];
    self.login = [aDecoder decodeObjectForKey:kM202Login];
    self.profession = [aDecoder decodeObjectForKey:kM202Profession];
    self.medals = [aDecoder decodeObjectForKey:kM202Medals];
    self.myCollege = [aDecoder decodeObjectForKey:kM202MyCollege];
    self.firstLetter = [aDecoder decodeObjectForKey:kM202FirstLetter];
    self.lastFeedId = [aDecoder decodeObjectForKey:kM202LastFeedId];
    self.userGroup = [aDecoder decodeObjectForKey:kM202UserGroup];
    self.uname = [aDecoder decodeObjectForKey:kM202Uname];
    self.location = [aDecoder decodeObjectForKey:kM202Location];
    self.lang = [aDecoder decodeObjectForKey:kM202Lang];
    self.loginSalt = [aDecoder decodeObjectForKey:kM202LoginSalt];
    self.groupIcon = [aDecoder decodeObjectForKey:kM202GroupIcon];
    self.sendEmailTime = [aDecoder decodeObjectForKey:kM202SendEmailTime];
    self.regIp = [aDecoder decodeObjectForKey:kM202RegIp];
    self.isDel = [aDecoder decodeObjectForKey:kM202IsDel];
    self.isAudit = [aDecoder decodeObjectForKey:kM202IsAudit];
    self.apiUserGroup = [aDecoder decodeObjectForKey:kM202ApiUserGroup];
    self.isInit = [aDecoder decodeObjectForKey:kM202IsInit];
    self.avatarOriginal = [aDecoder decodeObjectForKey:kM202AvatarOriginal];
    self.lastPostTime = [aDecoder decodeObjectForKey:kM202LastPostTime];
    self.intro = [aDecoder decodeObjectForKey:kM202Intro];
    self.avatarUrl = [aDecoder decodeObjectForKey:kM202AvatarUrl];
    self.avatarSmall = [aDecoder decodeObjectForKey:kM202AvatarSmall];
    self.sex = [aDecoder decodeObjectForKey:kM202Sex];
    self.email = [aDecoder decodeObjectForKey:kM202Email];
    self.area = [aDecoder decodeObjectForKey:kM202Area];
    self.spaceLink = [aDecoder decodeObjectForKey:kM202SpaceLink];
    self.signupCollege = [aDecoder decodeObjectForKey:kM202SignupCollege];
    self.domain = [aDecoder decodeObjectForKey:kM202Domain];
    self.city = [aDecoder decodeObjectForKey:kM202City];
    self.spaceUrl = [aDecoder decodeObjectForKey:kM202SpaceUrl];
    self.isActive = [aDecoder decodeObjectForKey:kM202IsActive];
    self.searchKey = [aDecoder decodeObjectForKey:kM202SearchKey];
    self.province = [aDecoder decodeObjectForKey:kM202Province];
    self.avatarBig = [aDecoder decodeObjectForKey:kM202AvatarBig];
    self.lastLoginTime = [aDecoder decodeObjectForKey:kM202LastLoginTime];
    self.inviteCode = [aDecoder decodeObjectForKey:kM202InviteCode];
    self.apiKey = [aDecoder decodeObjectForKey:kM202ApiKey];
    self.findStudyLevel = [aDecoder decodeObjectForKey:kM202FindStudyLevel];
    self.phoneActivate = [aDecoder decodeObjectForKey:kM202PhoneActivate];
    self.mailActivate = [aDecoder decodeObjectForKey:kM202MailActivate];
    self.avatarTiny = [aDecoder decodeObjectForKey:kM202AvatarTiny];
    self.spaceLinkNo = [aDecoder decodeObjectForKey:kM202SpaceLinkNo];
    self.identity = [aDecoder decodeObjectForKey:kM202Identity];
    self.phone = [aDecoder decodeObjectForKey:kM202Phone];
    self.myStudyLevel = [aDecoder decodeObjectForKey:kM202MyStudyLevel];
    self.timezone = [aDecoder decodeObjectForKey:kM202Timezone];
    self.studyPhase = [aDecoder decodeObjectForKey:kM202StudyPhase];
    self.avatarMiddle = [aDecoder decodeObjectForKey:kM202AvatarMiddle];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ctime forKey:kM202Ctime];
    [aCoder encodeObject:_feedEmailTime forKey:kM202FeedEmailTime];
    [aCoder encodeObject:_uid forKey:kM202Uid];
    [aCoder encodeObject:_login forKey:kM202Login];
    [aCoder encodeObject:_profession forKey:kM202Profession];
    [aCoder encodeObject:_medals forKey:kM202Medals];
    [aCoder encodeObject:_myCollege forKey:kM202MyCollege];
    [aCoder encodeObject:_firstLetter forKey:kM202FirstLetter];
    [aCoder encodeObject:_lastFeedId forKey:kM202LastFeedId];
    [aCoder encodeObject:_userGroup forKey:kM202UserGroup];
    [aCoder encodeObject:_uname forKey:kM202Uname];
    [aCoder encodeObject:_location forKey:kM202Location];
    [aCoder encodeObject:_lang forKey:kM202Lang];
    [aCoder encodeObject:_loginSalt forKey:kM202LoginSalt];
    [aCoder encodeObject:_groupIcon forKey:kM202GroupIcon];
    [aCoder encodeObject:_sendEmailTime forKey:kM202SendEmailTime];
    [aCoder encodeObject:_regIp forKey:kM202RegIp];
    [aCoder encodeObject:_isDel forKey:kM202IsDel];
    [aCoder encodeObject:_isAudit forKey:kM202IsAudit];
    [aCoder encodeObject:_apiUserGroup forKey:kM202ApiUserGroup];
    [aCoder encodeObject:_isInit forKey:kM202IsInit];
    [aCoder encodeObject:_avatarOriginal forKey:kM202AvatarOriginal];
    [aCoder encodeObject:_lastPostTime forKey:kM202LastPostTime];
    [aCoder encodeObject:_intro forKey:kM202Intro];
    [aCoder encodeObject:_avatarUrl forKey:kM202AvatarUrl];
    [aCoder encodeObject:_avatarSmall forKey:kM202AvatarSmall];
    [aCoder encodeObject:_sex forKey:kM202Sex];
    [aCoder encodeObject:_email forKey:kM202Email];
    [aCoder encodeObject:_area forKey:kM202Area];
    [aCoder encodeObject:_spaceLink forKey:kM202SpaceLink];
    [aCoder encodeObject:_signupCollege forKey:kM202SignupCollege];
    [aCoder encodeObject:_domain forKey:kM202Domain];
    [aCoder encodeObject:_city forKey:kM202City];
    [aCoder encodeObject:_spaceUrl forKey:kM202SpaceUrl];
    [aCoder encodeObject:_isActive forKey:kM202IsActive];
    [aCoder encodeObject:_searchKey forKey:kM202SearchKey];
    [aCoder encodeObject:_province forKey:kM202Province];
    [aCoder encodeObject:_avatarBig forKey:kM202AvatarBig];
    [aCoder encodeObject:_lastLoginTime forKey:kM202LastLoginTime];
    [aCoder encodeObject:_inviteCode forKey:kM202InviteCode];
    [aCoder encodeObject:_apiKey forKey:kM202ApiKey];
    [aCoder encodeObject:_findStudyLevel forKey:kM202FindStudyLevel];
    [aCoder encodeObject:_phoneActivate forKey:kM202PhoneActivate];
    [aCoder encodeObject:_mailActivate forKey:kM202MailActivate];
    [aCoder encodeObject:_avatarTiny forKey:kM202AvatarTiny];
    [aCoder encodeObject:_spaceLinkNo forKey:kM202SpaceLinkNo];
    [aCoder encodeObject:_identity forKey:kM202Identity];
    [aCoder encodeObject:_phone forKey:kM202Phone];
    [aCoder encodeObject:_myStudyLevel forKey:kM202MyStudyLevel];
    [aCoder encodeObject:_timezone forKey:kM202Timezone];
    [aCoder encodeObject:_studyPhase forKey:kM202StudyPhase];
    [aCoder encodeObject:_avatarMiddle forKey:kM202AvatarMiddle];
}

- (id)copyWithZone:(NSZone *)zone
{
    M202 *copy = [[M202 alloc] init];
    
    if (copy) {

        copy.ctime = [self.ctime copyWithZone:zone];
        copy.feedEmailTime = [self.feedEmailTime copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.login = [self.login copyWithZone:zone];
        copy.profession = [self.profession copyWithZone:zone];
        copy.medals = [self.medals copyWithZone:zone];
        copy.myCollege = [self.myCollege copyWithZone:zone];
        copy.firstLetter = [self.firstLetter copyWithZone:zone];
        copy.lastFeedId = [self.lastFeedId copyWithZone:zone];
        copy.userGroup = [self.userGroup copyWithZone:zone];
        copy.uname = [self.uname copyWithZone:zone];
        copy.location = [self.location copyWithZone:zone];
        copy.lang = [self.lang copyWithZone:zone];
        copy.loginSalt = [self.loginSalt copyWithZone:zone];
        copy.groupIcon = [self.groupIcon copyWithZone:zone];
        copy.sendEmailTime = [self.sendEmailTime copyWithZone:zone];
        copy.regIp = [self.regIp copyWithZone:zone];
        copy.isDel = [self.isDel copyWithZone:zone];
        copy.isAudit = [self.isAudit copyWithZone:zone];
        copy.apiUserGroup = [self.apiUserGroup copyWithZone:zone];
        copy.isInit = [self.isInit copyWithZone:zone];
        copy.avatarOriginal = [self.avatarOriginal copyWithZone:zone];
        copy.lastPostTime = [self.lastPostTime copyWithZone:zone];
        copy.intro = [self.intro copyWithZone:zone];
        copy.avatarUrl = [self.avatarUrl copyWithZone:zone];
        copy.avatarSmall = [self.avatarSmall copyWithZone:zone];
        copy.sex = [self.sex copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
        copy.spaceLink = [self.spaceLink copyWithZone:zone];
        copy.signupCollege = [self.signupCollege copyWithZone:zone];
        copy.domain = [self.domain copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.spaceUrl = [self.spaceUrl copyWithZone:zone];
        copy.isActive = [self.isActive copyWithZone:zone];
        copy.searchKey = [self.searchKey copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
        copy.avatarBig = [self.avatarBig copyWithZone:zone];
        copy.lastLoginTime = [self.lastLoginTime copyWithZone:zone];
        copy.inviteCode = [self.inviteCode copyWithZone:zone];
        copy.apiKey = [self.apiKey copyWithZone:zone];
        copy.findStudyLevel = [self.findStudyLevel copyWithZone:zone];
        copy.phoneActivate = [self.phoneActivate copyWithZone:zone];
        copy.mailActivate = [self.mailActivate copyWithZone:zone];
        copy.avatarTiny = [self.avatarTiny copyWithZone:zone];
        copy.spaceLinkNo = [self.spaceLinkNo copyWithZone:zone];
        copy.identity = [self.identity copyWithZone:zone];
        copy.phone = [self.phone copyWithZone:zone];
        copy.myStudyLevel = [self.myStudyLevel copyWithZone:zone];
        copy.timezone = [self.timezone copyWithZone:zone];
        copy.studyPhase = [self.studyPhase copyWithZone:zone];
        copy.avatarMiddle = [self.avatarMiddle copyWithZone:zone];
    }
    
    return copy;
}


@end
