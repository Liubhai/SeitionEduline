//
//  ShopManagerAdressViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/7/18.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopManagerAdressViewController : UIViewController

@property (strong ,nonatomic)UILabel       *name;
@property (strong ,nonatomic)UILabel       *phone;
@property (strong ,nonatomic)UILabel       *adress;
@property (strong ,nonatomic)UILabel       *line;
@property (strong ,nonatomic)UIButton      *defaultButton;
@property (strong ,nonatomic)UIButton      *editorButton;
@property (strong ,nonatomic)UIButton      *deleteButton;

@property (strong ,nonatomic)void (^seleAdressCell)(NSDictionary *cellDict);

@end
