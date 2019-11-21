//
//  settingViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width



#import "settingViewController.h"
#import "UIButton+WebCache.h"
#import "alterPWViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "RecuperationViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "SYG.h"


#import "PersonInfoViewController.h"

#import "AboutUsViewController.h"
#import "BoundViewController.h"
#import "InstitutionsChooseVC.h"


@interface settingViewController ()

{
    NSArray *textArr;
    NSArray *imageArr;
    NSString *_firstName;
    NSString *_imagurl;
}
@property (strong ,nonatomic)UIButton *btn;
@property (strong ,nonatomic)UILabel  *lbl;
@property (strong ,nonatomic)UILabel *sizeLabel;
@property (assign ,nonatomic)NSInteger totaiZise;

@property (strong ,nonatomic)NSDictionary   *appVersionDict;
@property (strong ,nonatomic)NSString       *currentVersion;

@end

@implementation settingViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _firstName = [defaults objectForKey:@"uname"];
    _imagurl = [defaults objectForKey:@"GLAcon"];
    NSLog(@"===%@",_firstName);
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self information];
        [self netWorkUserGetInfo];
    });
    if (_tableView) {
        [_tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(id)initWithUserFace:(UIImage *)face userName:(NSString *)name
{
    self =[super init];
    if (self) {
        self.face = face;
        self.myName = name;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNav];
    NSLog(@"%@",_allDic);
    _tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //iOS 11 适配
//    if (currentIOS >= 11.0) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
//        
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//    }
    
    textArr = [[NSArray alloc]initWithObjects:@"我的育币",@"我的银行卡" ,nil];
    imageArr = [NSArray arrayWithObjects:@"Shape 189.png",@"card.png", nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFace:) name:@"userFace" object:nil];
//    [self information];
    [self netWorkUserGetInfo];
    //    [self fileSize];
    
    //计算本地缓存
    NSString *onePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSInteger oneSize = [self fileSizeWithPath:onePath];
    
    NSString *twoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSInteger twoSize = [self fileSizeWithPath:twoPath];
    
    NSLog(@"%ld  %ld",oneSize,twoSize);
    _totaiZise = oneSize + twoSize;
//    _totaiZise = oneSize;
    NSLog(@"%ld",_totaiZise);
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"个人设置";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)userFace:(NSNotification *)info
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *btn = (UIButton *)[cell viewWithTag:5];
    UIImage *image = [UIImage imageWithData:[info.userInfo objectForKey:@"userFace"]];
    self.face = image;
    [btn setBackgroundImage:image forState:0];
    //    [btn sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"small"] forState:0];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 2;
    } else if (section == 0) {
        return 1;
    } else if (section == 3){
        if ([Show_Config isEqualToString:@"1"]) {
            // 开启了机构app
            return 5;
        }
        return 4;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        } else if (indexPath.row == 1) {
            return 50;
        }
        return 80;
    }
    if (indexPath.section == 3) {
        return 50;
    } else if (indexPath.section == 1) {
        return 60;
    }
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 45;
    }
    if (section == 3) {//退出账号
        return 20;
    }
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.sectionHeaderHeight, tableView.frame.size.width)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            _btn = [UIButton buttonWithType:0];
            _btn.tag = 5;
            _btn.frame = CGRectMake(10, 15, 50, 50);
            _btn.clipsToBounds = YES;
            [_btn addTarget:self action:@selector(btnClick) forControlEvents:0];
            
            [_btn.layer setCornerRadius:25];
            
            _lbl = [[UILabel alloc]initWithFrame:CGRectMake(70, 30, 200, 21)];
            NSString *imgUrl = [NSString stringWithFormat:@"%@",[_allDic stringValueForKey:@"avatar_middle"]];
            _lbl.text = [_allDic stringValueForKey:@"uname"];
            [_btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:0 placeholderImage:nil];
            [cell addSubview:_btn];
            [cell addSubview:_lbl];
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIButton *btn = [UIButton buttonWithType:0];
                btn.frame = CGRectMake(17, 10, 30, 25);
                btn.clipsToBounds = YES;
                [btn setImage:[UIImage imageNamed:[imageArr objectAtIndex:0]] forState:0];
                
                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(64, 14, 100, 21)];
                lbl.text = [textArr objectAtIndex:0];
                
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - MainScreenWidth / 2, 14, MainScreenWidth / 2 - 10, 21)];
                if (indexPath.row == 1) {
                    NSString *learnMoney = [NSString stringWithFormat:@"%d 育币",99999];
                    numberLbl.text = learnMoney;
                }
                numberLbl.text = [NSString stringWithFormat:@"%@积分",_score];
                numberLbl.textAlignment = NSTextAlignmentRight;
                numberLbl.textColor = [UIColor grayColor];
                
                [cell addSubview:btn];
                [cell addSubview:lbl];
                [cell addSubview:numberLbl];
            }
            return cell;
        } else {
            return nil;
        }
        
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text = @"绑定管理";
        }
        return cell;
    } else if(indexPath.section == 2) {
        static NSString *identifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSArray *array= @[@"修改密码",@"允许非wifi环境下观看和下载"];
        if (!cell) {
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, MainScreenWidth-30, 60)];
                numberLbl.text = array[0];
                [cell addSubview:numberLbl];
            }else{
                //初始化开关控件，CGRectMake(x坐标，y坐标，宽，高)
                UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 10, 150, 40)];
                //设置开关为YES状态
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *passWord = [ user objectForKey:@"netRook"];
                if ([passWord isEqualToString:@"1"]) {
                    [mySwitch setOn:YES];
//
                }else{
                    
                    [mySwitch setOn:NO];
                }
                //为控件添加事件
                [mySwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
                //向视图中添加该控件
                
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, MainScreenWidth-30,60)];
                numberLbl.text = array[1];
                [cell addSubview:numberLbl];
                [cell addSubview:mySwitch];
                [mySwitch setSize:mySwitch.size];
                mySwitch.center = CGPointMake(MainScreenWidth - 20 - mySwitch.width / 2.0, 60 / 2.0);
                
            }
        }
        return cell;
    }else if (indexPath.section == 3) {
        NSArray *array= @[@"版本检查更新",@"意见反馈",@"清除缓存",@"关于我们"];
        if ([Show_Config isEqualToString:@"1"]) {
            array= @[@"版本检查更新",@"意见反馈",@"清除缓存",@"关于我们",@"设置机构"];
        }
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            if (indexPath.row==0 || indexPath.row == 1 || indexPath.row == 4) {
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, MainScreenWidth-30, 21)];
                numberLbl.text = array[indexPath.row];
                [cell addSubview:numberLbl];
                
            }else if  (indexPath.row == 2){
                
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, 125, 21)];
                numberLbl.text = array[2];
                [cell addSubview:numberLbl];
                
                //添加缓存大小的按钮
                
                _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 0, 100, 40)];
                _sizeLabel.text = [NSString stringWithFormat:@"%ldK",_totaiZise / 1024];
    
                if (_totaiZise / 1024 > 1) {//KB
                     _sizeLabel.text = [NSString stringWithFormat:@"%ldM",_totaiZise / 1024 / 1024];
                } else if (_totaiZise / 1024 / 1024 > 1024) {// G
                     _sizeLabel.text = [NSString stringWithFormat:@"%ldG",_totaiZise / 1024 / 1024 / 1024];
                }
                
                _sizeLabel.textAlignment = NSTextAlignmentRight;
                [cell addSubview:_sizeLabel];
            } else if (indexPath.row == 3) {
                cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 12, MainScreenWidth-30, 21)];
                numberLbl.text = array[3];
                numberLbl.textColor = [UIColor redColor];
                [cell addSubview:numberLbl];
            }
            
        }
        return cell;
        
    } else if (indexPath.section == 4) {
        static NSString *identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1];
            UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2+20, (60-21)/2, 100, 21)];
            numberLbl.textColor = [UIColor whiteColor];
            numberLbl.text = @"退出账号";
            [cell addSubview:numberLbl];
        }
        return cell;
    }
    return nil;
}

