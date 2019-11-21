//
//  Good_PersonFaceBoundViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/12/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_PersonFaceBoundViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"

#import "Good_PersonFaceRegisterViewController.h"


@interface Good_PersonFaceBoundViewController ()

@property (strong ,nonatomic)UIImageView      *personImageView;
@property (strong ,nonatomic)UIView           *personBoundView;
@property (strong ,nonatomic)UIView           *personTryView;


@property (strong ,nonatomic)UILabel          *personTitle;
@property (strong ,nonatomic)NSDictionary     *statusDict;

@end

@implementation Good_PersonFaceBoundViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self NetWorkYouTuIsExist];
    
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
    [self interFcae];
    [self addNav];
    [self addImageView];
    [self addPersonBound];
    [self addPersonTry];
    [self NetWorkYouTuIsExist];
}

- (void)interFcae {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"人脸绑定";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
}

#pragma mark --- 添加视图

- (void)addImageView {
    _personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 200 * WideEachUnit)];
    _personImageView.backgroundColor = [UIColor whiteColor];
    _personImageView.image = Image(@"faceimg@3x");
    [self.view addSubview:_personImageView];
}

- (void)addPersonBound {
    _personBoundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_personImageView.frame), MainScreenWidth, 40 * WideEachUnit)];
    _personBoundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_personBoundView];
    
    //在视图上面添加Label
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth / 2, 40 * WideEachUnit)];
    title.text = @"人脸绑定";
    title.font = Font(14 * WideEachUnit);
    title.textColor = [UIColor lightGrayColor];
    [_personBoundView addSubview:title];
    
    //在视图上面添加Label
    UILabel *personTitle = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 0, MainScreenWidth / 2 - 30 * WideEachUnit, 40 * WideEachUnit)];
    personTitle.text = @"创建个人人物信息";
    personTitle.font = Font(14 * WideEachUnit);
    personTitle.textAlignment = NSTextAlignmentRight;
    personTitle.textColor = [UIColor lightGrayColor];
    [_personBoundView addSubview:personTitle];
    _personTitle = personTitle;
    
    //添加箭头
    UIButton *cilckButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40 * WideEachUnit, 0, 40 * WideEachUnit, 40 * WideEachUnit)];
    [cilckButton setImage:Image(@"ic_more@3x") forState:UIControlStateNormal];
    [_personBoundView addSubview:cilckButton];
    
    //添加透明的按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth, 40 * WideEachUnit)];
    cleanButton.backgroundColor = [UIColor clearColor];
    cleanButton.tag = 1;
    [cleanButton addTarget:self action:@selector(cleanButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_personBoundView addSubview:cleanButton];
    
}

- (void)addPersonTry {
    _personTryView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_personBoundView.frame) + 10 * WideEachUnit, MainScreenWidth, 40 * WideEachUnit)];
    _personTryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_personTryView];
    
    //在视图上面添加Label
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth / 2, 40 * WideEachUnit)];
    title.text = @"体验刷脸";
    title.font = Font(14 * WideEachUnit);
    title.textColor = [UIColor lightGrayColor];
    [_personTryView addSubview:title];
    
    //在视图上面添加Label
    UILabel *personTitle = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 0, MainScreenWidth / 2 - 30 * WideEachUnit, 40 * WideEachUnit)];
//    personTitle.text = @"创建个人人物信息";
    personTitle.font = Font(14 * WideEachUnit);
    personTitle.textAlignment = NSTextAlignmentRight;
    personTitle.textColor = [UIColor lightGrayColor];
    [_personTryView addSubview:personTitle];

    
    //添加箭头
    UIButton *cilckButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40 * WideEachUnit, 0, 40 * WideEachUnit, 40 * WideEachUnit)];
    [cilckButton setImage:Image(@"ic_more@3x") forState:UIControlStateNormal];
    [_personTryView addSubview:cilckButton];
    
    //添加透明的按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth, 40 * WideEachUnit)];
    cleanButton.backgroundColor = [UIColor clearColor];
    cleanButton.tag = 2;
    [cleanButton addTarget:self action:@selector(cleanButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_personTryView addSubview:cleanButton];
    
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cleanButtonCilck:(UIButton *)button {
    if (button.tag == 1) {
        if ([[_statusDict stringValueForKey:@"is_exist"] integerValue] == 1) {//已经绑定
            return;
        }
        Good_PersonFaceRegisterViewController *vc = [[Good_PersonFaceRegisterViewController alloc] init];
        vc.typeStr = @"1";
        vc.tryStr = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        Good_PersonFaceRegisterViewController *vc = [[Good_PersonFaceRegisterViewController alloc] init];
        vc.typeStr = @"1";
        vc.tryStr = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark ---- 网络请求
//检测是否已经绑定了人脸
- (void)NetWorkYouTuIsExist {
    
    NSString *endUrlStr = YunKeTang_YouTu_youtu_isExist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr = [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
                                         
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _statusDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_statusDict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_statusDict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                 _statusDict = [_statusDict dictionaryValueForKey:@"data"];
            } else {
                 _statusDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            if ([[_statusDict stringValueForKey:@"is_exist"] integerValue] == 0) {//不存在
                _personTitle.text = @"创建人物信息";
            } else if ([[_statusDict stringValueForKey:@"is_exist"] integerValue] == 1) {//正常使用
                _personTitle.text = @"已绑定";
            } else if ([[_statusDict stringValueForKey:@"is_exist"] integerValue] == 2) {//需要上传更多的照片
                _personTitle.text = @"完善人物信息";
            }
        } else {
            [TKProgressHUD showError:[_statusDict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
