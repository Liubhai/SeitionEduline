//
//  CollectTopicViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/11.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CollectTopicViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "ZhiyiHTTPRequest.h"

#import "TopicXXTableViewCell.h"
#import "TopicDetailViewController.h"


@interface CollectTopicViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;


@property (strong ,nonatomic)NSString *actionStr;
@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSDictionary *settingDic;
@property (strong ,nonatomic)NSString *topicID;

@property (strong ,nonatomic)NSString *UID;
@property (strong ,nonatomic)NSString *topicUID;

@property (strong ,nonatomic)UIView *commentView;
@property (strong ,nonatomic)UITextField *textField;

@end

@implementation CollectTopicViewController
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
    _titleImage.hidden = YES;
    [self interFace];
    [self addTableView];
    [self netWorkGetcollectTopic];
    
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _number = 0;
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"退款申请";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110 * WideEachUnit;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    //    [self NetWorkGetOrderWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    _number++;
    //    [self NetWorkGetOrderWithNumber:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}



#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    //自定义cell类
    TopicXXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[TopicXXTableViewCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataSourceWith:dic];
    
    [cell.setButton addTarget:self action:@selector(setButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    cell.setButton.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    [cell.PLButton addTarget:self action:@selector(plButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailViewController *topDeVc = [[TopicDetailViewController alloc] init];
    [self.navigationController pushViewController:topDeVc animated:YES];
}


#pragma mark --- cell 设置点击

//cell设置按钮事件
- (void)setButtonCilck:(UIButton *)button {
    NSInteger textNum = [button.titleLabel.text integerValue];
    _settingDic = _dataArray[textNum];
    _topicUID = _settingDic[@"uid"];
    _topicID = _settingDic[@"tid"];
    
    if ([_UID isEqualToString:_topicUID]) {//说明是自己的
        NSString *collectStr = @"收藏";
        NSString *topStr = @"置顶";
        NSString *distStr = @"精华";
        NSString *lockStr = @"锁定";
        
        if ([_settingDic[@"is_collect"] integerValue] == 1) {
            collectStr = @"取消收藏";
        }
        if ([_settingDic[@"top"] integerValue] == 1) {
            topStr = @"取消置顶";
        }
        if ([_settingDic[@"dist"] integerValue] == 1) {
            distStr = @"取消精华";
        }
        if ([_settingDic[@"lock"] integerValue] == 1) {
            lockStr = @"取消锁定";
        }
        
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:collectStr otherButtonTitles:topStr,distStr,lockStr,@"删除", nil];
        action.delegate = self;
        [action showInView:self.view];
        
    } else {//别人的
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消收藏", nil];
        action.delegate = self;
        [action showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //不是自己的时候
    if (![_UID isEqualToString:_topicUID]) {
        if (buttonIndex == 0) {//取消收藏
            _actionStr = @"2";
            _typeStr = @"collect";
            [self netWorkSettingTopic];
            return;
        } else {
            return;
        }
    }
    
    _actionStr = @"1";
    
    if (buttonIndex == 0) {//收藏
        _typeStr = @"collect";
        if ([_settingDic[@"is_collect"] integerValue] == 1) {
            _actionStr = @"2";
        }
    }else if (buttonIndex == 1) {//置顶
        _typeStr = @"top";
        if ([_settingDic[@"top"] integerValue] == 1) {
            _actionStr = @"2";
        }
    } else if (buttonIndex == 2) {//精华
        _typeStr = @"dist";
        if ([_settingDic[@"dist"] integerValue] == 1) {
            _actionStr = @"2";
        }
    } else if (buttonIndex == 3) {//锁定
        _typeStr = @"lock";
        if ([_settingDic[@"lock"] integerValue] == 1) {
            _actionStr = @"2";
        }
    } else if (buttonIndex == 4){
        [self netWorkDeleteTopic];
        return;
    } else {
        return;
    }
    [self netWorkSettingTopic];
}

- (void)plButtonClick:(UIButton *)button {
    _topicID = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%@",_topicID);
    
    [self addCommentView];
}

- (void)addCommentView {
    
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 50)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentView];
    
    //添加输入框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, MainScreenWidth - 80, 40)];
    _textField.placeholder = @"写下你的评论";
    [_commentView addSubview:_textField];
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 5;
    _textField.layer.borderColor = PartitionColor.CGColor;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_textField becomeFirstResponder];
    
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 5, 60, 40)];
    sendButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:sendButton];
    
    [UIView animateWithDuration:0.25 animations:^{
        _commentView.frame = CGRectMake(0, MainScreenHeight / 2, MainScreenWidth, 50);
    }];
    
}

- (void)sendButton {
    [self netWorkCommentTopic];
}

- (void)netWorkCommentTopic {
    
    
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入评论" toView:self.view];
        return;
    }
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [TKProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_textField.text forKey:@"content"];
    
    [manager BigWinCar_commentTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"评论成功" toView:self.view];
            [self netWorkGetcollectTopic];
            [self.view endEditing:YES];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"评论失败" toView:self.view];
    }];
    
}



//键盘弹上来
- (void)keyboardWillShow:(NSNotification *)not {
    NSLog(@"-----%@",not.userInfo);
    CGRect rect = [not.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat HFloat = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        _commentView.frame = CGRectMake(0, MainScreenHeight - 50 - HFloat, MainScreenWidth, 50);
    }];
    
    
}

//键盘下去
- (void)keyboardWillHide:(NSNotification *)not {
    [UIView animateWithDuration:0.25 animations:^{
        _commentView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 50);
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark --- 滚动试图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}






#pragma mark ----网络请求
- (void)netWorkGetcollectTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager BigWinCar_getTopicCollectList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = responseObject[@"data"];
        } else {
        }
        
        if ([msg isEqualToString:@"ok"]) {
        } else {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34 * HigtEachUnit)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [_tableView addSubview:imageView];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"没有获取到数据" toView:self.view];
    }];
}

//- (void)netWorkUserLineVideoGetCollectList:(NSInteger)Num {
//
//    NSString *endUrlStr = YunKeTang_User_lineVideo_getCollectList;
//    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
//
//    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:@"1" forKey:@"type"];
//    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
//    [mutabDict setObject:@"50" forKey:@"count"];
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
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        _dataArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
//        if (_dataArray.count == 0) {
//            //添加空白处理
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 48)];
//            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
//            [self.view addSubview:imageView];
//        }
//        [_tableView reloadData];
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//    }];
//    [op start];
//}





//置顶/精华/收藏/话题
- (void)netWorkSettingTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_actionStr forKey:@"action"];
    [dic setValue:_typeStr forKey:@"type"];
    
    [manager BigWinCar_operatTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"操作成功" toView:self.view];
            [self netWorkGetcollectTopic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"操作失败" toView:self.view];
    }];
}

//删除话题
- (void)netWorkDeleteTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_settingDic[@"gid"] forKey:@"group_id"];
    
    [manager BigWinCar_deleteTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"删除成功" toView:self.view];
            [self netWorkGetcollectTopic];
        } else {
            [TKProgressHUD showError:@"删除失败" toView:self.view];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"删除失败" toView:self.view];
    }];
}





@end
