//
//  GroupDetailViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosView.h"




@interface GroupDetailViewController : UIViewController

@property (strong ,nonatomic)NSString *IDString;

@property (strong ,nonatomic)NSString *imageStr;

@property (strong ,nonatomic)NSArray *cateArray;

@property (strong ,nonatomic)UIView *commentView;
@property (strong ,nonatomic)UITextField *textField;

@end
