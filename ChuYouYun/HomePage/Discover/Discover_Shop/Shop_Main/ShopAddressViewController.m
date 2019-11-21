//
//  ShopAddressViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/6/13.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "ShopAddressViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "SDCycleScrollView.h"
#import "BigWindCar.h"

#import "Good_AddBankProvinceViewController.h"

@interface ShopAddressViewController () {
    BOOL isSele;
}

@property (strong ,nonatomic)UITextField     *personTextField;
@property (strong ,nonatomic)UITextField     *teleTextField;
@property (strong ,nonatomic)UITextField     *areaTextField;
@property (strong ,nonatomic)UITextField     *addressTextField;
@property (strong ,nonatomic)UIButton        *defaultButton;

@property (strong ,nonatomic)NSDictionary    *proVinceDict;
@property (strong ,nonatomic)NSDictionary    *cityDict;
@property (strong ,nonatomic)NSDictionary    *countyDict;

@property (strong ,nonatomic)NSString        *proVinceID;
@property (strong ,nonatomic)NSString        *cityID;
@property (strong ,nonatomic)NSString        *countyID;

@property (strong ,nonatomic)NSString        *province;
@property (strong ,nonatomic)NSString        *city;
@property (strong ,nonatomic)NSString        *country;
@property (strong ,nonatomic)NSString        *is_default;



@end

@implementation ShopAddressViewController

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
    [self addInfoView];
    //    [self addTableHeaderView];
    //    [self addTableView];
    //    [self netWorkGetGoodsBanner];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProvince:) name:@"NSNotificationGood_Province" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCity:) name:@"NSNotificationGood_City" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCounty:) name:@"NSNotificationGood_County" object:nil];
    isSele = NO;
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"地址管理";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

#pragma mark --- 添加界面
- (void)addInfoView {
    CGFloat viewW = MainScreenWidth - 20 * WideEachUnit;
    CGFloat viewH = 50 * WideEachUnit;
    NSArray *titleArray = @[@"收货人",@"联系电话",@"所在地区",@"收货地址"];
    
    for (int i = 0 ; i < 4 ; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 70 + (viewH + 10) * WideEachUnit * i, viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 3;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [self.view addSubview:view];
        
        //添加文本
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, 80 * WideEachUnit, viewH)];
        label.text = titleArray[i];
        label.font = Font(16);
        label.textColor = [UIColor colorWithHexString:@"#333"];
        [view addSubview:label];
        
        //添加输入框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80 * WideEachUnit, 0, viewW - 90 * WideEachUnit, viewH)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor colorWithHexString:@"#888"];
        textField.font = Font(15);
        [view addSubview:textField];
        if (i == 0) {
            _personTextField = textField;
        } else if (i == 1) {
            _teleTextField = textField;
        } else if (i == 2) {
            _areaTextField = textField;
            _areaTextField.placeholder = @"省份 城市 地区";
            UIButton *areaTextFieldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW - 90 * WideEachUnit, viewH)];
            [areaTextFieldButton addTarget:self action:@selector(areaTextFieldButtonCilck) forControlEvents:UIControlEventTouchUpInside];
            [_areaTextField addSubview:areaTextFieldButton];
        } else if (i == 3) {
            _addressTextField = textField;
        }
    }
    
    //添加设置为默认的界面
    UIView *defaultView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 70 + (viewH + 10) * WideEachUnit * 4 + 10 * WideEachUnit, viewW, viewH)];
    defaultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:defaultView];
    
    //默认按钮
    UIButton *defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 140 * WideEachUnit, 30 * WideEachUnit)];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateNormal];
    defaultButton.titleLabel.font = Font(15);
    [defaultButton setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
    [defaultButton setImage:Image(@"") forState:UIControlStateNormal];
    [defaultButton addTarget:self action:@selector(defaultButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [defaultView addSubview:defaultButton];
    _defaultButton = defaultButton;
    
    //保存地址按钮
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(defaultView.frame) + 50 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 30 * WideEachUnit)];
    [saveButton setTitle:@"保存地址" forState:UIControlStateNormal];
    saveButton.titleLabel.font = Font(16);
    saveButton.backgroundColor = [UIColor whiteColor];
    [saveButton addTarget:self action:@selector(saveButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
    [self.view addSubview:saveButton];
}


#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)areaTextFieldButtonCilck {
    Good_AddBankProvinceViewController *vc = [[Good_AddBankProvinceViewController alloc] init];
    vc.typeStr = @"shopAddress";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)defaultButtonCilck {
    isSele = !isSele;
    if (isSele) {
        _is_default = @"1";
//        _defaultButton.image = [UIImage imageNamed:@"check_cb_on"];
    } else {
        _is_default = @"0";
//        _defaultButton.image = [UIImage imageNamed:@"check_cb_on"];
    }
}

- (void)saveButtonCilck {
    
}

#pragma mark --- 通知
- (void)getProvince:(NSNotification *)not {
    _proVinceDict = not.object;
    
    _areaTextField.text = [_proVinceDict stringValueForKey:@"title"];
    _proVinceID = [_proVinceDict stringValueForKey:@"area_id"];
}

- (void)getCity:(NSNotification *)not {
    _cityDict = not.object;
    _areaTextField.text = [NSString stringWithFormat:@"%@  %@",[_proVinceDict stringValueForKey:@"title"],[_cityDict stringValueForKey:@"title"]];
    _cityID = [_cityDict stringValueForKey:@"area_id"];
}

- (void)getCounty:(NSNotification *)not {
    _countyDict = not.object;
    _areaTextField.text = [NSString stringWithFormat:@"%@  %@   %@",[_proVinceDict stringValueForKey:@"title"],[_cityDict stringValueForKey:@"title"],[_countyDict stringValueForKey:@"title"]];
    _countyID = [_countyDict stringValueForKey:@"area_id"];
}

#pragma mark -- 网络请求

//商城的分类
- (void)netWorkAddressAdd {
    NSString *endUrlStr = YunKeTang_Address_address_add;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_province == nil) {
    } else {
        [mutabDict setObject:_province forKey:@"province"];
    }
    
    if (_city == nil) {
    } else {
        [mutabDict setObject:_city forKey:@"city"];
    }
    
    if (_country == nil) {
    } else {
        [mutabDict setObject:_country forKey:@"area"];
    }
    if (_addressTextField.text.length == 0) {
        
    } else {
        [mutabDict setObject:_addressTextField.text forKey:@"address"];
    }
    
    if (_personTextField.text.length == 0) {
        [TKProgressHUD showError:@"请输入收货人" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_personTextField.text forKey:@"name"];
    }
    if (_teleTextField.text.length == 0) {
        [TKProgressHUD showError:@"请输入联系电话" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_teleTextField.text forKey:@"phone"];
    }
    
    if (_is_default == nil) {
        
    } else {
        [mutabDict setObject:_is_default forKey:@"is_default"];
    }

    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
