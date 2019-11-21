//
//  ClassTestPracticeViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/1/14.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "ClassTestPracticeViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "TKProgressHUD+Add.h"
#import "MJRefresh.h"

#import "TestChooseTableViewCell.h"
#import "TestGapTableViewCell.h"
#import "TestSubjectivityTableViewCell.h"


@interface ClassTestPracticeViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextViewDelegate> {
    NSInteger refreshNumber;//刷新的次数
    CGFloat   webViewHight;//表格头部视图的webView的高度的记录
    NSInteger subjectNumber;//考试的题目 （在该类型中的序列号）
    NSInteger subjectAllNumber;//所有考试里面当前题的排序
    NSString  *collectType;//区分是收藏还是取消收藏
    NSInteger whichSubject;//这个是用于区分是哪种类型的题
    BOOL      unwindButtonSele;//这个是区分展开按钮展开与收拢
    CGFloat   analysisHeight;//解析视图的高度
    CGFloat   gapTrueHeight;
    CGFloat   subjectivityTrueHeight;
    NSInteger timePastting;//记录流逝的时间(记录当前用过的时间)
    NSInteger allTime;//全部的时间（当有时间限制的时候才会有这个东西）
    NSString  *stayWhiceController;//这个字符串是标示 当前用户的界面是停留在当前界面还是后面的答题卡界面（因为交卷的时候需要这个标识符）
}

//点击暂停以及返回的按钮
@property (strong ,nonatomic)UIView           *allView;
@property (strong ,nonatomic)UIButton         *allButton;
@property (strong ,nonatomic)UIView           *stopView;

//时间
@property (strong ,nonatomic)UILabel          *timeLabel;//时间的文本
@property (strong, nonatomic)NSTimer          *timer;


//表格
@property (strong ,nonatomic)UITableView      *chooseTableView;
@property (strong ,nonatomic)UITableView      *gapTableView;
@property (strong ,nonatomic)UITableView      *subjectivityTableView;

//表格头部的webView
@property (strong ,nonatomic)UIView           *chooseHeaderView;
@property (strong ,nonatomic)UIWebView        *chooseHeaderWebView;
@property (strong ,nonatomic)UIButton         *chooseHeaderWebViewButton;
@property (strong ,nonatomic)UILabel          *currentNumberLabel;


//表格底部的视图
@property (strong ,nonatomic)UIView           *tableFootView;//表格的底部视图
@property (strong ,nonatomic)UIButton         *advButton;//向上翻的
@property (strong ,nonatomic)UIButton         *collectButton;
@property (strong ,nonatomic)UIButton         *nextButton;
@property (strong ,nonatomic)UIButton         *unwindButton;
@property (strong ,nonatomic)UIView           *correctAndMyAnswerView;
@property (strong ,nonatomic)UIView           *analysisView;//解析的界面
@property (strong ,nonatomic)UILabel          *analysisLabel;
@property (strong ,nonatomic)UILabel          *analysisContentLabel;
@property (strong ,nonatomic)UILabel          *trueAnswerLabel;//正确的答案的文本
@property (strong ,nonatomic)UILabel          *userAnswerLabel;//自己的答案的文本
@property (strong ,nonatomic)UILabel          *trueAnswer;//正确的答案
@property (strong ,nonatomic)UILabel          *userAnswer;//用户的答案

@property (strong ,nonatomic)NSArray          *userOlderAnswerArray;//用户以前的答案 （用于继续答案的时候用）

@property (strong ,nonatomic)NSMutableDictionary *mangerAnswerDict;//处理




//填空题
@property (strong ,nonatomic)UIView           *answerView;
//主观题
@property (strong ,nonatomic)UITextView       *answerTextView;

//数据
@property (strong ,nonatomic)NSArray          *dataArray;
@property (strong ,nonatomic)NSArray          *allDataSourceArray;//试卷的所有问题
@property (strong ,nonatomic)NSMutableArray   *multipleArray;//单选
@property (strong ,nonatomic)NSMutableArray   *moreMultipleArray;//多选
@property (strong ,nonatomic)NSMutableArray   *gapArray;//填空
@property (strong ,nonatomic)NSMutableArray   *judgeArray;//判断
@property (strong ,nonatomic)NSMutableArray   *subjectivityArray;//主观
@property (strong ,nonatomic)NSMutableArray   *currentArray;//当前显示的数据

//用于记录当前选择的答案
@property (strong ,nonatomic)NSMutableArray   *multipleSeleArray;//答案过程中 单选选中的记录数组
@property (strong ,nonatomic)NSMutableArray   *multipleUserArray;//用户的答案（单选）

@property (strong ,nonatomic)NSMutableArray   *moreMultipleSeleArray;//答案过程中 多选选中的记录数组
@property (strong ,nonatomic)NSMutableArray   *moreMultipleUserArray;//用户的答案（du多o选）

@property (strong ,nonatomic)NSMutableArray   *judgeSeleArray;//答案过程中 判断选中的记录数组
@property (strong ,nonatomic)NSMutableArray   *judgeUserArray;//用户的答案（判断）

@property (strong ,nonatomic)NSMutableArray   *gapSeleArray;//答案过程中 填空选中的记录数组
@property (strong ,nonatomic)NSMutableArray   *gapUserArray;//用户的答案（填空）

@property (strong ,nonatomic)NSMutableArray   *subjectivitySeleArray;//答案过程中 主观选中的记录数组
@property (strong ,nonatomic)NSMutableArray   *subjectivityUserArray;//用户的答案（主观）

//收藏的数组（因为这里面没有接口，所以需要自己用数组来记录收藏的状态）
@property (strong ,nonatomic)NSMutableArray   *collectArray;//收藏的数组

//最后进入当前界面进行查看答案的时候
@property (strong ,nonatomic)NSMutableArray   *multipleIDArray;//由于接口返回的原因，所以需要装ID的数组
@property (strong ,nonatomic)NSMutableArray   *moreMultipleIDArray;//多选题的ID
@property (strong ,nonatomic)NSMutableArray   *judgeIDArray;//选择题的ID
@property (strong ,nonatomic)NSMutableArray   *gapIDArray;//题空的ID
@property (strong ,nonatomic)NSMutableArray   *subjectivityIDArray;//主观的ID

