//
//  GroupMeberViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/15.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GroupMeberViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "DLViewController.h"

#import "UIButton+WebCache.h"
#import "GroupMangerViewController.h"
#import "EditGroupViewController.h"
#import "JoinGroupViewController.h"

@interface GroupMeberViewController ()

@property (strong ,nonatomic)UIView *headerView;
@property (strong ,nonatomic)UIView *midView;
@property (strong ,nonatomic)UIView *threeView;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIView *downDownView;

@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray *applyArray;

@property (strong ,nonatomic)UIButton *addGroupButton;

@end

@implementation GroupMeberViewController

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
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addHeaderView];
    [self addMidView];
//    [self addDownView];
    [self addThreeView];
    [self netWorkGetMember];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    WZLabel.text = @"小组成员";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHeaderView {
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth * 2, 100)];
    [self.view addSubview:infoView];
    infoView.backgroundColor = BasidColor;
    _headerView = infoView;
    
    
    //添加图像使用迷糊处理
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[_dict stringValueForKey:@"logourl"]] placeholderImage:Image(@"站位图")];
    [infoView addSubview:imageView];
    infoView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES;
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:beffect];
    view.frame = CGRectMake(0,0, MainScreenWidth, 100);
    [imageView addSubview:view];
    
    
    CGFloat imageW;
    CGFloat imageH = imageW = 70;
    //添加头像
    UIButton *imgageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, imageW, imageH)];
    [imgageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [imgageButton sd_setImageWithURL:[NSURL URLWithString:_dict[@"logourl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    [infoView addSubview:imgageButton];
    imgageButton.layer.cornerRadius = imageH / 2;
    imgageButton.layer.masksToBounds = YES;
    
    //添加名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgageButton.frame) + SpaceBaside * 2, SpaceBaside, MainScreenWidth / 2, 20)];
    nameLabel.text = [_dict stringValueForKey:@"name"];
    nameLabel.textColor = [UIColor whiteColor];
    [infoView addSubview:nameLabel];
    
    //添加详情
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,32 ,MainScreenWidth - 110, 20)];
    NSLog(@"%@",_dict);
    NSString *tieStr = [_dict stringValueForKey:@"threadcount"];
    NSString *cheStr = [_dict stringValueForKey:@"membercount"];
    infoLabel.text = [NSString stringWithFormat:@"贴子 %@    成员 %@",tieStr,cheStr];
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
    editGroupButton.layer.cornerRadius = 5;
    editGroupButton.layer.borderWidth = 1;
    editGroupButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [editGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editGroupButton addTarget:self action:@selector(editButtonclick:) forControlEvents:UIControlEventTouchUpInside];
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

    
}


- (void)addMidView {
    _midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), MainScreenWidth, 100)];
    _midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_midView];
    
    //添加小组简介
    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    intro.font = Font(15);
    intro.text = @"小组简介";
    [_midView addSubview:intro];
    
    //添加小组具体简介
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 40, MainScreenWidth - 2 * SpaceBaside, 40)];
    content.backgroundColor = [UIColor whiteColor];
    content.font = Font(13);
    [_midView addSubview:content];

    CGRect frame;
    //文本赋值
    content.text = [_dict stringValueForKey:@"intro"];
    //设置label的最大行数
    content.numberOfLines = 0;
    CGRect labelSize = [content.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height;

    _midView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), MainScreenWidth, 50 + labelSize.size.height);
}

- (void)addThreeView {
    
    _threeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_midView.frame) + 2 * SpaceBaside, MainScreenWidth, 100)];
    _threeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_threeView];
    
    //添加小组公告
    UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    intro.font = Font(15);
    intro.text = @"小组公告";
    [_threeView addSubview:intro];
    
    //添加小组具体简介
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 40, MainScreenWidth - 2 * SpaceBaside, 40)];
    content.backgroundColor = [UIColor whiteColor];
    content.font = Font(13);
    [_threeView addSubview:content];
    
    CGRect frame;
    //文本赋值
    
    content.text = [_dict stringValueForKey:@"announce"];
    //设置label的最大行数
    content.numberOfLines = 0;
    CGRect labelSize = [content.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    frame.size.height = labelSize.size.height;
    
    _threeView.frame = CGRectMake(0, CGRectGetMaxY(_midView.frame) + SpaceBaside * 2, MainScreenWidth, 50 + labelSize.size.height);

}

- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_threeView.frame) + 2 * SpaceBaside, MainScreenWidth, 110)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加小组简介
    UILabel *Meber = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    Meber.font = Font(15);
    Meber.text = @"小组成员";
    [_downView addSubview:Meber];
    
    //添加按钮
    UIButton *inButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, SpaceBaside, 30, 20)];
    inButton.tag = 1;
    [inButton setBackgroundImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    [inButton addTarget:self action:@selector(inButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:inButton];
    
    
    CGFloat ButtonW = 60;
    CGFloat ButtonH = ButtonW;
    
    for (int i = 0 ; i < _dataArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 40, ButtonW, ButtonH)];
        button.backgroundColor = [UIColor yellowColor];
        button.layer.cornerRadius = ButtonW / 2;
        button.layer.masksToBounds = YES;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_dataArray objectAtIndex:i] stringValueForKey:@"avatar_small"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        [_downView addSubview:button];
    }

}


- (void)addDownDownView {
    
    _downDownView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_downView.frame) + 2 * SpaceBaside, MainScreenWidth, 110)];
    _downDownView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downDownView];
    
    //添加小组简介
    UILabel *Meber = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    Meber.font = Font(15);
    Meber.text = @"待审核小组成员";
    [_downDownView addSubview:Meber];
    
    //添加按钮
    UIButton *inButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, SpaceBaside, 30, 20)];
    [inButton setBackgroundImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    inButton.tag = 2;
    [inButton addTarget:self action:@selector(ininButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_downDownView addSubview:inButton];
    
    
    CGFloat ButtonW = 60;
    CGFloat ButtonH = ButtonW;
    
    for (int i = 0 ; i < _applyArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 40, ButtonW, ButtonH)];
        button.backgroundColor = [UIColor yellowColor];
        button.layer.cornerRadius = ButtonW / 2;
        button.layer.masksToBounds = YES;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_applyArray objectAtIndex:i] stringValueForKey:@"avatar_small"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        [_downDownView addSubview:button];
    }
    
    
}


#pragma mark --- 事件监听
- (void)inButtonClick:(UIButton *)button {
    GroupMangerViewController *groupMangerVc = [[GroupMangerViewController alloc] init];
    groupMangerVc.IDString = _IDString;
    groupMangerVc.dict = _dict;
    if (button.tag == 1) {//小组成员
        
    } else {//待审核
//        groupMangerVc.typeStr = @"apply";
    }
    [self.navigationController pushViewController:groupMangerVc animated:YES];
}

- (void)ininButtonClick:(UIButton *)button {
    JoinGroupViewController *joinGroupVc = [[JoinGroupViewController alloc] init];
    joinGroupVc.IDString = _IDString;
    joinGroupVc.dict = _dict;
    joinGroupVc.typeStr = @"apply";
    [self.navigationController pushViewController:joinGroupVc animated:YES];
}


- (void)editButtonclick:(UIButton *)button {
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

#pragma mark --- 相应事件

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



#pragma mark --- 网络请求
//小组成员管理
- (void)netWorkMember {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"" forKey:@"uid"];//需要管理成员的Uid
    [dic setValue:_IDString forKey:@"group_id"];
    
    [manager BigWinCar_member:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

//小组成员
- (void)netWorkGetMember {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_IDString forKey:@"group_id"];
    [dic setValue:@"" forKey:@"type"];
    [manager BigWinCar_getGroupMember:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dataArray = responseObject[@"data"];
        [self addDownView];
        [self netWorkGetMemberApply];
//        [self addDownDownView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}


//待审核小组成员
- (void)netWorkGetMemberApply {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_IDString forKey:@"group_id"];
    [dic setValue:@"apply" forKey:@"type"];
    [manager BigWinCar_getGroupMember:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _applyArray = responseObject[@"data"];
        if (_applyArray.count == 0) {
            return ;
        }
        [self addDownDownView];
        
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
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"加入成功" toView:self.view];
            [_addGroupButton setTitle:@"退出小组" forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
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
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TKProgressHUD showSuccess:@"解散失败" toView:self.view];
    }];
}



@end
