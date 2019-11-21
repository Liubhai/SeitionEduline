//
//  settingViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (strong, nonatomic)UIImage *face;
@property (strong, nonatomic)NSString *myName;
@property (strong ,nonatomic)NSString *score;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(id)initWithUserFace:(UIImage *)face userName:(NSString *)name;

@property (strong ,nonatomic)NSDictionary *allDic;
@end
