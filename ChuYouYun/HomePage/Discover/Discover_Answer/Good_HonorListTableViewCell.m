//
//  Good_HonorListTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/29.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_HonorListTableViewCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@implementation Good_HonorListTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}

//初始化控件
-(void)initLayuot{
    
    
    //添加线
    _listNumberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 25 * WideEachUnit,15 * WideEachUnit, 20 * WideEachUnit)];
    _listNumberImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_listNumberImageView];
    
    //头像
    _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 * WideEachUnit, 15 * WideEachUnit, 40 * WideEachUnit, 40 * WideEachUnit)];
    _userImageView.layer.cornerRadius = 20 * WideEachUnit;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.image = Image(@"站位图");
    [self addSubview:_userImageView];
    
    //名字
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_userImageView.frame) - 100 * WideEachUnit , 15 * WideEachUnit)];
    _userName.textColor = [UIColor colorWithHexString:@"#666"];
    _userName.font = Font(12 * WideEachUnit);
    _userName.backgroundColor = [UIColor whiteColor];
    [self addSubview:_userName];
    
    //时间
    _userInfo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_userImageView.frame) + 10 * WideEachUnit, 35 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_userImageView.frame) - 100 * WideEachUnit, 20 * WideEachUnit)];
    _userInfo.textColor = [UIColor colorWithHexString:@"#666"];
    _userInfo.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _userInfo.textAlignment = NSTextAlignmentLeft;
    _userInfo.backgroundColor = [UIColor whiteColor];
    [self addSubview:_userInfo];
    
    //具体
    _quesNumber = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit,12 * WideEachUnit, 40 * WideEachUnit, 14 * WideEachUnit)];
    _quesNumber.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    _quesNumber.textColor = [UIColor colorWithHexString:@"#656565"];
    _quesNumber.backgroundColor = [UIColor whiteColor];
    _quesNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_quesNumber];
    
    //回答
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit,40 * WideEachUnit, 40 * WideEachUnit, 14 * WideEachUnit)];
    questionLabel.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    questionLabel.textColor = BasidColor;
    questionLabel.text = @"回答";
    questionLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:questionLabel];

}


- (void)dataWithDict:(NSDictionary *)dict {
    NSString *urlStr = [[dict dictionaryValueForKey:@"userinfo"] stringValueForKey:@"avatar_big"];
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    _userName.text = [[dict dictionaryValueForKey:@"userinfo"] stringValueForKey:@"uname"];
    _userInfo.text = [[dict dictionaryValueForKey:@"userinfo"] stringValueForKey:@"intro"];
    _quesNumber.text = [dict stringValueForKey:@"count"];
}


@end
