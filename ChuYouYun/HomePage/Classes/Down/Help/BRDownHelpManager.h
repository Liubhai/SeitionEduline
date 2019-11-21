//
//  BRDownHelpManager.h
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BRUpdateDownProgressDelegate <NSObject>

@optional
- (void)downHelpUpdateProgress:(float)progress url:(NSString *)url isDownFinish:(BOOL)isFinish courseInfo:(NSDictionary *)courseInfo;
@end
@interface BRDownHelpManager : NSObject
+ (instancetype)manager;
- (void)br_addDelegates:(id<BRUpdateDownProgressDelegate>)delegate;
- (void)br_startDownUrl:(NSString *)url dictInfo:(NSDictionary *)info;


- (void)br_saveCoureData:(NSDictionary *)data coureInfo:(NSDictionary *)info;
- (NSDictionary *)br_getCourseInfoWithListCourseInfo:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
