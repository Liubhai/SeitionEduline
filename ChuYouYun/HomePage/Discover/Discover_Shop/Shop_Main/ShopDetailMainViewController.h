//
//  ShopDetailMainViewController.h
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailMainViewController : UIViewController

@property (strong ,nonatomic)NSDictionary     *dict;
@property (strong ,nonatomic)NSString         *scoreStaus;
@property (assign ,nonatomic)CGFloat          percentage;
@property (strong ,nonatomic)NSArray          *payTypeArray;

@end
