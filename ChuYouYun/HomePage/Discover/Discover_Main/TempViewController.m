//
//  TempViewController.m
//  dafengche
//
//  Created by IOS on 16/10/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "TempViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "ManageAddressViewController.h"


#import "MyLiveViewController.h"
#import "Good_MyClassDownloadViewController.h"


#import "Good_ClassMainViewController.h"
#import "Good_QuestionsAndAnswersMainViewController.h"
#import "ShopAddressViewController.h"
#import "JVSRSAHandler.h"

//支付
//#import "PKPaymentAuthorizationViewController.h"
#import <PassKit/PassKit.h>

#import "DLViewController.h"


@interface TempViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

@end

@implementation TempViewController

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
    //[self addscrollow];
    //[self addTableView];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(156, 100, 80, 20)];
    [btn setTitle:@"支付" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goPaiKe) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(156, 140, 160, 20)];
    [btn1 setTitle:@"管理收货地址" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(goManageAddress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(156, 180, 160, 20)];
    [btn2 setTitle:@"地区" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(area) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(60, 180, 160, 20)];
    [btn3 setTitle:@"视频空间" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(Video) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(60, 230, 160, 20)];
    [btn4 setTitle:@"独立域名" forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    [btn4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(Name) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(60, 260, 160, 20)];
    [btn5 setTitle:@"独立财务账户" forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    [btn5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(Money) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn6 = [[UIButton alloc]initWithFrame:CGRectMake(60, 390, 160, 20)];
    [btn6 setTitle:@"商城" forState:UIControlStateNormal];
    [self.view addSubview:btn6];
    [btn6 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn9 = [[UIButton alloc]initWithFrame:CGRectMake(60, 510, 160, 20)];
    [btn9 setTitle:@"直播列表" forState:UIControlStateNormal];
    [self.view addSubview:btn9];
    [btn9 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn9 addTarget:self action:@selector(goMyLive) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn10 = [[UIButton alloc]initWithFrame:CGRectMake(60, 540, 160, 20)];
    [btn10 setTitle:@"讲师列表" forState:UIControlStateNormal];
    [self.view addSubview:btn10];
    [btn10 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn10 addTarget:self action:@selector(goteacher) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn11 = [[UIButton alloc]initWithFrame:CGRectMake(60, 580, 160, 20)];
    [btn11 setTitle:@"live" forState:UIControlStateNormal];
    [self.view addSubview:btn11];
    [btn11 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn11 addTarget:self action:@selector(goZXList) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn12 = [[UIButton alloc]initWithFrame:CGRectMake(60, 620, 160, 20)];
    [btn12 setTitle:@"课程详情" forState:UIControlStateNormal];
    [self.view addSubview:btn12];
    [btn12 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn12 addTarget:self action:@selector(goClass) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn13 = [[UIButton alloc]initWithFrame:CGRectMake(150, 520, 160, 20)];
    [btn13 setTitle:@"问答相关" forState:UIControlStateNormal];
    [self.view addSubview:btn13];
    [btn13 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn13 addTarget:self action:@selector(goWenDa) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn14 = [[UIButton alloc]initWithFrame:CGRectMake(250, 520, 120, 20)];
    [btn14 setTitle:@"我的下载" forState:UIControlStateNormal];
    [self.view addSubview:btn14];
    [btn14 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn14 addTarget:self action:@selector(goDown) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btn15 = [[UIButton alloc]initWithFrame:CGRectMake(250, 600, 120, 20)];
    [btn15 setTitle:@"我的下载" forState:UIControlStateNormal];
    [self.view addSubview:btn15];
    [btn15 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn15 addTarget:self action:@selector(goJieMi) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *btn16 = [[UIButton alloc]initWithFrame:CGRectMake(250, 300, 120, 30)];
    [btn16 setTitle:@"进度条" forState:UIControlStateNormal];
    [self.view addSubview:btn16];
    [btn16 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn16 addTarget:self action:@selector(jinDuTiao) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)goZXList{
    
}

-(void)goteacher{
}

-(void)goMyLive{

}
-(void)goLive{

}

-(void)gomy{
}
-(void)popView{
    
}

- (void)Money {

}

- (void)Name {
    
}

- (void)Video {
    
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
    } else {
        NSLog(@"不能支付");
    }
}

-(void)area{
    
}
-(void)goManageAddress{

    [self.navigationController pushViewController:[ManageAddressViewController new] animated:YES];
    
}

- (void)goClass {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goWenDa {
    Good_QuestionsAndAnswersMainViewController *vc = [[Good_QuestionsAndAnswersMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goDown {
    Good_MyClassDownloadViewController *vc = [[Good_MyClassDownloadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goJieMi {
}

- (void)jinDuTiao {
//    JieMiTestViewController *vc = [[JieMiTestViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    ShopAddressViewController *vc = [[ShopAddressViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    //加密
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"value2" forKey:@"param2"];
    [dict setObject:@"value1" forKey:@"param1"];

    
    
//    NSString *chh = [[JVSRSAHandler shareInstance] encryptDictionary:dict WithRSAKeyType:(KeyTypePublic)];
//
//
//   NSString *encryptStr = [chh stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
//   encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    

    //获取当前时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *newStr = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:nil];
    
    if (!jsonData) {
    }else{
        newStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
//    timeSp = @"1523944599";
    NSString *keyStr = [NSString stringWithFormat:@"%@|%@",timeSp,newStr];
    
    
    NSData *keyData = [keyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:keyData options:NSJSONReadingMutableContainers error:&err];
    
    
    NSData *data = [keyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64Str =  [data base64EncodedStringWithOptions:0];
    
    
    NSData *baseData = [base64Str dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:baseData options:NSJSONReadingMutableContainers error:&err];
    
    NSData *daaaaaa =  [[JVSRSAHandler shareInstance] encryptionData:baseData WithRSAKeyType:KeyTypePublic];
    
    NSString *fffff = [daaaaaa base64EncodedStringWithOptions:0];
    

    NSString *gggggstr = [fffff stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    gggggstr = [gggggstr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    
    
    //解密
    NSString *JIEMIStr = fffff;
    
    NSData *KKKKK = [[JVSRSAHandler shareInstance] decryptData:baseData WithRSAKeyType:KeyTypePublic];
    
    NSString * str  =[[NSString alloc] initWithData:KKKKK encoding:NSUTF8StringEncoding];
    
    
    
    
}

-(void)addscrollow{

    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,66, MainScreenWidth,44*MainScreenHeight/667)];
    _headScrollow.contentSize = CGSizeMake(MainScreenWidth*4, _headScrollow.bounds.size.height);
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = YES;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
}
-(void)goPaiKe{
    
}
- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"临时页面";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 32, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"资讯分类@2x"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(ShopCateButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
}
//分类
-(void)ShopCateButton{
    
    NSLog(@"分类");
}
- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
