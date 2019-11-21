//
//  ShopDetailCommentTableViewCell.m
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "ShopDetailCommentTableViewCell.h"
#import "SYG.h"

@implementation ShopDetailCommentTableViewCell


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
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    
    //头像
    _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 12 * WideEachUnit, 35 * WideEachUnit, 35 * WideEachUnit)];
    _photoImageView.clipsToBounds = YES;
    _photoImageView.layer.cornerRadius = 17.5 * WideEachUnit;
    [self addSubview:_photoImageView];
    
    //名字
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_photoImageView.frame) + 10 * WideEachUnit, 22 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_photoImageView.frame) - 100 * WideEachUnit , 15 * WideEachUnit)];
    _userName.textColor = [UIColor colorWithHexString:@"#666"];
    _userName.font = Font(12 * WideEachUnit);
    _userName.backgroundColor = [UIColor whiteColor];
    [self addSubview:_userName];
    _userName.text = @"张三";
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 150 * WideEachUnit, 15 * WideEachUnit, 140 * WideEachUnit, 20 * WideEachUnit)];
    _time.textColor = [UIColor colorWithHexString:@"#666"];
    _time.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _time.textAlignment = NSTextAlignmentRight;
    _time.backgroundColor = [UIColor whiteColor];
    [self addSubview:_time];
    
    //具体
    _comment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_photoImageView.frame) + 10 * WideEachUnit, CGRectGetMaxY(_time.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit - CGRectGetMaxX(_photoImageView.frame), 24 * WideEachUnit)];
    _comment.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    _comment.textColor = [UIColor colorWithHexString:@"#656565"];
    _comment.backgroundColor = [UIColor whiteColor];
    [self addSubview:_comment];
}


- (void)dataWithDict:(NSDictionary *)dict {
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[[dict dictionaryValueForKey:@"uidInfo"] stringValueForKey:@"avatar_big"]] placeholderImage:Image(@"站位图")];
    _userName.text = [[dict dictionaryValueForKey:@"uidInfo"] stringValueForKey:@"uname"];
    _time.text = [dict stringValueForKey:@"ctime"];
    _comment.text = [dict stringValueForKey:@"to_comment"];
}





@end
