//
//  TestCurrentViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestCurrentViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "TestAnswerSheetViewController.h"
#import "TestChooseTableViewCell.h"
#import "TestGapTableViewCell.h"
#import "TestSubjectivityTableViewCell.h"



@interface TestCurrentViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UITextViewDelegate> {
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
@property (strong, nonatomic) UILabel *examPointLabel;// 考点内容
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


@end

@implementation TestCurrentViewController

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

- (UILabel *)examPointLabel {
    if (!_examPointLabel) {
        _examPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit - 10 * WideEachUnit - 100 *WideEachUnit, 80 * WideEachUnit, 100 * WideEachUnit, 20 * WideEachUnit)];
        _examPointLabel.textColor = RGBHex(0x868686);
        _examPointLabel.font = SYSTEMFONT(13);
        _examPointLabel.textAlignment = NSTextAlignmentRight;
    }
    return _examPointLabel;
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
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 20 * WideEachUnit, 165 * WideEachUnit, 44 * WideEachUnit)];
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

#pragma mark --- 视图开始

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //进去当前界面的标识符
    stayWhiceController = @"TestCurrent";
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    //在离开的时候标识符
    stayWhiceController = @"TestAnswerSheet";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self initialization];//初始化
    [self addNav];
    [self addChooseTableView];
