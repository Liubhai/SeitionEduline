//
//  TestClassMainTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestClassMainTableViewCell.h"
#import "SYG.h"


@implementation TestClassMainTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initLayuotFuture];
    }
    return self;
}

//初始化控件
-(void)initLayuot{
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 16 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _titleLabel.text = @"2014物业管理师考试参考答案";
    _titleLabel.font = Font(15 * WideEachUnit);
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_titleLabel];
    
    //时间
    _personLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 46 * WideEachUnit, 120 * WideEachUnit, 13 * WideEachUnit)];
    [self addSubview:_personLabel];
    _personLabel.text = @"更新时间：2016-10-10";
    _personLabel.font = Font(13 * WideEachUnit);
    _personLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    
    _subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_personLabel.frame) + 50 * WideEachUnit, 46 * WideEachUnit,120 *  WideEachUnit, 13 * WideEachUnit)];
    [self addSubview:_subjectLabel];
    _subjectLabel.text = @"更新时间：2016-10-10";
    _subjectLabel.font = Font(13 * WideEachUnit);
    _subjectLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    _classInfo = dict;
    if ([[dict objectForKey:@"price"] integerValue] == 0) {
        _typeLabel.text = @"免费";
        _typeLabel.textColor = BasidColor;
        _typeLabel.layer.borderColor = BasidColor.CGColor;
        [_doButton setTitle:@"开始考试" forState:0];
    } else {
        if ([[dict objectForKey:@"is_buy"] boolValue]) {
            _typeLabel.text = @"已解锁";
            _typeLabel.textColor = [UIColor greenColor];
            _typeLabel.layer.borderColor = [UIColor greenColor].CGColor;
            [_doButton setTitle:@"开始考试" forState:0];
        } else {
            _typeLabel.text = @"收费";
            _typeLabel.textColor = RGBHex(0xDF0500);
            _typeLabel.layer.borderColor = RGBHex(0xDF0500).CGColor;
            [_doButton setTitle:[NSString stringWithFormat:@"¥%@ 解锁",[dict objectForKey:@"price"]] forState:0];
        }
    }
    CGFloat typeWidth = [_typeLabel.text sizeWithFont:_typeLabel.font].width + 4;
    [_typeLabel setWidth:typeWidth];
    [_titleLabel setLeft:_typeLabel.right + 2];
    _titleLabel.text = [dict stringValueForKey:@"exams_paper_title"];
    _personLabel.text = [NSString stringWithFormat:@"参考人数:  %@",[dict stringValueForKey:@"exams_count"]];
    _subjectLabel.text = [NSString stringWithFormat:@"题数:  %@",[dict stringValueForKey:@"questions_count"]];
    CGFloat personWidth = [_personLabel.text sizeWithFont:_personLabel.font].width + 4;
    CGFloat subjectWidth = [_subjectLabel.text sizeWithFont:_subjectLabel.font].width + 4;
    [_personLabel setWidth:personWidth];
    [_subjectIcon setLeft:_personLabel.right + 20];
    [_subjectLabel setLeft:_subjectIcon.right + 1];
    [_subjectLabel setWidth:subjectWidth];
}

//初始化控件
-(void)initLayuotFuture{
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 25, 13)];
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.borderWidth = 1;
    _typeLabel.clipsToBounds = YES;
    _typeLabel.layer.cornerRadius = 2;
    _typeLabel.font = SYSTEMFONT(10);
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_typeLabel];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeLabel.right + 2, 15, MainScreenWidth - 15 - 88 - (_typeLabel.right + 2), 18)];
    _titleLabel.text = @"2014物业管理师考试参考答案";
    _titleLabel.font = Font(17);
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_titleLabel];
    _typeLabel.centerY = _titleLabel.centerY;
    
    _personIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_typeLabel.left, 0, 17, 17)];
    _personIcon.image = Image(@"人数icon");
    [self addSubview:_personIcon];
    
    //时间
    _personLabel = [[UILabel alloc] initWithFrame:CGRectMake(_personIcon.right + 1, _titleLabel.bottom + 12, 120, 14)];
    [self addSubview:_personLabel];
    _personLabel.text = @"更新时间：2016-10-10";
    _personLabel.font = Font(14);
    _personLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    _personIcon.centerY = _personLabel.centerY;
    
    _subjectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_personLabel.right + 20, 0, 17, 17)];
    _subjectIcon.image = Image(@"考题 icon");
    _subjectIcon.centerY = _personIcon.centerY;
    [self addSubview:_subjectIcon];
    
    _subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(_subjectIcon.right + 1, _personLabel.top,120 *  WideEachUnit, 14)];
    [self addSubview:_subjectLabel];
    _subjectLabel.text = @"更新时间：2016-10-10";
    _subjectLabel.font = Font(14);
    _subjectLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    _doBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 88, 15, 99, 41)];
    _doBackImage.image = Image(@"按钮");
    _doBackImage.clipsToBounds = YES;
    _doBackImage.contentMode = UIViewContentModeScaleAspectFill;
    _doBackImage.layer.masksToBounds = YES;
    _doBackImage.layer.cornerRadius = 41 / 2.0;
    [self addSubview:_doBackImage];
    
    _doButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 88, 15, 88, 27)];
    [_doButton setTitleColor:[UIColor whiteColor] forState:0];
    _doButton.clipsToBounds = YES;
    _doButton.layer.masksToBounds = YES;
    _doButton.layer.cornerRadius = 27 / 2.0;
    [_doButton setTitle:@"开始考试" forState:0];
    _doButton.titleLabel.font = SYSTEMFONT(14);
    [_doButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    _doButton.centerY = 75 * HigtEachUnit / 2.0;
    _doBackImage.center = _doButton.center;
    [self addSubview:_doButton];
}

- (void)testAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(doButtonClick:cellInfo:)]) {
        [_delegate doButtonClick:self cellInfo:_classInfo];
    }
}

@end
