//
//  BRDownFileCacheManager.h
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRDownFileCacheManager : NSObject
+ (instancetype)manager;
-(NSArray *)classWithDic:(NSMutableDictionary *)dic;
-(void)saveClasses:(NSArray *)SYGClass;
@end

NS_ASSUME_NONNULL_END
