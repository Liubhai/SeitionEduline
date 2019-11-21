//
//  ShopDetailInfoViewController.h
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailInfoViewController : UIViewController

-(instancetype)initWithDict:(NSDictionary *)dict;
@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);

@end
