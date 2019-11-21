//
//  OfflineDetailViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineDetailViewController : UIViewController

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *imageUrl;
@property (strong ,nonatomic)NSString *titleStr;

//营销数据
@property (strong ,nonatomic)NSString *orderSwitch;

@end
