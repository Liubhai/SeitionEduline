//
//  Good_AddBankViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/10.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_AddBankViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_AddBankProvinceViewController.h"

@interface Good_AddBankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UIScrollView    *scrollView;
@property (strong ,nonatomic)UIView          *openBankView;
@property (strong ,nonatomic)UIView          *openProvinceView;
@property (strong ,nonatomic)UIView          *kinsView;
@property (strong ,nonatomic)UIButton        *submitButton;
@property (strong ,nonatomic)UITableView     *tableView;

@property (strong ,nonatomic)UILabel         *addBankTitle;
@property (strong ,nonatomic)UILabel         *provinceLabel;
@property (strong ,nonatomic)UILabel         *cityLabel;
@property (strong ,nonatomic)UILabel         *countyLabel;

@property (strong ,nonatomic)UILabel         *bankLabel;
@property (strong ,nonatomic)UITextField     *allTextField;
@property (strong ,nonatomic)UITextField     *adressTextField;
@property (strong ,nonatomic)UITextField     *bankNumberTextField;
@property (strong ,nonatomic)UITextField     *nameTextField;
@property (strong ,nonatomic)UITextField     *TelNumberTextField;


@property (strong ,nonatomic)NSArray         *banksArray;
@property (strong ,nonatomic)NSDictionary    *proVinceDict;
@property (strong ,nonatomic)NSDictionary    *cityDict;
@property (strong ,nonatomic)NSDictionary    *countyDict;

@property (strong ,nonatomic)NSString        *proVinceID;
@property (strong ,nonatomic)NSString        *cityID;
@property (strong ,nonatomic)NSString        *countyID;

//
@property (strong ,nonatomic)NSString    *seleStr;//选中的字典

@end

@implementation Good_AddBankViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    NSLog(@"%@  %@  %@",_proVinceDict,_cityDict,_countyDict);
    
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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"添加银行卡";
    [self addScrollView];
    [self addOpenBankView];
    [self addOpenProvinceView];
    [self addKinsView];
    [self addSubmitButton];
    //    [self addTextView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProvince:) name:@"NSNotificationGood_Province" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCity:) name:@"NSNotificationGood_City" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCounty:) name:@"NSNotificationGood_County" object:nil];
    
    //添加键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardCome:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
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
    WZLabel.text = @"添加银行卡";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
}

#pragma mark --- 添加详情界面

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 10 * WideEachUnit);
}

- (void)addInfoView {
    
}

- (void)addOpenBankView {
    
    _openBankView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 * WideEachUnit, MainScreenWidth, 60 * WideEachUnit)];
    _openBankView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_openBankView];
    
    //添加中间的文字
    UILabel *openBank = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0 * WideEachUnit, 200 * WideEachUnit, 15 * WideEachUnit)];
    openBank.text = @"开户银行";
    [openBank setTextColor:[UIColor blackColor]];
    openBank.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    [_openBankView addSubview:openBank];
    
    //添加输入框
    UIView *addBankGoundView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 20 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 40 * WideEachUnit)];
