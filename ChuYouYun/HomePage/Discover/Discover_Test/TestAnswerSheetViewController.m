//
//  TestAnswerSheetViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/27.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestAnswerSheetViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "TestResultViewController.h"

#define buttonW 36 * WideEachUnit
#define buttonH 36 * WideEachUnit
#define oneAndLastSpace 20 * WideEachUnit
#define space 39 * WideEachUnit

@interface TestAnswerSheetViewController ()

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UITableView  *tableView;
@property (strong ,nonatomic)UIButton     *commitButton;

//时间相关
@property (strong ,nonatomic)UILabel          *timeLabel;//时间的文本
@property (strong, nonatomic)NSTimer          *timer;
@property (assign ,nonatomic)NSInteger         allTime;

//数据分类
@property (strong ,nonatomic)NSMutableArray   *multipleArray;//单选
@property (strong ,nonatomic)NSMutableArray   *moreMultipleArray;//多选
@property (strong ,nonatomic)NSMutableArray   *gapArray;//填空
@property (strong ,nonatomic)NSMutableArray   *judgeArray;//判断
@property (strong ,nonatomic)NSMutableArray   *subjectivityArray;//主观

@property (strong ,nonatomic)NSMutableDictionary *mangerAnswerDict;//处理答案

//单选视图
@property (strong ,nonatomic)UIView       *multipleView;
//多选视图
@property (strong ,nonatomic)UIView       *moreMultipleView;
//判断视图
@property (strong ,nonatomic)UIView       *judgeView;
//填空视图
@property (strong ,nonatomic)UIView       *gapView;
//主观视图
@property (strong ,nonatomic)UIView       *subjectivityView;


@property (strong ,nonatomic)NSMutableArray      *dataArray;


@end

@implementation TestAnswerSheetViewController

#pragma mark --- 懒加载
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//处理答案
-(NSMutableDictionary *)mangerAnswerDict {
    if (!_mangerAnswerDict) {
        _mangerAnswerDict = [NSMutableDictionary dictionary];
    }
    return _mangerAnswerDict;
}

-(UIView *)multipleView {
    if (!_multipleView) {
        _multipleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
        [_scrollView addSubview:_multipleView];
    }
    return _multipleView;
}

-(UIView *)moreMultipleView {
    if (!_moreMultipleView) {
        _moreMultipleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
        [_scrollView addSubview:_moreMultipleView];
    }
    return _moreMultipleView;
}

-(UIView *)judgeView {
    if (!_judgeView) {
        _judgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
        [_scrollView addSubview:_judgeView];
    }
    return _judgeView;
}

-(UIView *)gapView {
    if (!_gapView) {
        _gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
        [_scrollView addSubview:_subjectivityView];
    }
    return _gapView;
}

-(UIView *)subjectivityView {
    if (!_subjectivityView) {
        _subjectivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
    }
    return _subjectivityView;
}




-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self initialization];//初始化
    [self addNav];
//    [self addScrollView];
    //    [self addTableHeaderView];
    [self addScrollView];
    [self addMultipleView];
    [self addMoreMultipleView];
    [self addJudgeView];
    [self addGapView];
    [self addSubjectivityView];
    [self addCommitButton];
    [self timeManger];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
//    _dataArray = @[@[@"1",@"2"],@[@"1",@"2",@"3",@"4",@"5",@"6"]];
}
- (void)initialization {//初始化
    [self.dataArray addObjectsFromArray:_multipleUserArray];
    [self.dataArray addObjectsFromArray:_moreMultipleUserArray];
    [self.dataArray addObjectsFromArray:_judgeUserArray];
    [self.dataArray addObjectsFromArray:_gapUserArray];
    [self.dataArray addObjectsFromArray:_subjectivityUserArray];
    
    
    _multipleArray = [NSMutableArray array];
    _moreMultipleArray = [NSMutableArray array];
    _gapArray = [NSMutableArray array];
    _judgeArray = [NSMutableArray array];
    _subjectivityArray = [NSMutableArray array];
    
    _multipleArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"1"];
    _moreMultipleArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"2"];
    _judgeArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"3"];
    _gapArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"4"];
    _subjectivityArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"5"];
    
}

