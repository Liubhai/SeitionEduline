//
//  BJXQViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/30.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//


#import "BJXQViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "emotionjiexi.h"
#import "SYG.h"
#import "EJTableViewCell.h"
#import "UIColor+HTMLColors.h"
#import "My_NotesCell.h"


@interface BJXQViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UILabel *lable;
}

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)UIView *topView;
@property (strong ,nonatomic)UIView *commentView;
@property (strong ,nonatomic)UIView *downView;

@property (strong ,nonatomic)UITextField *PLTextField;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation BJXQViewController

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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"笔记评论";
    [self addTopView];
    [self addTableView];
    [self addDownView];
    [self netWorkUserNotesGetList:1];
}

- (void)addNav {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    WZLabel.text = @"笔记评论";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTopView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 80)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _topView = topView;
    
    //添加头像
    UIButton *headImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_headStr] forState:UIControlStateNormal];
    headImageButton.layer.cornerRadius = 20;
    headImageButton.layer.masksToBounds = YES;
    [topView addSubview:headImageButton];
    
    //添加名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 60, 20)];
    nameLabel.text = _nameStr;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:nameLabel];
    
    
    //添加日期
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, 10, 140, 20)];
    timeLabel.text = _timeStr;
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
//    [topView addSubview:timeLabel];
    
    //添加内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, MainScreenWidth - 20, 40)];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [topView addSubview:contentLabel];
    _contentLabel = contentLabel;
    [self setIntroductionText:_JTStr];
    
    //添加横线
    UILabel *lineButton = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame), MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加评论的视图
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame) + 10 * WideEachUnit, MainScreenWidth,40 * WideEachUnit)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_commentView];
    _commentView.layer.borderWidth = 1;
    _commentView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    
    //添加评论数的按钮
    
    //添加评论按钮
   UIButton *PLButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, 20, 20)];
    [PLButton setBackgroundImage:[UIImage imageNamed:@"笔记评论@2x"] forState:UIControlStateNormal];
    [_commentView addSubview:PLButton];
    
    //添加评论人数
   UILabel *PLLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 40, 20)];
    PLLabel.textColor = [UIColor colorWithRed:99.f / 255 green:99.f / 255 blue:99.f / 255 alpha:1];
    [_commentView addSubview:PLLabel];
    PLLabel.text = [_dict stringValueForKey:@"note_comment_count"];
    
    //添加点赞按钮
   UIButton *DZButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 8, 20, 20)];
    [DZButton setBackgroundImage:[UIImage imageNamed:@"笔记点赞@2x"] forState:UIControlStateNormal];
    [_commentView addSubview:DZButton];
    
    //添加点赞人数
   UILabel *DZLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 8, 30, 20)];
    DZLabel.textColor = [UIColor colorWithRed:99.f / 255 green:99.f / 255 blue:99.f / 255 alpha:1];
    [_commentView addSubview:DZLabel];
    DZLabel.text = [_dict stringValueForKey:@"note_help_count"];
    
    
    //时间
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 8, MainScreenWidth / 2 - 10, 20)];
    timerLabel.textColor = [UIColor colorWithRed:99.f / 255 green:99.f / 255 blue:99.f / 255 alpha:1];
    [_commentView addSubview:timerLabel];
    timerLabel.textColor = [UIColor colorWithHexString:@"#888"];
    timerLabel.font = Font(14);
    timerLabel.text = [_dict stringValueForKey:@"strtime"];
    timerLabel.textAlignment = NSTextAlignmentRight;
    
    _topView.frame = CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, _commentView.bottom);
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), MainScreenWidth, MainScreenHeight - CGRectGetMaxY(_topView.frame) - 15) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
//    CGRect frame;
    //文本赋值
    _contentLabel.text = text;
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;
//    [_contentLabel sizeToFit];
    CGRect labelSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
}


- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50, MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    _PLTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, MainScreenWidth - 80, 40)];
    _PLTextField.placeholder = @"写下你的评论";
    [_downView addSubview:_PLTextField];
    _PLTextField.layer.borderWidth = 1;
    _PLTextField.layer.cornerRadius = 5;
    _PLTextField.layer.borderColor = PartitionColor.CGColor;
    _PLTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _PLTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 5, 60, 40)];
    sendButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:sendButton];
    
}

- (void)sendButton {
    [self netWorkUserNotesAdd];
}

#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120 * WideEachUnit;
//    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellStr = @"WDTableViewCell";
    My_NotesCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[My_NotesCell alloc] initWithReuseIdentifier:cellStr];
    }
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [cell dataWithDict:dict];
    
    return cell;
}

#pragma mark --- Tool

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

#pragma mark --- 键盘

//键盘弹上来
- (void)keyboardWillShow:(NSNotification *)not {
    NSLog(@"-----%@",not.userInfo);
    CGRect rect = [not.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat HFloat = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        _downView.frame = CGRectMake(0, MainScreenHeight - 50 - HFloat, MainScreenWidth, 50);
    }];
    
    
}

//键盘下去
- (void)keyboardWillHide:(NSNotification *)not {
    [UIView animateWithDuration:0.25 animations:^{
        _downView.frame = CGRectMake(0, MainScreenHeight - 50, MainScreenWidth, 50);
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



#pragma mark --- 网络请求

//获取笔记的二级评论
- (void)netWorkUserNotesGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_User_notes_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"pid"];
    [mutabDict setObject:@"1" forKey:@"ntype"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _dataArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            [_tableView reloadData];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



//添加评论
- (void)netWorkUserNotesAdd {
    
    NSString *endUrlStr = YunKeTang_User_notes_add;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"pid"];
    [mutabDict setObject:@"1" forKey:@"kztype"];
    [mutabDict setObject:_ID forKey:@"kzid"];
    [mutabDict setObject:@"1" forKey:@"is_open"];
    [mutabDict setObject:_PLTextField.text forKey:@"content"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:@"评论成功" toView:self.view];
             _PLTextField.text = @"";
            [_tableView reloadData];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}






@end