//    addBankTitle.text = @"中国银行";
//    addBankTitle.font = Font(16 * WideEachUnit);
    addBankGoundView.backgroundColor = [UIColor whiteColor];
    [_openBankView addSubview:addBankGoundView];
    
    //添加银行名字
    UILabel *addBankTitle = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 80 * WideEachUnit, 20 * WideEachUnit)];
    addBankTitle.text = @"中国银行";
    addBankTitle.text = nil;
    [addBankTitle setTextColor:[UIColor blackColor]];
    addBankTitle.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    [addBankGoundView addSubview:addBankTitle];
    _addBankTitle = addBankTitle;
    
    //添加按钮
    UIButton *addBankButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70 * WideEachUnit, 0, 40 * WideEachUnit, 40 * WideEachUnit)];
    
    [addBankButton setImage:[UIImage imageNamed:@"icon_dropdown@3x"] forState:UIControlStateNormal];
    [addBankButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addBankButton addTarget:self action:@selector(addBankButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [addBankGoundView addSubview:addBankButton];
    
    
    //添加一个透明的按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0,MainScreenWidth -  30 * WideEachUnit,40 * WideEachUnit)];
    cleanButton.backgroundColor = [UIColor clearColor];
    [cleanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(addBankButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [addBankGoundView addSubview:cleanButton];
    
    
}

- (void)addOpenProvinceView {
    _openProvinceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_openBankView.frame) + 15 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 60 * WideEachUnit)];
    _openProvinceView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_openProvinceView];
    
    //添加中间的文字
    UILabel *openBank = [[UILabel  alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0 * WideEachUnit, 200 * WideEachUnit, 15 * WideEachUnit)];
    openBank.text = @"开户省城区";
    [openBank setTextColor:[UIColor blackColor]];
    openBank.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    [_openProvinceView addSubview:openBank];
    
    CGFloat ViewW = (MainScreenWidth - 50 * WideEachUnit) / 3;
    CGFloat ViewH = 40 * WideEachUnit;
    
//    for (int i = 0; i < 3 ; i ++) {
//        UIView *addBankGoundView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit + i * (ViewW + 10 * WideEachUnit), 20 * WideEachUnit ,ViewW, ViewH)];
//        //    addBankTitle.text = @"中国银行";
//        //    addBankTitle.font = Font(16 * WideEachUnit);
//        addBankGoundView.backgroundColor = [UIColor whiteColor];
//        [_openProvinceView addSubview:addBankGoundView];
//
//        //添加银行名字
//        UILabel *addBankTitle = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit,ViewW - 20 * WideEachUnit, 20 * WideEachUnit)];
//        addBankTitle.text = @"四川";
//        [addBankTitle setTextColor:[UIColor blackColor]];
//        addBankTitle.font = [UIFont systemFontOfSize:13 * WideEachUnit];
//        [addBankGoundView addSubview:addBankTitle];
//
//        if (i == 0) {
//            _provinceLabel = addBankTitle;
//        } else if (i == 1) {
//            _cityLabel = addBankTitle;
//        } else if (i == 2) {
//            _countyLabel = addBankTitle;
//        }
//
//        //添加按钮
//        UIButton *addBankButton = [[UIButton alloc] initWithFrame:CGRectMake(ViewW - 40 * WideEachUnit, 0, 40 * WideEachUnit, 40 * WideEachUnit)];
//        [addBankButton setImage:[UIImage imageNamed:@"icon_dropdown@3x"] forState:UIControlStateNormal];
//        addBankButton.backgroundColor = [UIColor whiteColor];
//        [addBankButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        addBankButton.tag = 10 * i;
//        [addBankButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [addBankGoundView addSubview:addBankButton];
//
//    }
    
    
    //添加一个Label
    UITextField *allTextField = [[UITextField alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 20 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 40 * WideEachUnit)];
    allTextField.backgroundColor = [UIColor whiteColor];
    allTextField.placeholder = @"点击选择地区";
    [allTextField setValue:[UIFont boldSystemFontOfSize:14 * WideEachUnit] forKeyPath:@"_placeholderLabel.font"];
    [_openProvinceView addSubview:allTextField];
    allTextField.userInteractionEnabled = YES;
    allTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10 * WideEachUnit, 10 * WideEachUnit)];
    allTextField.leftViewMode = UITextFieldViewModeAlways;
    _allTextField = allTextField;
    _allTextField.font = Font(14 * WideEachUnit);
    
    
    
    //添加按钮
    UIButton *textFieldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 30 * WideEachUnit, 40 * WideEachUnit)];
    textFieldButton.backgroundColor = [UIColor clearColor];
    [allTextField addSubview:textFieldButton];
    [textFieldButton addTarget:self action:@selector(textFieldButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加手势
    [allTextField addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldClick:)]];
    
}