- (void)getNstioncation {
    //从课时进去考试的时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTestType:) name:@"NotificationVideoGotoTest" object:nil];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25+MACRO_UI_STATUSBAR_ADD_HEIGHT,MainScreenWidth - 100, 30)];
    WZLabel.text = @"时间";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    _timeLabel = WZLabel;
    [_timeLabel setTextColor:[UIColor whiteColor]];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT - 1,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 定时器

- (void)timeManger {
    if ([_examType integerValue] == 3) {//查看模式的时候就不用定时间了
        _timeLabel.text = @"在线考试";
        return;
    }
    
    if ([_contentStr isEqualToString:@"continue"] || [_againStr isEqualToString:@"again"]) {//说明是再次挑战或者是继续答题
        if ([[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] == 0) {//没有限制
            [self addTimePass];
        } else {
            _allTime = [[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] * 60;//转为秒
            [self addTimePass];
        }
    } else {
        if ([[_testDict stringValueForKey:@"reply_time"] integerValue] == 0) {//没有限制
            [self addTimePass];
        } else {
            _allTime = [[_testDict stringValueForKey:@"reply_time"] integerValue] * 60;//转为秒
            [self addTimePass];
        }
    }

}

- (void)addTimePass {
//    if ([[_testDict stringValueForKey:@"reply_time"] integerValue] == 0) {//没有限制
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePassWithOut) userInfo:nil repeats:YES];
//    } else {//有限制
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
//    }
    
    if ([_contentStr isEqualToString:@"continue"] || [_againStr isEqualToString:@"again"]) {
        if ([[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] == 0) {//没有限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePassWithOut) userInfo:nil repeats:YES];
        } else {//有限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
        }
    } else {
        if ([[_testDict stringValueForKey:@"reply_time"] integerValue] == 0) {//没有限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePassWithOut) userInfo:nil repeats:YES];
        } else {//有限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
        }
    }

}
- (void)timePast {
    _passTimeIng ++;
    if (_allTime == 0 || _allTime < 0) {
        return;
    }
    NSInteger endTime = _allTime - _passTimeIng;
    NSInteger endHour = endTime / 3600;
    NSInteger endMin = (endTime - endHour * 3600) / 60;
    NSInteger endSecond = endTime % 60;
    NSString *endString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",endHour,endMin,endSecond];
    _timeLabel.text = endString;
    
    if (_allTime < _passTimeIng) {
        _timeLabel.text = @"00:00:00";
        [_timer invalidate];
        self.timer = nil;
        [self netWorkExamsSubmitExams];
    }
    
    if ([_timeLabel.text isEqualToString:@"00:00:00"]) {
        [_timer invalidate];
        self.timer = nil;
        //被迫交卷
        [self netWorkExamsSubmitExams];
    }
}

//没有限制的时候的时间规定
- (void)timePassWithOut {
    _passTimeIng ++;
    NSInteger BeginTime = _passTimeIng;
    NSInteger benginHour = BeginTime / 3600;
    NSInteger benginMin = (BeginTime - benginHour * 3600) / 60;
    NSInteger benginSecond = BeginTime % 60;
    NSString *benginString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",benginHour,benginMin,benginSecond];
    _timeLabel.text = benginString;
}


#pragma mark --- 提交按钮
- (void)addCommitButton {
    _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, MainScreenHeight - 60 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 40 * WideEachUnit)];
    [_commitButton setTitle:@"交卷" forState:UIControlStateNormal];
    _commitButton.backgroundColor = BasidColor;
    [_commitButton addTarget:self action:@selector(commitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitButton];
    
    if ([_examType integerValue] == 3) {//查看模式的时候
        _commitButton.hidden = YES;
    }
    
    //假如时间时间到了就直接调用
    if ([_timeIsOver isEqualToString:@"timeOver"]) {
//        [self commitButtonCilck];
        [self netWorkExamsSubmitExams];
    }
}


#pragma mark --- 添加全局的滚动试图
- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 80 * WideEachUnit)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];

}

#pragma mark --- 添加各种视图

