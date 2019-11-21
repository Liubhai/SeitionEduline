//
//  categoryList.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "categoryList.h"
NSString * const kcategoryID = @"zy_video_category_id";
NSString * const kcategoryPid = @"pid";
NSString * const kcategoryTitle = @"title";
@interface categoryList()
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

@implementation categoryList
@synthesize category_pid = _category_pid;
@synthesize categoryId = _categoryId;
@synthesize Category_title = _Category_title;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dicts
{
    return [[self alloc] initWithDictionary:dicts];
}

- (instancetype)initWithDictionarys:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.categoryId = [self objectOrNilForKeys: kcategoryID fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.category_pid = [self objectOrNilForKeys:kcategoryPid fromDictionary:dict];
        self.Category_title = [self objectOrNilForKeys:kcategoryTitle fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)DictionaryRepresentation
{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.category_pid forKey:kcategoryPid];
    [mutableDict setValue:self.categoryId forKey:kcategoryID];
    [mutableDict setValue:self.Category_title forKey:kcategoryTitle];

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
    
    self.categoryId = [aDecoder decodeObjectForKey:kcategoryID];
    self.category_pid = [aDecoder decodeObjectForKey:kcategoryPid];
    self.Category_title = [aDecoder decodeObjectForKey:kcategoryTitle];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_categoryId forKey:kcategoryID];
    [aCoder encodeObject:_category_pid forKey:kcategoryPid];
    [aCoder encodeObject:_Category_title forKey:kcategoryTitle];

}

- (id)copyWithZone:(NSZone *)zone
{
    categoryList *copy = [[categoryList alloc] init];
    
    if (copy) {
        
        copy.category_pid = [self.category_pid copyWithZone:zone];
        copy.categoryId = [self.categoryId copyWithZone:zone];
        copy.Category_title = [self.Category_title copyWithZone:zone];
    }
    return copy;
}

@end