- (void)addKinsView {
    _kinsView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_openProvinceView.frame) + 15 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 300 * WideEachUnit)];
    _kinsView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:_kinsView];
    
    NSArray *titleArray = @[@"开户分行地址",@"银行账号",@"开户姓名",@"手机号码"];
    
    for (int i = 0 ; i < 4 ; i ++) {
        //添加中间的文字
        UILabel *openBank = [[UILabel  alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 10 * WideEachUnit + 80 * WideEachUnit * i, 200 * WideEachUnit, 15 * WideEachUnit)];
        openBank.text = titleArray[i];
        [openBank setTextColor:[UIColor blackColor]];
        openBank.font = [UIFont systemFontOfSize:14 * WideEachUnit];
        [_kinsView addSubview:openBank];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 35 * WideEachUnit + 80 * WideEachUnit * i, MainScreenWidth - 30 * WideEachUnit, 40 * WideEachUnit)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10 * WideEachUnit, 10 * WideEachUnit)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.font = Font(14 * WideEachUnit);
        [_kinsView addSubview:textField];
        if (i == 0) {
            _adressTextField = textField;
            _adressTextField.placeholder = @"请输入地址";
        } else if (i == 1) {
            _bankNumberTextField = textField;
            _bankNumberTextField.placeholder = @"请输入账号";
        } else if (i == 2) {
            _nameTextField = textField;
            _nameTextField.placeholder = @"请输入名字";
        } else if (i == 3) {
            _TelNumberTextField = textField;
            _TelNumberTextField.placeholder = @"请输入手机号码";
        }
    }
}

- (void)addSubmitButton {
    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(40 * WideEachUnit, CGRectGetMaxY(_kinsView.frame) + 40 * WideEachUnit, MainScreenWidth - 80 * WideEachUnit, 35 * WideEachUnit)];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.layer.cornerRadius = 10 * WideEachUnit;
    _submitButton.backgroundColor = BasidColor;
//    _submitButton.backgroundColor = [UIColor lightGrayColor];
//    _submitButton.enabled = NO;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitButton];
}

#pragma mark --- 添加表格
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit,_banksArray.count * 60 * WideEachUnit) style:UITableViewStyleGrouped];
    NSLog(@"%lf  %lf",_banksArray.count * 60 * WideEachUnit,MainScreenHeight - 80 - 64);
    if (_banksArray.count * 60 * WideEachUnit > MainScreenHeight - 120 * WideEachUnit - 64) {
        _tableView.frame = CGRectMake(15 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, MainScreenHeight - 120 * WideEachUnit - 64);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }

}

#pragma mark --- UITableViewDelegate

#pragma mark --- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01 * WideEachUnit;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _banksArray.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"cell";
    //自定义cell类
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_banksArray objectAtIndex:indexPath.row];
    cell.textLabel.font = Font(14 * WideEachUnit);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_tableView removeFromSuperview];
    _tableView.frame = CGRectMake(0, 0, 0, 0);
    
    _seleStr = [_banksArray objectAtIndex:indexPath.row];
    _addBankTitle.text = _seleStr;
}



#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBankButtonPressed {
    
    if (_tableView.bounds.size.width) {//说明表表格已经存在
        return;
    }
    [self netWorkUserGetBankList];
    
}

