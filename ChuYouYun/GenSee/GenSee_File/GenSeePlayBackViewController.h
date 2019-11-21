//
//  GenSeePlayBackViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/8/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlayerSDK/VodSDK.h>

@interface GenSeePlayBackViewController : UIViewController

@property (nonatomic, strong) downItem *item;
@property (nonatomic, assign) BOOL isLivePlay;

@property (strong ,nonatomic)NSString *typeStr;

@end
