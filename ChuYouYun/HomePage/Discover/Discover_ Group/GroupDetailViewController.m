//
//  GroupDetailViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "UIImageView+WebCache.h"

#import "EditGroupViewController.h"
#import "TopicXXTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "TopicDetailViewController.h"
#import "DLViewController.h"

#import "PublishTopicViewController.h"
#import "GroupMeberViewController.h"


@interface GroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

{
    BOOL isSecet;
    BOOL isCellSecet;
    CGFloat infoH;
    NSInteger reLoadNum;
}

@property (strong ,nonatomic)UIScrollView *allScrollView;

@property (strong ,nonatomic)UIView *infoView;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSDictionary *dict;

@property (strong ,nonatomic)NSArray *SYGArray;

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (assign ,nonatomic)CGFloat tableViewHeight;

@property (strong ,nonatomic)NSString *isEssence;

@property (strong ,nonatomic)UIView *setView;

@property (strong ,nonatomic)NSArray *setArray;

@property (strong ,nonatomic)NSString *actionStr;//话题操作的类型

@property (strong ,nonatomic)NSString *typeStr;//设置

@property (strong ,nonatomic)NSDictionary *settingDic;//设置是需要的字典

@property (strong ,nonatomic)NSString *topicID;//话题ID

@property (strong ,nonatomic)UIButton *editButton;//发布话题按钮

@property (strong ,nonatomic)UIButton *addGroupButton;

@property (strong ,nonatomic)UIImageView *imageView;


@end

@implementation GroupDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //刷新数据
    [self netWorkTopic];
    [self netWork];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
//    [self addInfoView];
//    [self addHeadView];
//    [self addTableView];
//    [self publishButton];
    [self addEditTopic];
    [self netWork];
    [self netWorkTopic];
//    [self netWorkGetMember];//可用

}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];

    _dataArray = [NSArray array];
    isSecet = NO;
    isCellSecet = NO;
    _SYGArray = @[@"全部",@"精华"];

    _tableViewHeight = 0;
    infoH = 100;
    reLoadNum = 0;

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
    WZLabel.text = @"小组详情";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加分类的按钮
    UIButton *SortButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 30, 60, 30)];
    [SortButton setTitle:@"分类" forState:UIControlStateNormal];
    [SortButton addTarget:self action:@selector(SortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SortButton];
    SortButton.hidden = YES;
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 30) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = _infoView;
    [self.view addSubview:_tableView];

}

- (void)addEditTopic {
    
    //悬浮按钮
    _editButton = [[UIButton alloc] init];
    _editButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 220 + 64, 40,40);

    [_editButton setBackgroundImage:Image(@"发帖") forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view insertSubview:_editButton atIndex:99];
    [self.view addSubview:_editButton];
    
    [_editButton addTarget:self action:@selector(editTopic) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_editButton aboveSubview:_tableView];
    [self.view insertSubview:_tableView belowSubview:_editButton];

}

- (void)addHeadView {
    
    UIScrollView *infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth * 2, 100)];
    [self.view addSubview:infoView];
    infoView.contentSize = CGSizeMake(MainScreenWidth, 0);
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.showsHorizontalScrollIndicator = NO;
    infoView.showsVerticalScrollIndicator = NO;
    infoView.pagingEnabled = YES;
    _infoView = infoView;
    
    //添加图像使用迷糊处理
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:Image(@"站位图")];
    [infoView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = CGRectMake(0,0, MainScreenWidth, 100);
    [imageView addSubview:view];

    CGFloat imageW;
    CGFloat imageH = imageW = 70;
    //添加头像
    NSLog(@"%@",_imageStr);
    UIButton *imgageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, imageW, imageH)];
    [imgageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [imgageButton sd_setImageWithURL:[NSURL URLWithString:_imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    [infoView addSubview:imgageButton];
    imgageButton.layer.cornerRadius = imageW / 2;
    imgageButton.layer.masksToBounds = YES;
    [imgageButton addTarget:self action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, SpaceBaside, MainScreenWidth / 2, 20)];
    nameLabel.text = [_dict stringValueForKey:@"name"];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = Font(20);
    nameLabel.backgroundColor = [UIColor clearColor];
    [infoView addSubview:nameLabel];
    
    //添加详情
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,32 ,MainScreenWidth - 110, 20)];
    NSLog(@"%@",_dict);
    NSString *tieStr = [_dict stringValueForKey:@"threadcount"];
    NSString *cheStr = [_dict stringValueForKey:@"membercount"];
