//
//  YunKeTang_HomeCollectionViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/3/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "YunKeTang_HomeCollectionViewCell.h"
#import "SYG.h"

#define CellWidth self.bounds.size.width

@implementation YunKeTang_HomeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        _frame = frame;
        //        [self addSubview:self.imageV];
        //        [self addSubview:self.title];
        //        [self addSubview:self.icon];
        [self addSubview];
    }
    return self;
}

- (void)addSubview {
    
    _imagePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 5 * WideEachUnit, CellWidth, CellWidth / 5 * 3)];
    _imagePhoto.image = Image(@"你好");
    _imagePhoto.backgroundColor = [UIColor redColor];
    [self addSubview:_imagePhoto];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_imagePhoto.frame),CellWidth - 20 * WideEachUnit , 20 * WideEachUnit)];
    _title.numberOfLines = 1;
    _title.text = @"适应自然法则";
    _title.font = Font(14 * WideEachUnit);
    _title.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_title];
    
    _person = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_title.frame), CellWidth / 2 - SpaceBaside, 20 * WideEachUnit)];
    _person.text = @"10人学习";
    _person.font = Font(12);
    _person.textColor = [UIColor colorWithHexString:@"#888"];
    [self addSubview:_person];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(CellWidth / 2, CGRectGetMaxY(_title.frame), CellWidth / 2 - 10 * WideEachUnit, 20 * WideEachUnit)];
    _price.text = @"122育币";
    _price.textColor = BasidColor;
    _price.font = Font(14);
    _price.textAlignment = NSTextAlignmentRight;
    [self addSubview:_price];
    
//    _stats = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside / 2, 0, self.bounds.size.width / 2 - SpaceBaside, 20)];
//    _stats.text = @"直播中...";
//    _stats.textColor = [UIColor whiteColor];
//    _stats.backgroundColor = [UIColor clearColor];
//    _stats.font = Font(12);
//    [self addSubview:_stats];
}

- (void)dataWithDict:(NSDictionary *)dict {
    NSLog(@"%@",dict);
    NSString *urlStr = [dict stringValueForKey:@"imageurl"];
    [_imagePhoto sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    _title.text = [dict stringValueForKey:@"video_title"];
    _person.text = [NSString stringWithFormat:@"%@人报名",[dict stringValueForKey:@"video_order_count"]];
    _price.text = [NSString stringWithFormat:@"育币:%@",[dict stringValueForKey:@"price"]];
    if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
        _price.text = @"免费";
        _price.textColor = [UIColor colorWithHexString:@"#46c37b"];
    }
    
//    //获取当前时间戳
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
//    NSString *beginSp = [dict stringValueForKey:@"beginTime"];
//    NSString *endSp = [dict stringValueForKey:@"endTime"];
//
//    if ([timeSp integerValue] < [beginSp integerValue]) {//还没有开始
//        _stats.text = @"暂未开始...";
//        _stausImageView.image = Image(@"readyto@3x");
//    } else if ([timeSp integerValue] > [beginSp integerValue] && [timeSp integerValue] < [endSp integerValue]) {//直播中
//        _stats.text = @"直播中...";
//        _stausImageView.image = Image(@"living@3x");
//    } else if ([timeSp integerValue] > [endSp integerValue]){//直播已经结束
//        _stats.text = @"已结束...";
//        _stausImageView.image = Image(@"over1@3x");
//    }
//
}


@end