//    [self addGapTableView];
//    [self addSubjectivityTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    if ([[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"].allKeys.count == 0) {
        [TKProgressHUD showError:@"数据为空" toView:self.view];
        [self backPressed];
        return;
    }
    _multipleArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"1"];
    _moreMultipleArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"2"];
    _judgeArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"3"];
    _gapArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"4"];
    _subjectivityArray = (NSMutableArray *)[[[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions_data"] arrayValueForKey:@"5"];
    
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
    if (_currentArray.count == 0) {
        [self backPressed];
        return;
    }
    
    
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
    
    if ([_examsType integerValue] == 1) {//练习模式
        if ([_continueStr isEqualToString:@"continue"]) {//表示这次进来是继续答上次没有答完的题
            
            timePastting = [[_dataSource stringValueForKey:@"anser_time"] integerValue];
            
            //这里就要处理之前的答案和之前答题的时间了
            _userOlderAnswerArray = [_dataSource arrayValueForKey:@"user_answer_temp"];//这个是装之前答过的答案
            [self managerBeforeAnswer];
        }
    }
    
    if ([_examsType integerValue] == 3) {//查看模式会得到答案
        [self getUserAnswer];
        [self check_userAnswer];//得到之前用户上传自己做的答案
    }
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MACRO_UI_UPHEIGHT)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    _timeLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        _timeLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    
    if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {
        
        if ([_continueStr isEqualToString:@"continue"]) {//继续作答
            if ([[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] == 0) {
                 _timeLabel.text = @"00:00:00";
            } else {//再次进来的时间
                 allTime = [[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] * 60;//转为秒
            }
        } else if ([_continueStr isEqualToString:@"again"]) {//再次挑战
            if ([[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] == 0) {
                _timeLabel.text = @"00:00:00";
            } else {
                allTime = [[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] * 60;//转为秒
            }
        } else {//第一次作答
            if ([[_testDict stringValueForKey:@"reply_time"] integerValue] == 0) {
                 _timeLabel.text = @"00:00:00";
            } else {
                 allTime = [[_testDict stringValueForKey:@"reply_time"] integerValue] * 60;//转为秒
            }
        }
        
        [self addTimePass];
        
        
        
    } else if ([_examsType integerValue] == 3) {//查看模式
        _timeLabel.text = @"在线考试";
    }
    
    [_timeLabel setTextColor:[UIColor whiteColor]];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    [SYGView addSubview:_timeLabel];
    
    
    
    UIButton *stopAndBeginButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 40, 40)];
    [stopAndBeginButton setImage:[UIImage imageNamed:@"pause@3x"] forState:UIControlStateNormal];
    [stopAndBeginButton addTarget:self action:@selector(stopBeginButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:stopAndBeginButton];
    if ([_examsType integerValue] == 2 || [_examsType integerValue] == 3) {
        stopAndBeginButton.hidden = YES;
    } else {
        stopAndBeginButton.hidden = NO;
    }
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 22+MACRO_UI_STATUSBAR_ADD_HEIGHT, 40, 40)];
    [commitButton setImage:[UIImage imageNamed:@"sheet@3x"] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:commitButton];
    
    
    
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT - 1,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

#pragma mark --- 定时器
- (void)addTimePass {
    
    if ([_continueStr isEqualToString:@"continue"]) {//继续作答
        if ([[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] == 0) {//没有时间限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePassWithOut) userInfo:nil repeats:YES];
        } else {//有时间限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
        }
    } else if ([_continueStr isEqualToString:@"again"]) {
        NSLog(@"%@",_testDict[@"paper_info"][@"reply_time"]);
        if ([[[_testDict dictionaryValueForKey:@"paper_info"] stringValueForKey:@"reply_time"] integerValue] == 0) {//没有时间限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePassWithOut) userInfo:nil repeats:YES];
        } else {//有时间限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
        }
    } else {//第一次进来作答
        if ([[_testDict stringValueForKey:@"reply_time"] integerValue] == 0) {//没有时间限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePassWithOut) userInfo:nil repeats:YES];
        } else {//有时间限制
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
        }
    }
    

}
- (void)timePast {
    timePastting ++;
    if (allTime == 0 || allTime < 0) {
        return;
    }
    NSInteger endTime = allTime - timePastting;
    NSInteger endHour = endTime / 3600;
    NSInteger endMin = (endTime - endHour * 3600) / 60;
    NSInteger endSecond = endTime % 60;
    NSString *endString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",endHour,endMin,endSecond];
    _timeLabel.text = endString;
    
    if ([_timeLabel.text isEqualToString:@"00:00:00"]) {
        [_timer invalidate];
        self.timer = nil;
        //被迫交卷
        if ([stayWhiceController isEqualToString:@"TestAnswerSheet"]) {//说明当前用户在后面的答题卡
            
        } else if ([stayWhiceController isEqualToString:@"TestCurrent"]){//当前界面
//             [self forcedCommitPaper];
            [self netWorkExamsSubmitExams];
        }

    }
}

//没有限制的时候的时间规定
- (void)timePassWithOut {
    timePastting ++;
    NSInteger BeginTime = timePastting;
    NSInteger benginHour = BeginTime / 3600;
    NSInteger benginMin = (BeginTime - benginHour * 3600) / 60;
    NSInteger benginSecond = BeginTime % 60;
    NSString *benginString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",benginHour,benginMin,benginSecond];
    _timeLabel.text = benginString;
}


//由于时间到了才提示的是否需要交卷
- (void)forcedCommitPaper {
    TestAnswerSheetViewController *vc = [[TestAnswerSheetViewController alloc] init];
    vc.dataSource = _dataSource;
    vc.multipleUserArray = _multipleUserArray;
    vc.moreMultipleUserArray = _moreMultipleUserArray;
    vc.judgeUserArray = _judgeUserArray;
    vc.gapUserArray = _gapUserArray;
    vc.subjectivityUserArray = _subjectivityUserArray;
    vc.examType = _examsType;
    
    if ([_continueStr isEqualToString:@"again"]) {//再次挑战
        vc.againStr = @"again";
    }
    
    //传入由于时间到了才交卷的标识符
    vc.timeIsOver = @"timeOver";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 添加表格
//选择表格
- (void)addChooseTableView {
    _chooseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStyleGrouped];
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
    if ([_errorsFag isEqualToString:@"error"]) {//说明现在的模式是查看模式下面的错题解析模式
        NSInteger errorAllNumber = _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count + _subjectivityArray.count;
         currentNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",subjectAllNumber + 1,errorAllNumber];
    } else if ([_errorsFag isEqualToString:@"wrongExams"]){//错题重做的
        NSInteger errorAllNumber = _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count + _subjectivityArray.count;
        currentNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",subjectAllNumber + 1,errorAllNumber];
    } else if ([_examsType integerValue] == 3) {//全部解析
        NSInteger errorAllNumber = _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count + _subjectivityArray.count;
        currentNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",subjectAllNumber + 1,errorAllNumber];
    } else {
//        currentNumberLabel.text = [NSString stringWithFormat:@"%ld/%@",subjectAllNumber + 1,[_dataSource stringValueForKey:@"questions_count"]];
        
        NSInteger errorAllNumber = _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count + _subjectivityArray.count;
        currentNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",subjectAllNumber + 1,errorAllNumber];
    }
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

    if (_currentArray.count == 0) {
        [self backPressed];
        return headerView;
    }
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
    if ([_examsType integerValue] == 1) {//练习模式
        if (unwindButtonSele) {//选中（为展开）
            if (whichSubject == 4) {//填空
                return 220 * WideEachUnit + gapTrueHeight + analysisHeight;
            } else {//非填空的时候
                return 240 * WideEachUnit + analysisHeight;
            }
        } else {//闭合状态
            return 120 * WideEachUnit;
        }
    } else if ([_examsType integerValue] == 2) {//考试模式
        return 120 * WideEachUnit;
    } else if ([_examsType integerValue] == 3) {//查看模式
        if (whichSubject == 4) {//填空题的时候
             return 190 * WideEachUnit + gapTrueHeight + analysisHeight;
        } else {//非填空题的时候
             return 210 * WideEachUnit + analysisHeight;
        }

    }
    return 0;

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
    
    if (_errorsFag == nil) {//这个标识符为空的时候 就是为联系模式或者考试模式，或者是查看全部解析的模式
        if (subjectAllNumber == 0) {//第一题的时候
            self.advButton.hidden = YES;
            self.nextButton.frame = CGRectMake(15 * WideEachUnit, 20 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit);
        } else if (subjectAllNumber + 1 == [[_dataSource stringValueForKey:@"questions_count"] integerValue] ){//最后一题
            self.advButton.hidden = NO;
            self.nextButton.frame = CGRectMake(195 * WideEachUnit, 20 * WideEachUnit, 165 * WideEachUnit, 44 * WideEachUnit);
            [self.nextButton setTitle:@"交卷" forState:UIControlStateNormal];
            self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#f76c59"];
            if ([_examsType integerValue] == 3) {//查看模式
                [self.nextButton setTitle:@"退出" forState:UIControlStateNormal];
            }
        } else {//中间题的时候
            self.advButton.hidden = NO;
            self.nextButton.frame = CGRectMake(195 * WideEachUnit, 20 * WideEachUnit, 165 * WideEachUnit, 44 * WideEachUnit);
        }
    } else if ([_errorsFag isEqualToString:@"error"] || [_errorsFag isEqualToString:@"wrongExams"]) {//错题解析或者是错题重做的时候
        NSInteger errorAllNumber = _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count + _subjectivityArray.count;
        
        if (subjectAllNumber == 0) {//第一题的时候
            self.advButton.hidden = YES;
            self.nextButton.frame = CGRectMake(15 * WideEachUnit, 20 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 44 * WideEachUnit);
        } else if (subjectAllNumber + 1 == errorAllNumber ){//最后一题
            self.advButton.hidden = NO;
            self.nextButton.frame = CGRectMake(195 * WideEachUnit, 20 * WideEachUnit, 165 * WideEachUnit, 44 * WideEachUnit);
            [self.nextButton setTitle:@"交卷" forState:UIControlStateNormal];
            self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#f76c59"];
            if ([_examsType integerValue] == 3) {//查看模式
                [self.nextButton setTitle:@"退出" forState:UIControlStateNormal];
            }
        } else {//中间题的时候
            self.advButton.hidden = NO;
            self.nextButton.frame = CGRectMake(195 * WideEachUnit, 20 * WideEachUnit, 165 * WideEachUnit, 44 * WideEachUnit);
        }
    }
    
    self.nextButton.layer.cornerRadius = 3 * WideEachUnit;
    [self.nextButton addTarget:self action:@selector(nextButtonButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:self.nextButton];
    
    //添加展开习题的按钮

    if (unwindButtonSele) {
        [self.unwindButton setTitle:@"收起解析" forState:UIControlStateNormal];
        [self.unwindButton setImage:Image(@"ic_dropdown_livedown@3x") forState:UIControlStateNormal];
    } else {
        [self.unwindButton setTitle:@"展开解析" forState:UIControlStateNormal];
        [self.unwindButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    
    self.unwindButton.imageEdgeInsets =  UIEdgeInsetsMake(0,70 * WideEachUnit,0,0);
    self.unwindButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40 * WideEachUnit);
    [self.unwindButton setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
    self.unwindButton.layer.cornerRadius = 3 * WideEachUnit;
    self.unwindButton.titleLabel.font = Font(14 * WideEachUnit);
    [self.unwindButton addTarget:self action:@selector(unwindButtonButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFootView addSubview:self.unwindButton];
    if ([_examsType integerValue] == 1) {//练习模式
        self.unwindButton.hidden = NO;
    } else if ([_examsType integerValue] == 2) {//考试模式
        self.unwindButton.hidden = YES;
    }
    
    //添加收藏习题的按钮
    [self.collectButton setTitle:@" 收藏习题" forState:UIControlStateNormal];
    if ([[self.collectArray objectAtIndex:subjectAllNumber] integerValue] == 0) {
        [self.collectButton setImage:Image(@"test_uncollect@3x") forState:UIControlStateNormal];
        [self.collectButton setTitle:@" 收藏习题" forState:UIControlStateNormal];
    } else {
        [self.collectButton setImage:Image(@"test_collect@3x") forState:UIControlStateSelected];
        [self.collectButton setTitle:@" 取消收藏" forState:UIControlStateNormal];
    }
    [self.collectButton setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
    self.collectButton.titleLabel.font = Font(13 * WideEachUnit);
    [self.collectButton addTarget:self action:@selector(collectButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    self.examPointLabel.text = [NSString stringWithFormat:@"考点:%@",[[_currentArray objectAtIndex:subjectNumber] objectForKey:@"exams_point_title"]];
    
    
    //添加解析的界面
    if ([_examsType integerValue] == 1 || [_examsType integerValue] == 3) {//练习模式 或者是查看模式
        self.correctAndMyAnswerView.backgroundColor = [UIColor colorWithHexString:@"#fde7e4"];
        self.correctAndMyAnswerView.layer.cornerRadius = 3 * WideEachUnit;
        [self.tableFootView addSubview:self.correctAndMyAnswerView];
        
        //添加正确答案
        self.trueAnswerLabel.text = @"正确答案";
        self.trueAnswerLabel.font = Font(12 * WideEachUnit);
        self.trueAnswerLabel.textColor = [UIColor colorWithHexString:@"#333"];
        self.trueAnswerLabel.textAlignment = NSTextAlignmentCenter;
        if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3) {//选择题的时候
            self.trueAnswerLabel.textAlignment = NSTextAlignmentCenter;
        } else if (whichSubject == 4 || whichSubject == 5) {//填空和主观
            self.trueAnswerLabel.textAlignment = NSTextAlignmentLeft;
            self.trueAnswerLabel.text = @"  正确答案";
        }
        [self.correctAndMyAnswerView addSubview:self.trueAnswerLabel];
        
        //添加答案
        self.trueAnswer.textColor = [UIColor colorWithHexString:@"#6bbc7c"];
        self.trueAnswer.font = Font(20 * WideEachUnit);
        self.trueAnswer.textAlignment = NSTextAlignmentCenter;
        NSArray *answer_true_option_array = [[_currentArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
        NSString *answer_true_option_str = nil;
        for (int i = 0 ; i < answer_true_option_array.count ; i ++) {
            if (i == 0) {
                if (whichSubject == 4) {
                     answer_true_option_str = [NSString stringWithFormat:@"%d、%@",i + 1,[answer_true_option_array objectAtIndex:i]];
                    self.trueAnswer.font = Font(14 * WideEachUnit);
                } else if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3 || whichSubject == 5) {
                     answer_true_option_str = [NSString stringWithFormat:@"%@",[answer_true_option_array objectAtIndex:i]];
                }
            } else {
                if (whichSubject == 4) {//填空的时候
                     answer_true_option_str = [NSString stringWithFormat:@"%@   %d、%@",answer_true_option_str,i + 1,[answer_true_option_array objectAtIndex:i]];
                     self.trueAnswer.font = Font(14 * WideEachUnit);
                } else if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3 || whichSubject == 5) {
                     answer_true_option_str = [NSString stringWithFormat:@"%@%@",answer_true_option_str,[answer_true_option_array objectAtIndex:i]];
                }
            }
        }
        self.trueAnswer.text = answer_true_option_str;
        [self.correctAndMyAnswerView addSubview:self.trueAnswer];
        
        
        //在这里来清算是属于哪种类型的题（根据不同的类型显示不同）
        if (whichSubject == 1 || whichSubject == 2 || whichSubject == 3) {//选择题的时候
            self.trueAnswerLabel.textAlignment = NSTextAlignmentCenter;
        } else if (whichSubject == 4) {//填空
            self.trueAnswerLabel.textAlignment = NSTextAlignmentLeft;
            self.trueAnswerLabel.text = @"  正确答案";
            self.trueAnswer.textAlignment = NSTextAlignmentLeft;
            self.trueAnswer.font = Font(14 * WideEachUnit);
            self.trueAnswer.frame = CGRectMake(10 * WideEachUnit,32 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit);//重新安排哈位置
            //填空的正确答案
            self.trueAnswer.numberOfLines = 0;
            CGRect labelSize = [self.trueAnswer.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 50 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * WideEachUnit]} context:nil];
            if (labelSize.size.height < 20 * WideEachUnit) {
                labelSize.size.height = 20 * WideEachUnit;
            }
            self.trueAnswer.frame = CGRectMake(10 * WideEachUnit,32 * WideEachUnit,MainScreenWidth - 40 * WideEachUnit, labelSize.size.height);
            self.correctAndMyAnswerView.frame = CGRectMake(15 * WideEachUnit, 120 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit + labelSize.size.height);
            gapTrueHeight = labelSize.size.height;//记录当前的高度
            
        } else if (whichSubject == 5) {//主观
            self.trueAnswerLabel.textAlignment = NSTextAlignmentLeft;
            self.trueAnswerLabel.text = @"  正确答案";
            //因为主观题不会返回正确答案 所以这里为空的（默认的）
            self.correctAndMyAnswerView.frame = CGRectMake(15 * WideEachUnit, 120 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 70 * WideEachUnit);
            
            //在这里要提前算了（因为是主观，后面又设置了一次,因为涉及到主观题的界面解析需要承接这里的答案视图）
            self.correctAndMyAnswerView.frame = CGRectMake(15 * WideEachUnit, 120 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 70 * WideEachUnit);
        }
        
        
        //添加解析的界面
        self.analysisView.backgroundColor = [UIColor whiteColor];
        [self.tableFootView addSubview:self.analysisView];
        
        if (unwindButtonSele) {
            self.correctAndMyAnswerView.hidden = NO;
            self.analysisView.hidden = NO;
        } else {
            self.correctAndMyAnswerView.hidden = YES;
            self.analysisView.hidden = YES;
        }
        
        self.analysisLabel.text = @"解析";
        self.analysisLabel.font = Font(16 * WideEachUnit);
        self.analysisLabel.textColor = [UIColor colorWithHexString:@"#888"];
        [self.analysisView addSubview:self.analysisLabel];
        

        self.analysisContentLabel.backgroundColor = [UIColor whiteColor];
        self.analysisContentLabel.font = Font(14 * WideEachUnit);
        self.analysisContentLabel.text = [Passport filterHTML:[[_currentArray objectAtIndex:subjectNumber] stringValueForKey:@"analyze" defaultValue:@""]];
        self.analysisContentLabel.numberOfLines = 0;
        
        CGRect labelSize = [self.analysisContentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 30 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * WideEachUnit]} context:nil];
        self.analysisContentLabel.frame = CGRectMake(15 * WideEachUnit,50 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, labelSize.size.height + 15 * WideEachUnit);
        self.analysisView.frame = CGRectMake(0, CGRectGetMaxY(self.correctAndMyAnswerView.frame), MainScreenWidth, 50 * WideEachUnit + labelSize.size.height + 15 * WideEachUnit);
        [self.analysisView addSubview:self.analysisContentLabel];
        analysisHeight = labelSize.size.height + 15 * WideEachUnit;//记录当前的高度
        
        if ([_examsType integerValue] == 3) {//查看模式的一些配置
            
            if (whichSubject == 5) {//填空题和主观题不需要这样
                self.collectButton.hidden = YES;
                [self.unwindButton setTitle:@"" forState:UIControlStateNormal];
                [self.unwindButton setImage:Image(@"") forState:UIControlStateNormal];
                unwindButtonSele = YES;
                
                self.trueAnswerLabel.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 12 * WideEachUnit);
                self.userAnswerLabel.hidden = YES;
                self.userAnswer.hidden = YES;
                
                //设置位置
                self.correctAndMyAnswerView.frame = CGRectMake(15 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 70 * WideEachUnit);
                
            } else if (whichSubject == 4) {//填空题
                self.collectButton.hidden = YES;
                [self.unwindButton setTitle:@"" forState:UIControlStateNormal];
                [self.unwindButton setImage:Image(@"") forState:UIControlStateNormal];
                unwindButtonSele = YES;
                
                self.trueAnswerLabel.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 12 * WideEachUnit);
                self.userAnswerLabel.hidden = YES;
                self.trueAnswer.frame = CGRectMake(10 * WideEachUnit,32 * WideEachUnit,MainScreenWidth - 40 * WideEachUnit,gapTrueHeight);
                self.correctAndMyAnswerView.frame = CGRectMake(15 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit + gapTrueHeight);
                self.userAnswer.hidden = YES;
                
            } else {//选择题
                self.collectButton.hidden = YES;
                [self.unwindButton setTitle:@"" forState:UIControlStateNormal];
                [self.unwindButton setImage:Image(@"") forState:UIControlStateNormal];
                unwindButtonSele = YES;
                self.userAnswer.hidden = NO;
                self.userAnswerLabel.hidden = NO;
                
                //添加标准答案和以及自己的答案
                self.trueAnswerLabel.frame = CGRectMake(0, 10 * WideEachUnit, (MainScreenWidth - 30) / 2 , 12 * WideEachUnit);
                self.userAnswerLabel.frame = CGRectMake( (MainScreenWidth - 30) / 2, 10 * WideEachUnit, (MainScreenWidth - 30) / 2 , 12 * WideEachUnit);
                self.userAnswerLabel.text = @"我的答案";
                self.userAnswerLabel.font = Font(14 * WideEachUnit);
                self.userAnswerLabel.textColor = [UIColor colorWithHexString:@"#333"];
                [self.correctAndMyAnswerView addSubview:self.userAnswerLabel];
                self.trueAnswerLabel.textAlignment = NSTextAlignmentCenter;
                self.userAnswerLabel.textAlignment = NSTextAlignmentCenter;
                
                self.trueAnswer.frame = CGRectMake(0, 32 * WideEachUnit, (MainScreenWidth - 30) / 2 , 20 * WideEachUnit);
                self.userAnswer.frame = CGRectMake((MainScreenWidth - 30) / 2 , 32 * WideEachUnit, (MainScreenWidth - 30) / 2 , 20 * WideEachUnit);
                [self.correctAndMyAnswerView addSubview:self.userAnswer];

                self.userAnswer.textColor = [UIColor colorWithHexString:@"#d25151"];
                self.userAnswer.font = Font(20 * WideEachUnit);
                self.trueAnswer.textAlignment = NSTextAlignmentCenter;
                self.userAnswer.textAlignment = NSTextAlignmentCenter;
                
                //这里需要用户的答案现在出来
                if (whichSubject == 1) {//单选
                    BOOL isHaveCurrent = NO;
                    NSString *currentID = [NSString stringWithFormat:@"%@", [_multipleIDArray objectAtIndex:subjectNumber]];
                    if (_allUserAnswerArray.count == 0) {
                        self.userAnswer.text = @"未作答";
                    }
                    for (int i = 0 ; i < _allUserAnswerArray.count ; i ++) {
                        NSString *ID = [[_allUserAnswerArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
                        if ([currentID integerValue] == [ID integerValue]) {//说明是同一个试题
                            NSArray *answerArray = [[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"];
                            self.userAnswer.text = [[answerArray objectAtIndex:0] stringValueForKey:@"answer_value"];
                            isHaveCurrent = YES;
                            break;
                        }
                    }
                    
                    if (!isHaveCurrent) {
                        self.userAnswer.text = @"未作答";
                    }
                    
                    
                    
                } else if (whichSubject == 2) {
                    BOOL isHaveCurrent = NO;
                    if (_allUserAnswerArray.count == 0) {
                        self.userAnswer.text = @"未作答";
                    }
                    NSString *currentID = [NSString stringWithFormat:@"%@", [_moreMultipleIDArray objectAtIndex:subjectNumber]];
                    for (int i = 0 ; i < _allUserAnswerArray.count ; i ++) {
                        NSString *ID = [[_allUserAnswerArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
                        if ([currentID integerValue] == [ID integerValue]) {//说明是同一个试题
                            NSArray *moreAnswerArray = [[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"];
                            NSString *answerStr = nil;
                            for (int k = 0 ; k < moreAnswerArray.count ; k ++) {
                                if (k == 0) {
                                    answerStr = [[moreAnswerArray objectAtIndex:0] stringValueForKey:@"answer_value"];
                                } else {
                                    answerStr = [NSString stringWithFormat:@"%@%@",answerStr,[[moreAnswerArray objectAtIndex:k] stringValueForKey:@"answer_value"]];
                                }
                            }
                            self.userAnswer.text = answerStr;
                            isHaveCurrent = YES;
                            break;
                        }
                    }
                    
                    if (!isHaveCurrent) {
                         self.userAnswer.text = @"未作答";
                    }
                    
                } else if (whichSubject == 3) {
                    BOOL isHaveCurrent = NO;
                    if (_allUserAnswerArray.count == 0) {
                        self.userAnswer.text = @"未作答";
                    }
                    NSString *currentID = [NSString stringWithFormat:@"%@", [_judgeIDArray objectAtIndex:subjectNumber]];
                    for (int i = 0 ; i < _allUserAnswerArray.count ; i ++) {
                        NSString *ID = [[_allUserAnswerArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
                        if ([currentID integerValue] == [ID integerValue]) {//说明是同一个试题
                            self.userAnswer.text = [[[[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
                            isHaveCurrent = YES;
                        }
                    }
                    if (!isHaveCurrent) {
                         self.userAnswer.text = @"未作答";
                    }
                }
                
                //算尺寸
                self.correctAndMyAnswerView.frame = CGRectMake(15 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 70 * WideEachUnit);
                
            }
            _collectButton.hidden = NO;
            _collectButton.centerY = _analysisLabel.centerY;
            _examPointLabel.centerY = _collectButton.centerY;
            [self.analysisView addSubview:self.collectButton];
            [self.analysisView addSubview:self.examPointLabel];
        } else {
            [self.tableFootView addSubview:self.collectButton];
            [self.tableFootView addSubview:self.examPointLabel];
        }
        
    }
    
    
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
        
        if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
            if (whichSubject == 1) {
                [cell cellChangeWithType:whichSubject WithArray:_multipleSeleArray WithNumber:indexPath.row];
            } else if (whichSubject == 2) {
                [cell cellChangeWithType:whichSubject WithArray:_moreMultipleSeleArray WithNumber:indexPath.row];
            } else if (whichSubject == 3) {
                [cell cellChangeWithType:whichSubject WithArray:_judgeSeleArray WithNumber:indexPath.row];
            }
        } else if ([_examsType integerValue] == 3) {//查看模式
            if (whichSubject == 1) {
                NSArray *answer_true_option_array = [[_currentArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
                [cell cellChangeWithType:whichSubject WithArray:answer_true_option_array WithNumber:indexPath.row WithType:_examsType];
            } else if (whichSubject == 2) {
                NSArray *answer_true_option_array = [[_currentArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
                [cell cellChangeWithType:whichSubject WithArray:answer_true_option_array WithNumber:indexPath.row WithType:_examsType];
            } else if (whichSubject == 3) {
                NSArray *answer_true_option_array = [[_currentArray objectAtIndex:subjectNumber] arrayValueForKey:@"answer_true_option"];
                [cell cellChangeWithType:whichSubject WithArray:answer_true_option_array WithNumber:indexPath.row WithType:_examsType];
            }
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
        
        if ([_examsType integerValue] == 1 || [_examsType integerValue] == 3) {//查看模式的时候
            NSString *textStr = [_subjectivityUserArray objectAtIndex:subjectNumber];
            if ([textStr integerValue] == 100) {//说明是原始答案
                self.answerTextView.text = nil;
            } else {
                self.answerTextView.text = textStr;
            }
        }
        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_examsType integerValue] == 3) {//查看模式
        return;
    }
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

- (void)GoOut {
    [self.navigationController popViewControllerAnimated:YES];
    [_timer invalidate];
    self.timer = nil;
}

- (void)backPressed {
    
    if ([_examsType integerValue] == 3) {//查看模式
        [self GoOut];
        return;
    }

    NSString *messageStr = nil;
    if ([_examsType integerValue] == 1) {//练习模式
        messageStr = @"（退出后会保留当前答题进度）";
        if ([[_dataSource stringValueForKey:@"assembly_type"] integerValue] == 1) {//不会保存进度
            messageStr = @"退出但是不会保存进度";
        }
    } else if ([_examsType integerValue] == 2) {
        messageStr = @"（退出后不会保留当前答题进度）";
    }
    if ([_errorsFag isEqualToString:@"wrongExams"]) {//错题重练
        messageStr = @"（退出后会保留当前答题进度）";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出当前答题" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if ([_examsType integerValue] == 1) {//练习模式 (保存当前进度)
            if ([_errorsFag isEqualToString:@"wrongExams"]) {//错题重练
                [self netWorkExamsSaveExams];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self GoOut];
                });
            } else {
                if ([[_dataSource stringValueForKey:@"assembly_type"] integerValue] == 1) {//不会保存进度 并会退出
                    [self GoOut];
                } else {
                    [self netWorkExamsSaveExams];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self GoOut];
                    });
                }
            }
        } else if ([_examsType integerValue] == 2) {
            [self GoOut];
        }
        
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

    }];
                               
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)stopBeginButtonCilck {
     [self.timer setFireDate:[NSDate distantFuture]];
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:_allView];
    
    NSArray *buttonArray = @[@"继续",@"退出"];
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(82 * WideEachUnit, 300 * WideEachUnit + 64 * WideEachUnit * i, 210 * WideEachUnit, 44 * WideEachUnit)];
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 2;
        button.tag = i;
        button.titleLabel.font = Font(16 * WideEachUnit);
        button.layer.cornerRadius = 22 * WideEachUnit;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stopTypeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_allView addSubview:button];
    }
}

- (void)stopTypeButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//继续
        [_allView removeFromSuperview];
         [self.timer setFireDate:[NSDate distantPast]];
    } else {//退出
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要离开，离开后可在我的考试里面继续答题" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//            [_allView removeFromSuperview];
//            [self backPressed];
//        }];
//        [alertController addAction:sureAction];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        [self backPressed];
    }
}

- (void)commitButtonCilck {
    TestAnswerSheetViewController *vc = [[TestAnswerSheetViewController alloc] init];
    vc.dataSource = _dataSource;
    vc.multipleUserArray = _multipleUserArray;
    vc.moreMultipleUserArray = _moreMultipleUserArray;
    vc.judgeUserArray = _judgeUserArray;
    vc.gapUserArray = _gapUserArray;
    vc.subjectivityUserArray = _subjectivityUserArray;
    vc.examType = _examsType;
    vc.classTestType = _classTestType;
    if ([_continueStr isEqualToString:@"again"]) {//再次挑战
        vc.againStr = @"again";
    } else if ([_continueStr isEqualToString:@"continue"]) {//继续答题
        vc.contentStr = _continueStr;
    }
    
    
    if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
        //传时间相关的一些东西
        if ([[_testDict stringValueForKey:@"reply_time"] integerValue] == 0) {
            vc.passTimeIng = timePastting;
            vc.testDict = _testDict;
        } else {//添加时间限制的相关
            vc.testDict = _testDict;
            vc.passTimeIng = timePastting;
        }
    } else if ([_examsType integerValue] == 3) {//查看模式不需要
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
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

//展开的按钮
- (void)unwindButtonButtonCilck:(UIButton *)button {
    if ([_examsType integerValue] == 1) {//练习模式
        unwindButtonSele = !unwindButtonSele;
        if (unwindButtonSele) {
            [self.unwindButton setTitle:@"收起解析" forState:UIControlStateNormal];
            [self.unwindButton setImage:Image(@"ic_dropdown_livedown@3x") forState:UIControlStateNormal];
        } else {
            [self.unwindButton setTitle:@"展开解析" forState:UIControlStateNormal];
            [self.unwindButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        }
        [_chooseTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [_chooseTableView reloadData];
        });
    } else if ([_examsType integerValue] == 2) {//考试模式
        
    }
}

- (void)collectButtonCilck {
    if ([[[_currentArray objectAtIndex:subjectNumber] stringValueForKey:@"is_collect"] integerValue] == 0) {
        collectType = @"1";
//        [self NetWorkCollect];
        [self netWorkExamsCollect];
    } else {
        collectType = @"0";
//        [self NetWorkCollect];
        [self netWorkExamsCollect];
    }
}

//交卷
- (void)handIn {
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

#pragma mark --- 通知
- (void)answerTextFieldTextChange:(NSNotification *)not {
    
}
- (void)TestGapTableViewCellGetAnswerAndNumber:(NSNotification *)not {
    
    NSLog(@"OBJ---%@",not.object);
    NSInteger Number = [[not.object stringValueForKey:@"number"] integerValue];
    NSString *textStr = [not.object stringValueForKey:@"text"];
    
    NSMutableArray *indexArray = [_gapUserArray objectAtIndex:subjectNumber];
    if (Number >= indexArray.count) {
        return;
    }
    [indexArray replaceObjectAtIndex:Number withObject:textStr];
    NSLog(@"=----%ld",Number);
    [_gapUserArray replaceObjectAtIndex:subjectNumber withObject:indexArray];
    
    NSLog(@"%@",_gapUserArray);
}

- (void)answerTextViewTextChange:(NSNotification *)not {
    NSString *textStr = self.answerTextView.text;
    [_subjectivityUserArray replaceObjectAtIndex:subjectNumber withObject:textStr];
}

//从答题卡传过来的具体哪题
- (void)TestAnswerSheetGiveButtonTag:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSString *tagStr = not.object;
    NSInteger tag = [tagStr integerValue];
    whichSubject = tag / 100;
    subjectNumber = tag % 100;
    if (whichSubject == 1) {
        _currentArray = _multipleArray;
        subjectAllNumber = subjectNumber;
        [_multipleSeleArray removeAllObjects];
        [self Next_multipleConfig];
    } else if (whichSubject == 2) {
        _currentArray = _moreMultipleArray;
        subjectAllNumber = subjectNumber + _multipleArray.count;
        [self Next_moreMultipleConfig];
    } else if (whichSubject == 3) {
        _currentArray = _judgeArray;
        subjectAllNumber = subjectNumber + _multipleArray.count + _moreMultipleArray.count;
        [self Next_judgeConfig];
    } else if (whichSubject == 4) {
        _currentArray = _gapArray;
        subjectAllNumber = subjectNumber + _multipleArray.count + _moreMultipleArray.count + _judgeArray.count;
        [self Next_gapConfig];
    } else if (whichSubject == 5) {
        _currentArray = _subjectivityArray;
        subjectAllNumber = subjectNumber + _multipleArray.count + _moreMultipleArray.count + _judgeArray.count + _gapArray.count;
        [self Next_subjectivityConfig];
    }
    
    [_chooseTableView reloadData];
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
    
    
    //有些刷新需要的 就在刷新之前给重置了
    if ([_examsType integerValue] == 1) {//如果是练习模式，就在点击上一题的时候收上去
        unwindButtonSele = NO;
    }
    [_chooseTableView reloadData];
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

                if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
                    [self handIn];
                } else if ([_examsType integerValue] == 3) {//查看模式
                    [self GoOut];
                }
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
                if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
                    [self handIn];
                } else if ([_examsType integerValue] == 3) {//查看模式
                    [self GoOut];
                }
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
                if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
                    [self handIn];
                } else if ([_examsType integerValue] == 3) {//查看模式
                    [self GoOut];
                }
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
                if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
                    [self handIn];
                } else if ([_examsType integerValue] == 3) {//查看模式
                    [self GoOut];
                }
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
            if ([_examsType integerValue] == 1 || [_examsType integerValue] == 2) {//练习或者考试模式
                [self handIn];
            } else if ([_examsType integerValue] == 3) {//查看模式
                [self GoOut];
            }
            return;
        }
    }
    
    //有些刷新需要的 就在刷新之前给重置了
//    [_multipleSeleArray removeAllObjects];
    if ([_examsType integerValue] == 1) {//如果是练习模式，就在点击下一题的时候收上去
        unwindButtonSele = NO;
    }
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

#pragma mark ---- 在查看模式下的到接口返回的用户的答案
- (void)getUserAnswer  {
    //得到全部的答案
    _allUserAnswerArray = [[_dataSource dictionaryValueForKey:@"exams_user_info"] arrayValueForKey:@"content"];
    
}

#pragma mark --- 查看模式下得到用户之前做的答案
- (void)check_userAnswer {
    
    for (int i = 0 ; i < _allUserAnswerArray.count ; i ++ ) {
        NSString *questionID = [[_allUserAnswerArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        NSString *multAnswerVale = [[[[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
        
        //单选的时候
        for (int k = 0 ; k < _multipleIDArray.count ; k ++) {//单选的时候
            NSString *multID = [_multipleIDArray objectAtIndex:k];
            if ([multID integerValue] == [questionID integerValue]) {//说明就是同一题
                
                if ([multAnswerVale isEqualToString:@"A"]) {
                    [_multipleUserArray replaceObjectAtIndex:k withObject:@"1"];
                } else if ([multAnswerVale isEqualToString:@"B"]) {
                    [_multipleUserArray replaceObjectAtIndex:k withObject:@"2"];
                } else if ([multAnswerVale isEqualToString:@"C"]) {
                    [_multipleUserArray replaceObjectAtIndex:k withObject:@"3"];
                } else if ([multAnswerVale isEqualToString:@"D"]) {
                    [_multipleUserArray replaceObjectAtIndex:k withObject:@"4"];
                } else if ([multAnswerVale isEqualToString:@"E"]) {
                    [_multipleUserArray replaceObjectAtIndex:k withObject:@"5"];
                } else if ([multAnswerVale isEqualToString:@"F"]) {
                    [_multipleUserArray replaceObjectAtIndex:k withObject:@"6"];
                }
                //                continue;
            }
        }
        
        NSArray *moreMultArray = [[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"];
        //多选的时候
        for (int k = 0 ; k < _moreMultipleIDArray.count ; k ++) {
            NSString *moreMultID = [_moreMultipleIDArray objectAtIndex:k];
            if ([questionID integerValue] == [moreMultID integerValue]) {//说明是同一题
                for (int j = 0 ; j < moreMultArray.count ; j ++) {
                    NSDictionary *moreMultDict = [moreMultArray objectAtIndex:j];
                    NSMutableArray *flgArray = [NSMutableArray arrayWithArray:[_moreMultipleUserArray objectAtIndex:k]];
                    if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"A"]) {
                        [flgArray replaceObjectAtIndex:0 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"B"]) {
                        [flgArray replaceObjectAtIndex:1 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"C"]) {
                        [flgArray replaceObjectAtIndex:2 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"D"]) {
                        [flgArray replaceObjectAtIndex:3 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"E"]) {
                        [flgArray replaceObjectAtIndex:4 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"F"]) {
                        [flgArray replaceObjectAtIndex:5 withObject:@"1"];
                    }
                    
                    [_moreMultipleUserArray replaceObjectAtIndex:k withObject:flgArray];
                }
            }
        }
        
        //判断
        NSString *judgeAnswerVale = [[[[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
        for (int k = 0 ; k < _judgeIDArray.count ; k ++) {//单选的时候
            NSString *judgeID = [_judgeIDArray objectAtIndex:k];
            if ([judgeID integerValue] == [questionID integerValue]) {//说明就是同一题
                if ([judgeAnswerVale isEqualToString:@"A"]) {//因为判断只有2中情况
                    [_judgeUserArray replaceObjectAtIndex:k withObject:@"1"];
                } else {
                    [_judgeUserArray replaceObjectAtIndex:k withObject:@"2"];
                }
//                continue;
            }
        }
        
        //填空
        NSArray *answerGapArray = [[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"];
        for (int k = 0 ; k < _gapIDArray.count ; k ++) {
            NSString *gapID = [_gapIDArray objectAtIndex:k];
            if ([questionID integerValue] == [gapID integerValue]) {//说明是同一题
                for (int j = 0 ; j < answerGapArray.count ; j ++) {
                    NSDictionary *moreMultDict = [answerGapArray objectAtIndex:j];
                    NSMutableArray *flgArray = [NSMutableArray arrayWithArray:[_gapUserArray objectAtIndex:k]];
                    
                    NSInteger gapIndex = [[moreMultDict stringValueForKey:@"answer_key"] integerValue];
                    NSString *gapStr = [moreMultDict stringValueForKey:@"answer_value"];
                    [flgArray replaceObjectAtIndex:gapIndex withObject:gapStr];
                    [_gapUserArray replaceObjectAtIndex:k withObject:flgArray];
                }
            }
        }
        
        
        
        //主观
        NSString *subjectAnswerVale = [[[[_allUserAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
        for (int k = 0 ; k < _subjectivityIDArray.count ; k ++) {//单选的时候
            NSString *judgeID = [_subjectivityIDArray objectAtIndex:k];
            if ([judgeID integerValue] == [questionID integerValue]) {//说明就是同一题
                [_subjectivityUserArray replaceObjectAtIndex:k withObject:subjectAnswerVale];
//                continue;
            }
        }
    }
    
}


#pragma mark --- 处理继续答题的一些事情（吧之前的答案都放在最新的答案里面去）
- (void)managerBeforeAnswer {//继续答案的时候 处理之前的答案
    for (int i = 0 ; i < _userOlderAnswerArray.count ; i ++ ) {
        NSString *questionID = [[_userOlderAnswerArray objectAtIndex:i] stringValueForKey:@"exams_question_id"];
        NSString *multAnswerVale = [[[[_userOlderAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
        
        //单选的时候
        for (int k = 0 ; k < _multipleIDArray.count ; k ++) {//单选的时候
            NSString *multID = [_multipleIDArray objectAtIndex:k];
            if ([multID integerValue] == [questionID integerValue]) {//说明就是同一题

                if ([multAnswerVale isEqualToString:@"A"]) {
                     [_multipleUserArray replaceObjectAtIndex:k withObject:@"1"];
                } else if ([multAnswerVale isEqualToString:@"B"]) {
                     [_multipleUserArray replaceObjectAtIndex:k withObject:@"2"];
                } else if ([multAnswerVale isEqualToString:@"C"]) {
                     [_multipleUserArray replaceObjectAtIndex:k withObject:@"3"];
                } else if ([multAnswerVale isEqualToString:@"D"]) {
                     [_multipleUserArray replaceObjectAtIndex:k withObject:@"4"];
                } else if ([multAnswerVale isEqualToString:@"E"]) {
                     [_multipleUserArray replaceObjectAtIndex:k withObject:@"5"];
                } else if ([multAnswerVale isEqualToString:@"F"]) {
                     [_multipleUserArray replaceObjectAtIndex:k withObject:@"6"];
                }
//                continue;
            }
        }
        
        NSArray *moreMultArray = [[_userOlderAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"];
        //多选的时候
        for (int k = 0 ; k < _moreMultipleIDArray.count ; k ++) {
            NSString *moreMultID = [_moreMultipleIDArray objectAtIndex:k];
            if ([questionID integerValue] == [moreMultID integerValue]) {//说明是同一题
                for (int j = 0 ; j < moreMultArray.count ; j ++) {
                    NSDictionary *moreMultDict = [moreMultArray objectAtIndex:j];
                    NSMutableArray *flgArray = [NSMutableArray arrayWithArray:[_moreMultipleUserArray objectAtIndex:k]];
                    if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"A"]) {
                         [flgArray replaceObjectAtIndex:0 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"B"]) {
                         [flgArray replaceObjectAtIndex:1 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"C"]) {
                         [flgArray replaceObjectAtIndex:2 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"D"]) {
                         [flgArray replaceObjectAtIndex:3 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"E"]) {
                         [flgArray replaceObjectAtIndex:4 withObject:@"1"];
                    } else if ([[moreMultDict stringValueForKey:@"answer_value"] isEqualToString:@"F"]) {
                         [flgArray replaceObjectAtIndex:5 withObject:@"1"];
                    }
                    
                    [_moreMultipleUserArray replaceObjectAtIndex:k withObject:flgArray];
                }
            }
        }
        
        //判断
        NSString *judgeAnswerVale = [[[[_userOlderAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
        for (int k = 0 ; k < _judgeIDArray.count ; k ++) {//单选的时候
            NSString *judgeID = [_judgeIDArray objectAtIndex:k];
            if ([judgeID integerValue] == [questionID integerValue]) {//说明就是同一题
                if ([judgeAnswerVale isEqualToString:@"A"]) {//因为判断只有2中情况
                     [_judgeUserArray replaceObjectAtIndex:k withObject:@"1"];
                } else {
                     [_judgeUserArray replaceObjectAtIndex:k withObject:@"2"];
                }
                continue;
            }
        }
        
        //填空
        NSArray *answerGapArray = [[_userOlderAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"];
        for (int k = 0 ; k < _gapIDArray.count ; k ++) {
            NSString *gapID = [_gapIDArray objectAtIndex:k];
            if ([questionID integerValue] == [gapID integerValue]) {//说明是同一题
                for (int j = 0 ; j < answerGapArray.count ; j ++) {
                    NSDictionary *moreMultDict = [answerGapArray objectAtIndex:j];
                    NSMutableArray *flgArray = [NSMutableArray arrayWithArray:[_gapUserArray objectAtIndex:k]];
                    
                    NSInteger gapIndex = [[moreMultDict stringValueForKey:@"answer_key"] integerValue];
                    NSString *gapStr = [moreMultDict stringValueForKey:@"answer_value"];
                   [flgArray replaceObjectAtIndex:gapIndex withObject:gapStr];
                    [_gapUserArray replaceObjectAtIndex:k withObject:flgArray];
                }
            }
        }
        
        
        
        //主观
        NSString *subjectAnswerVale = [[[[_userOlderAnswerArray objectAtIndex:i] arrayValueForKey:@"user_answer"] objectAtIndex:0] stringValueForKey:@"answer_value"];
        for (int k = 0 ; k < _subjectivityIDArray.count ; k ++) {//单选的时候
            NSString *judgeID = [_subjectivityIDArray objectAtIndex:k];
            if ([judgeID integerValue] == [questionID integerValue]) {//说明就是同一题
                [_subjectivityUserArray replaceObjectAtIndex:k withObject:subjectAnswerVale];
                continue;
            }
        }
        
        
    }
    
    
    //这里是将答案已经填写在现有的答案当中了
    if (_currentArray == _multipleArray) {//说明单选时最先的
        if ([[_multipleUserArray objectAtIndex:0] integerValue] == 100) {//说明之前的第一题没有答案
            
        } else {
            [self Next_multipleConfig];
        }
    } else if (_currentArray == _moreMultipleArray) {//多选

        NSArray *firstArray = [_moreMultipleUserArray objectAtIndex:0];
        BOOL isHaveBeforeAnsewr = NO;
        for (int i = 0; i < firstArray.count ; i ++) {
            NSString *indexStr = [firstArray objectAtIndex:i];
            if ([indexStr integerValue] == 100) {
                
            } else {
                isHaveBeforeAnsewr = YES;
            }
        }
        
        if (isHaveBeforeAnsewr) {//说明第一道有以前的答案
            [self Next_moreMultipleConfig];
        } else {
            
        }
        
    } else if (_currentArray == _judgeArray) {//判断
        if ([[_judgeUserArray objectAtIndex:0] integerValue] == 100) {//说明之前的第一题没有答案
            
        } else {
            [self Next_judgeConfig];
        }
    } else if (_currentArray == _gapArray) {//填空
        NSArray *firstArray = [_gapUserArray objectAtIndex:0];
        BOOL isHaveBeforeAnsewr = NO;
        for (int i = 0; i < firstArray.count ; i ++) {
            NSString *indexStr = [firstArray objectAtIndex:i];
            if ([indexStr integerValue] == 100) {
                
            } else {
                isHaveBeforeAnsewr = YES;
            }
        }
        
        if (isHaveBeforeAnsewr) {//说明第一道有以前的答案
            [self Next_gapConfig];
        } else {
            
        }
    } else if (_currentArray == _subjectivityArray) {//主观
        if ([[_subjectivityUserArray objectAtIndex:0] integerValue] == 100) {//说明之前的第一题没有答案
            
        } else {
            [self Next_subjectivityConfig];
        }
    }
    
    
    
}

#pragma mark --- 网络请求
//考试的收藏
- (void)netWorkExamsCollect {
    NSString *endUrlStr = YunKeTang_Exams_exams_collect;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *ID = [[_currentArray objectAtIndex:subjectNumber] stringValueForKey:@"exams_question_id"];
    [mutabDict setObject:ID forKey:@"source_id"];
    if ([[self.collectArray objectAtIndex:subjectAllNumber] integerValue] == 1) {//已经收藏过
        [mutabDict setObject:@"0" forKey:@"action"];//1 收藏 0 取消收藏
    } else {//没有收藏
        [mutabDict setObject:@"1" forKey:@"action"];//1 收藏 0 取消收藏
    }

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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if (dict.allKeys.count > 0) {
            if ([[self.collectArray objectAtIndex:subjectAllNumber] integerValue] == 0) {//收藏
                [self.collectButton setTitle:@" 取消收藏" forState:UIControlStateNormal];
                [self.collectButton setImage:Image(@"test_collect@3x") forState:UIControlStateNormal];
                [self.collectArray replaceObjectAtIndex:subjectAllNumber withObject:@"1"];
            } else {//取消收藏
                [self.collectButton setTitle:@" 添加收藏" forState:UIControlStateNormal];
                [self.collectButton setImage:Image(@"test_uncollect@3x") forState:UIControlStateNormal];
                [self.collectArray replaceObjectAtIndex:subjectAllNumber withObject:@"0"];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//保存考试当前进度
- (void)netWorkExamsSaveExams {
    [self manageAnswer];
    NSString *endUrlStr = YunKeTang_Exams_exams_saveExams;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *ID = [_dataSource stringValueForKey:@"exams_paper_id"];
    [mutabDict setObject:ID forKey:@"paper_id"];
    if (timePastting == 0) {//说明时间是不限制的
        [mutabDict setObject:[NSString stringWithFormat:@"%ld",timePastting] forKey:@"anser_time"];
    } else if (timePastting > 0){//说明时间一直在走
        [mutabDict setObject:[NSString stringWithFormat:@"%ld",timePastting] forKey:@"anser_time"];
    }
    [mutabDict setObject:@"1" forKey:@"exams_type"];
    [mutabDict setObject:self.mangerAnswerDict forKey:@"user_answer"];
    
    if ([_continueStr isEqualToString:@"again"]) {
        
    } else {
        if ([_dataSource stringValueForKey:@"exams_users_id"] == nil) {
            
        } else {
            [mutabDict setObject:[_dataSource stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
        }
    }
    
//    if ([_dataSource stringValueForKey:@"wrong_exams_users_id"] == nil) {
//
//    } else {
//        [mutabDict setObject:[_dataSource stringValueForKey:@"wrong_exams_users_id"] forKey:@"wrong_exams_users_id"];
//    }
    
    if ([_continueStr isEqualToString:@"again"]) {//再次挑战
        
    } else {
        if ([_dataSource stringValueForKey:@"wrong_exams_users_id"] == nil) {
            
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
    [TKProgressHUD showMessag:@"保存答案中..." toView:self.view];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [op start];
}




#pragma mark --- 交卷的相关事情

#pragma mark --- 网络请求
//在最后一题的时候 点击交卷的时候 （然后交卷）
//考试交卷
- (void)netWorkExamsSubmitExams {
     [self manageAnswer];
    NSString *endUrlStr = YunKeTang_Exams_exams_submitExams;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *ID = [_dataSource stringValueForKey:@"exams_paper_id"];
    [mutabDict setObject:ID forKey:@"paper_id"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",timePastting] forKey:@"anser_time"];
    [mutabDict setObject:_examsType forKey:@"exams_type"];
    [mutabDict setObject:self.mangerAnswerDict forKey:@"user_answer"];
    if ([_dataSource stringValueForKey:@"exams_users_id"] == nil) {
    } else {
        if ([_continueStr isEqualToString:@"again"]) {//再次挑战
        } else {
            [mutabDict setObject:[_dataSource stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
        }
    }
    
    if ([_dataSource stringValueForKey:@"wrong_exams_users_id"] == nil  || [[_dataSource stringValueForKey:@"wrong_exams_users_id"] integerValue] == 0 ) {
    } else {
        if ([_continueStr isEqualToString:@"again"]) {//再次挑战
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
        [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self GoOut];
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
