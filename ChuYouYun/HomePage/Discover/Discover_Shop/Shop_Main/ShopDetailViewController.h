//
//  ShopDetailViewController.h
//  dafengche
//
//  Created by IOS on 16/10/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailViewController : UIViewController

@property (strong ,nonatomic)NSDictionary   *dict;
@property (strong ,nonatomic)NSArray        *payTypeArray;
@property (strong ,nonatomic)NSString       *scoreStaus;
@property (assign ,nonatomic)CGFloat        percentage;
-(instancetype)initWithID:(NSString *)IDStr;

@end
