//
//  STRIAPManager.h
//  YunKeTang
//
//  Created by IOS on 2018/12/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    SIAPPurchSuccess = 0,       // 购买成功
    SIAPPurchFailed = 1,        // 购买失败
    SIAPPurchCancle = 2,        // 取消购买
    SIAPPurchVerFailed = 3,     // 订单校验失败
    SIAPPurchVerSuccess = 4,    // 订单校验成功
    SIAPPurchNotArrow = 5,      // 不允许内购
}SIAPPurchType;

typedef void (^IAPCompletionHandle)(SIAPPurchType type,NSData *data);

@interface STRIAPManager : NSObject


+ (instancetype)shareSIAPManager;
//开始内购
- (void)startPurchWithID:(NSString *)purchID completeHandle:(IAPCompletionHandle)handle;

@end
