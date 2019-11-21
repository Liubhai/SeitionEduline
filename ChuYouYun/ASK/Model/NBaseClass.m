//
//  NBaseClass.m
//
//  Created by 志强 林 on 15/2/6
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "NBaseClass.h"


NSString *const kNBaseClassNoteSource = @"note_source";
NSString *const kNBaseClassCtime = @"ctime";
NSString *const kNBaseClassUname = @"uname";
NSString *const kNBaseClassOid = @"oid";
NSString *const kNBaseClassParentId = @"parent_id";
NSString *const kNBaseClassNoteDescription = @"note_description";
NSString *const kNBaseClassNoteCommentCount = @"note_comment_count";
NSString *const kNBaseClassIsOpen = @"is_open";
NSString *const kNBaseClassType = @"type";
NSString *const kNBaseClassId = @"id";
NSString *const kNBaseClassNoteVoteCount = @"note_vote_count";
NSString *const kNBaseClassUid = @"uid";
NSString *const kNBaseClassNoteCollectCount = @"note_collect_count";
NSString *const kNBaseClassNoteHelpCount = @"note_help_count";
NSString *const kNBaseClassUserface = @"userface";
NSString *const kNBaseClassNoteTitle = @"note_title";
NSString *const kNBaseClassReplyUid = @"reply_uid";
NSString *const kNBaseClassQcount = @"qcount";
NSString *const kNBaseClassStrtime = @"strtime";
NSString *const kNBaseClassPid = @"pid";


@interface NBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NBaseClass

