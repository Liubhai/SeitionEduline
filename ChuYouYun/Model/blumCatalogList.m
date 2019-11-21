//
//  blumCatalogList.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "blumCatalogList.h"

NSString * const kBlumCatalogId=@"id";
NSString * const kBlumCatalogTitle = @"video_title";

@interface blumCatalogList()
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

@implementation blumCatalogList
@synthesize classId = _classId;
@synthesize classTitle = _classTitle;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dicts
{
    return [[self alloc] initWithDictionary:dicts];
}
- (instancetype)initWithDictionarys:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.classId = [self objectOrNilForKeys: kBlumCatalogId fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.classTitle = [self objectOrNilForKeys:kBlumCatalogTitle fromDictionary:dict];
        
        
    }
    
    return self;
    
}

- (NSDictionary *)DictionaryRepresentation
{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.classId forKey:kBlumCatalogId];
    [mutableDict setValue:self.classTitle forKey:kBlumCatalogTitle];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self DictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.classId = [aDecoder decodeObjectForKey:kBlumCatalogId];
    self.classTitle = [aDecoder decodeObjectForKey:kBlumCatalogTitle];
    
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_classTitle forKey:kBlumCatalogTitle];
    [aCoder encodeObject:_classId forKey:kBlumCatalogId];
   
    
}

- (id)copyWithZone:(NSZone *)zone
{
    blumCatalogList *copy = [[blumCatalogList alloc] init];
    
    if (copy) {
        
        copy.classId = [self.classId copyWithZone:zone];
        copy.classTitle = [self.classTitle copyWithZone:zone];
        
        
        
    }
    
    return copy;
}





@end
