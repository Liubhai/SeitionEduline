//
//  MyLineDownClassReservationViewController.h
//  YunKeTang
//
//  Created by IOS on 2019/3/1.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLineDownClassReservationViewController : UIViewController

@property (strong ,nonatomic)NSDictionary  *dict;

-(instancetype)initWithID:(NSDictionary *)dict;

@end
