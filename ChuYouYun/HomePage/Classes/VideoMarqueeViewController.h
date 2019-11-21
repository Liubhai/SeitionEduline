//
//  VideoMarqueeViewController.h
//  YunKeTang
//
//  Created by IOS on 2019/3/12.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoMarqueeViewController : UIViewController

@property (strong ,nonatomic)NSDictionary   *dict;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
