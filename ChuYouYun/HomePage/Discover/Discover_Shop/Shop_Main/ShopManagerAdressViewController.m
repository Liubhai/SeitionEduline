//
//  ShopManagerAdressViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/7/18.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "ShopManagerAdressViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "AddAddressViewController.h"
#import "TKProgressHUD+Add.h"
#import "EditAdressViewController.h"
#import "ShopManagerAdressTableViewCell.h"

@interface ShopManagerAdressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView         *tableView;
@property (strong ,nonatomic)UIButton            *addAdressButton;

@property (strong ,nonatomic)NSArray             *dataArray;

@end

@implementation ShopManagerAdressViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
//    [self requestData];
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
    [self addTableView];
    [self addDownButton];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    title.text = @"管理收货地址1";
    [SYGView addSubview:title];
    title.font = [UIFont systemFontOfSize:20];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        title.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}

#pragma mark --- 添加表格
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, MainScreenWidth, MainScreenHeight - 65 - 42) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88 - 42);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- 添加按钮
- (void)addDownButton {
    _addAdressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    _addAdressButton.backgroundColor = [UIColor colorWithHexString:@"#888"];
    [_addAdressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [_addAdressButton addTarget:self action:@selector(addAdressButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addAdressButton];
}

#pragma mark --- 添加cell
- (void)addCellSubView {
    _name = [[UILabel alloc]initWithFrame:CGRectMake(15 * WideEachUnit, 5 * WideEachUnit, 121 * WideEachUnit, 20 * WideEachUnit)];
    _name.font = [UIFont systemFontOfSize:13 * WideEachUnit];
    _name.textColor = [UIColor blackColor];
    _name.text = @"周星星";
    
    _adress = [[UILabel alloc]initWithFrame:CGRectMake(_name.current_x +10, _name.current_y_h + 5,MainScreenWidth -40, 20)];
    _adress.font = [UIFont systemFontOfSize:13];
    _adress.textColor = [UIColor colorWithHexString:@"#999999"];
    _adress.text = @"四川省成都市双流县航空港机场路88号";
    
    _phone = [[UILabel alloc]initWithFrame:CGRectMake(_name.current_x_w,_name.current_y, MainScreenWidth - _name.current_x_w - 10, 20)];
    _phone.font = [UIFont systemFontOfSize:12];
    _phone.textColor = [UIColor blackColor];
    _phone.textAlignment = NSTextAlignmentRight;
    _phone.text = @"15538983107";
    
    _line = [[UILabel alloc]initWithFrame:CGRectMake(0,_adress.current_y_h + 10 , MainScreenWidth, 1)];
    _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImage * buttonImage = [UIImage imageNamed:@"首页更多"];
    CGFloat buttonImageViewWidth = CGImageGetWidth(buttonImage.CGImage);
    
    
    
    _defaultButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_line.frame) + 9 * WideEachUnit, 100 * WideEachUnit, 25 * WideEachUnit)];
    [_defaultButton setTitle:@" 默认地址" forState:UIControlStateNormal];
    [_defaultButton setImage:Image(@"gl未选中") forState:UIControlStateNormal];
    [_defaultButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    
    _editorButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, CGRectGetMaxY(_line.frame) + 9 * WideEachUnit, MainScreenWidth / 4, 25 * WideEachUnit)];
    [_editorButton setTitle:@" 编辑" forState:UIControlStateNormal];
    [_editorButton setImage:Image(@"gl编辑") forState:UIControlStateNormal];
    [_editorButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 * 3, CGRectGetMaxY(_line.frame) + 9 * WideEachUnit, MainScreenWidth / 4, 25 * WideEachUnit)];
    [_deleteButton setTitle:@" 删除" forState:UIControlStateNormal];
    [_deleteButton setImage:Image(@"gl删除") forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    
//
//    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, _lineLab.current_y_h+9, 16, 16)];
//    _imgView.image = [UIImage imageNamed:@"gl未选中"];
//
//    _firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, _lineLab.current_y_h+5, 75,25)];
//    [_firstBtn addTarget:self action:@selector(setDefaultKey:) forControlEvents:UIControlEventTouchUpInside];
//
//    _defaultlab = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.current_x_w, _lineLab.current_y_h+5, 105,25)];
//    _defaultlab.text = [NSString stringWithFormat:@"  %@",@"默认地址"];
//    _defaultlab.textColor = [UIColor colorWithHexString:@"#999999"];
//    _defaultlab.font = Font(13);
//    //    [_firstBtn setTitle:[NSString stringWithFormat:@"  %@",@"默认地址"] forState:UIControlStateNormal];
//    //    [_firstBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    //    _firstBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    //    [_firstBtn setImage:[UIImage imageNamed:@"check_cb_no"] forState:UIControlStateNormal];
//
//    BJimgView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth -150, _lineLab.current_y_h+9, 16,16)];
//    BJimgView.image = [UIImage imageNamed:@"gl编辑"];
//    _secondBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth -157, _lineLab.current_y_h+5, 75,25)];
//    [_secondBtn setTitle:[NSString stringWithFormat:@"  %@",@"编辑"] forState:UIControlStateNormal];
//    [_secondBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    _secondBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [_secondBtn addTarget:self action:@selector(setDefaultKey1:) forControlEvents:UIControlEventTouchUpInside];
//
//
//    // [_secondBtn setImage:[UIImage imageNamed:@"gl编辑"] forState:UIControlStateNormal];
//    //_secondBtn.backgroundColor = [UIColor cyanColor];;
//
//    _thirdBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth -77, _lineLab.current_y_h+5, 75,25)];
//    SCimgView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth -70, _lineLab.current_y_h+9, 16,16)];
//    SCimgView.image = [UIImage imageNamed:@"gl删除"];
//    [_thirdBtn setTitle:[NSString stringWithFormat:@"  %@",@"删除"] forState:UIControlStateNormal];
//    [_thirdBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [_thirdBtn addTarget:self action:@selector(setDefaultKey2:) forControlEvents:UIControlEventTouchUpInside];
//    //  [_thirdBtn setImage:[UIImage imageNamed:@"gl删除"] forState:UIControlStateNormal];
}

-(void)addAddress{
    [self.navigationController pushViewController:[AddAddressViewController new] animated:YES];
}

#pragma mark -- UITableViewDatasoure

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"shopManagerCell";
    //自定义cell类
    ShopManagerAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ShopManagerAdressTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
    //    [self backPressed];
    //classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
    //classDVc.isLoad = @"123";
    // [self.navigationController pushViewController:classDVc animated:YES];
    
    //添加通知
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationGetAddress" object:_dataArray[indexPath.row]];
    //    [self backPressed];
    NSDictionary *cellDict = [_dataArray objectAtIndex:indexPath.row];
    self.seleAdressCell(cellDict);
}


#pragma mark --- 事件点击
- (void)backButtonCilck {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAdressButtonCilck {
    
}

@end
