//
//  blumCatalogList.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface blumCatalogList : NSObject

@property(nonatomic,retain)NSString * classId;
@property(nonatomic,retain)NSString * classTitle;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dicts;
- (instancetype)initWithDictionarys:(NSDictionary *)dict;
- (NSDictionary *)DictionaryRepresentation;

@end
