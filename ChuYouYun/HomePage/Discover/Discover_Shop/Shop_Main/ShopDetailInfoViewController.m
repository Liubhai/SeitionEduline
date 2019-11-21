//
//  ShopDetailInfoViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "ShopDetailInfoViewController.h"
#import "SYG.h"
#import "BigWindCar.h"


@interface ShopDetailInfoViewController ()

@property (strong ,nonatomic)UILabel      *detail;

@property (strong ,nonatomic)NSDictionary *dict;

@end

@implementation ShopDetailInfoViewController

-(instancetype)initWithDict:(NSDictionary *)dict {
    if (!self) {
        self = [super init];
        _dict = dict;
    }
    _dict = dict;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addDetail];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addDetail {
    _detail = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20 * WideEachUnit, 100 * WideEachUnit)];
    _detail.backgroundColor = [UIColor whiteColor];
    _detail.text = [_dict stringValueForKey:@"info"];
    _detail.font = Font(13 * WideEachUnit);
    _detail.numberOfLines = 0;
    [self setIntroductionText:[_dict stringValueForKey:@"info"]];
    [self.view addSubview:_detail];
    
    
}

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _detail.text = text;
    //设置label的最大行数
    _detail.numberOfLines = 0;
    if ([_detail.text isEqual:[NSNull null]]) {
        _detail.frame = CGRectMake(15 * WideEachUnit,130 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit,30 * WideEachUnit);
        return;
    }
    
    CGRect labelSize = [text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13 * WideEachUnit]} context:nil];
    _detail.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit,labelSize.size.height);
    
}



@end