//    infoLabel.text = [NSString stringWithFormat:@"贴子 %@    成员 %@",tieStr,cheStr];
    infoLabel.text = [NSString stringWithFormat:@"成员 %@    贴子 %@",cheStr,tieStr];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = Font(12);
    [infoView addSubview:infoLabel];
    
    
    //添加编辑小组
    UIButton *editGroupButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 55, 75, 25)];
    
    NSString *uID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    NSString *Str = @"编辑小组";
    if ([uID isEqualToString:[_dict stringValueForKey:@"uid"]]) {
        [editGroupButton setTitle:Str forState:UIControlStateNormal];
    } else {
        editGroupButton.hidden = YES;
    }
    editGroupButton.backgroundColor = [UIColor clearColor];
    editGroupButton.titleLabel.font = Font(13);
    editGroupButton.layer.cornerRadius = 5;
    editGroupButton.layer.borderWidth = 1;
    editGroupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [editGroupButton addTarget:self action:@selector(editGroupButton:) forControlEvents:UIControlEventTouchUpInside];
    [editGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoView addSubview:editGroupButton];

    
    //添加加入小组按钮
    UIButton *addGroupButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(editGroupButton.frame) + SpaceBaside, 55, 75,25)];
    
    NSString *Str0 = @"解散小组";
    NSString *Str1 = @"加入小组";
    NSString *Str2 = @"退出小组";
    
    if ([uID isEqualToString:[_dict stringValueForKey:@"uid"]]) {
         [addGroupButton setTitle:Str0 forState:UIControlStateNormal];
    } else {
        if ([[_dict stringValueForKey:@"is_join"] integerValue] == 1) {
            [addGroupButton setTitle:Str2 forState:UIControlStateNormal];
        } else {
            [addGroupButton setTitle:Str1 forState:UIControlStateNormal];
        }
    }
    
    //没有编辑小组的时候 位置的改变
    if (editGroupButton.hidden == YES) {
        addGroupButton.frame = CGRectMake(100, 55, 75, 25);
    }
    
    addGroupButton.backgroundColor = [UIColor clearColor];
    addGroupButton.titleLabel.font = Font(13);
    addGroupButton.layer.cornerRadius = 5;
    addGroupButton.layer.borderWidth = 1;
    addGroupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [addGroupButton addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
    [addGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoView addSubview:addGroupButton];
    _addGroupButton = addGroupButton;

    infoView.frame = CGRectMake(0, 0, MainScreenWidth, 100);
}


#pragma mark -- UITableViewDataSource


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
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
    NSLog(@"%@",_dataArray[indexPath.row]);
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicDetailViewController *topicDVc = [[TopicDetailViewController alloc] init];
    topicDVc.topicID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
    topicDVc.groupID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"gid"];
    [self.navigationController pushViewController:topicDVc animated:YES];
    
}

#pragma mark -- 网络请求

- (void)netWork {

    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_IDString forKey:@"group_id"];
    
    [manager BigWinCar_GetGroupInfo:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---%@",responseObject);
        NSLog(@"%@",operation);
        _dict = responseObject[@"data"];
        [self addHeadView];
        [self addTableView];
        [_tableView reloadData];
        //让按钮 在最上面
        [self.view insertSubview:_editButton atIndex:99];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
 
}