@property (strong ,nonatomic)NSArray          *allUserAnswerArray;//用户的全部答案（接口返回的全部都在这里）

@property (strong ,nonatomic)NSDictionary    *dataSource;

@end

@implementation ClassTestPracticeViewController

#pragma mark --- 懒加载

//头部视图
-(UIView *)chooseHeaderView {
    if (!_chooseHeaderView) {
        _chooseHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60 * WideEachUnit)];
    }
    return _chooseHeaderView;
}
- (UILabel *)currentNumberLabel {
    if (!_currentNumberLabel) {
        _currentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 40 * WideEachUnit, 13 * WideEachUnit)];
    }
    return _currentNumberLabel;
}

-(UIWebView *)chooseHeaderWebView {
    if (!_chooseHeaderWebView) {
        _chooseHeaderWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit,30 * WideEachUnit)];
    }
    return _chooseHeaderWebView;
}

-(UIButton *)chooseHeaderWebViewButton {
    if (!_chooseHeaderWebViewButton) {
        _chooseHeaderWebViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit,30 * WideEachUnit)];
        [_chooseHeaderWebView addSubview:_chooseHeaderWebViewButton];
        _chooseHeaderWebViewButton.backgroundColor = [UIColor clearColor];
    }
    return _chooseHeaderWebViewButton;
}

- (UIView *)tableFootView {
    if (!_tableFootView) {
        _tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 120 * WideEachUnit)];
    }
    return _tableFootView;
}

- (UIButton *)collectButton {//收藏按钮
    if (!_collectButton) {
        _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 80 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    }
    return _collectButton;
}
-(UIButton *)advButton {
    if (!_advButton) {
        _advButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 20 * WideEachUnit,165 * WideEachUnit, 44 * WideEachUnit)];
        _advButton.backgroundColor = [UIColor colorWithHexString:@"#c6cacf"];
    }
    return _advButton;
}

-(UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 10 * WideEachUnit, 20 * WideEachUnit, 165 * WideEachUnit, 44 * WideEachUnit)];
    }
    return _nextButton;
}

-(UIButton *)unwindButton {
    if (!_unwindButton) {
        _unwindButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 80 * WideEachUnit, 110 * WideEachUnit, 20 * WideEachUnit)];
    }
    return _unwindButton;
}

-(UIView *)correctAndMyAnswerView {
    if (!_correctAndMyAnswerView) {
        _correctAndMyAnswerView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 120 * WideEachUnit, MainScreenWidth - 30 *WideEachUnit, 70 * WideEachUnit)];
    }
    return _correctAndMyAnswerView;
}

- (UIView *)analysisView {
    if (!_analysisView) {
        _analysisView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 190 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    }
    return _analysisView;
}

-(UILabel *)trueAnswerLabel {
    if (!_trueAnswerLabel) {
        _trueAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 12 * WideEachUnit)];
    }
    return _trueAnswerLabel;
}

- (UILabel *)trueAnswer {
    if (!_trueAnswer) {
        _trueAnswer = [[UILabel alloc] initWithFrame:CGRectMake(0, 32 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    }
    return _trueAnswer;
}

-(UILabel *)userAnswerLabel {
    if (!_userAnswerLabel) {
        _userAnswerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 12 * WideEachUnit)];
    }
    return _userAnswerLabel;
}

- (UILabel *)userAnswer {
    if (!_userAnswer) {
        _userAnswer = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 12 * WideEachUnit)];
    }
    return _userAnswer;
}

-(UILabel *)analysisLabel {
    if (!_analysisLabel) {
        _analysisLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    }
    return _analysisLabel;
}

-(UILabel *)analysisContentLabel {
    if (!_analysisContentLabel) {
        _analysisContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    }
    return _analysisContentLabel;
}

//填空题的答题区域
-(UIView *)answerView {
    if (!_answerView) {
        _answerView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    }
    return _answerView;
}
//主观题的答题区域
-(UITextView *)answerTextView {
    if (!_answerTextView) {
        _answerTextView = [[UITextView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 20 * WideEachUnit, MainScreenWidth - 40 * WideEachUnit, 190 * WideEachUnit)];
    }
    return _answerTextView;
}

//处理答案
-(NSMutableDictionary *)mangerAnswerDict {
    if (!_mangerAnswerDict) {
        _mangerAnswerDict = [NSMutableDictionary dictionary];
    }
    return _mangerAnswerDict;
}

//用于记录收藏的数组
-(NSMutableArray *)collectArray {
    if (!_collectArray) {
        _collectArray = [NSMutableArray array];
    }
    return _collectArray;
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
    [self addNav];
    [self addChooseTableView];
//    [self netWorkVideoSectionExams];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加通知（填空题的答案）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerTextFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    //添加通知(主观题的答案)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerTextViewTextChange:) name:UITextViewTextDidChangeNotification object:nil];
    //这个是从填空cell传过来的答案以及当前编辑的是那个
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TestGapTableViewCellGetAnswerAndNumber:) name:@"TestGapTableViewCellGetAnswerAndNumber" object:nil];
    //从答题卡传过来的按钮的tag(从而确定是什么类型的题和具体哪一题)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TestAnswerSheetGiveButtonTag:) name:@"TestAnswerSheetGiveButtonTag" object:nil];
}

