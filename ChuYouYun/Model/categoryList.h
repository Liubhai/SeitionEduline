//
//  categoryList.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface categoryList : NSObject
@property(nonatomic,retain)NSString * categoryId;
@property(nonatomic,retain)NSString * category_pid;
@property(nonatomic,retain)NSString * Category_title;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dicts;
- (instancetype)initWithDictionarys:(NSDictionary *)dict;
- (NSDictionary *)DictionaryRepresentation;
@end