- (void)addMultipleView {
    
    if (_multipleUserArray.count == 0) {
        self.multipleView.frame = CGRectMake(0, 0, MainScreenWidth, 0);
        [_scrollView addSubview:self.multipleView];
        return;
    }
    self.multipleView.backgroundColor = [UIColor whiteColor];
    if (_multipleUserArray.count % 5 == 0 ) {//能整除
        self.multipleView.frame = CGRectMake(0, 0, MainScreenWidth, 40 * WideEachUnit + _multipleUserArray.count / 5 * 56 * WideEachUnit);
    } else {//不能整除
         self.multipleView.frame = CGRectMake(0, 0, MainScreenWidth, 40 * WideEachUnit + (_multipleUserArray.count / 5 + 1) * 56 * WideEachUnit);
    }
    [_scrollView addSubview:self.multipleView];
    
    if (_multipleUserArray.count == 0) {
        _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(self.multipleView.frame) + 5 * WideEachUnit);
    }
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20 * WideEachUnit)];
    title.text = @"    单选题";
    title.font = Font(12 * WideEachUnit);
    title.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.multipleView addSubview:title];
    
    for (int i = 0; i < _multipleUserArray.count ; i ++ ) {
        UIButton *indexButton = [[UIButton alloc] initWithFrame:CGRectMake(oneAndLastSpace + (i % 5) * (buttonW + space),20 * WideEachUnit + oneAndLastSpace + (i / 5) * (buttonH + oneAndLastSpace), buttonW, buttonH)];
        indexButton.layer.cornerRadius = buttonW / 2;
        indexButton.layer.masksToBounds = YES;

        if ([[_multipleUserArray objectAtIndex:i] integerValue] == 100) {//没有回答
            indexButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        } else {//回答的了
            indexButton.backgroundColor = BasidColor;
        }
        [indexButton setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        indexButton.tag = 100 * 1 + i;
        //        indexButton.tag = [[[_dataArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        [indexButton addTarget:self action:@selector(indexButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [self.multipleView addSubview:indexButton];
    }
}

- (void)addMoreMultipleView {
    if (_moreMultipleUserArray.count == 0) {
        self.moreMultipleView.frame = CGRectMake(0, CGRectGetMaxY(self.multipleView.frame), MainScreenWidth, 0);
        [_scrollView addSubview:self.moreMultipleView];
        return;
    }
    self.moreMultipleView.backgroundColor = [UIColor whiteColor];
    if (_moreMultipleUserArray.count % 5 == 0 ) {//能整除
        self.moreMultipleView.frame = CGRectMake(0, CGRectGetMaxY(self.multipleView.frame), MainScreenWidth, 40 * WideEachUnit + _moreMultipleUserArray.count / 5 * 56 * WideEachUnit);
        NSLog(@"%lf",CGRectGetMaxY(self.multipleView.frame));
        
    } else {//不能整除
        self.moreMultipleView.frame = CGRectMake(0, CGRectGetMaxY(self.multipleView.frame), MainScreenWidth, 40 * WideEachUnit + (_moreMultipleUserArray.count / 5 + 1) * 56 * WideEachUnit);
    }
    [_scrollView addSubview:self.moreMultipleView];
    
    if (_moreMultipleUserArray.count == 0) {
        _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(self.moreMultipleView.frame) + 5 * WideEachUnit);
    }
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20 * WideEachUnit)];
    title.text = @"    多选题";
    title.font = Font(12 * WideEachUnit);
    title.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.moreMultipleView addSubview:title];
    
    for (int i = 0; i < _moreMultipleUserArray.count ; i ++ ) {
        UIButton *indexButton = [[UIButton alloc] initWithFrame:CGRectMake(oneAndLastSpace + (i % 5) * (buttonW + space),20 * WideEachUnit + oneAndLastSpace + (i / 5) * (buttonH + oneAndLastSpace), buttonW, buttonH)];
        indexButton.layer.cornerRadius = buttonW / 2;
        indexButton.layer.masksToBounds = YES;
        NSArray *moreArray = [_moreMultipleUserArray objectAtIndex:i];
        BOOL isAnswer = NO;
        for (int k = 0 ; k < moreArray.count ; k ++) {
            if ([[moreArray objectAtIndex:k] integerValue] == 100) {
                
            } else {
                isAnswer = YES;
            }
        }
        if (!isAnswer) {//没有回答
            indexButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        } else {//回答的了
            indexButton.backgroundColor = BasidColor;
        }
        [indexButton setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        indexButton.tag = 100 * 2 + i;
        //        indexButton.tag = [[[_dataArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        [indexButton addTarget:self action:@selector(indexButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [self.moreMultipleView addSubview:indexButton];
    }
    
}

