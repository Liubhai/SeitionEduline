//
//  courseNoteModel.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "courseNoteModel.h"
//笔记
NSString * const kCourseNoteId = @"id";
NSString * const kCourseNoteTitle =@"note_title";
NSString * const kCourseNoteDescription = @"note_description";
NSString * const kCourseNoteTime = @"ctime";
NSString * const kCourseNoteUserName = @"username";
NSString * const kCourseNoteUserFace = @"userface";
NSString * const kCourseNoteZan = @"note_help_count";
NSString * const kCourseNoteComment = @"note_comment_count";
//提问
NSString * const kCourseQstDescription = @"qst_description";
NSString * const kCourseQstHelpCount = @"qst_help_count";
NSString * const kCourseQstCommentCount = @"qst_comment_count";
NSString * const kCourseQstTitle = @"qst_title";
NSString * const kCourseQstId = @"id";
//点评
NSString * const kCourseReviewStar = @"star";
NSString * const kCourseReviewDescription = @"review_description";
NSString * const kCourseReviewCommentCount = @"review_vote_count";
NSString * const kCourseReviewIsVote = @"isvote";
NSString * const kCourseReviewId = @"id";
@interface courseNoteModel ()
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict;
@end

@implementation courseNoteModel
@synthesize note_id = _note_id;
@synthesize note_comment_count = _note_comment_count;
@synthesize note_description = _note_description;
@synthesize note_time = _note_time;
@synthesize note_title = _note_title;
@synthesize userFace = _userFace;
@synthesize userName = _userName;
@synthesize note_help_count = _note_help_count;
@synthesize qst_comment_count = _qst_comment_count;
@synthesize qst_description = _qst_description;
@synthesize qst_help_count = _qst_help_count;
@synthesize qst_title = _qst_title;
@synthesize star = _star;
@synthesize review_comment_count = _review_comment_count;
@synthesize review_description = _review_description;
@synthesize isvote=_isvote;
@synthesize review_id = _review_id;
@synthesize qst_id = _qst_id;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dicts
{
    return [[self alloc] initWithDictionary:dicts];
}

