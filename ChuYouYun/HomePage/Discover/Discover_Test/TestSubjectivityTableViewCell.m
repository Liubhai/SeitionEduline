//
//  TestSubjectivityTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestSubjectivityTableViewCell.h"
#import "SYG.h"

@implementation TestSubjectivityTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}

//初始化控件
-(void)initLayuot{
    [self.contentView addSubview:self.answerTextView];
}

#pragma mark --- 初始化
-(UITextView *)answerTextView{
    
    if (!_answerTextView) {
        _answerTextView = [[UITextView alloc]initWithFrame:CGRectMake(20 * WideEachUnit, 20 * WideEachUnit, MainScreenWidth - 40 * WideEachUnit, 190 * WideEachUnit)];
        _answerTextView.font = [UIFont systemFontOfSize:15 * WideEachUnit];
        _answerTextView.layer.cornerRadius = 5 * WideEachUnit;
        _answerTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _answerTextView.layer.borderWidth = 1 * WideEachUnit;
        _answerTextView.textColor = [UIColor blackColor];
    }
    return _answerTextView;
}

@end
