//
//  OpenMemberViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/10/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenMemberViewController : UIViewController

@property (strong ,nonatomic)NSDictionary  *vipDict;
@property (strong ,nonatomic)NSArray       *vipArray;
@property (strong ,nonatomic)NSArray       *vipMoneyArray;
@property (assign ,nonatomic)NSInteger     currentSeleVip;//记录从会员中心选中的会员等级

@property (strong ,nonatomic)NSString      *openOrRenew;
@property (strong ,nonatomic)NSString      *upgradeStr;


@end
