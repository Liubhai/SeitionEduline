//
//  RefundFailViewController.h
//  YunKeTang
//
//  Created by IOS on 2018/9/25.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundFailViewController : UIViewController

@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSDictionary *orderDict;
@property (strong ,nonatomic)NSString *isInst;

- (instancetype)initWithType:(NSString *)type;

@end