//获取话题
- (void)netWorkTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }

    [dic setValue:_IDString forKey:@"group_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];

    //判断是不是精华话题
    if (_isEssence != nil) {
        [dic setValue:_isEssence forKey:@"dist"];
    }

    [manager BigWinCar_getGroupTopList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
         _dataArray = responseObject[@"data"];
        
        if (![msg isEqualToString:@"ok"]) {//提示为空
            if (_imageView.image) {
                _imageView.hidden = NO;
            } else {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, _tableView.bounds.size.height - 100)];
                _imageView.image = Image(@"云课堂_空数据");
                _imageView.hidden = NO;
                [_tableView addSubview:_imageView];
            }
        } else {
            _imageView.hidden = YES;
        }
        
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}

//加入小组
- (void)netWorkAddGroup {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [dic setValue:_IDString forKey:@"group_id"];
    [dic setValue:@"" forKey:@"reason"];
    [manager BigWinCar_joinGroup:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        NSLog(@"----%@",msg);
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:msg toView:self.view];
            [_addGroupButton setTitle:@"退出小组" forState:UIControlStateNormal];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    [self hideView];
}


//退出小组
- (void)netWorkGooutGroup {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [dic setValue:_IDString forKey:@"group_id"];
    [manager BigWinCar_quitGroup:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"退出成功" toView:self.view];
            [_addGroupButton setTitle:@"加入小组" forState:UIControlStateNormal];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"退出小组失败" toView:self.view];
    }];
}

//解散小组
- (void)netWorkDeleteGroup {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [dic setValue:_IDString forKey:@"group_id"];
    [manager BigWinCar_deleteGroup:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"解散成功" toView:self.view];
            [self backPressed];
        } else {
            [TKProgressHUD showError:@"解散失败" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [TKProgressHUD showSuccess:@"解散失败" toView:self.view];
    }];
    
    [self hideView];
}

//置顶/精华/收藏/话题
- (void)netWorkSettingTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_actionStr forKey:@"action"];
    [dic setValue:_typeStr forKey:@"type"];
    
    [manager BigWinCar_operatTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
//        NSDictionary *dict = responseObject[@"data"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:msg toView:self.view];
            [self netWorkTopic];
        } else if ([responseObject[@"code"] integerValue] == 0) {
            [TKProgressHUD showSuccess:msg toView:self.view];
            return ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"操作失败" toView:self.view];
    }];
    
    [self hideView];
}

//删除话题
- (void)netWorkDeleteTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_IDString forKey:@"group_id"];
    
    [manager BigWinCar_deleteTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"删除成功" toView:self.view];
            [self netWorkTopic];
        } else {
            [TKProgressHUD showError:@"删除失败" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"删除失败" toView:self.view];
    }];
    
}

//话题回复
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
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_textField.text forKey:@"content"];
    
    [manager BigWinCar_commentTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"评论成功" toView:self.view];
            [self netWorkTopic];
            [self.view endEditing:YES];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showError:@"评论失败" toView:self.view];
    }];
    
}

#pragma mark --- 事件监听

- (void)imageButtonClick {
    GroupMeberViewController *groupMeberVc = [[GroupMeberViewController alloc] init];
    groupMeberVc.dict = _dict;
    groupMeberVc.IDString = _IDString;
    groupMeberVc.cateArray = _cateArray;
    [self.navigationController pushViewController:groupMeberVc animated:YES];
}

- (void)editGroupButton:(UIButton *)button {

    EditGroupViewController *editGroupVc = [[EditGroupViewController alloc] init];
    editGroupVc.dict = _dict;
    editGroupVc.cateArray = _cateArray;
    [self.navigationController pushViewController:editGroupVc animated:YES];
}

- (void)addGroup:(UIButton *)button {
    
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"解散小组"]) {
        [self isSureDele];
    } else if ([title isEqualToString:@"加入小组"]) {
        [self netWorkAddGroup];
    } else if ([title isEqualToString:@"退出小组"]) {
        [self netWorkGooutGroup];
    }

}

