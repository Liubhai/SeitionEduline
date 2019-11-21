//
//  OfflineMainTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OfflineMainTableViewCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"


@implementation OfflineMainTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 0, MainScreenWidth - 10 * WideEachUnit, 110 * WideEachUnit)];
    cellView.backgroundColor = [UIColor whiteColor];
    [self addSubview:cellView];
    
    _imagePhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 5 * WideEachUnit, 170 * WideEachUnit, 100 * WideEachUnit)];
    _imagePhotoView.backgroundColor = [UIColor whiteColor];
    [cellView addSubview:_imagePhotoView];
    
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 5 * WideEachUnit, MainScreenWidth - 210 * WideEachUnit, 15 * WideEachUnit)];
    _title.textColor = [UIColor blackColor];
    _title.backgroundColor = [UIColor whiteColor];
    [cellView addSubview:_title];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 28 * WideEachUnit, MainScreenWidth - 210 * WideEachUnit, 20 * WideEachUnit)];
    _price.font = Font(16 * WideEachUnit);
    _price.backgroundColor = [UIColor whiteColor];
    _price.textColor = [UIColor colorWithHexString:@"#fe575f"];
    [cellView addSubview:_price];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 63 * WideEachUnit, MainScreenWidth - 210 * WideEachUnit, 15 * WideEachUnit)];
    _time.font = Font(12 * WideEachUnit);
    _time.backgroundColor = [UIColor whiteColor];
    _time.textColor = [UIColor colorWithHexString:@"#656565"];
    [cellView addSubview:_time];
    
    
    _adress = [[UILabel alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 88 * WideEachUnit, MainScreenWidth - 210 * WideEachUnit, 15 * WideEachUnit)];
    _adress.font = Font(12 * WideEachUnit);
    _adress.backgroundColor = [UIColor whiteColor];
    _adress.textColor = [UIColor colorWithHexString:@"#656565"];
    [cellView addSubview:_adress];
    
//    _onlineButton = [[UIButton alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 113 * WideEachUnit, 170 * WideEachUnit, 30 * WideEachUnit)];
//    [_onlineButton setTitle:@"线上咨询" forState:UIControlStateNormal];
//    _onlineButton.layer.cornerRadius = 4 * WideEachUnit;
//    _onlineButton.layer.borderWidth = 1;
//    _onlineButton.layer.borderColor = BasidColor.CGColor;
//    [_onlineButton setTitleColor:BasidColor forState:UIControlStateNormal];
//    [cellView addSubview:_onlineButton];
//    
//    _orderButton = [[UIButton alloc] initWithFrame:CGRectMake(190 * WideEachUnit, 113 * WideEachUnit, 170 * WideEachUnit, 30 * WideEachUnit)];
//    [_orderButton setTitle:@"预约课程" forState:UIControlStateNormal];
//    [_orderButton setTitleColor:BasidColor forState:UIControlStateNormal];
//    _orderButton.layer.cornerRadius = 4 * WideEachUnit;
//    _orderButton.layer.borderWidth = 1;
//    _orderButton.layer.borderColor = BasidColor.CGColor;
//    _orderButton.titleLabel.font = Font(16 * WideEachUnit);
//    [cellView addSubview:_orderButton];
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    NSLog(@"555-----%@",dict);
    if ([dict isEqual:[NSNull null]]) {
        return;
    }
    NSString *urlStr = [dict stringValueForKey:@"imageurl"];
    [_imagePhotoView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    
    _title.text = [dict stringValueForKey:@"course_name"];
    _price.text = [NSString stringWithFormat:@"育币%@",[dict stringValueForKey:@"price"]];
    if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
        _price.text = @"免费";
        _price.textColor = [UIColor colorWithHexString:@"#47b37d"];
    }
    
    NSString *beginStr = [Passport formatterDate:[dict stringValueForKey:@"listingtime"]];
    NSString *endStr = [Passport formatterDate:[dict stringValueForKey:@"uctime"]];
    
    _time.text = [NSString stringWithFormat:@"%@ ~ %@",beginStr,endStr];
    
    _adress.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"teach_areas"]];
    _adress.hidden = YES;
    
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {//已经解锁
        [_orderButton setTitle:@"已解锁" forState:UIControlStateNormal];
    }
    
    
}




@end
