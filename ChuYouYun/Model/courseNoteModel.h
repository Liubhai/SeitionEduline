//
//  courseNoteModel.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface courseNoteModel : NSObject
//笔记
@property(nonatomic,retain)NSString *note_id;
@property(nonatomic,retain)NSString * note_title;
@property(nonatomic,retain)NSString * note_time;
@property(nonatomic,retain)NSString * userFace;
@property(nonatomic,retain)NSString * userName;
@property(nonatomic,retain)NSString * note_help_count;
@property(nonatomic,retain)NSString * note_description;
@property(nonatomic,retain)NSString * note_comment_count;
//提问
@property(nonatomic,retain)NSString * qst_description;
@property(nonatomic,retain)NSString * qst_help_count;
@property(nonatomic,retain)NSString * qst_comment_count;
@property(nonatomic,retain)NSString * qst_title;
@property(nonatomic,retain)NSString * qst_id;
//点评
@property(nonatomic,retain)NSString * star;
@property(nonatomic,retain)NSString * review_description;
@property(nonatomic,retain)NSString * review_comment_count;
@property(nonatomic,retain)NSNumber * isvote;
@property(nonatomic,retain)NSString * review_id;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dicts;
- (instancetype)initWithDictionarys:(NSDictionary *)dict;
- (NSDictionary *)DictionaryRepresentation;

@end
