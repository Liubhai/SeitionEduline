//
//  InstatutionCollectionViewCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/24.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstatutionCollectionViewCell.h"
#import "UIView+Utils.h"
#import "UIImageView+WebCache.h"
#import "SYG.h"


@implementation InstatutionCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        frame = frame;
//        [self addSubview:self.imageV];
//        [self addSubview:self.title];
//        [self addSubview:self.icon];
        [self addSubview];
    }
    return self;
}
//懒加载
//- (UIImageView *)imageV
//{
//    if (!_imageV) {
//        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,_frame.size.width-10,(_frame.size.width-10)*1.4)];
//    }
//    return _imageV;
//}
//- (UILabel *)title{
//    if (!_title) {
//        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,_imageV.current_y_h+10, _frame.size.width, 18)];
//        self.title.font = [UIFont systemFontOfSize:15];
//        self.title.textAlignment = NSTextAlignmentCenter;
//    }
//    return _title;
//}
//- (UILabel *)icon{
//    if (!_price) {
//        self.price = [[UILabel alloc]initWithFrame:CGRectMake(0, _title.current_y_h+5, _frame.size.width, 18)];
//        self.price.font = [UIFont systemFontOfSize:13];
//        self.price.textColor = [UIColor lightGrayColor];
//        self.price.numberOfLines = 2;
//        self.price.textAlignment = NSTextAlignmentCenter;
//        
//    }
//    return _price;
//}


- (void)addSubview {
    
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 120)];
    _imageV.image = Image(@"你好");
    [self addSubview:_imageV];
    
    _stausImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2, 20)];
    [self addSubview:_stausImageView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_imageV.frame),self.bounds.size.width , 30)];
    _title.numberOfLines = 2;
    _title.text = @"适应自然法则";
    _title.font = Font(14);
    _title.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_title];
    
    _person = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_title.frame), self.bounds.size.width / 2 - SpaceBaside, 30)];
    _person.text = @"10人学习";
    _person.font = Font(12);
    _person.textColor = [UIColor colorWithHexString:@"#888"];
    [self addSubview:_person];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2, CGRectGetMaxY(_title.frame), self.bounds.size.width / 2 - SpaceBaside, 30)];
    _price.text = @"122育币";
    _price.textColor = BasidColor;
    _price.font = Font(14);
    _price.textAlignment = NSTextAlignmentRight;
    [self addSubview:_price];
    
    _stats = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside / 2, 0, self.bounds.size.width / 2 - SpaceBaside, 20)];
    _stats.text = @"直播中...";
    _stats.textColor = [UIColor whiteColor];
    _stats.backgroundColor = [UIColor clearColor];
    _stats.font = Font(12);
    [self addSubview:_stats];
}

- (void)dataWithDict:(NSDictionary *)dict WithOrderSwitch:(NSString *)orderSwitch{
    NSLog(@"%@",dict);
    NSString *urlStr = [dict stringValueForKey:@"cover"];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    _title.text = [dict stringValueForKey:@"video_title"];
    _person.text = [NSString stringWithFormat:@"%@人报名",[dict stringValueForKey:@"video_order_count"]];
    if ([orderSwitch integerValue] == 1) {
         _person.text = [NSString stringWithFormat:@"%@人报名",[dict stringValueForKey:@"video_order_count_mark"]];
    }
    _price.text = [NSString stringWithFormat:@"育币%@",[dict stringValueForKey:@"price"]];
    if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
        _price.text = @"免费";
        _price.textColor = [UIColor colorWithHexString:@"#46c37b"];
    }
    
    //获取当前时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *beginSp = [dict stringValueForKey:@"beginTime"];
    NSString *endSp = [dict stringValueForKey:@"endTime"];
    
    if ([timeSp integerValue] < [beginSp integerValue]) {//还没有开始
        _stats.text = @"暂未开始...";
        _stausImageView.image = Image(@"readyto@3x");
    } else if ([timeSp integerValue] > [beginSp integerValue] && [timeSp integerValue] < [endSp integerValue]) {//直播中
        _stats.text = @"直播中...";
        _stausImageView.image = Image(@"living@3x");
    } else if ([timeSp integerValue] > [endSp integerValue]){//直播已经结束
        _stats.text = @"已结束...";
        _stausImageView.image = Image(@"over1@3x");
    }
    
}

@end