- (void)addJudgeView {
    if (_judgeUserArray.count == 0) {
        self.judgeView.frame = CGRectMake(0, CGRectGetMaxY(self.moreMultipleView.frame), MainScreenWidth, 0);
        [_scrollView addSubview:self.judgeView];
        return;
    }
    self.judgeView.backgroundColor = [UIColor whiteColor];
    if (_judgeUserArray.count % 5 == 0 ) {//能整除
        self.judgeView.frame = CGRectMake(0, CGRectGetMaxY(self.moreMultipleView.frame), MainScreenWidth, 40 * WideEachUnit + _judgeUserArray.count / 5 * 56 * WideEachUnit);
    } else {//不能整除
        self.judgeView.frame = CGRectMake(0, CGRectGetMaxY(self.moreMultipleView.frame), MainScreenWidth, 40 * WideEachUnit + (_judgeUserArray.count / 5 + 1) * 56 * WideEachUnit);
    }
    [_scrollView addSubview:self.judgeView];
    if (_judgeUserArray.count == 0) {
        _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(self.judgeView.frame) + 5 * WideEachUnit);
    }
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20 * WideEachUnit)];
    title.text = @"    判断题";
    title.font = Font(12 * WideEachUnit);
    title.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.judgeView addSubview:title];
    
    for (int i = 0; i < _judgeUserArray.count ; i ++ ) {
        UIButton *indexButton = [[UIButton alloc] initWithFrame:CGRectMake(oneAndLastSpace + (i % 5) * (buttonW + space),20 * WideEachUnit + oneAndLastSpace + (i / 5) * (buttonH + oneAndLastSpace), buttonW, buttonH)];
        indexButton.layer.cornerRadius = buttonW / 2;
        indexButton.layer.masksToBounds = YES;
        if ([[_judgeUserArray objectAtIndex:i] integerValue] == 100) {//没有回答
            indexButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        } else {//回答的了
            indexButton.backgroundColor = BasidColor;
        }
        [indexButton setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        indexButton.tag = 3 * 100 + i;
        //        indexButton.tag = [[[_dataArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        [indexButton addTarget:self action:@selector(indexButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [self.judgeView addSubview:indexButton];
    }
    
}

