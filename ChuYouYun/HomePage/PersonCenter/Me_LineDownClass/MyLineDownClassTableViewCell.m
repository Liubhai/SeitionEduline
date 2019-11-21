//
//  MyLineDownClassTableViewCell.m
//  YunKeTang
//
//  Created by IOS on 2019/3/1.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "MyLineDownClassTableViewCell.h"
#import "SYG.h"


@implementation MyLineDownClassTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 10 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit)];
    _photoView.backgroundColor = [UIColor redColor];
    [self addSubview:_photoView];
    
    //标题
    _lineClass = [[UILabel alloc] initWithFrame:CGRectMake(90 * WideEachUnit,10 * WideEachUnit,MainScreenWidth - 155 * WideEachUnit, 16 * WideEachUnit)];
    [self addSubview:_lineClass];
    _lineClass.text = @"使用一应";
    _lineClass.font = Font(16 * WideEachUnit);
    _lineClass.textColor = [UIColor colorWithHexString:@"#575757"];
    
    //价格
    _price = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit,10 * WideEachUnit,70 * WideEachUnit, 15 * WideEachUnit)];
    [self addSubview:_price];
    _price.text = @"使用一应";
    _price.font = Font(15 * WideEachUnit);
    _price.textColor = [UIColor colorWithHexString:@"#575757"];
    _price.textColor = [UIColor orangeColor];
    
    //名字
    _teacher = [[UILabel alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 35 * WideEachUnit,MainScreenWidth - 180 * WideEachUnit, 12 * WideEachUnit)];
    [self addSubview:_teacher];
    _teacher.font = Font(11 * WideEachUnit);
    _teacher.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _teacher.text = @"你是你上午我问问我我等你过个";
    
    _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(_teacher.left, _teacher.bottom + 11, _teacher.width, _teacher.height)];
    _sexLabel.font = Font(11 * WideEachUnit);
    _sexLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    [self addSubview:_sexLabel];
    
    //添加线
    UILabel *lineTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, 80 * WideEachUnit, MainScreenWidth, 1)];
    lineTwo.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineTwo];
    
    _mapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 115 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    _mapIcon.backgroundColor = [UIColor whiteColor];
    _mapIcon.image = Image(@"dingwei");
    [self addSubview:_mapIcon];
    
    
    _adress = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 100 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_adress];
    _adress.font = Font(13 * WideEachUnit);
    _adress.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _adress.text = @"你是你上午我问问我我等你过个";
    
    
    _tel = [[UILabel alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 130 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_tel];
    _tel.font = Font(13 * WideEachUnit);
    _tel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    //添加线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 160 * WideEachUnit, MainScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:line];
    
    _orderStaus = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 170 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_orderStaus];
    _orderStaus.font = Font(13 * WideEachUnit);
    _orderStaus.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _orderStaus.text = @"你是你上午我问问我我等你过个";
    _orderStaus.hidden = YES;
    
    
    _completeButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 170 * WideEachUnit, 50 * WideEachUnit, 20 * WideEachUnit)];
    _completeButton.backgroundColor = [UIColor whiteColor];
    [_completeButton setTitle:@"已完成" forState:UIControlStateNormal];
    _completeButton.titleLabel.font = Font(10);
    _completeButton.layer.cornerRadius = 3;
    _completeButton.layer.borderWidth = 1;
    _completeButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:_completeButton];
    
    
    _orderTime = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 185 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    [self addSubview:_orderTime];
    _orderTime.font = Font(13 * WideEachUnit);
    _orderTime.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _orderTime.text = @"你是你上午我问问我我等你过个";
    
    
    //机构按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 230 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit)];
    _rightButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_rightButton];
    
    
    
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)typeStr{
    
    [_photoView sd_setImageWithURL:[NSURL URLWithString:[dict stringValueForKey:@"imageurl"]] placeholderImage:Image(@"站位图")];
    _lineClass.text = [dict stringValueForKey:@"course_name"];
    _teacher.text = [NSString stringWithFormat:@"讲师：%@",[dict stringValueForKey:@"teacher_name"]];
    _teacher.frame =CGRectMake(90 * WideEachUnit, 40 * WideEachUnit,MainScreenWidth - 180 * WideEachUnit, 20 * WideEachUnit);
    _price.text = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"t_price"]];
    _adress.text = [NSString stringWithFormat:@"授课地点：%@",[dict stringValueForKey:@"address"]];
    if ([dict stringValueForKey:@"address"] == nil ||[[dict stringValueForKey:@"address"] isEqualToString:@""] ) {
        _adress.text = @"授课地点：暂无";
    }
    _tel.text = [NSString stringWithFormat:@"联系方式：%@",[dict stringValueForKey:@"tphone"]];
    if ([typeStr  integerValue] == 1) {
        _orderStaus.text = @"支付状态：未完成";
        _completeButton.backgroundColor = BasidColor;
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeButton setTitle:@"确认完成" forState:UIControlStateNormal];
    } else if ([typeStr  integerValue] == 2){
        _orderStaus.text = @"支付状态：已完成";
        [_completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _completeButton.backgroundColor = [UIColor whiteColor];
        [_completeButton setTitle:@"已完成" forState:UIControlStateNormal];
        _completeButton.backgroundColor = [UIColor grayColor];
        _completeButton.userInteractionEnabled = NO;
    }
    
    if ([[dict stringValueForKey:@"learn_status"] integerValue] == 1) {
        [_completeButton setTitle:@"待讲师确认" forState:UIControlStateNormal];
        _completeButton.userInteractionEnabled = NO;
        _completeButton.backgroundColor = [UIColor whiteColor];
        [_completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _completeButton.layer.borderWidth = 1;
    } else {
        [_completeButton setTitle:@"确认完成" forState:UIControlStateNormal];
        _completeButton.userInteractionEnabled = YES;
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeButton.layer.borderWidth = 0;
//        _completeButton.hidden = YES;
    }
    
    CGFloat completeWidth = [_completeButton.titleLabel.text sizeWithFont:_completeButton.titleLabel.font].width + 4;
    _completeButton.frame = CGRectMake(MainScreenWidth - (10 + completeWidth) * WideEachUnit, 170 * WideEachUnit, completeWidth * WideEachUnit, 20 * WideEachUnit);
    _orderTime.text = [NSString stringWithFormat:@"订单时间：%@",[Passport formatterDate:[dict stringValueForKey:@"order_time"]]];
}


- (void)dataSourceWithTeacher:(NSDictionary *)dict WithType:(NSString *)typeStr {
    [_photoView sd_setImageWithURL:[NSURL URLWithString:[dict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
    _lineClass.text = [dict stringValueForKey:@"course_name"];
    _teacher.text = [NSString stringWithFormat:@"学生：%@",[dict stringValueForKey:@"student_name"]];
    _sexLabel.text = [NSString stringWithFormat:@"性别:%@",[[dict stringValueForKey:@"student_sex"] integerValue] == 1 ? @"男" : @"女"];
    _price.text = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"price"]];
    _adress.text = [NSString stringWithFormat:@"授课地点：%@",[dict stringValueForKey:@"address"]];
    if ([dict stringValueForKey:@"address"] == nil ||[[dict stringValueForKey:@"address"] isEqualToString:@""] ) {
        _adress.text = @"授课地点：暂无";
    }

    if ([dict stringValueForKey:@"student_phone"] == nil || [[dict stringValueForKey:@"student_phone"] isEqualToString:@""]) {
        if ([dict stringValueForKey:@"student_email"] == nil) {
            _tel.text = @"联系方式：";
        } else {
            _tel.text = [NSString stringWithFormat:@"联系方式：%@",[dict stringValueForKey:@"student_email"]];
        }
    } else {
        _tel.text = [NSString stringWithFormat:@"联系方式：%@",[dict stringValueForKey:@"student_phone"]];
    }
    if ([typeStr  integerValue] == 1) {
        _orderStaus.text = @"支付状态：未完成";
        _completeButton.backgroundColor = BasidColor;
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeButton setTitle:@"确认完成" forState:UIControlStateNormal];
    } else if ([typeStr  integerValue] == 2){
        _orderStaus.text = @"支付状态：已完成";
        [_completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _completeButton.backgroundColor = [UIColor whiteColor];
        [_completeButton setTitle:@"已完成" forState:UIControlStateNormal];
        _completeButton.backgroundColor = [UIColor grayColor];
        _completeButton.userInteractionEnabled = NO;
    }
    
    if ([[dict stringValueForKey:@"learn_status"] integerValue] == 0) {
//        [_completeButton setTitle:@"等待确认" forState:UIControlStateNormal];
//        _completeButton.userInteractionEnabled = NO;
//        _completeButton.backgroundColor = [UIColor grayColor];
//        [_completeButton setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        _orderStaus.text = @"支付状态：未完成";
        _completeButton.backgroundColor = [UIColor whiteColor];
        [_completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_completeButton setTitle:@"等待学生完成" forState:UIControlStateNormal];
        _completeButton.userInteractionEnabled = NO;
        _completeButton.layer.borderWidth = 1;
    } else {
//        [_completeButton setTitle:@"确认完成" forState:UIControlStateNormal];
//        _completeButton.userInteractionEnabled = YES;
//        [_completeButton setTitleColor:BasidColor forState:UIControlStateNormal];
        
        _orderStaus.text = @"支付状态：已完成";
        [_completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _completeButton.backgroundColor = [UIColor whiteColor];
        [_completeButton setTitle:@"确认完成" forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completeButton.layer.borderWidth = 0;
        _completeButton.userInteractionEnabled = YES;
        _completeButton.backgroundColor = BasidColor;
    }
    CGFloat completeWidth = [_completeButton.titleLabel.text sizeWithFont:_completeButton.titleLabel.font].width + 4;
    _completeButton.frame = CGRectMake(MainScreenWidth - (10 + completeWidth) * WideEachUnit, 170 * WideEachUnit, completeWidth * WideEachUnit, 20 * WideEachUnit);
    _orderTime.text = [NSString stringWithFormat:@"订单时间：%@",[Passport formatterDate:[dict stringValueForKey:@"order_time"]]];
}





@end