- (void)initialization {
    _multipleArray = [NSMutableArray array];
    _moreMultipleArray = [NSMutableArray array];
    _gapArray = [NSMutableArray array];
    _judgeArray = [NSMutableArray array];
    _subjectivityArray = [NSMutableArray array];
    _currentArray = [NSMutableArray array];
    
    
    //创建装答案的数组
    _multipleUserArray = [NSMutableArray array];
    _moreMultipleUserArray = [NSMutableArray array];
    _judgeUserArray = [NSMutableArray array];
    _gapUserArray = [NSMutableArray array];
    _subjectivityUserArray = [NSMutableArray array];
    
    //选择题中的选中的过渡数据
    _multipleSeleArray = [NSMutableArray array];
    _moreMultipleSeleArray = [NSMutableArray array];
    _judgeSeleArray = [NSMutableArray array];
    _gapSeleArray = [NSMutableArray array];
    _subjectivitySeleArray = [NSMutableArray array];
    
    //初始化装ID的数组（查看模式的时候会用）
    _multipleIDArray = [NSMutableArray array];
    _moreMultipleIDArray = [NSMutableArray array];
    _judgeIDArray = [NSMutableArray array];
    _gapIDArray = [NSMutableArray array];
    _subjectivityIDArray = [NSMutableArray array];
    
    
    //将数据分类
    NSLog(@"---%@",_dataSource);
    if (_dataArray.count == 0) {
        [TKProgressHUD showError:@"数据为空" toView:self.view];
        [self backPressed];
        return;
    }
    
    
    //遍历
    for (int i = 0 ; i < _dataArray.count ; i ++) {
        NSDictionary *indexDict = [_dataArray objectAtIndex:i];
        NSString *exams_question_type_id = [[indexDict dictionaryValueForKey:@"type_info"] stringValueForKey:@"exams_question_type_id"];

        if ([exams_question_type_id integerValue] == 1) {//单选
            [_multipleArray addObject:indexDict];
        } else if ([exams_question_type_id integerValue] == 2) {//多选
            [_moreMultipleArray addObject:indexDict];
        } else if ([exams_question_type_id integerValue] == 3) {//判断
            [_judgeArray addObject:indexDict];
        } else if ([exams_question_type_id integerValue] == 4) {//填空题
            [_gapArray addObject:indexDict];
        }
    }
    
//    _multipleArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"1"];
//    _moreMultipleArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"2"];
//    _judgeArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"3"];
//    _gapArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"4"];
//    _subjectivityArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"5"];
    
    //将每个将要装答案的数据先用其他的数据先代替
    for (int i = 0; i < _multipleArray.count ; i ++) {
        [_multipleUserArray addObject:@"100"];
        //添加收藏的数组
        NSString *isCollect = [NSString stringWithFormat:@"%@",[[_multipleArray objectAtIndex:i] stringValueForKey:@"is_collect"]];
        [self.collectArray addObject:isCollect];
        
        //得到单选题的ID
        NSString *ID = [[_multipleArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        [_multipleIDArray addObject:ID];
        
    }
    for (int i = 0; i < _moreMultipleArray.count ; i ++) {//多选题
        NSMutableArray *multipleOneArray = [NSMutableArray array];
        NSArray *sectionArray = [[_moreMultipleArray objectAtIndex:i] arrayValueForKey:@"answer_options"];
        for (int k = 0 ; k < sectionArray.count; k ++) {
            [multipleOneArray addObject:@"100"];
        }
        [_moreMultipleUserArray addObject:multipleOneArray];
        NSLog(@"%@",_moreMultipleUserArray);
        
        //添加收藏的数组
        NSString *isCollect = [NSString stringWithFormat:@"%@",[[_moreMultipleArray objectAtIndex:i] stringValueForKey:@"is_collect"]];
        [self.collectArray addObject:isCollect];
        
        
        //得到多选题的ID
        NSString *ID = [[_moreMultipleArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        [_moreMultipleIDArray addObject:ID];
        
        //判断是否第一题为多选题
        if (_multipleArray.count == 0) {//那就是第一题为多选题
            for (int i = 0 ; i < 10; i ++) {
                [_moreMultipleSeleArray addObject:@"0"];
            }
        }
        
    }
    for (int i = 0; i < _judgeArray.count ; i ++) {
        [_judgeUserArray addObject:@"100"];
        //添加收藏的数组
        NSString *isCollect = [NSString stringWithFormat:@"%@",[[_judgeArray objectAtIndex:i] stringValueForKey:@"is_collect"]];
        [self.collectArray addObject:isCollect];
        
        //得到判断选题的ID
        NSString *ID = [[_judgeArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        [_judgeIDArray addObject:ID];
    }
    for (int i = 0; i < _gapArray.count ; i ++) {//填空题和多选题比较特殊
        NSMutableArray *gapOneArray = [NSMutableArray array];
        NSArray *sectionArray = [[_gapArray objectAtIndex:i] arrayValueForKey:@"answer_true_option"];
        for (int k = 0 ; k < sectionArray.count; k ++) {
            [gapOneArray addObject:@"100"];
        }
        [_gapUserArray addObject:gapOneArray];
        
        //添加收藏的数组
        NSString *isCollect = [NSString stringWithFormat:@"%@",[[_gapArray objectAtIndex:i] stringValueForKey:@"is_collect"]];
        [self.collectArray addObject:isCollect];
        
        //得到题空选题的ID
        NSString *ID = [[_gapArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        [_gapIDArray addObject:ID];
    }
    for (int i = 0; i < _subjectivityArray.count ; i ++) {
        [_subjectivityUserArray addObject:@"100"];
        
        //添加收藏的数组
        NSString *isCollect = [NSString stringWithFormat:@"%@",[[_subjectivityArray objectAtIndex:i] stringValueForKey:@"is_collect"]];
        [self.collectArray addObject:isCollect];
        
        //得到主观选题的ID
        NSString *ID = [[_subjectivityArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        [_subjectivityIDArray addObject:ID];
    }
    NSLog(@"%@",_moreMultipleUserArray);
    
    NSLog(@"----%@",_multipleArray);
    if (_multipleArray.count > 0) {//说明最先是单选题
        _currentArray = _multipleArray;
        whichSubject = 1;//设置当前题型为单选
    } else if (_moreMultipleArray.count > 0) {//多选题
        _currentArray = _moreMultipleArray;
        whichSubject = 2;
    } else if (_judgeArray.count > 0) {//判断题
        _currentArray = _judgeArray;
        whichSubject = 3;
    } else if (_gapArray.count > 0) {//填空题
        _currentArray = _gapArray;
        whichSubject = 4;
    } else if (_subjectivityArray.count > 0) {//主观题
        _currentArray = _subjectivityArray;
        whichSubject = 5;
    } else {//没有数据的时候
        _currentArray = nil;
        return;
    }
//    if (_currentArray.count == 0) {
//        [self backPressed];
//        return;
//    }
    
    
    NSLog(@"%@",_currentArray);
    refreshNumber = 0;
    webViewHight = 0;
    subjectNumber = 0;
    subjectAllNumber = 0;
    collectType = nil;
    analysisHeight = 0;
    gapTrueHeight = 0;
    subjectivityTrueHeight = 0;
    timePastting = 0;//初始值
    stayWhiceController = @"TestCurrent";//当前界面
    
    
    unwindButtonSele = NO;
    
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"测试";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    //   // 添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}


#pragma mark --- 添加表格
//选择表格
- (void)addChooseTableView {
    _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _chooseTableView.delegate = self;
    _chooseTableView.dataSource = self;
    _chooseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉表格中间的分割线
    [self.view addSubview:_chooseTableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_chooseTableView];
    }
}


#pragma mark --- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (webViewHight == 0) {
        return 100 * WideEachUnit;
    } else {
        return webViewHight + 40 * WideEachUnit;
    }
}

//这个方法调用就是防止头部的webView 刷新不出来
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60 * WideEachUnit)];
    if (webViewHight > 0) {
        headerView.frame = CGRectMake(0, 0, MainScreenWidth, 40 * WideEachUnit + webViewHight);
    }
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    //添加多少题
    UILabel *currentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 50 * WideEachUnit, 13 * WideEachUnit)];
    currentNumberLabel.text = @"8/89";
    currentNumberLabel.font = Font(14 * WideEachUnit);
    
    NSInteger errorAllNumber = _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count + _subjectivityArray.count;
    currentNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",subjectAllNumber + 1,errorAllNumber];
    
    [headerView addSubview:currentNumberLabel];
    
    currentNumberLabel.numberOfLines = 1;
    CGRect labelSize = [currentNumberLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 50 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * WideEachUnit]} context:nil];
    //    if (labelSize.size.height < 20 * WideEachUnit) {
    //        labelSize.size.height = 20 * WideEachUnit;
    //    }
    currentNumberLabel.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit,labelSize.size.width, 13 * WideEachUnit);
    
    //添加类型
    UILabel *topicType = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentNumberLabel.frame) + 10 * WideEachUnit, 10 * WideEachUnit, 40 * WideEachUnit, 13 * WideEachUnit)];
    if (whichSubject == 1) {
        topicType.text = @"单选题";
    } else if (whichSubject == 2) {
        topicType.text = @"多选题";
    } else if (whichSubject == 3) {
        topicType.text = @"判断题";
    } else if (whichSubject == 4) {
        topicType.text = @"填空题";
    } else if (whichSubject == 5) {
        topicType.text = @"主观题";
    }
    
    
    topicType.textAlignment = NSTextAlignmentCenter;
    topicType.font = Font(10 * WideEachUnit);
    topicType.backgroundColor = [UIColor colorWithHexString:@"#111"];
    topicType.backgroundColor = [UIColor colorWithRed:200.f / 255 green:200.f / 255 blue:200.f / 255 alpha:1];
    topicType.textColor = [UIColor colorWithHexString:@"#fff"];
    [headerView addSubview:topicType];
    
    //添加提干（这里需要用到webView "因为可能会有图片的原因"）
    self.chooseHeaderWebView.frame = CGRectMake(10 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 30 * WideEachUnit);
    if (webViewHight > 0) {
        self.chooseHeaderWebView.frame = CGRectMake(10 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, webViewHight);
        self.chooseHeaderWebViewButton.frame = CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit, webViewHight);
    }
    self.chooseHeaderWebView.backgroundColor = [UIColor whiteColor];
    self.chooseHeaderWebView.delegate = self;
    [headerView addSubview:self.chooseHeaderWebView];
    