- (void)addGapView {
    if (_gapUserArray.count == 0) {
        self.gapView.frame = CGRectMake(0, CGRectGetMaxY(self.judgeView.frame), MainScreenWidth, 0);
        [_scrollView addSubview:self.gapView];
        return;
    }
    self.gapView.backgroundColor = [UIColor whiteColor];
    if (_gapUserArray.count % 5 == 0 ) {//能整除
        self.gapView.frame = CGRectMake(0, CGRectGetMaxY(self.judgeView.frame), MainScreenWidth, 40 * WideEachUnit + _gapUserArray.count / 5 * 56 * WideEachUnit);
    } else {//不能整除
        self.gapView.frame = CGRectMake(0, CGRectGetMaxY(self.judgeView.frame), MainScreenWidth, 40 * WideEachUnit + (_gapUserArray.count / 5 + 1) * 56 * WideEachUnit);
    }
    [_scrollView addSubview:self.gapView];
    if (_subjectivityUserArray.count == 0) {
           _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(self.gapView.frame) + 5 * WideEachUnit);
    }

    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20 * WideEachUnit)];
    title.text = @"    填空题";
    title.font = Font(12 * WideEachUnit);
    title.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.gapView addSubview:title];
    
    for (int i = 0; i < _gapUserArray.count ; i ++ ) {
        UIButton *indexButton = [[UIButton alloc] initWithFrame:CGRectMake(oneAndLastSpace + (i % 5) * (buttonW + space),20 * WideEachUnit + oneAndLastSpace + (i / 5) * (buttonH + oneAndLastSpace), buttonW, buttonH)];
        indexButton.layer.cornerRadius = buttonW / 2;
        indexButton.layer.masksToBounds = YES;
        NSArray *moreArray = [_gapUserArray objectAtIndex:i];
        BOOL isAnswer = NO;
        for (int k = 0 ; k < moreArray.count ; k ++) {
            if ([[moreArray objectAtIndex:k] integerValue] == 100) {
                
            } else {
                isAnswer = YES;
            }
        }
        if (!isAnswer) {//没有回答
            indexButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        } else {//回答的了
            indexButton.backgroundColor = BasidColor;
        }
        [indexButton setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        indexButton.tag = 4 * 100 + i;
        //        indexButton.tag = [[[_dataArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        [indexButton addTarget:self action:@selector(indexButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [self.gapView addSubview:indexButton];
    }
}
- (void)addSubjectivityView {
    if (_subjectivityUserArray.count == 0) {
        self.subjectivityView.frame = CGRectMake(0, CGRectGetMaxY(self.gapView.frame), MainScreenWidth, 0);
        [_scrollView addSubview:self.subjectivityView];
        _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(self.gapView.frame) + 10);
        return;
    }
    self.gapView.backgroundColor = [UIColor whiteColor];
    if (_subjectivityUserArray.count % 5 == 0 ) {//能整除
        self.subjectivityView.frame = CGRectMake(0, CGRectGetMaxY(self.gapView.frame), MainScreenWidth, 40 * WideEachUnit + _subjectivityUserArray.count / 5 * 56 * WideEachUnit);
    } else {//不能整除
        self.subjectivityView.frame = CGRectMake(0, CGRectGetMaxY(self.gapView.frame), MainScreenWidth, 40 * WideEachUnit + (_subjectivityUserArray.count / 5 + 1) * 56 * WideEachUnit);
    }
    [_scrollView addSubview:self.subjectivityView];
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(self.subjectivityView.frame) + 5 * WideEachUnit);
    
    //添加标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20 * WideEachUnit)];
    title.text = @"    主观题";
    title.font = Font(12 * WideEachUnit);
    title.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self.subjectivityView addSubview:title];
    
    for (int i = 0; i < _subjectivityUserArray.count ; i ++ ) {
        UIButton *indexButton = [[UIButton alloc] initWithFrame:CGRectMake(oneAndLastSpace + (i % 5) * (buttonW + space),20 * WideEachUnit + oneAndLastSpace + (i / 5) * (buttonH + oneAndLastSpace), buttonW, buttonH)];
        indexButton.layer.cornerRadius = buttonW / 2;
        indexButton.layer.masksToBounds = YES;
        if ([[_subjectivityUserArray objectAtIndex:i] integerValue] == 100) {//没有回答
            indexButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        } else {//回答的了
            indexButton.backgroundColor = BasidColor;
        }
        [indexButton setTitle:[NSString stringWithFormat:@"%d",i + 1] forState:UIControlStateNormal];
        indexButton.tag = 5 * 100 + i;
        //        indexButton.tag = [[[_dataArray objectAtIndex:i] stringValueForKey:@"goods_id"] integerValue];
        [indexButton addTarget:self action:@selector(indexButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [self.subjectivityView addSubview:indexButton];
    }
}



#pragma mark --- 事件处理
- (void)indexButtonCilck:(UIButton *)button {
    NSInteger ButtonTag = button.tag;

    if (ButtonTag < 200) {//单选
        
    } else if (ButtonTag < 300) {//多选
        
    } else if (ButtonTag < 400) {//判断
        
    } else if (ButtonTag < 500) {//填空
        
    } else if (ButtonTag < 600) {//主观
        
    }
    
    //发送通知
    NSString *tagStr = [NSString stringWithFormat:@"%ld",ButtonTag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestAnswerSheetGiveButtonTag" object:tagStr];
    [self backPressed];

}
- (void)commitButtonCilck {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认是否交卷？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self netWorkExamsSubmitExams];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 处理答案的字符串
- (void)manageAnswer {
    
    //单选
    for (int i = 0; i < _multipleArray.count ; i ++) {
        NSString *key = [NSString stringWithFormat:@"%@",[[_multipleArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
        NSString *answer = [_multipleUserArray objectAtIndex:i];
        if ([answer integerValue] == 1) {
            answer = @"A";
        } else if ([answer integerValue] == 2) {
            answer = @"B";
        } else if ([answer integerValue] == 3) {
            answer = @"C";
        } else if ([answer integerValue] == 4) {
            answer = @"D";
        } else if ([answer integerValue] == 5) {
            answer = @"E";
        } else if ([answer integerValue] == 100) {
            answer = @"";
        }
        
        [self.mangerAnswerDict setObject:answer forKey:key];
    }
    
    //多选
    for (int i = 0 ; i < _moreMultipleArray.count ; i ++) {
        NSArray *array = [_moreMultipleUserArray objectAtIndex:i];
        NSArray *optionArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H"];
        NSInteger index = 0;
        NSMutableArray *indexMoreMultipleArray = [NSMutableArray arrayWithCapacity:0];
        for (int k = 0 ; k < array.count ; k ++) {
            NSString *key = [NSString stringWithFormat:@"user_answer[%@][%ld]",[[_moreMultipleArray objectAtIndex:i] stringValueForKey:@"exams_question_id"],index];
            NSString *answer = [array objectAtIndex:k];
            if ([answer integerValue] == 1) {//说明是选中的
                answer = [optionArray objectAtIndex:k];
//                [self.mangerAnswerDict setObject:answer forKey:key];
                [indexMoreMultipleArray addObject:answer];
                index ++;
            } else if ([answer integerValue] == 100) {//没有选中的
                
            }
        }
        [self.mangerAnswerDict setObject:indexMoreMultipleArray forKey:[[_moreMultipleArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
    }
    
    //判断
    for (int i = 0; i < _judgeArray.count ; i ++) {
        NSString *key = [NSString stringWithFormat:@"%@",[[_judgeArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
        NSString *answer = [_judgeUserArray objectAtIndex:i];
        if ([answer integerValue] == 1) {
            answer = @"A";
        } else if ([answer integerValue] == 2) {
            answer = @"B";
        } else if ([answer integerValue] == 100) {//没有作答的
            answer = @"";
        }
        
        [self.mangerAnswerDict setObject:answer forKey:key];
    }
    
    //填空
    for (int i = 0 ; i < _gapArray.count ; i ++) {
        NSArray *array = [_gapUserArray objectAtIndex:i];
        NSMutableArray *indexGapArray = [NSMutableArray arrayWithCapacity:0];
        for (int k = 0 ; k < array.count ; k ++) {
            NSString *key = [NSString stringWithFormat:@"%@",[[_gapArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
            NSString *answer = [array objectAtIndex:k];
            if ([answer integerValue] == 100) {//没有作答
                [self.mangerAnswerDict setObject:@"" forKey:key];
            } else if ([answer isEqualToString:@""]) {//没有作答
                [self.mangerAnswerDict setObject:@"" forKey:key];
            } else {
//                [self.mangerAnswerDict setObject:answer forKey:key];
                [indexGapArray addObject:answer];
            }
        }
        [self.mangerAnswerDict setObject:indexGapArray forKey:[[_gapArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
    }
    
    //主观题
    for (int i = 0 ; i < _subjectivityArray.count ; i ++) {
        NSString *key = [NSString stringWithFormat:@"%@",[[_subjectivityArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
        NSString *answer = [_subjectivityUserArray objectAtIndex:i];
        if ([answer integerValue] == 100) {//没有作答
            answer = @"";
            [self.mangerAnswerDict setObject:@"" forKey:key];
        } else if ([answer isEqualToString:@""]) {//没有作答
            [self.mangerAnswerDict setObject:@"" forKey:key];
        } else {//作答
            [self.mangerAnswerDict setObject:answer forKey:key];
        }
    }
}

#pragma mark --- 网络请求
//考试交卷
- (void)netWorkExamsSubmitExams {
    [self manageAnswer];
    NSString *endUrlStr = YunKeTang_Exams_exams_submitExams;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *ID = [_dataSource stringValueForKey:@"exams_paper_id"];
    [mutabDict setObject:ID forKey:@"paper_id"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",_passTimeIng] forKey:@"anser_time"];
    [mutabDict setObject:_examType forKey:@"exams_type"];
    [mutabDict setObject:self.mangerAnswerDict forKey:@"user_answer"];
    if ([_dataSource stringValueForKey:@"exams_users_id"] == nil) {
    } else {
        if ([_againStr isEqualToString:@"again"]) {//再次挑战
        } else {
            [mutabDict setObject:[_dataSource stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
        }
    }
    
    if ([_dataSource stringValueForKey:@"wrong_exams_users_id"] == nil  || [[_dataSource stringValueForKey:@"wrong_exams_users_id"] integerValue] == 0 ) {
    } else {
        if ([_againStr isEqualToString:@"again"]) {//再次挑战
        } else {
            [mutabDict setObject:[_dataSource stringValueForKey:@"wrong_exams_users_id"] forKey:@"wrong_exams_users_id"];
        }
    }
    
    //后面添加的
    [mutabDict setObject:[[_dataSource dictionaryValueForKey:@"paper_options"] stringValueForKey:@"exams_paper_options_id"] forKey:@"paper_options_id"];
    
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    [TKProgressHUD showMessag:@"交卷中..." toView:self.view];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [_timer invalidate];//移除时间
            self.timer = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([_contentStr isEqualToString:@"continue"]) {//这个是从我的考试里面的保存进度进来的交卷的
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                } else {
                    if (_classTestType != nil) {

                        if ([_classTestType isEqualToString:@"Search_ClassGoin"]) {
                             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
                        } else {
                             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                        }
                        
                        
                        NSLog(@"---%@",self.navigationController.viewControllers);

                    } else {
                         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                        
                        NSLog(@"%@",self.navigationController.viewControllers);
                        
                    }
                }
            });
        } else {
             [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [op start];
}







@end