-(void)switchIsChanged:(UISwitch *)sender{
    //将NSString 对象存储到 NSUserDefaults 中
    NSLog(@"%d",sender.on);
    NSString *passWord;
    if (sender.on) {
        passWord = @"1";
    }else{
    
        passWord = @"0";
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:passWord forKey:@"netRook"];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                PersonInfoViewController *infoVc = [[PersonInfoViewController alloc] initWithUserFace:self.face];
                infoVc.allDict = _allDic;
                [self.navigationController pushViewController:infoVc animated:YES];
            }
        }
            break;
        case 1:
        {
            BoundViewController *vc = [[BoundViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            if (indexPath.row == 0) {
                alterPWViewController *alert = [[alterPWViewController alloc]init];
                [self.navigationController pushViewController:alert animated:YES];
            }
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                [self getCurrentVersion];
                [self netWorkConfigGetAppVersion];
            } else if (indexPath.row == 1) {
                [self.navigationController pushViewController:[RecuperationViewController new] animated:YES];
            } else if (indexPath.row == 2) {
                UIActionSheet *shit = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
                shit.tag = 100;
                [shit showInView:self.view];
            } else if (indexPath.row == 3) {
                AboutUsViewController *aboutVc = [[AboutUsViewController alloc] init];
                [self.navigationController pushViewController:aboutVc animated:YES];
            } else if (indexPath.row == 4) {
                InstitutionsChooseVC *vc = [[InstitutionsChooseVC alloc] init];
                vc.fromSetingVC = YES;
                vc.institutionChooseFinished = ^(BOOL succesed) {
                    [rootViewController destoryShared];
                    rootViewController * tabbar = [rootViewController sharedBaseTabBarViewController];
                    AppDelegate *app = [AppDelegate delegate];
                    app.window.rootViewController = tabbar;
                    [app.window makeKeyAndVisible];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        case 4:
        {
            UIActionSheet *shit = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"退出", nil];
            shit.tag = 200;
            [shit showInView:self.view];
        }
            break;
        default:
            break;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 100) {//说明是清除缓存
        switch (buttonIndex) {
            case 0:
                [self removeBenDi];
                break;
            default:
                break;
        }
        
    } else if (actionSheet.tag == 200) {//退出程序
        switch (buttonIndex) {
            case 0:
                [self quit];
                break;
            default:
                break;
        }
    }
}

#pragma mark --- 事件点击处理

//清除缓存
- (void)removeBenDi {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *caches1 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    [manager removeItemAtPath:caches1 error:nil];
    
    NSLog(@"---%@",caches1);
    
    NSString *caches2 = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    [manager removeItemAtPath:caches2 error:nil];
    _sizeLabel.text = @"0M";
}

-(void)quit {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userface"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthTokenSecret"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"oauthToken"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"User_id"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"avatar_small"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"uname"];
    [defaults removeObjectForKey:@"balance"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fans"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"follow"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"schoolID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Video_Face"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasAlipay"];
    [Passport removeFile];
    
    DLViewController *DLVC = [[DLViewController alloc] init];
    DLVC.typeStr = @"123";
    [self.navigationController pushViewController:DLVC animated:YES];
}

