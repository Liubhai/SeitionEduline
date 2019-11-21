//
//  ClassNeedTestViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/8.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "ClassNeedTestViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

@interface ClassNeedTestViewController ()

@property (strong ,nonatomic)UIView     *testView;
@property (strong ,nonatomic)UIButton   *clearButton;
@property (strong ,nonatomic)UIButton   *seleButton;
@property (strong ,nonatomic)UIButton   *resultsButton;
@property (strong ,nonatomic)UIButton   *exchangeButton;
@property (strong ,nonatomic)UILabel    *content;
@property (strong ,nonatomic)UILabel    *parsing;


@property (strong ,nonatomic)NSMutableArray *optionHeaderArray;
@property (strong ,nonatomic)NSArray        *optionsArray;
@property (strong ,nonatomic)NSMutableArray *answerArray;
@property (strong ,nonatomic)NSDictionary   *testDict;

@property (strong ,nonatomic)NSString       *typeStr;
@property (strong ,nonatomic)NSString       *rightStr;

@end

@implementation ClassNeedTestViewController

-(instancetype)initWithDict:(NSDictionary *)dict {
    if (!self) {
        self = [super init];
    }
    _dict = dict;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addClearButton];
    [self addTestView];
    [self netWorkVideoGetPopup];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    _answerArray = [NSMutableArray array];
    _optionHeaderArray = [NSMutableArray array];
}

- (void)addTestView {
    
    _testView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, MainScreenWidth - 30 * WideEachUnit, 260 * WideEachUnit)];
    _testView.backgroundColor = [UIColor whiteColor];
    _testView.center = self.view.center;
    _testView.userInteractionEnabled = YES;
    [self.view addSubview:_testView];
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
    title.text = @"请回答一下试题";
    title.layer.borderWidth = 1;
    title.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    title.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = Font(20);
    [_testView addSubview:title];
    
    //题的类型
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 60 * WideEachUnit, 100 * WideEachUnit, 15 * WideEachUnit)];
    type.text = [[_testDict dictionaryValueForKey:@"type_info"] stringValueForKey:@"question_type_title"];
    type.textColor = [UIColor colorWithHexString:@"#2069CF"];
    type.font = Font(12);
    [_testView addSubview:type];
    
    if ([type.text containsString:@"单"]) {
        _typeStr = @"1";
    } else if ([type.text containsString:@"多"]) {
        _typeStr = @"2";
    } else if ([type.text containsString:@"判断"]) {
        _typeStr = @"3";
    }
    
    //题干
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 70 * WideEachUnit, MainScreenWidth - 60, 50 * WideEachUnit)];
    content.text = [Passport filterHTML:[_testDict stringValueForKey:@"content"]];
    content.textColor = [UIColor colorWithHexString:@"#878383"];
    content.font = Font(14);
    content.numberOfLines = 0;
    [_testView addSubview:content];
    _content = content;
    [self setIntroductionText:content.text];
    
    //添加选项
    CGFloat buttonW = 140 * WideEachUnit;
    CGFloat buttonH = 30 * WideEachUnit;
    NSMutableArray *answer_value_array = [NSMutableArray array];
    NSArray *answer_options = [_testDict arrayValueForKey:@"answer_options"];
    for (int i = 0; i < answer_options.count ; i ++) {
        NSString *answer_key = [[answer_options objectAtIndex:i] stringValueForKey:@"answer_key"];
        [_optionHeaderArray addObject:answer_key];
        
        NSString *answer_value = [Passport filterHTML:[[answer_options objectAtIndex:i] stringValueForKey:@"answer_value"]];
        [answer_value_array addObject:answer_value];
    }
    
    for (int i = 0; i < answer_value_array.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit + (i % 2) * (buttonW + 30 * WideEachUnit), (i / 2) * (buttonH + 15 * WideEachUnit) + + CGRectGetMaxY(content.frame), buttonW, buttonH)];
        button.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        [button setTitle:[NSString stringWithFormat:@"%@:%@",_optionHeaderArray[i],answer_value_array[i]] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.tag = i;
        [button setTitleColor:[UIColor colorWithHexString:@"#8D8D8D"] forState:UIControlStateNormal];
        button.titleLabel.font = Font(12);
        button.titleLabel.numberOfLines = 0;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_testView addSubview:button];
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //添加结果的按钮
    UIButton *resultsButton = [[UIButton alloc] initWithFrame:CGRectMake(102 * WideEachUnit, answer_value_array.count * 30 * WideEachUnit + CGRectGetMaxY(content.frame) - 20 * WideEachUnit, buttonW, buttonH)];
    resultsButton.backgroundColor = [UIColor whiteColor];
    resultsButton.layer.cornerRadius = 5;
    [resultsButton setTitle:@"提交" forState:UIControlStateNormal];
    [resultsButton setTitleColor:BasidColor forState:UIControlStateNormal];
    resultsButton.layer.borderColor = BasidColor.CGColor;
    [resultsButton addTarget:self action:@selector(resultsButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    resultsButton.layer.borderWidth = 1;
    [_testView addSubview:resultsButton];
    _resultsButton = resultsButton;
    
    
    //添加解析
    UILabel *parsing = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit,                 CGRectGetMaxY(resultsButton.frame) + 10 * WideEachUnit, MainScreenWidth - 60, 20 * WideEachUnit)];
    parsing.text = [Passport filterHTML:[_testDict stringValueForKey:@"analyze"]];
    parsing.textColor = [UIColor colorWithHexString:@"#878383"];
    parsing.font = Font(14);
    parsing.numberOfLines = 0;
    [_testView addSubview:parsing];
    parsing.hidden = YES;
    _parsing = parsing;
    
    
    //换题的按钮
    UIButton *exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, CGRectGetMaxY(resultsButton.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 25 * WideEachUnit)];
    [exchangeButton setTitle:@"换一题" forState:UIControlStateNormal];
    exchangeButton.backgroundColor = BasidColor;
    exchangeButton.titleLabel.font = Font(12);
    exchangeButton.layer.cornerRadius = 5;
    [_testView addSubview:exchangeButton];
    [exchangeButton addTarget:self action:@selector(exchangeButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    exchangeButton.hidden = YES;
    _exchangeButton = exchangeButton;
    
    
    _testView.frame = CGRectMake(15 * WideEachUnit, 0, MainScreenWidth - 30 * WideEachUnit, CGRectGetMaxY(exchangeButton.frame) + 20 * WideEachUnit);
    _testView.center = self.view.center;
    
}

#pragma mark --- 自适应
-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _content.text = text;
    //设置label的最大行数
    _content.numberOfLines = 0;
    if ([_content.text isEqual:[NSNull null]]) {
        _content.frame = CGRectMake(15 * WideEachUnit, 70 * WideEachUnit, MainScreenWidth - 60, 50 * WideEachUnit);
        return;
    }
    
    CGRect labelSize = [text boundingRectWithSize:CGSizeMake(MainScreenWidth - 60 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 * WideEachUnit]} context:nil];
    _content.frame = CGRectMake(15 * WideEachUnit,75 * WideEachUnit,MainScreenWidth - 60 * WideEachUnit,labelSize.size.height + 10 * WideEachUnit);
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0,  0 , MainScreenWidth, MainScreenHeight)];
    clearButton.userInteractionEnabled = YES;
    if (iPhoneX) {
        clearButton.frame = CGRectMake(0, 24 + 36 * WideEachUnit * 4, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit - 36 * WideEachUnit * 4);
    }
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    _clearButton = clearButton;
}


