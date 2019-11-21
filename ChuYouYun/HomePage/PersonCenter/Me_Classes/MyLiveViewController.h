//
//  MyLiveViewController.h
//  ChuYouYun
//
//  Created by IOS on 16/11/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLiveViewController : UIViewController


@property(nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSString * num;
@property(nonatomic,retain)NSString * cateory_id;

@property (strong ,nonatomic)NSString *formStr;//标识字段


//机构
@property (strong ,nonatomic)NSString *institutionStr;

- (void)refreshHeader;
- (id)initWithId:(NSString *)Id;



@end
