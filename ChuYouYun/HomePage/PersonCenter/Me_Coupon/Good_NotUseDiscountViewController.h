//
//  Good_NotUseDiscountViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/12/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewCOntroller.h"

@interface Good_NotUseDiscountViewController : BaseViewController

@property (nonatomic, assign) BOOL isCombo;

- (instancetype)initWithID:(NSString *)ID withDict:(NSDictionary *)dict;

@end
