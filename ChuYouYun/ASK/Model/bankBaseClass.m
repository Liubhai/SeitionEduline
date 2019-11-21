//
//  bankBaseClass.m
//
//  Created by 志强 林 on 15/2/10
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "bankBaseClass.h"


NSString *const kbankBaseClassAccount = @"account";
NSString *const kbankBaseClassArea = @"area";
NSString *const kbankBaseClassUid = @"uid";
NSString *const kbankBaseClassId = @"id";
NSString *const kbankBaseClassCity = @"city";
NSString *const kbankBaseClassLocation = @"location";
NSString *const kbankBaseClassBankofdeposit = @"bankofdeposit";
NSString *const kbankBaseClassTelNum = @"tel_num";
NSString *const kbankBaseClassAccountmaster = @"accountmaster";
NSString *const kbankBaseClassAccounttype = @"accounttype";
NSString *const kbankBaseClassProvince = @"province";


@interface bankBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation bankBaseClass

@synthesize account = _account;
@synthesize area = _area;
@synthesize uid = _uid;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize city = _city;
@synthesize location = _location;
@synthesize bankofdeposit = _bankofdeposit;
@synthesize telNum = _telNum;
@synthesize accountmaster = _accountmaster;
@synthesize accounttype = _accounttype;
@synthesize province = _province;


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
            self.account = [self objectOrNilForKey:kbankBaseClassAccount fromDictionary:dict];
            self.area = [self objectOrNilForKey:kbankBaseClassArea fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kbankBaseClassUid fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kbankBaseClassId fromDictionary:dict];
            self.city = [self objectOrNilForKey:kbankBaseClassCity fromDictionary:dict];
            self.location = [self objectOrNilForKey:kbankBaseClassLocation fromDictionary:dict];
            self.bankofdeposit = [self objectOrNilForKey:kbankBaseClassBankofdeposit fromDictionary:dict];
            self.telNum = [self objectOrNilForKey:kbankBaseClassTelNum fromDictionary:dict];
            self.accountmaster = [self objectOrNilForKey:kbankBaseClassAccountmaster fromDictionary:dict];
            self.accounttype = [self objectOrNilForKey:kbankBaseClassAccounttype fromDictionary:dict];
            self.province = [self objectOrNilForKey:kbankBaseClassProvince fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.account forKey:kbankBaseClassAccount];
    [mutableDict setValue:self.area forKey:kbankBaseClassArea];
    [mutableDict setValue:self.uid forKey:kbankBaseClassUid];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kbankBaseClassId];
    [mutableDict setValue:self.city forKey:kbankBaseClassCity];
    [mutableDict setValue:self.location forKey:kbankBaseClassLocation];
    [mutableDict setValue:self.bankofdeposit forKey:kbankBaseClassBankofdeposit];
    [mutableDict setValue:self.telNum forKey:kbankBaseClassTelNum];
    [mutableDict setValue:self.accountmaster forKey:kbankBaseClassAccountmaster];
    [mutableDict setValue:self.accounttype forKey:kbankBaseClassAccounttype];
    [mutableDict setValue:self.province forKey:kbankBaseClassProvince];

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

    self.account = [aDecoder decodeObjectForKey:kbankBaseClassAccount];
    self.area = [aDecoder decodeObjectForKey:kbankBaseClassArea];
    self.uid = [aDecoder decodeObjectForKey:kbankBaseClassUid];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kbankBaseClassId];
    self.city = [aDecoder decodeObjectForKey:kbankBaseClassCity];
    self.location = [aDecoder decodeObjectForKey:kbankBaseClassLocation];
    self.bankofdeposit = [aDecoder decodeObjectForKey:kbankBaseClassBankofdeposit];
    self.telNum = [aDecoder decodeObjectForKey:kbankBaseClassTelNum];
    self.accountmaster = [aDecoder decodeObjectForKey:kbankBaseClassAccountmaster];
    self.accounttype = [aDecoder decodeObjectForKey:kbankBaseClassAccounttype];
    self.province = [aDecoder decodeObjectForKey:kbankBaseClassProvince];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_account forKey:kbankBaseClassAccount];
    [aCoder encodeObject:_area forKey:kbankBaseClassArea];
    [aCoder encodeObject:_uid forKey:kbankBaseClassUid];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kbankBaseClassId];
    [aCoder encodeObject:_city forKey:kbankBaseClassCity];
    [aCoder encodeObject:_location forKey:kbankBaseClassLocation];
    [aCoder encodeObject:_bankofdeposit forKey:kbankBaseClassBankofdeposit];
    [aCoder encodeObject:_telNum forKey:kbankBaseClassTelNum];
    [aCoder encodeObject:_accountmaster forKey:kbankBaseClassAccountmaster];
    [aCoder encodeObject:_accounttype forKey:kbankBaseClassAccounttype];
    [aCoder encodeObject:_province forKey:kbankBaseClassProvince];
}

- (id)copyWithZone:(NSZone *)zone
{
    bankBaseClass *copy = [[bankBaseClass alloc] init];
    
    if (copy) {

        copy.account = [self.account copyWithZone:zone];
        copy.area = [self.area copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.location = [self.location copyWithZone:zone];
        copy.bankofdeposit = [self.bankofdeposit copyWithZone:zone];
        copy.telNum = [self.telNum copyWithZone:zone];
        copy.accountmaster = [self.accountmaster copyWithZone:zone];
        copy.accounttype = [self.accounttype copyWithZone:zone];
        copy.province = [self.province copyWithZone:zone];
    }
    
    return copy;
}


@end
