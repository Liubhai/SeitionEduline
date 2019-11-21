//
//  Good_MyClassDownloadTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyClassDownloadTableViewCell.h"
#import "SYG.h"

@implementation Good_MyClassDownloadTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.backgroundColor = [UIColor whiteColor];
    
    //头像
    _palyImage = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    _palyImage.backgroundColor = [UIColor whiteColor];
    _palyImage.image = Image(@"ico_video@3x");
    [self addSubview:_palyImage];
    _palyImage.hidden = YES;
    
    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit, 15 * WideEachUnit)];
    _title.font = Font(14 * WideEachUnit);
    _title.textColor = [UIColor colorWithHexString:@"#333"];
    _title.text = @"人与自然";
    _title.backgroundColor = [UIColor redColor];
    [self addSubview:_title];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 30 * WideEachUnit , MainScreenWidth - 120 * WideEachUnit, 10 * WideEachUnit)];
    [self addSubview:_time];
    _time.numberOfLines = 1;
    _time.text = @"50分钟";
    _time.textColor = [UIColor grayColor];
    _time.font = Font(10 * WideEachUnit);
    
    //试看
    _isLookButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 15 * WideEachUnit, 50 * WideEachUnit, 20 * WideEachUnit)];
    _isLookButton.backgroundColor = [UIColor whiteColor];
    [_isLookButton setTitle:@"可试看" forState:UIControlStateNormal];
    [_isLookButton setTitleColor:[UIColor colorWithHexString:@"#25b882"] forState:UIControlStateNormal];
    _isLookButton.titleLabel.font = Font(12 * WideEachUnit);
    [self addSubview:_isLookButton];
    
    
}

- (void)dataSourceWithDict:(NSDictionary *)dict {
    
}

- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type {
    if ([type integerValue] == 0) {//列表
        _isLookButton.hidden = YES;
        
    } else if ([type integerValue] == 1) {//选择下载
        _isLookButton.hidden = NO;
        [_isLookButton setImage:Image(@"is_download@3x") forState:UIControlStateNormal];
        [_isLookButton setTitle:@"" forState:UIControlStateNormal];
    } else if ([type integerValue] == 2) {//我的下载
        _isLookButton.hidden = YES;
    }
}



@end
