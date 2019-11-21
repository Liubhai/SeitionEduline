//
//  AllOrderModelVC.h
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderModelVC : UIViewController

@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSDictionary *orderDict;
@property (strong ,nonatomic)NSString *isInst;

- (instancetype)initWithType:(NSString *)type;

@end
