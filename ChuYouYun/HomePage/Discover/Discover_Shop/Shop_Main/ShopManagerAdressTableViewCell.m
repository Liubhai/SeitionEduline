//
//  ShopManagerAdressTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/7/18.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "ShopManagerAdressTableViewCell.h"
#import "SYG.h"


@implementation ShopManagerAdressTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(15 * WideEachUnit, 5 * WideEachUnit, 121 * WideEachUnit, 20 * WideEachUnit)];
    _name.font = [UIFont systemFontOfSize:13 * WideEachUnit];
    _name.textColor = [UIColor blackColor];
    _name.text = @"周星星";
    [self addSubview:_name];
    
    _adress = [[UILabel alloc]initWithFrame:CGRectMake(_name.current_x +10, _name.current_y_h + 5,MainScreenWidth -40, 20)];
    _adress.font = [UIFont systemFontOfSize:13];
    _adress.textColor = [UIColor colorWithHexString:@"#999999"];
    _adress.text = @"四川省成都市双流县航空港机场路88号";
    [self addSubview:_adress];
    
    _phone = [[UILabel alloc]initWithFrame:CGRectMake(_name.current_x_w,_name.current_y, MainScreenWidth - _name.current_x_w - 10, 20)];
    _phone.font = [UIFont systemFontOfSize:12];
    _phone.textColor = [UIColor blackColor];
    _phone.textAlignment = NSTextAlignmentRight;
    _phone.text = @"15538983107";
    [self addSubview:_phone];
    
    _line = [[UILabel alloc]initWithFrame:CGRectMake(0,_adress.current_y_h + 10 , MainScreenWidth, 1)];
    _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_line];
    
    _defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_line.frame) + 9 * WideEachUnit, 100 * WideEachUnit, 25 * WideEachUnit)];
    [_defaultButton setTitle:@" 默认地址" forState:UIControlStateNormal];
    [_defaultButton setImage:Image(@"gl未选中") forState:UIControlStateNormal];
    [_defaultButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self addSubview:_defaultButton];
    
    _editorButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, CGRectGetMaxY(_line.frame) + 9 * WideEachUnit, MainScreenWidth / 4, 25 * WideEachUnit)];
    [_editorButton setTitle:@" 编辑" forState:UIControlStateNormal];
    [_editorButton setImage:Image(@"gl编辑") forState:UIControlStateNormal];
    [_editorButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self addSubview:_editorButton];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 * 3, CGRectGetMaxY(_line.frame) + 9 * WideEachUnit, MainScreenWidth / 4, 25 * WideEachUnit)];
    [_deleteButton setTitle:@" 删除" forState:UIControlStateNormal];
    [_deleteButton setImage:Image(@"gl删除") forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    
}



@end