//    if (_currentArray.count == 0) {
//        [self backPressed];
//        return headerView;
//    }
    //图片的处理
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *originalStr =  [[_currentArray objectAtIndex:subjectNumber] stringValueForKey:@"content"];
    NSString *textStr = [originalStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    
    if (textStr.length>2) {
        NSString *str2 = [textStr substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            textStr = [textStr substringFromIndex:3];
        }
    }
    
    //视频音频的处理
    NSString *videoReplaceStr = [NSString stringWithFormat:@"src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *videoTextStr = [textStr stringByReplacingOccurrencesOfString:@"src=\"/data/upload" withString:videoReplaceStr];
    
    if (videoTextStr.length>2) {
        NSString *str2 = [videoTextStr substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            videoTextStr = [videoTextStr substringFromIndex:3];
        }
    }
    
    
    NSString * str1 = [NSString stringWithFormat:@"<div style=\"margin-left:0px; margin-bottom:5px;font-size:%fpx;color:#010101;text-align:left;\">%@</div>",15.0 * WideEachUnit,videoTextStr];
    //    NSString * str2 = [NSString stringWithFormat:@"<div style=\"float:left;font-size:%fpx;color:#9B9B9B;text-align:left;\">%@</div>",15.0,[NSString stringWithFormat:@"发布时间：%@",_timeStr]];
    //    NSString * str3 = [NSString stringWithFormat:@"<div style=\"float:right;font-size:%fpx;color:#9B9B9B;text-align:left;\">%@</div>",15.0,[NSString stringWithFormat:@"阅读：%@",_readStr]];
    //    NSString * str4 = [NSString stringWithFormat:@"<div style=\"float:left; margin-top:5px;font-size:%fpx;color:#010101;text-align:left;\">%@</div>",18.0,[NSString stringWithFormat:@"摘要：%@",@"下列选择，没有生命迹象的为？"]];
    
    
    NSString *divStr = [NSString stringWithFormat:@"<div style=\"margin:%dpx;border:0;padding:0;\"></div>",SpaceBaside];
    NSString *styleStr = [NSString stringWithFormat:@"<style> .mobile_upload {width:%fpx; height:auto;} </style><style> .emot {width:%fpx; height:%fpx;} img{width:%fpx;} </style><div style=\"word-wrap:break-word; width:%fpx;\"><font style=\"font-size:%fpx;color:#262626;\">",MainScreenWidth-SpaceBaside*2,16.0,18.0,MainScreenWidth - 2 * SpaceBaside,MainScreenWidth-SpaceBaside*2,18.0];
    //    NSString *str = [NSString stringWithFormat:@"%@%@%@%@</font></div>",str1,divStr,styleStr,content];
    NSString *str = [NSString stringWithFormat:@"%@%@%@</font></div>",str1,divStr,styleStr];
    
    [self.chooseHeaderWebView loadHTMLString:str baseURL:nil];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    self.tableFootView.frame = CGRectMake(0, 0, MainScreenWidth, 30 * WideEachUnit);
    self.tableFootView.backgroundColor = [UIColor whiteColor];
    
    [self.advButton setTitle:@"上一题" forState:UIControlStateNormal];
    self.advButton.layer.cornerRadius = 3 * WideEachUnit;
    [self.advButton addTarget:self action:@selector(advButtonButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:self.advButton];
    
    //下一题的按钮
    self.nextButton.backgroundColor = BasidColor;
    [self.nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    
    
    self.nextButton.layer.cornerRadius = 3 * WideEachUnit;
    [self.nextButton addTarget:self action:@selector(nextButtonButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:self.nextButton];
    return self.tableFootView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    } else if (whichSubject == 4) {
        return 61 * WideEachUnit;
        //        NSArray *array = [[_gapArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
        //        return 25 + array.count * 61 * WideEachUnit;
    } else if (whichSubject == 5){
        return 230 * WideEachUnit;
    } else {
        return 100 * WideEachUnit;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3) {
        NSArray *sectionArray = [[_currentArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_options"];
        return sectionArray.count;
    } else if (whichSubject == 4) {
        NSArray *array = [[_gapArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
        return array.count;
        return 1;
    } else if (whichSubject == 5){
        return 1;
    } else {
        return 0;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3) {
        static NSString *CellIdentifier = @"culture";
        //自定义cell类
        TestChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TestChooseTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        NSArray *sectionArray = [[_currentArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_options"];
        NSLog(@"---%@",sectionArray);
        NSString *title = nil;
        title = [[sectionArray objectAtIndex:indexPath.row] stringValueForKey:@"answer_value"];
        [cell dataWithTitle:title WithNumber:indexPath.row];
        
        if (whichSubject == 1) {
            [cell cellChangeWithType:whichSubject WithArray:_multipleSeleArray WithNumber:indexPath.row];
        } else if (whichSubject == 2) {
            [cell cellChangeWithType:whichSubject WithArray:_moreMultipleSeleArray WithNumber:indexPath.row];
        } else if (whichSubject == 3) {
            [cell cellChangeWithType:whichSubject WithArray:_judgeSeleArray WithNumber:indexPath.row];
        }
        return cell;
    } else if (whichSubject == 4) {//填空题
        static NSString *CellIdentifier = @"gap";
        //自定义cell类
        TestGapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TestGapTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        //        NSArray *array = [[_gapArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
        NSArray *array = [_gapUserArray objectAtIndex:subjectNumber];
        [cell dataWithArray:array WithNumber:indexPath.row];
        self.answerView = cell.answerView;
        return cell;
    } else if (whichSubject == 5) {//主观题
        static NSString *CellIdentifier = @"subject";
        //自定义cell类
        TestSubjectivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TestSubjectivityTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        self.answerTextView = cell.answerTextView;
        self.answerTextView.delegate = self;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_chooseTableView == tableView) {
        if (whichSubject == 1) {//单选
            [_multipleSeleArray removeAllObjects];
            for (int i = 0; i < 10; i++) {
                [_multipleSeleArray addObject:@"0"];
            }
            [_multipleSeleArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [_multipleUserArray replaceObjectAtIndex:subjectNumber withObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        } else if (whichSubject == 2) {//多选
            if ([[_moreMultipleSeleArray objectAtIndex:indexPath.row] integerValue] == 1) {
                [_moreMultipleSeleArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
            } else {
                [_moreMultipleSeleArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            }
            NSMutableArray *indexArray = [_moreMultipleUserArray objectAtIndex:subjectNumber];
            NSString *indexpathStr = [indexArray objectAtIndex:indexPath.row];
            if ([indexpathStr integerValue] == 100) {
                [indexArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            } else if ([indexpathStr integerValue] == 1) {
                [indexArray replaceObjectAtIndex:indexPath.row withObject:@"100"];
            }
            [_moreMultipleUserArray replaceObjectAtIndex:subjectNumber withObject:indexArray];
            
            
        } else if (whichSubject == 3) {//判断
            [_judgeSeleArray removeAllObjects];
            for (int i = 0; i < 10; i++) {
                [_judgeSeleArray addObject:@"0"];
            }
            [_judgeSeleArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [_judgeUserArray replaceObjectAtIndex:subjectNumber withObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        } else if (whichSubject == 4) {
            return;
        } else if (whichSubject == 5) {
            return;
        }
        [_chooseTableView reloadData];
    }
    
}

#pragma mark --- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView  {
    //    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    //    CGFloat height = [[self.chooseHeaderWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    //    NSLog(@"----%lf",height);
    //
    //    CGSize webSize = [self.chooseHeaderWebView sizeThatFits:CGSizeZero];
    //    NSLog(@"---%lf",webSize.height);
    //    webViewHight = webSize.height;
    
    CGRect frame = self.chooseHeaderWebView.frame;
    frame.size.width = MainScreenWidth - 20 * WideEachUnit;
    frame.size.height = 1 * WideEachUnit;
    //    webView.scrollView.scrollEnabled = NO;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webView.frame = frame;
    webViewHight = frame.size.height;
    
    
    
    //    self.chooseHeaderWebView.frame = CGRectMake(10 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 30 * WideEachUnit);
    if (refreshNumber == 0) {
        [_chooseTableView reloadData];
        refreshNumber = 1;
    } else {
        refreshNumber = 0;
    }
    
}

#pragma mark --- 事件处理

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
    
}

//上一题
- (void)advButtonButtonCilck:(UIButton *)button {
    //处理答案的一些操作
    
    [self uplastDoThing];
    
}
//下一题
- (void)nextButtonButtonCilck:(UIButton *)button {
    //处理答案一些操作
    
    [self nextLastDoThing];
}



#pragma mark --- 点上一题的时候吧必要的事情 （最后需要处理的事情都放在这个方法里面）
- (void)uplastDoThing {
    subjectAllNumber --;
    subjectNumber --;
    if (whichSubject == 1) {//当前单选
        if (subjectNumber < 0) {//说明该换题型了
            [TKProgressHUD showError:@"已是第一题" toView:self.view];
            subjectAllNumber ++;
            subjectNumber ++;
            return;
        } else if (subjectNumber >= 0) {//还是之前的题型 （还是在单选里面）
            [self Up_multipleConfig];
        }
    } else if (whichSubject == 2) {//当前多选
        if (subjectNumber < 0) {//说明改换题型了
            if (_multipleArray.count > 0) {
                subjectNumber = _multipleArray.count - 1;
                _currentArray = _multipleArray;
                whichSubject = 1;
                [self Up_multipleConfig];
            } else {//最前面一题
                [TKProgressHUD showError:@"已是第一题" toView:self.view];
                subjectAllNumber ++;
                subjectNumber ++;
                return;
            }
        } else if (subjectNumber >= 0) {//还是在多选题中
            //进去多选题的准备
            [self Up_moreMultipleConfig];
        }
    } else if (whichSubject == 3) {//当前判断
        if (subjectNumber < 0) {//说明该换题型了
            if (_moreMultipleArray.count > 0) {
                subjectNumber = _moreMultipleArray.count - 1;
                _currentArray = _moreMultipleArray;
                whichSubject = 2;
                [self Up_moreMultipleConfig];
            } else if (_multipleArray.count > 0){
                subjectNumber = _multipleArray.count - 1;
                _currentArray = _multipleArray;
                whichSubject = 1;
                [self Up_multipleConfig];
            } else {//最前面一题
                [TKProgressHUD showError:@"已是第一题" toView:self.view];
                subjectAllNumber ++;
                subjectNumber ++;
                return;
            }
        } else if (subjectNumber >= 0) {//还是在当前的题型中
            [self Up_judgeConfig];
        }
    } else if (whichSubject == 4) {//当前填空
        if (subjectNumber < 0) {//说明该换题了
            if (_judgeArray.count > 0) {
                subjectNumber = _judgeArray.count - 1;
                _currentArray = _judgeArray;
                whichSubject = 3;
                [self Up_judgeConfig];
            } else if (_moreMultipleArray.count > 0) {
                subjectNumber = _moreMultipleArray.count - 1;
                _currentArray = _moreMultipleArray;
                whichSubject = 2;
                [self Up_moreMultipleConfig];
            } else if (_multipleArray.count > 0){
                subjectNumber = _multipleArray.count - 1;
                _currentArray = _multipleArray;
                whichSubject = 1;
                [self Up_multipleConfig];
            } else {//最前面一题
                [TKProgressHUD showError:@"已是第一题" toView:self.view];
                subjectAllNumber ++;
                subjectNumber ++;
                return;
            }
        } else if (subjectNumber >= 0) {//还是在当前题型中
            [self Up_gapConfig];
        }
    } else if (whichSubject == 5) {//当前主观
        if (subjectNumber < 0) {//说明该换题了
            if (_gapArray.count > 0) {
                subjectNumber = _gapArray.count - 1;
                _currentArray = _gapArray;
                whichSubject = 4;
                [self Up_gapConfig];
            } else if (_judgeArray.count > 0) {
                subjectNumber = _judgeArray.count - 1;
                _currentArray = _judgeArray;
                whichSubject = 3;
                [self Up_judgeConfig];
            } else if (_moreMultipleArray.count > 0) {
                subjectNumber = _moreMultipleArray.count - 1;
                _currentArray = _moreMultipleArray;
                whichSubject = 2;
                [self Up_moreMultipleConfig];
            } else if (_multipleArray.count > 0){
                subjectNumber = _multipleArray.count - 1;
                _currentArray = _multipleArray;
                whichSubject = 1;
                [self Up_multipleConfig];
            } else {//最前面一题
                [TKProgressHUD showError:@"已是第一题" toView:self.view];
                subjectAllNumber ++;
                subjectNumber ++;
                return;
            }
        } else if (subjectNumber >= 0) {//还是在当前题型中
            [self Up_subjectivityConfig];
        }
    }
    
    
//    //有些刷新需要的 就在刷新之前给重置了
//    if ([_examsType integerValue] == 1) {//如果是练习模式，就在点击上一题的时候收上去
//        unwindButtonSele = NO;
//    }
    [_chooseTableView reloadData];
}



#pragma mark --- 上一题的处理（由于东西太多，所以才剃出来的）
//单选题的一些繁琐的配置
- (void)Up_multipleConfig {
    if ([[_multipleUserArray objectAtIndex:subjectNumber] integerValue] == 100) {//说明是没有答案的
        [_multipleSeleArray removeAllObjects];
        for (int i = 0 ; i < 10; i ++) {
            [_multipleSeleArray addObject:@"0"];
        }
    } else {//说明之前是答过题的
        [_multipleSeleArray removeAllObjects];
        for (int i = 0 ; i < 10 ; i ++) {
            if (i == [[_multipleUserArray objectAtIndex:subjectNumber] integerValue] - 1) {
                [_multipleSeleArray addObject:@"1"];
            } else {
                [_multipleSeleArray addObject:@"0"];
            }
        }
    }
}

//多选题的一些配置
- (void)Up_moreMultipleConfig {
    NSMutableArray *moreCurrentMultipleArray = [NSMutableArray array];
    moreCurrentMultipleArray = [_moreMultipleUserArray objectAtIndex:subjectNumber];
    BOOL isHaveAnswer = NO;
    for (int i = 0 ; i < moreCurrentMultipleArray.count ; i ++) {
        if ([[moreCurrentMultipleArray objectAtIndex:i] integerValue] == 100) {
            
        } else {
            isHaveAnswer = YES;
        }
    }
    
    if (isHaveAnswer) {
        [_moreMultipleSeleArray removeAllObjects];
        for (int i = 0 ; i < moreCurrentMultipleArray.count ; i ++) {
            if ([[moreCurrentMultipleArray objectAtIndex:i] integerValue] == 1) {
                [_moreMultipleSeleArray addObject:@"1"];
            } else {
                [_moreMultipleSeleArray addObject:@"0"];
            }
        }
    } else {//没有答案的，所以全部重置
        [_moreMultipleSeleArray removeAllObjects];
        for (int i = 0 ; i < 10; i ++) {
            [_moreMultipleSeleArray addObject:@"0"];
        }
    }
}

//判断题的一些配置
- (void)Up_judgeConfig {
    if ([[_judgeUserArray objectAtIndex:subjectNumber] integerValue] == 100) {//说明是没有答案的
        [_judgeSeleArray removeAllObjects];
        for (int i = 0 ; i < 10; i ++) {
            [_judgeSeleArray addObject:@"0"];
        }
    } else {//说明之前是答过题的
        [_judgeSeleArray removeAllObjects];
        for (int i = 0 ; i < 10 ; i ++) {
            if (i == [[_judgeUserArray objectAtIndex:subjectNumber] integerValue] - 1) {
                [_judgeSeleArray addObject:@"1"];
            } else {
                [_judgeSeleArray addObject:@"0"];
            }
        }
    }
}

//填空题的一些配置
- (void)Up_gapConfig {
    
}


//主观题的一些配置
- (void)Up_subjectivityConfig {
    if ([[_subjectivityUserArray objectAtIndex:subjectNumber] integerValue] == 100) {//说明是没有答案的
        self.answerTextView.text = nil;
    } else {//说明之前是答过题的
        //将之前的答案填写在这里
        NSString *textStr = [_subjectivityUserArray objectAtIndex:subjectNumber];
        self.answerTextView.text = textStr;
    }
}




#pragma mark --- 点下一题的时候吧必要的事情（最后需要处理的事情都放在这个方法里面）
- (void)nextLastDoThing {
    subjectAllNumber ++;
    subjectNumber ++;
    if (whichSubject == 1) {//当前单选
        if (subjectNumber < _multipleArray.count) {//说明还当前的题型中
            [self Next_multipleConfig];
        } else if (subjectNumber >= _multipleArray.count) {//该换题型了
            if (_moreMultipleArray.count > 0) {
                subjectNumber = 0;//置零
                whichSubject = 2;
                NSLog(@"---%ld",subjectNumber);
                _currentArray = _moreMultipleArray;
                //进去多选题的准备
                [self Next_moreMultipleConfig];
                
            } else if (_judgeArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 3;
                _currentArray = _judgeArray;
                [self Next_judgeConfig];
            } else if (_gapArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 4;
                _currentArray = _gapArray;
                [self Next_gapConfig];
            } else if (_subjectivityArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 5;
                _currentArray = _subjectivityArray;
                [self Next_subjectivityConfig];
            } else {
                
//                if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
//                    [self handIn];
//                } else if ([_examsType integerValue] == 3) {//查看模式
//                    [self GoOut];
//                }
                 [self handIn];
                subjectNumber --;
                subjectAllNumber --;
                return;
            }
        }
    } else if (whichSubject == 2) {//当前多选
        if (subjectNumber < _moreMultipleArray.count) {//说明还当前的题型中
            
            [self Next_moreMultipleConfig];
            
        } else if (subjectNumber >= _moreMultipleArray.count) {//该换题型了
            if (_judgeArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 3;
                _currentArray = _judgeArray;
                [self Next_judgeConfig];
            } else if (_gapArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 4;
                _currentArray = _gapArray;
                [self Next_gapConfig];
            } else if (_subjectivityArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 5;
                _currentArray = _subjectivityArray;
                [self Next_subjectivityConfig];
            }  else {
                 [self handIn];
                subjectNumber --;
                subjectAllNumber --;
                return;
            }
        }
    } else if (whichSubject == 3) {//当前判断
        if (subjectNumber < _judgeArray.count) {//说明还当前的题型中
            [self Next_judgeConfig];
        } else if (subjectNumber >= _judgeArray.count) {//该换题型了
            if (_gapArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 4;
                _currentArray = _gapArray;
                [self Next_gapConfig];
            } else if (_subjectivityArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 5;
                _currentArray = _subjectivityArray;
                [self Next_subjectivityConfig];
            } else {
                [self handIn];
                subjectNumber --;
                subjectAllNumber --;
                return;
            }
        }
    } else if (whichSubject == 4) {//当前填空
        if (subjectNumber < _gapArray.count) {//说明还当前的题型中
            //填空题不用专门做处理，因为在编辑填空题答案的时候 通知方法中已经做过处理了
        } else if (subjectNumber >= _gapArray.count) {//说明是最后一种题了 因为之前加了1的
            if (_subjectivityArray.count > 0) {
                subjectNumber = 0;
                whichSubject = 5;
                _currentArray = _subjectivityArray;
                [self Next_subjectivityConfig];
            } else {
                [self handIn];
                subjectNumber --;
                subjectAllNumber --;
                return;
            }
        }
    } else if (whichSubject == 5) {//当前主观
        if (subjectNumber < _subjectivityArray.count) {//说明还当前的题型中
            [self Next_subjectivityConfig];
            
        } else if (subjectNumber == _subjectivityArray.count) {//这个应该才是最后一个
            subjectAllNumber --;
            subjectNumber --;
            [self handIn];
            return;
        }
    }
    
    //有些刷新需要的 就在刷新之前给重置了
    [_chooseTableView reloadData];
}


#pragma mark --- 下一题的处理（由于东西太多，所以才剃出来的）
//单选题的一些配置
- (void)Next_multipleConfig {
    if ([[_multipleUserArray objectAtIndex:subjectNumber] integerValue] == 100) {//说明是没有答案的
        [_multipleSeleArray removeAllObjects];
        for (int i = 0 ; i < 10; i ++) {
            [_multipleSeleArray addObject:@"0"];
        }
    } else {//说明之前是答过题的
        [_multipleSeleArray removeAllObjects];
        for (int i = 0 ; i < 10 ; i ++) {
            if (i == [[_multipleUserArray objectAtIndex:subjectNumber] integerValue] - 1) {
                [_multipleSeleArray addObject:@"1"];
            } else {
                [_multipleSeleArray addObject:@"0"];
            }
        }
    }
}
//主观题的一些配置
- (void)Next_moreMultipleConfig {
    //进去多选题的准备
    NSMutableArray *moreCurrentMultipleArray = [NSMutableArray array];
    moreCurrentMultipleArray = [_moreMultipleUserArray objectAtIndex:subjectNumber];
    BOOL isHaveAnswer = NO;
    for (int i = 0 ; i < moreCurrentMultipleArray.count ; i ++) {
        if ([[moreCurrentMultipleArray objectAtIndex:i] integerValue] == 100) {
            
        } else {
            isHaveAnswer = YES;
        }
    }
    
    if (isHaveAnswer) {
        [_moreMultipleSeleArray removeAllObjects];
        for (int i = 0 ; i < moreCurrentMultipleArray.count ; i ++) {
            if ( [[moreCurrentMultipleArray objectAtIndex:i] integerValue] == 1) {
                [_moreMultipleSeleArray addObject:@"1"];
            } else {
                [_moreMultipleSeleArray addObject:@"0"];
            }
        }
    } else {//没有答案的，所以全部重置
        [_moreMultipleSeleArray removeAllObjects];
        for (int i = 0 ; i < 10; i ++) {
            [_moreMultipleSeleArray addObject:@"0"];
        }
    }
}
//判断的一些配置
- (void)Next_judgeConfig {
    if ([[_judgeUserArray objectAtIndex:subjectNumber] integerValue] == 100) {//说明是没有答案的
        [_judgeSeleArray removeAllObjects];
        for (int i = 0 ; i < 10; i ++) {
            [_judgeSeleArray addObject:@"0"];
        }
    } else {//说明之前是答过题的
        [_judgeSeleArray removeAllObjects];
        for (int i = 0 ; i < 10 ; i ++) {
            if (i == [[_judgeUserArray objectAtIndex:subjectNumber] integerValue] - 1) {
                [_judgeSeleArray addObject:@"1"];
            } else {
                [_judgeSeleArray addObject:@"0"];
            }
        }
    }
}
//填空题的一些配置
- (void)Next_gapConfig {
    
}
//主观题的一些配置
- (void)Next_subjectivityConfig {
    if ([[_subjectivityUserArray objectAtIndex:subjectNumber] integerValue] == 100) {//说明是没有答案的
        self.answerTextView.text = nil;
    } else {//说明之前是答过题的
        //将之前的答案填写在这里
        NSString *textStr = [_subjectivityUserArray objectAtIndex:subjectNumber];
        self.answerTextView.text = textStr;
    }
}


#pragma mark ---- 交卷
//交卷
- (void)handIn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认是否交卷？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self netWorkExamsSubmitExams];
        [self manageAnswer];
//        [self netWorkVideoSaveQuestion];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark ---处理答案
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
        NSMutableArray *indexMoreMultiArray = [NSMutableArray arrayWithCapacity:0];
        for (int k = 0 ; k < array.count ; k ++) {
            NSString *answer = [array objectAtIndex:k];
            if ([answer integerValue] == 1) {//说明是选中的
                answer = [optionArray objectAtIndex:k];
                [indexMoreMultiArray addObject:answer];
                index ++;
            } else if ([answer integerValue] == 100) {//没有选中的
                
            }
        }
        [self.mangerAnswerDict setObject:indexMoreMultiArray forKey:[[_moreMultipleArray objectAtIndex:i] stringValueForKey:@"exams_question_id"]];
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
    
    //填空题
    for (int i = 0 ; i < _gapArray.count ; i ++) {
        NSArray *array = [_gapUserArray objectAtIndex:i];
        NSMutableArray *indexGapArray = [NSMutableArray arrayWithCapacity:0];
        for (int k = 0 ; k < array.count ; k ++) {
            NSString *answer = [array objectAtIndex:k];
            if ([answer integerValue] == 100) {//没有作答
                
            } else if ([answer isEqualToString:@""]) {//没有作答
                
            } else {
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
        } else if ([answer isEqualToString:@""]) {//没有作答
            
        } else {//作答
            [self.mangerAnswerDict setObject:answer forKey:key];
        }
    }
    
}



//#pragma mark --- 网络请求
////考试试题的详情
//- (void)netWorkVideoSectionExams {
//    NSString *endUrlStr = YunKeTang_Video_video_sectionExams;
//    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
//
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:[_videoDict stringValueForKey:@"qid"] forKey:@"exams_id"];
////    [mutabDict setObject:@"2" forKey:@"exams_type"];
//
//    NSString *oath_token_Str = nil;
//    if (UserOathToken) {
//        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//    }
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
//    [request setHTTPMethod:NetWay];
//    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
//    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
//    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
//
//    [TKProgressHUD showMessag:@"加载中...." toView:[UIApplication sharedApplication].keyWindow];
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
//        NSLog(@"----%@",_dataArray);
//        [self initialization];
//        [_chooseTableView reloadData];
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        [TKProgressHUD showError:@"加载失败" toView:self.view];
//    }];
//    [op start];
//}
//
//
////考试试题提交
//- (void)netWorkVideoSaveQuestion {
//    NSString *endUrlStr = YunKeTang_Video_video_saveQuestion;
//    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
//
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:[_videoDict stringValueForKey:@"qid"] forKey:@"exams_question_id"];
//    [mutabDict setObject:[_videoDict stringValueForKey:@"id"] forKey:@"section_id"];
//    [mutabDict setObject:self.mangerAnswerDict forKey:@"user_answer"];
//
//    NSString *oath_token_Str = nil;
//    if (UserOathToken) {
//        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
//    }
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
//    [request setHTTPMethod:NetWay];
//    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
//    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
//    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
//        [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self backPressed];
//        });
//
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        [TKProgressHUD showError:@"加载失败" toView:self.view];
//    }];
//    [op start];
//}
//
//



@end