-(void)btnClick {

}


#pragma mark --- 文件的计算

//计算文件夹的大小
- (void)fileSize {
    NSFileManager *manager = [NSFileManager defaultManager];
    //    NSString *caches1 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *caches = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSLog(@"-----%@",caches);
    NSArray *subPaths = [manager subpathsAtPath:caches];
    NSInteger totalBySize = 0;
    for (NSString *subPath in subPaths) {
        NSString *fullSubPath = [caches stringByAppendingPathComponent:subPath];
        BOOL dir = NO;//判断是否为文件
        [manager fileExistsAtPath:fullSubPath isDirectory:&dir];
        
        if (dir == NO) {//文件
            totalBySize += [[manager attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
    
    NSLog(@"-----%ld",totalBySize);
    _totaiZise = totalBySize;
    
}

- (NSInteger)fileSizeWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSLog(@"-----%@",path);
    NSArray *subPaths = [manager subpathsAtPath:path];
    NSInteger totalBySize = 0;
    for (NSString *subPath in subPaths) {
        NSString *fullSubPath = [path stringByAppendingPathComponent:subPath];
        BOOL dir = NO;//判断是否为文件
        [manager fileExistsAtPath:fullSubPath isDirectory:&dir];
        
        if (dir == NO) {//文件
            totalBySize += [[manager attributesOfItemAtPath:fullSubPath error:nil][NSFileSize] integerValue];
        }
    }
    
    NSLog(@"-----%ld",totalBySize);
    return totalBySize;
}

- (void)getCurrentVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey]; //获取项目版本号
    NSLog(@"version .. %@",version);
    _currentVersion = version;
}

#pragma mark -- alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        NSURL *url = [NSURL URLWithString:[[_appVersionDict dictionaryValueForKey:@"ios"] stringValueForKey:@"down_url"]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark --- 网络请求

//获取用户信息
- (void)netWorkUserGetInfo {
    
    NSString *endUrlStr = YunKeTang_User_user_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (UserID == nil) {
    } else {
        [mutabDict setObject:UserID forKey:@"user_id"];
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
        _allDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取app版本
- (void)netWorkConfigGetAppVersion {
    
    NSString *endUrlStr = YunKeTang_config_getAppVersion;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _appVersionDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _appVersionDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[[_appVersionDict dictionaryValueForKey:@"ios"] stringValueForKey:@"version"] integerValue] != [_currentVersion integerValue] ) {//需要更新
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本，是否前往更新？" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                alert.tag = 2;
                [alert show];
            } else {
                [TKProgressHUD showError:@"已是最新版本" toView:self.view];
                return ;
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
