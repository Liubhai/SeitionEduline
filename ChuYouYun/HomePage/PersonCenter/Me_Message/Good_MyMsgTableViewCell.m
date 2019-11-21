//
//  Good_MyMsgTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyMsgTableViewCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"


@implementation Good_MyMsgTableViewCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //图像
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit , 15 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    _headerImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_headerImageView];
    
    
    //介绍
    _name = [[UILabel alloc] initWithFrame:CGRectMake(70 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 160 * WideEachUnit, 16 * WideEachUnit)];
    _name.font = [UIFont systemFontOfSize:16 * WideEachUnit];
    _name.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_name];
    
    
    //日期
    _time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 15 * WideEachUnit, 80 * WideEachUnit, 15 * WideEachUnit)];
    _time.textColor = [UIColor colorWithHexString:@"#666"];
    _time.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    [self addSubview:_time];
    
    //内容
     _content = [[UILabel alloc] initWithFrame:CGRectMake(70 * WideEachUnit, 41 * WideEachUnit, MainScreenWidth - 80 * WideEachUnit, 15 * WideEachUnit)];
    _content.textColor = [UIColor colorWithHexString:@"#666"];
    _content.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    [self addSubview:_content];
}

- (void)dataWithDict:(NSDictionary *)dict {

}

@end
