//
//  ManageAdressTableViewCell.m
//  dafengche
//
//  Created by IOS on 16/10/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#define horizontalrate MainScreenWidth/320
#define verticalrate  MainScreenHeight/667
#import "ManageAdressTableViewCell.h"
#import "SYG.h"

@implementation ManageAdressTableViewCell


//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PaiKeTableViewCell"];
    if (self) {
        [self.contentView addSubview:self.firstLab];
        [self.contentView addSubview:self.secondLab];
        [self.contentView addSubview:self.ImagV];
        [self.contentView addSubview:self.thirdLab];
        [self.contentView addSubview:self.lastNumLab];
        [self.contentView addSubview:self.lastLab];
        [self.contentView addSubview:self.lineLab];
        
    }
    return self;
}

-(UILabel *)firstLab{
    
    if (!_firstLab) {
        _firstLab = [[UILabel alloc]initWithFrame:CGRectMake(15*horizontalrate, 5*horizontalrate, 75*horizontalrate, 20*horizontalrate)];
        _firstLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _firstLab.textColor = [UIColor blackColor];
        _firstLab.text = @"09:00";
    }
    return _firstLab;
}
-(UILabel *)secondLab{
    
    if (!_secondLab) {
        _secondLab = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.current_x, _firstLab.current_y_h, 75*horizontalrate, 20*horizontalrate)];
        _secondLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _secondLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _secondLab.text = @"开始时间";
    }
    return _secondLab;
}


-(UILabel *)thirdLab{
    
    if (!_thirdLab) {
        _thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(_ImagV.current_x_w + 30*horizontalrate, 5*horizontalrate, 80*horizontalrate, 20*horizontalrate)];
        _thirdLab.font = [UIFont systemFontOfSize:12*horizontalrate];
        _thirdLab.textColor = [UIColor blackColor];
        _thirdLab.text = @"12:00";
        
    }
    return _thirdLab;
}

//
//-(UILabel *)lastNumLab{
//    
//    if (!_lastNumLab) {
//        _lastNumLab = [[UILabel alloc]initWithFrame:CGRectMake(8*horizontalrate+_endTimeLab.current_x_w,_endTimeLab.current_y, 100*horizontalrate, 20*horizontalrate)];
//        _lastNumLab.font = [UIFont systemFontOfSize:12*horizontalrate];
//        _lastNumLab.textColor = [UIColor cyanColor];
//        _lastNumLab.text = @"30/100";
//    }
//    return _lastNumLab;
//}
//-(UILabel *)lineLab{
//    
//    if (!_lineLab) {
//        _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(15*horizontalrate,_lastLab.current_y_h+5*horizontalrate, MainScreenWidth - 15*horizontalrate, 1*horizontalrate)];
//        _lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    }
//    return _lineLab;
//}


@end
