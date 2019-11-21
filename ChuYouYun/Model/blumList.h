//
//  blumList.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface blumList : NSObject
@property(nonatomic,retain)NSString * blum_id;
@property(nonatomic,retain)NSString * album_title;
@property(nonatomic,retain)NSString * album_intro;
@property(nonatomic,retain)NSNumber* album_score;
@property(nonatomic,retain)NSNumber * video_cont;
@property(nonatomic,retain)NSString * album_collect_count;
@property(nonatomic,retain)NSString * img;
@property(nonatomic,retain)NSString * money_data;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dicts;
- (instancetype)initWithDictionarys:(NSDictionary *)dict;
- (NSDictionary *)DictionaryRepresentation;
@end
