//
//  EntityCardViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2018/1/8.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//  实体卡界面

#import "EntityCardViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"


@interface EntityCardViewController ()<UITextFieldDelegate> {
    NSInteger Number;
}

@property (strong ,nonatomic)UITextField *textField;
@property (strong ,nonatomic)UIButton    *submitButton;

@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)UILabel *back;


@end

@implementation EntityCardViewController

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
    _titleLabel.text = @"实体卡充值";
    [self interFace];
    [self addTextView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    Number = 3;
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
    WZLabel.text = @"实体卡充值";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

#pragma mark --- 添加视图



- (void)addTextView {
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 125 * WideEachUnit)];
    textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:textView];
    
    
    UILabel *rechargeCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 20 * WideEachUnit, 200 * WideEachUnit, 16 * WideEachUnit)];
    rechargeCardLabel.text = @"实体卡卡号";
    rechargeCardLabel.font = Font(16 * WideEachUnit);
    rechargeCardLabel.textAlignment = NSTextAlignmentCenter;
    rechargeCardLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [textView addSubview:rechargeCardLabel];
    
    
    //添加输入文本
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 56 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 50 * WideEachUnit)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = Font(20 * WideEachUnit);
    textField.placeholder = @"请输入卡号";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = Font(20 * WideEachUnit);
    textField.delegate = self;
    textField.textColor = [UIColor colorWithHexString:@"#333"];
    [textView addSubview:textField];
    _textField = textField;
    
    
    if (_entityDict != nil) {//说明是
//        rechargeCardLabel.frame = CGRectMake(0, 0, 0, 0);
        textField.hidden = YES;
        
        //添加卡号的文本
        UILabel *rechargeCardCode = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 56 * WideEachUnit, 200 * WideEachUnit, 50 * WideEachUnit)];
        rechargeCardCode.text = [_entityDict stringValueForKey:@"code"];
        rechargeCardCode.font = Font(20 * WideEachUnit);
        rechargeCardCode.textAlignment = NSTextAlignmentCenter;
        rechargeCardCode.textColor = [UIColor colorWithHexString:@"#333"];
        [textView addSubview:rechargeCardCode];
    }
    
    
    
    //添加提交订单按钮
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(37.5 * WideEachUnit, MACRO_UI_UPHEIGHT + 150 * WideEachUnit, 300 * WideEachUnit, 46 * WideEachUnit)];
    [_submitButton setTitle:@"确认使用" forState:UIControlStateNormal];
    _submitButton.layer.cornerRadius = 10 * WideEachUnit;
    _submitButton.backgroundColor = BasidColor;
    [_submitButton addTarget:self action:@selector(submitButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    if (_entityDict != nil) {
        [_submitButton setTitle:@"取消使用" forState:UIControlStateNormal];
    }
    
}

#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textChange:(NSNotification *)not {
    
}

- (void)submitButtonCilck {
    [_textField resignFirstResponder];
    if (_entityDict == nil) {//使用实体卡
//          [self NetWorkGetExchangeCard];
        [self netWorkCouponGetExchangeCard];
    } else {//取消使用实体啦
//          [self NetWorkCancelExchangeCard];
        [self netWorkCouponCancelExchangeCard];
    }
}

#pragma mark --- 添加充值成功的界面

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(0, 0, 250 * WideEachUnit, 130 * WideEachUnit);
    _buyView.backgroundColor = [UIColor whiteColor];
    _buyView.layer.cornerRadius = 5 * WideEachUnit;
    _buyView.center = self.view.center;
    [_allView addSubview:_buyView];
    
    //添加图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(125 * WideEachUnit - 26 * WideEachUnit, 15 * WideEachUnit, 52 * WideEachUnit, 52 * WideEachUnit)];
    imageView.image = Image(@"找回成功@2x");
    [_buyView addSubview:imageView];
    
    //添加充值成功
    UILabel *succeed = [[UILabel alloc] initWithFrame:CGRectMake(0, 73 * WideEachUnit, 250 * WideEachUnit, 16 * WideEachUnit)];
    succeed.text = @"充值成功";
    succeed.font = Font(16 * WideEachUnit);
    succeed.textAlignment = NSTextAlignmentCenter;
    succeed.textColor = [UIColor colorWithHexString:@"#333"];
    [_buyView addSubview:succeed];
    
    
    //添加返回的文本
    UILabel *back = [[UILabel alloc] initWithFrame:CGRectMake(0, 103 * WideEachUnit, 250 * WideEachUnit, 12 * WideEachUnit)];
    back.text = @"3秒自动返回育币页";
    back.font = Font(12 * WideEachUnit);
    back.textAlignment = NSTextAlignmentCenter;
    back.textColor = [UIColor colorWithHexString:@"#888"];
    [_buyView addSubview:back];
    _back = back;
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self miss];
        [self backPressed];
    });
    
    
}


- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
    });
    
    
    Number = 3;
}

- (void)timePast {
    Number --;
    _back.text = [NSString stringWithFormat:@"%ld秒自动返回育币页",Number];
}


#pragma mark --- 网络请求

// (实体卡的信息)
- (void)NetWorkGetExchangeCard {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:[[_dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"school_id"] forKey:@"mhm_id"];
    [dic setObject:[_dict stringValueForKey:@"price"] forKey:@"price"];
    
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入实体卡卡号" toView:self.view];
        return;
    }
    [dic setObject:_textField.text forKey:@"coupon_code"];
    
    [manager BigWinCar_GetPublicWay:dic mod:@"Video" act:@"getExchangeCard" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {//说明可以使用
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationEntityCardUse" object:[responseObject dictionaryValueForKey:@"data"]];
            [self backPressed];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)NetWorkCancelExchangeCard {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:[[_dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"school_id"] forKey:@"mhm_id"];
    [dic setObject:[_entityDict stringValueForKey:@"code"] forKey:@"coupon_code"];
    
    [manager BigWinCar_GetPublicWay:dic mod:@"Video" act:@"cancelExchangeCard" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {//取消使用成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationEntityCardUse" object:nil];
            [TKProgressHUD showError:msg toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//使用实体卡
- (void)netWorkCouponGetExchangeCard {//
    
    NSString *endUrlStr = YunKeTang_Coupon_coupon_getExchangeCard;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (SWNOTEmptyDictionary([_dict dictionaryValueForKey:@"school_info"])) {
        [mutabDict setObject:[[_dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"school_id"] forKey:@"mhm_id"];
    }
    if (SWNOTEmptyStr([_dict objectForKey:@"mhm_id"])) {
        [mutabDict setObject:[_dict objectForKey:@"mhm_id"] forKey:@"mhm_id"];
    }
    [mutabDict setObject:[_dict stringValueForKey:@"price"] forKey:@"price"];
    
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入实体卡卡号" toView:self.view];
        return;
    }
    [mutabDict setObject:_textField.text forKey:@"coupon_code"];
    if ([[_dict stringValueForKey:@"type"] integerValue] == 1) {//点播
        [mutabDict setObject:[_dict stringValueForKey:@"id"] forKey:@"vid"];
    } else if ([[_dict stringValueForKey:@"type"] integerValue] == 2) {
        [mutabDict setObject:[_dict stringValueForKey:@"live_id"] forKey:@"vid"];
    } else if ([[_dict stringValueForKey:@"type"] integerValue] == 6) {
        [mutabDict setObject:[_dict stringValueForKey:@"id"] forKey:@"vid"];
    }
    if (_isCombo) {
       [mutabDict setObject:[_dict stringValueForKey:@"id"] forKey:@"vid"];
    }
    [mutabDict setObject:@"0" forKey:@"event"];
    if (SWNOTEmptyDictionary(_activityInfo)) {
        if ([[_activityInfo objectForKey:@"is_start"] integerValue]) {
            [mutabDict setObject:@"1" forKey:@"event"];
        }
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                dict = [dict dictionaryValueForKey:@"data"];
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationEntityCardUse" object:dict];
            [self backPressed];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//取消使用实体卡
- (void)netWorkCouponCancelExchangeCard {
    
    NSString *endUrlStr = YunKeTang_Coupon_coupon_cancelExchangeCard;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (SWNOTEmptyDictionary([_dict dictionaryValueForKey:@"school_info"])) {
        [mutabDict setObject:[[_dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"school_id"] forKey:@"mhm_id"];
    }
    if (SWNOTEmptyStr([_dict objectForKey:@"mhm_id"])) {
        [mutabDict setObject:[_dict objectForKey:@"mhm_id"] forKey:@"mhm_id"];
    }
    [mutabDict setObject:[_entityDict stringValueForKey:@"code"] forKey:@"coupon_code"];
    
    
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationEntityCardUse" object:nil];
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
