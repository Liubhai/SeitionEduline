//
//  EditAdressViewController.h
//  dafengche
//
//  Created by IOS on 16/11/17.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAdressViewController : UIViewController

@property (strong ,nonatomic)NSDictionary    *dict;
-(instancetype)initWithName:(NSString *)name adress:(NSString *)adress phone:(NSString *)phone area:(NSString *)area is_default:(NSString *)is_default address_id:(NSString *)address_id;

@end
