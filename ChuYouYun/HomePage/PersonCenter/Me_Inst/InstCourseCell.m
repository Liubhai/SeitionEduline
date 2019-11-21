//
//  InstCourseCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

//#define horizontalrate MainScreenWidth/320
//#define verticalrate  MainScreenHeight/667

#import "InstCourseCell.h"
#import "SYG.h"

#import "Passport.h"





@implementation InstCourseCell

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InstCourseCell"];
    if (self) {
        [self.contentView addSubview:self.startTimeLab];
        [self.contentView addSubview:self.startLab];
        [self.contentView addSubview:self.ImagV];
        [self.contentView addSubview:self.endTimeLab];
        [self.contentView addSubview:self.endLab];
        [self.contentView addSubview:self.lastNumLab];
        [self.contentView addSubview:self.lastLab];
        [self.contentView addSubview:self.lineLab];
        
    }
    return self;
}

-(UILabel *)startTimeLab{
    
    if (!_startTimeLab) {
        _startTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(15*horizontalrate, 5*horizontalrate, 75*horizontalrate, 20*horizontalrate)];
        _startTimeLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _startTimeLab.textColor = [UIColor blackColor];
        _startTimeLab.text = @"09:00";
    }
    return _startTimeLab;
}
-(UILabel *)startLab{
    
    if (!_startLab) {
        _startLab = [[UILabel alloc]initWithFrame:CGRectMake(_startTimeLab.current_x, _startTimeLab.current_y_h, 75*horizontalrate, 20*horizontalrate)];
        _startLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _startLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _startLab.text = @"开始时间";
    }
    return _startLab;
}
-(UIImageView *)ImagV{
    
    if (!_ImagV) {
        _ImagV = [[UIImageView alloc]initWithFrame:CGRectMake(_startTimeLab.current_x_w, _startLab.current_y-2*horizontalrate, 83*horizontalrate, 5*horizontalrate)];
        _ImagV.image = [UIImage imageNamed:@"arrange_class_arrow"];
        
    }
    return _ImagV;
}

-(UILabel *)endTimeLab{
    
    if (!_endTimeLab) {
        _endTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 30*horizontalrate, 5*horizontalrate, 80*horizontalrate, 20*horizontalrate)];
        _endTimeLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _endTimeLab.textColor = [UIColor blackColor];
        _endTimeLab.text = @"12:00";
        
    }
    return _endTimeLab;
}

-(UILabel *)endLab{
    
    if (!_endLab) {
        _endLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 30*horizontalrate, _startLab.current_y, 80*horizontalrate, 20*horizontalrate)];
        _endLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _endLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _endLab.text = @"结束时间";
    }
    return _endLab;
}
-(UILabel *)lastNumLab{
    
    if (!_lastNumLab) {
        _lastNumLab = [[UILabel alloc]initWithFrame:CGRectMake(8*horizontalrate+_endTimeLab.current_x_w,_endTimeLab.current_y, 100*horizontalrate, 20*horizontalrate)];
        _lastNumLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _lastNumLab.textColor = [UIColor cyanColor];
        _lastNumLab.text = @"30/100";
    }
    return _lastNumLab;
}
-(UILabel *)lastLab{
    
    if (!_lastLab) {
        _lastLab = [[UILabel alloc]initWithFrame:CGRectMake(_lastNumLab.current_x,_lastNumLab.current_y_h, 100*horizontalrate, 20*horizontalrate)];
        _lastLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _lastLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _lastLab.text = @"剩余并发时间";
    }
    return _lastLab;
}
-(UILabel *)lineLab{
    
    if (!_lineLab) {
        _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(15*horizontalrate,_lastLab.current_y_h+5*horizontalrate, MainScreenWidth - 15*horizontalrate, 1*horizontalrate)];
        _lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineLab;
}

- (void)dataWithDic:(NSDictionary *)dict {
    
    NSString *startTime = [Passport formatterTime:dict[@"start_time"]];
    NSString *endTime = [Passport formatterTime:dict[@"end_time"]];
//    NSLog(@"%@ -- %@",startTime,endTime);//然后截取
    
    NSString *startHour = [startTime substringWithRange:NSMakeRange(11, 5)];
//    NSLog(@"%@",startHour);
    
    NSString *endHour = [endTime substringWithRange:NSMakeRange(11, 5)];
//    NSLog(@"%@",endHour);
    
    _startTimeLab.text = startHour;
    _endTimeLab.text = endHour;
    _lastNumLab.text = dict[@"concurrent_nums"];
    
}

@end