@synthesize noteSource = _noteSource;
@synthesize ctime = _ctime;
@synthesize uname = _uname;
@synthesize oid = _oid;
@synthesize parentId = _parentId;
@synthesize noteDescription = _noteDescription;
@synthesize noteCommentCount = _noteCommentCount;
@synthesize isOpen = _isOpen;
@synthesize type = _type;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize noteVoteCount = _noteVoteCount;
@synthesize uid = _uid;
@synthesize noteCollectCount = _noteCollectCount;
@synthesize noteHelpCount = _noteHelpCount;
@synthesize userface = _userface;
@synthesize noteTitle = _noteTitle;
@synthesize replyUid = _replyUid;
@synthesize qcount = _qcount;
@synthesize strtime = _strtime;
@synthesize pid = _pid;


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
            self.noteSource = [self objectOrNilForKey:kNBaseClassNoteSource fromDictionary:dict];
            self.ctime = [self objectOrNilForKey:kNBaseClassCtime fromDictionary:dict];
            self.uname = [self objectOrNilForKey:kNBaseClassUname fromDictionary:dict];
            self.oid = [self objectOrNilForKey:kNBaseClassOid fromDictionary:dict];
            self.parentId = [self objectOrNilForKey:kNBaseClassParentId fromDictionary:dict];
            self.noteDescription = [self objectOrNilForKey:kNBaseClassNoteDescription fromDictionary:dict];
            self.noteCommentCount = [self objectOrNilForKey:kNBaseClassNoteCommentCount fromDictionary:dict];
            self.isOpen = [self objectOrNilForKey:kNBaseClassIsOpen fromDictionary:dict];
            self.type = [self objectOrNilForKey:kNBaseClassType fromDictionary:dict];
            self.internalBaseClassIdentifier = [self objectOrNilForKey:kNBaseClassId fromDictionary:dict];
            self.noteVoteCount = [self objectOrNilForKey:kNBaseClassNoteVoteCount fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kNBaseClassUid fromDictionary:dict];
            self.noteCollectCount = [self objectOrNilForKey:kNBaseClassNoteCollectCount fromDictionary:dict];
            self.noteHelpCount = [self objectOrNilForKey:kNBaseClassNoteHelpCount fromDictionary:dict];
            self.userface = [self objectOrNilForKey:kNBaseClassUserface fromDictionary:dict];
            self.noteTitle = [self objectOrNilForKey:kNBaseClassNoteTitle fromDictionary:dict];
            self.replyUid = [self objectOrNilForKey:kNBaseClassReplyUid fromDictionary:dict];
            self.qcount = [self objectOrNilForKey:kNBaseClassQcount fromDictionary:dict];
            self.strtime = [self objectOrNilForKey:kNBaseClassStrtime fromDictionary:dict];
            self.pid = [self objectOrNilForKey:kNBaseClassPid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.noteSource forKey:kNBaseClassNoteSource];
    [mutableDict setValue:self.ctime forKey:kNBaseClassCtime];
    [mutableDict setValue:self.uname forKey:kNBaseClassUname];
    [mutableDict setValue:self.oid forKey:kNBaseClassOid];
    [mutableDict setValue:self.parentId forKey:kNBaseClassParentId];
    [mutableDict setValue:self.noteDescription forKey:kNBaseClassNoteDescription];
    [mutableDict setValue:self.noteCommentCount forKey:kNBaseClassNoteCommentCount];
    [mutableDict setValue:self.isOpen forKey:kNBaseClassIsOpen];
    [mutableDict setValue:self.type forKey:kNBaseClassType];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kNBaseClassId];
    [mutableDict setValue:self.noteVoteCount forKey:kNBaseClassNoteVoteCount];
    [mutableDict setValue:self.uid forKey:kNBaseClassUid];
    [mutableDict setValue:self.noteCollectCount forKey:kNBaseClassNoteCollectCount];
    [mutableDict setValue:self.noteHelpCount forKey:kNBaseClassNoteHelpCount];
    [mutableDict setValue:self.userface forKey:kNBaseClassUserface];
    [mutableDict setValue:self.noteTitle forKey:kNBaseClassNoteTitle];
    [mutableDict setValue:self.replyUid forKey:kNBaseClassReplyUid];
    [mutableDict setValue:self.qcount forKey:kNBaseClassQcount];
    [mutableDict setValue:self.strtime forKey:kNBaseClassStrtime];
    [mutableDict setValue:self.pid forKey:kNBaseClassPid];

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

    self.noteSource = [aDecoder decodeObjectForKey:kNBaseClassNoteSource];
    self.ctime = [aDecoder decodeObjectForKey:kNBaseClassCtime];
    self.uname = [aDecoder decodeObjectForKey:kNBaseClassUname];
    self.oid = [aDecoder decodeObjectForKey:kNBaseClassOid];
    self.parentId = [aDecoder decodeObjectForKey:kNBaseClassParentId];
    self.noteDescription = [aDecoder decodeObjectForKey:kNBaseClassNoteDescription];
    self.noteCommentCount = [aDecoder decodeObjectForKey:kNBaseClassNoteCommentCount];
    self.isOpen = [aDecoder decodeObjectForKey:kNBaseClassIsOpen];
    self.type = [aDecoder decodeObjectForKey:kNBaseClassType];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kNBaseClassId];
    self.noteVoteCount = [aDecoder decodeObjectForKey:kNBaseClassNoteVoteCount];
    self.uid = [aDecoder decodeObjectForKey:kNBaseClassUid];
    self.noteCollectCount = [aDecoder decodeObjectForKey:kNBaseClassNoteCollectCount];
    self.noteHelpCount = [aDecoder decodeObjectForKey:kNBaseClassNoteHelpCount];
    self.userface = [aDecoder decodeObjectForKey:kNBaseClassUserface];
    self.noteTitle = [aDecoder decodeObjectForKey:kNBaseClassNoteTitle];
    self.replyUid = [aDecoder decodeObjectForKey:kNBaseClassReplyUid];
    self.qcount = [aDecoder decodeObjectForKey:kNBaseClassQcount];
    self.strtime = [aDecoder decodeObjectForKey:kNBaseClassStrtime];
    self.pid = [aDecoder decodeObjectForKey:kNBaseClassPid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_noteSource forKey:kNBaseClassNoteSource];
    [aCoder encodeObject:_ctime forKey:kNBaseClassCtime];
    [aCoder encodeObject:_uname forKey:kNBaseClassUname];
    [aCoder encodeObject:_oid forKey:kNBaseClassOid];
    [aCoder encodeObject:_parentId forKey:kNBaseClassParentId];
    [aCoder encodeObject:_noteDescription forKey:kNBaseClassNoteDescription];
    [aCoder encodeObject:_noteCommentCount forKey:kNBaseClassNoteCommentCount];
    [aCoder encodeObject:_isOpen forKey:kNBaseClassIsOpen];
    [aCoder encodeObject:_type forKey:kNBaseClassType];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kNBaseClassId];
    [aCoder encodeObject:_noteVoteCount forKey:kNBaseClassNoteVoteCount];
    [aCoder encodeObject:_uid forKey:kNBaseClassUid];
    [aCoder encodeObject:_noteCollectCount forKey:kNBaseClassNoteCollectCount];
    [aCoder encodeObject:_noteHelpCount forKey:kNBaseClassNoteHelpCount];
    [aCoder encodeObject:_userface forKey:kNBaseClassUserface];
    [aCoder encodeObject:_noteTitle forKey:kNBaseClassNoteTitle];
    [aCoder encodeObject:_replyUid forKey:kNBaseClassReplyUid];
    [aCoder encodeObject:_qcount forKey:kNBaseClassQcount];
    [aCoder encodeObject:_strtime forKey:kNBaseClassStrtime];
    [aCoder encodeObject:_pid forKey:kNBaseClassPid];
}

- (id)copyWithZone:(NSZone *)zone
{
    NBaseClass *copy = [[NBaseClass alloc] init];
    
    if (copy) {

        copy.noteSource = [self.noteSource copyWithZone:zone];
        copy.ctime = [self.ctime copyWithZone:zone];
        copy.uname = [self.uname copyWithZone:zone];
        copy.oid = [self.oid copyWithZone:zone];
        copy.parentId = [self.parentId copyWithZone:zone];
        copy.noteDescription = [self.noteDescription copyWithZone:zone];
        copy.noteCommentCount = [self.noteCommentCount copyWithZone:zone];
        copy.isOpen = [self.isOpen copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.noteVoteCount = [self.noteVoteCount copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.noteCollectCount = [self.noteCollectCount copyWithZone:zone];
        copy.noteHelpCount = [self.noteHelpCount copyWithZone:zone];
        copy.userface = [self.userface copyWithZone:zone];
        copy.noteTitle = [self.noteTitle copyWithZone:zone];
        copy.replyUid = [self.replyUid copyWithZone:zone];
        copy.qcount = [self.qcount copyWithZone:zone];
        copy.strtime = [self.strtime copyWithZone:zone];
        copy.pid = [self.pid copyWithZone:zone];
    }
    
    return copy;
}


@end