//是否 真要删除小组
- (void)isSureDele {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要删除该小组" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self netWorkDeleteGroup];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)SortButtonClick {
    isSecet = !isSecet;
    
    if (isSecet == YES) {//创建
        [self addMoreView];
    }else {//移除
    }
    
}


- (void)addMoreView {
    
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth - 100, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        //在view上面添加东西
        for (int i = 0 ; i < _SYGArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_SYGArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];

        }
        
        //添加中间的分割线
        for (int i = 0; i < _SYGArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
    
    
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        isSecet = NO;
        
    });
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


- (void)SYGButton:(UIButton *)button {
    
    isSecet = NO;
    NSLog(@"%@",button.titleLabel.text);
    [self miss];
    
    if ([button.titleLabel.text isEqualToString:@"精华"]) {
        _isEssence = @"123";
    } else {
        _isEssence = nil;
    }
    [self netWorkTopic];
}

//cell设置按钮事件
- (void)setButtonCilck:(UIButton *)button {
    NSInteger textNum = [button.titleLabel.text integerValue];
    _settingDic = _dataArray[textNum];
    
    
    NSLog(@"111%@",_dict);
    NSLog(@"222%@",_settingDic);
    //获取到自己的uid
    NSString *uID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    
    if ([uID isEqualToString:_dict[@"uid"]]) {//说明自己是管理员或者创建者
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
        _topicID = [NSString stringWithFormat:@"%ld",button.tag];

    } else if ([_dict[@"is_admin"] integerValue] == 0) {//只是普通成员
        NSString *collectStr = @"收藏";
        if ([_settingDic[@"is_collect"] integerValue] == 1) {
            collectStr = @"取消收藏";
        }
        if ([_settingDic[@"uid"] isEqualToString:uID]) {//说明当前的帖子是自己发的
            UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:collectStr otherButtonTitles:@"删除", nil];
            action.delegate = self;
            [action showInView:self.view];
        } else {
            UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:collectStr otherButtonTitles:nil, nil];
            action.delegate = self;
            [action showInView:self.view];
        }
        _topicID = [NSString stringWithFormat:@"%ld",button.tag];
        
    } else if ([_dict[@"is_admin"] integerValue] == 1) {//是管理员
        
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _actionStr = @"1";
    NSLog(@"%ld",actionSheet.numberOfButtons);

    if (actionSheet.numberOfButtons == 2) {//那就只有收藏与取消
        if (buttonIndex == 0) {//收藏
            _typeStr = @"collect";
            if ([_settingDic[@"is_collect"] integerValue] == 1) {
                _actionStr = @"2";
            }
            [self netWorkSettingTopic];
        } else {//取消
            return;
        }
    } else if (actionSheet.numberOfButtons == 3) {//说明是 收藏 删除 取消
        if (buttonIndex == 0) {//收藏
            _typeStr = @"collect";
            if ([_settingDic[@"is_collect"] integerValue] == 1) {
                _actionStr = @"2";
            }
            
            [self netWorkSettingTopic];
        } else if (buttonIndex == 1) {//删除话题
            [self netWorkDeleteTopic];
            return;
        } else {//取消
            return;
        }
    } else if (actionSheet.numberOfButtons == 6) {//说明自己是创建者
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
}

//发布话题
- (void)editTopic {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }

    PublishTopicViewController *publishTopicVc = [[PublishTopicViewController alloc] init];
    publishTopicVc.IDString = _IDString;
    [self.navigationController pushViewController:publishTopicVc animated:YES];
    
}

- (void)plButtonClick:(UIButton *)button {
    _topicID = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%@",_topicID);
    
    [self addCommentView];
}

- (void)sendButton {
    [self netWorkCommentTopic];
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

#pragma mark --- 提示的试图消失
- (void)hideView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
    });

}



@end
