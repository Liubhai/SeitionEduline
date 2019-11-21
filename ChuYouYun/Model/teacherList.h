//
//  teacherList.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/22.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface teacherList : NSObject
@property(nonatomic,retain)NSString *iD;
@property(nonatomic,retain)NSString * uid;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * inro;
@property(nonatomic,retain)NSString * heading;
@property(nonatomic,retain)NSString * video_count;

@property(nonatomic,retain)NSString * video_title;
@property(nonatomic,retain)NSString * video_inro;
@property(nonatomic,retain)NSString * img;
@property(nonatomic,retain)NSString * watchCount;
@property(nonatomic,retain)NSString * video_order_count;
@property(nonatomic,retain)NSString * video_score;
@property(nonatomic,retain)NSString * mzprice;
@property(nonatomic,retain)NSString * imgUrl;
@property(nonatomic,retain)NSString * price;
@property(nonatomic,retain)NSString * vprice;
@property(nonatomic,retain)NSString * cid;//课程id
@property(nonatomic,retain)NSString * listTime;//上架时间
@property(nonatomic,retain)NSString * uTime;//修改时间
@property(nonatomic,retain)NSString * videoImageUrl;
@property(nonatomic,retain)NSString * videoAddress;//视频地址
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dicts;
- (instancetype)initWithDictionarys:(NSDictionary *)dict;
- (NSDictionary *)DictionaryRepresentation;

@end