- (void)downButtonClick:(UIButton *)button {

    NSInteger buttonTag = button.tag;
    if (buttonTag == 0) {//省级按钮
        Good_AddBankProvinceViewController *vc = [[Good_AddBankProvinceViewController alloc] init];
        vc.typeStr = @"addBank";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (buttonTag == 10) {//市级按钮
        
    } else if (buttonTag == 20) {//县级按钮
        
    }
}

- (void)textFieldButtonCilck:(UIButton *)button {
    Good_AddBankProvinceViewController *vc = [[Good_AddBankProvinceViewController alloc] init];
    vc.typeStr = @"addBank";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitButtonCilck:(UIButton *)button {
    [self netWorkUserBindBankCard];
}

#pragma mark --- 通知

- (void)textFieldClick:(NSNotification *)not {
    Good_AddBankProvinceViewController *vc = [[Good_AddBankProvinceViewController alloc] init];
    vc.typeStr = @"addBank";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 键盘的通知

//键盘弹起
- (void)keyboardCome:(NSNotification *)Not {
    
    //    NSLog(@"%@",isUp);
    NSLog(@"%@",Not.userInfo);
//    if (isUp == YES) {
//        [_scrollView setContentOffset:CGPointMake(0,200) animated:YES];
//        isUp = YES;
//    } else {
//        isUp = NO;
//        [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
//    }
    
    
    
   [_scrollView setContentOffset:CGPointMake(0,200) animated:YES];
}

//键盘下去
- (void)keyboardHide:(NSNotification *)Not {
    
    [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
//    isUp = !isUp;
}


#pragma mark --- 通知
- (void)getProvince:(NSNotification *)not {
    _proVinceDict = not.object;
    
    _allTextField.text = [_proVinceDict stringValueForKey:@"title"];
    _proVinceID = [_proVinceDict stringValueForKey:@"area_id"];
}

- (void)getCity:(NSNotification *)not {
    _cityDict = not.object;
    _allTextField.text = [NSString stringWithFormat:@"%@  %@",[_proVinceDict stringValueForKey:@"title"],[_cityDict stringValueForKey:@"title"]];
    _cityID = [_cityDict stringValueForKey:@"area_id"];
}

- (void)getCounty:(NSNotification *)not {
    _countyDict = not.object;
    _allTextField.text = [NSString stringWithFormat:@"%@  %@   %@",[_proVinceDict stringValueForKey:@"title"],[_cityDict stringValueForKey:@"title"],[_countyDict stringValueForKey:@"title"]];
    _countyID = [_countyDict stringValueForKey:@"area_id"];
}


#pragma mark --- 网络请求
//银行卡列表
- (void)netWorkUserGetBankList {
    
    NSString *endUrlStr = YunKeTang_User_user_getBankList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"-1" forKey:@"area_id"];
    
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
            _banksArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
//            _banksArray = [dict arrayValueForKey:@"bank"];
            [self addTableView];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}


//绑定银行卡
- (void)netWorkUserBindBankCard {
    
    NSString *endUrlStr = YunKeTang_User_user_bindBankCard;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_bankNumberTextField.text.length > 0) {
        [mutabDict setObject:_bankNumberTextField.text forKey:@"account"];//银行卡号
    } else {
        [TKProgressHUD showError:@"请填写银行卡号" toView:self.view];
        return;
    }
    
    if (_nameTextField.text.length > 0) {
        [mutabDict setObject:_nameTextField.text forKey:@"accountmaster"];//姓名
    } else {
        [TKProgressHUD showError:@"请填写姓名" toView:self.view];
        return;
    }
    
    if (_addBankTitle.text.length > 0) {
        [mutabDict setObject:_addBankTitle.text forKey:@"accounttype"];//银行卡的名称
    } else {
        [TKProgressHUD showError:@"请选择所属银行" toView:self.view];
        return;
    }
    
    if (_TelNumberTextField.text.length > 0) {
        [mutabDict setObject:_TelNumberTextField.text forKey:@"tel_num"];//手机号
    } else {
        [TKProgressHUD showError:@"请填写手机号码" toView:self.view];
        return;
    }
    [mutabDict setObject:_allTextField.text forKey:@"location"];//手机号
    if (_nameTextField.text.length > 0) {
        [mutabDict setObject:_nameTextField.text forKey:@"bankofdeposit"];//姓名
    }
    if (_proVinceID == nil) {
        [TKProgressHUD showError:@"请选择所在省份" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_proVinceID forKey:@"province"];//省的ID
    }
    if (_cityID == nil) {
        [TKProgressHUD showError:@"请选择所在城市" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_cityID forKey:@"city"];//城市的ID
    }
    if (_countyID == nil) {
        [TKProgressHUD showError:@"请选择所在区域" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_countyID forKey:@"area"];//区域的ID
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
        if (dict.allKeys.count > 0 ) {
            [TKProgressHUD showError:@"绑定成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:@"绑定失败" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}






@end
