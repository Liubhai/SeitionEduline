//
//  MyShareTableViewCell.m
//  YunKeTang
//
//  Created by IOS on 2019/2/26.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "MyShareTableViewCell.h"
#import "SYG.h"

@implementation MyShareTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit, 90 * WideEachUnit, 50 * WideEachUnit)];
    _photoView.backgroundColor = [UIColor redColor];
    [self addSubview:_photoView];
    
    //标题
    _name = [[UILabel alloc] initWithFrame:CGRectMake(120 * WideEachUnit,15 * WideEachUnit,MainScreenWidth - 135 * WideEachUnit, 15 * WideEachUnit)];
    [self addSubview:_name];
    _name.text = @"使用一应";
    _name.font = Font(15 * WideEachUnit);
    _name.textColor = [UIColor colorWithHexString:@"#575757"];
    
    //名字
    _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(120 * WideEachUnit, 40 * WideEachUnit,MainScreenWidth - 180 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_urlLabel];
    _urlLabel.font = Font(13 * WideEachUnit);
    _urlLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _urlLabel.text = @"你是你上午我问问我我等你过个";
    _urlLabel.font = Font(13);
    
    
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 40 * WideEachUnit,50 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_time];
    _time.font = Font(13 * WideEachUnit);
    _time.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _time.text = @"你是你上午我问问我我等你过个";
    
    //机构按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 0, 50 * WideEachUnit, 75 * WideEachUnit)];
    _rightButton.backgroundColor = [UIColor whiteColor];
    [_rightButton setTitleColor:BasidColor forState:UIControlStateNormal];
    _rightButton.titleLabel.font = Font(18 * WideEachUnit);
    [self addSubview:_rightButton];
    _rightButton.hidden = YES;
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    [_photoView sd_setImageWithURL:[NSURL URLWithString:[dict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
    _urlLabel.text = [dict stringValueForKey:@"share_url"];
    _name.text = [dict stringValueForKey:@"title"];
    _time.text = [Passport formatterTime:[dict stringValueForKey:@"ctime"]];
    _time.text = [_time.text substringWithRange:NSMakeRange(5, 5)];
    
}

@end
