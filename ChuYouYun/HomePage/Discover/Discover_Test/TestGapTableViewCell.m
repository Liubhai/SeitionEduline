//
//  TestGapTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestGapTableViewCell.h"
#import "SYG.h"

@interface TestGapTableViewCell()<UITextFieldDelegate> {
    
}
@end

@implementation TestGapTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}

-(void)layoutSubview{
    [super layoutSubviews];
}

//初始化控件
-(void)initLayuot{
    
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.answerTextField];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerTextFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
//    [self.contentView addSubview:self.answerView];
    
    
//    _answerTextField = [[UITextField alloc]initWithFrame:CGRectMake(50 * WideEachUnit, 25 * WideEachUnit, MainScreenWidth - 70 * WideEachUnit, 36 * WideEachUnit)];
//    _answerTextField.font = [UIFont systemFontOfSize:15 * WideEachUnit];
//    _answerTextField.layer.cornerRadius = 10 * WideEachUnit;
//    _answerTextField.delegate = self;
//    _answerTextField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    _answerTextField.layer.borderWidth = 1 * WideEachUnit;
//    _answerTextField.textColor = [UIColor blackColor];
//    [self addSubview:_answerTextField];
}

#pragma mark --- 初始化
-(UITextField *)answerTextField{
    
    if (!_answerTextField) {
        _answerTextField = [[UITextField alloc]initWithFrame:CGRectMake(50 * WideEachUnit, 25 * WideEachUnit, MainScreenWidth - 70 * WideEachUnit, 36 * WideEachUnit)];
        _answerTextField.font = [UIFont systemFontOfSize:15 * WideEachUnit];
        _answerTextField.layer.cornerRadius = 10 * WideEachUnit;
        _answerTextField.delegate = self;
        _answerTextField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _answerTextField.layer.borderWidth = 1 * WideEachUnit;
        _answerTextField.textColor = [UIColor blackColor];
    }
    return _answerTextField;
}

-(UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 25 * WideEachUnit, 40 * WideEachUnit, 36 * WideEachUnit)];
        _numberLabel.font = Font(16 * WideEachUnit);
        _numberLabel.backgroundColor = [UIColor whiteColor];
        _numberLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
        [self.answerView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (UIView *)answerView {
    if (!_answerView) {
        _answerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
    }
    return _answerView;
}

#pragma mark --- 由外面传进来的数组决定显示添加多少个输入框
- (void)dataWithArray:(NSArray *)array WithNumber:(NSInteger)indexPath {
    //先要移除子视图
//    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSLog(@"----%@",array);
    _numberLabel.text = [NSString stringWithFormat:@"%ld、",indexPath + 1];
    if ([[array objectAtIndex:indexPath] integerValue] == 100) {//说明是原始答案
        _answerTextField.text = @"";
    } else {
        _answerTextField.text = [array objectAtIndex:indexPath];
    }
    _indexPath = indexPath;
    
    
}

#pragma mark -- 代理
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"---%@",textField.text);
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerTextFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)answerTextFieldTextChange:(NSNotification *)not {
    NSLog(@"%@",_answerTextField);
    NSLog(@"text---%@",_answerTextField.text);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_answerTextField.text forKey:@"text"];
    [dict setObject:[NSString stringWithFormat:@"%ld",_indexPath] forKey:@"number"];
    NSLog(@"%@",dict);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestGapTableViewCellGetAnswerAndNumber" object:dict];
}


#pragma mark --- 通知




@end
