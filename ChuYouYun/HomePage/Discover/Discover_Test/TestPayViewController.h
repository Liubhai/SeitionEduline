//
//  TestPayViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/8/2.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"

@interface TestPayViewController : BaseViewController

@property (strong, nonatomic) void (^paySuccess)(NSString *paper_id);

@property (strong, nonatomic) NSDictionary *info;

@end
