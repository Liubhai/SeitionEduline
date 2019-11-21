//
//  VideoMarqueeViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/12.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "VideoMarqueeViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

@interface VideoMarqueeViewController () {
    NSInteger Number;
    CGRect    _labelSize;
}

@property (strong ,nonatomic)NSTimer   *marqueeTimer;
@property (strong ,nonatomic)UILabel   *marqueeLabel;

@property (strong ,nonatomic)NSString  *showTime;
@property (strong ,nonatomic)NSString  *intervalTime;

@end

@implementation VideoMarqueeViewController

-(instancetype)initWithDict:(NSDictionary *)dict {
    if (!self) {
        self = [super init];
    }
    _dict = dict;
    return self;
}

-(UILabel *)marqueeLabel {
    if (!_marqueeLabel) {
        _marqueeLabel = [[UILabel alloc] init];
        _marqueeLabel.backgroundColor = [UIColor clearColor];
        _marqueeLabel.text = [_dict stringValueForKey:@"content"];
        _marqueeLabel.textColor = [UIColor redColor];
        _marqueeLabel.font = Font(12);
        [self.view addSubview:_marqueeLabel];
    }
    return _marqueeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self locationMarquu];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = NO;
    _showTime = [_dict stringValueForKey:@"show"];
    _intervalTime = [_dict stringValueForKey:@"times"];
    Number = 0;
    
    self.marqueeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(marqueeTimerDeal) userInfo:nil repeats:YES];
}

- (void)locationMarquu {
    [self locationMarquuSize];
    CGFloat marqueeW = _labelSize.size.width;
    CGFloat marqueeH = 20 * WideEachUnit;
    CGFloat X = arc4random_uniform(MainScreenWidth - marqueeW);
    CGFloat Y = arc4random_uniform(190 * WideEachUnit);
    self.marqueeLabel.frame = CGRectMake(X, Y, marqueeW, marqueeH);
}

- (void)locationMarquuSize {
    //设置label的最大行数
    _marqueeLabel.numberOfLines = 0;
    if ([_marqueeLabel.text isEqual:[NSNull null]]) {
        _marqueeLabel.frame = CGRectMake(15 * WideEachUnit,130 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit,30 * WideEachUnit);
        return;
    }
    
    CGRect labelSize = [_marqueeLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 * WideEachUnit]} context:nil];
    _labelSize = labelSize;
}

- (void)marqueeTimerDeal {
    Number ++;
    if (Number % ([_showTime integerValue] + [_intervalTime integerValue]) == 0) {//刚好显示完一轮
        _marqueeLabel.hidden = YES;
        [self locationMarquu];
    } else if (Number % ([_showTime integerValue] + [_intervalTime integerValue]) < [_intervalTime integerValue]) {//说明正在隐藏阶段
        _marqueeLabel.hidden = YES;
    } else if (Number % ([_showTime integerValue] + [_intervalTime integerValue]) < [_showTime integerValue] + [_intervalTime integerValue]) {//当前正在显示
        _marqueeLabel.hidden = NO;
    }
}

@end