#pragma mark --- 事件处理

- (void)removeSelfView {
    NSLog(@"dianji");
    [self.view removeFromSuperview];
}

- (void)buttonCilck:(UIButton *)button {
    _seleButton.selected = NO;
    _seleButton.backgroundColor = [UIColor whiteColor];
    button.selected = YES;
    _seleButton = button;
    button.backgroundColor = BasidColor;
    
    if ([_typeStr integerValue] == 1) {//单选
        [_answerArray removeAllObjects];
        [_answerArray addObject:[_optionHeaderArray objectAtIndex:button.tag]];
    } else if ([_typeStr integerValue] == 2) {//多选
        for (int i = 0; i < _answerArray.count ; i ++) {
            NSString *answerStr = [_answerArray objectAtIndex:i];
            if ([answerStr integerValue] == button.tag) {
                [_answerArray removeObject:answerStr];
            } else {
                [_answerArray addObject:answerStr];
            }
        }
    } else if ([_typeStr integerValue] == 3) {//判断
        [_answerArray removeAllObjects];
        [_answerArray addObject:[_optionHeaderArray objectAtIndex:button.tag]];
    }
    
    
}

- (void)resultsButtonCilck {
    if (_answerArray.count == 0) {
        [TKProgressHUD showError:@"请选择答案再提交" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    NSString *userAnswerStr = nil;
    if ([_typeStr integerValue] == 1) {
        userAnswerStr = [NSString stringWithFormat:@"%@",_answerArray[0]];
    } else if ([_typeStr integerValue] == 2) {
        
    } else if ([_typeStr integerValue] == 3) {
        userAnswerStr = [NSString stringWithFormat:@"%@",_answerArray[0]];
    }
    
    if ([_rightStr isEqualToString:userAnswerStr]) {//正确
        [_resultsButton setTitleColor:BasidColor forState:UIControlStateNormal];
        [_resultsButton setTitle:@"正确" forState:UIControlStateNormal];
        _resultsButton.layer.borderColor = BasidColor.CGColor;
        [_resultsButton setImage:Image(@"gou1") forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeSelfView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TheAnswerRight" object:@"1"];
        });
    } else {//错误
        [_resultsButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_resultsButton setTitle:@"错误" forState:UIControlStateNormal];
        [_resultsButton setImage:Image(@"chachacopy@2x") forState:UIControlStateNormal];
        _resultsButton.layer.borderColor = [UIColor orangeColor].CGColor;
        
        //具体的处理
        _parsing.text = [NSString stringWithFormat:@"答案解析：%@",[Passport filterHTML:[_testDict stringValueForKey:@"analyze"]]];
        _parsing.hidden = NO;
        _exchangeButton.hidden = NO;
        
    }
}

- (void)exchangeButtonCilck {
    [_testView removeFromSuperview];
    [self netWorkVideoGetPopup];
}

#pragma mark --- 网络请求
//配置客服按钮
- (void)netWorkVideoGetPopup {
    
    NSString *endUrlStr = YunKeTang_Video_video_getPopup;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_dict stringValueForKey:@"qid"] forKey:@"qid"];
    [mutabDict setObject:[_dict stringValueForKey:@"id"] forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _testDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_testDict isKindOfClass:[NSArray class]]) {
        } else {
            
        }
        
        [self addTestView];
        NSArray *rightArray = [_testDict arrayValueForKey:@"answer_true_option"];
        _rightStr = [NSString stringWithFormat:@"%@",rightArray[0]];
        
        NSLog(@"---%@",_testDict);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}





@end