- (instancetype)initWithDictionarys:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.note_id = [self objectOrNilForKeys: kCourseNoteId fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.note_time = [self objectOrNilForKeys:kCourseNoteTime fromDictionary:dict];
        self.note_title = [self objectOrNilForKeys:kCourseNoteTitle fromDictionary:dict];
        self.note_help_count = [self objectOrNilForKeys:kCourseNoteZan fromDictionary:dict];
        self.note_description = [self objectOrNilForKeys:kCourseNoteDescription fromDictionary:dict];
        
        self.note_comment_count = [self objectOrNilForKeys:kCourseNoteComment fromDictionary:dict];
        self.userName = [self objectOrNilForKeys:kCourseNoteUserName fromDictionary:dict];
        
        self.userFace = [self objectOrNilForKeys:kCourseNoteUserFace fromDictionary:dict];
        
        self.qst_title = [self objectOrNilForKeys: kCourseQstTitle fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.qst_help_count = [self objectOrNilForKeys:kCourseQstHelpCount fromDictionary:dict];
        self.qst_description = [self objectOrNilForKeys:kCourseQstDescription fromDictionary:dict];
        self.qst_comment_count = [self objectOrNilForKeys:kCourseQstCommentCount fromDictionary:dict];
        
        self.star = [self objectOrNilForKeys:kCourseReviewStar fromDictionary:dict];
        self.review_description = [self objectOrNilForKeys:kCourseReviewDescription fromDictionary:dict];
        self.review_comment_count = [self objectOrNilForKeys:kCourseReviewCommentCount fromDictionary:dict];
        self.isvote = [self objectOrNilForKeys:kCourseReviewIsVote fromDictionary:dict];
        self.review_id = [self objectOrNilForKeys:kCourseReviewId fromDictionary:dict];
        self.qst_id = [self objectOrNilForKeys:kCourseQstId fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)DictionaryRepresentation
{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.note_comment_count forKey:kCourseNoteComment];
    [mutableDict setValue:self.note_description forKey:kCourseNoteDescription];
    [mutableDict setValue:self.note_help_count forKey:kCourseNoteZan];
    [mutableDict setValue:self.note_id forKey:kCourseNoteId];
    [mutableDict setValue:self.note_time forKey:kCourseNoteTime];
    [mutableDict setValue:self.note_title forKey:kCourseNoteTitle];
    [mutableDict setValue:self.userFace forKey:kCourseNoteUserFace];
    [mutableDict setValue:self.userName forKey:kCourseNoteUserName];
    
    [mutableDict setValue:self.qst_comment_count forKey:kCourseQstCommentCount];
    [mutableDict setValue:self.qst_description forKey:kCourseQstDescription];
    [mutableDict setValue:self.qst_help_count forKey:kCourseQstHelpCount];
    [mutableDict setValue:self.qst_title forKey:kCourseQstTitle];
    
    [mutableDict setValue:self.star forKey:kCourseReviewStar];
    [mutableDict setValue:self.review_comment_count forKey:kCourseReviewCommentCount];
    [mutableDict setValue:self.review_description forKey:kCourseReviewDescription];
    [mutableDict setValue:self.isvote forKey:kCourseReviewIsVote];
    [mutableDict setValue:self.review_id forKey:kCourseReviewId];
     [mutableDict setValue:self.qst_id forKey:kCourseQstId];
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
    
    self.note_id = [aDecoder decodeObjectForKey:kCourseNoteId];
    self.note_time = [aDecoder decodeObjectForKey:kCourseNoteTime];
    self.note_title = [aDecoder decodeObjectForKey:kCourseNoteTitle];
    self.note_help_count = [aDecoder decodeObjectForKey:kCourseNoteZan];
    self.note_description = [aDecoder decodeObjectForKey:kCourseNoteDescription];
    self.note_comment_count = [aDecoder decodeObjectForKey:kCourseNoteComment];
    self.userName = [aDecoder decodeObjectForKey:kCourseNoteUserName];
    self.userFace = [aDecoder decodeObjectForKey:kCourseNoteUserFace];
    
    self.qst_title = [aDecoder decodeObjectForKey:kCourseQstTitle];
    self.qst_help_count = [aDecoder decodeObjectForKey:kCourseQstHelpCount];
    self.qst_description = [aDecoder decodeObjectForKey:kCourseQstDescription];
    self.qst_comment_count = [aDecoder decodeObjectForKey:kCourseQstCommentCount];
    self.star = [aDecoder decodeObjectForKey:kCourseReviewStar];
    self.review_description = [aDecoder decodeObjectForKey:kCourseReviewDescription];
    self.review_comment_count = [aDecoder decodeObjectForKey:kCourseReviewCommentCount];
    self.isvote = [aDecoder decodeObjectForKey:kCourseReviewIsVote];
    self.review_id = [aDecoder decodeObjectForKey:kCourseReviewId];
    self.qst_id = [aDecoder decodeObjectForKey:kCourseQstId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_note_id forKey:kCourseNoteId];
    [aCoder encodeObject:_note_time forKey:kCourseNoteTime];
    [aCoder encodeObject:_note_title forKey:kCourseNoteTitle];
    [aCoder encodeObject:_note_help_count forKey:kCourseNoteZan];
    [aCoder encodeObject:_note_description forKey:kCourseNoteDescription];
    [aCoder encodeObject:_note_comment_count forKey:kCourseNoteComment];
    [aCoder encodeObject:_userName forKey:kCourseNoteUserName];
    [aCoder encodeObject:_userFace forKey:kCourseNoteUserFace];
    
    [aCoder encodeObject:_qst_title forKey:kCourseQstTitle];
    [aCoder encodeObject:_qst_help_count forKey:kCourseQstHelpCount];
    [aCoder encodeObject:_qst_description forKey:kCourseQstDescription];
    [aCoder encodeObject:_qst_comment_count forKey:kCourseQstCommentCount];
    
    [aCoder encodeObject:_star forKey:kCourseReviewStar];
    [aCoder encodeObject:_review_description forKey:kCourseReviewDescription];
    [aCoder encodeObject:_review_comment_count forKey:kCourseReviewCommentCount];
     [aCoder encodeObject:_isvote forKey:kCourseReviewIsVote];
    [aCoder encodeObject:_review_id forKey:kCourseReviewId];
    [aCoder encodeObject:_qst_id forKey:kCourseQstId];
}

- (id)copyWithZone:(NSZone *)zone
{
    courseNoteModel *copy = [[courseNoteModel alloc] init];
    
    if (copy) {
        
        copy.note_comment_count = [self.note_comment_count copyWithZone:zone];
        copy.note_description = [self.note_description copyWithZone:zone];
        copy.note_help_count = [self.note_help_count copyWithZone:zone];
        copy.note_id = [self.note_id copyWithZone:zone];
        copy.note_time = [self.note_time copyWithZone:zone];
        copy.note_title = [self.note_title copyWithZone:zone];
        copy.userFace = [self.userFace copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
        
        copy.qst_comment_count = [self.qst_comment_count copyWithZone:zone];
        copy.qst_description= [self.qst_description copyWithZone:zone];
        copy.qst_help_count = [self.qst_help_count copyWithZone:zone];
        copy.qst_title = [self.qst_title copyWithZone:zone];
        
        copy.star= [self.star copyWithZone:zone];
        copy.review_comment_count = [self.review_comment_count copyWithZone:zone];
        copy.review_description = [self.review_description copyWithZone:zone];
         copy.isvote = [self.isvote copyWithZone:zone];
        copy.review_id = [self.review_id copyWithZone:zone];
        copy.qst_id = [self.qst_id copyWithZone:zone];
    }
    
    return copy;
}


@end
