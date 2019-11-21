//
//  ManageAddressViewController.m
//  dafengche
//
//  Created by IOS on 16/10/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "ManageAdressTableViewCell.h"
#import "AddAddressViewController.h"
#import "MyHttpRequest.h"
#import "TKProgressHUD+Add.h"

#import "EditAdressViewController.h"



@interface ManageAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{

    NSString *_address_id;
    NSInteger _tempNumber;
    UIImageView * BJimgView ;
    UIImageView * SCimgView;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;
@property (strong ,nonatomic)NSArray *lookArray;
//存放数据
@property (nonatomic , retain)NSArray *dataArray;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;
//存放图片
@property (nonatomic , retain)NSMutableArray *ImgArray;


@end

@implementation ManageAddressViewController


-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - MACRO_UI_SAFEAREA - 40)];
        _imageView.image = Image(@"云课堂_空数据");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

-(void)detail{
    _firstLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 121, 20)];
    _firstLab.font = [UIFont systemFontOfSize:13];
    _firstLab.textColor = [UIColor blackColor];
    _firstLab.text = @"周星星";
    
    _secondLab = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.current_x +10, _firstLab.current_y_h + 5,MainScreenWidth -40, 20)];
    _secondLab.font = [UIFont systemFontOfSize:13];
    _secondLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _secondLab.text = @"四川省成都市双流县航空港机场路88号";
    
    _thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(_firstLab.current_x_w,_firstLab.current_y, MainScreenWidth - _firstLab.current_x_w - 10, 20)];
    _thirdLab.font = [UIFont systemFontOfSize:12];
    _thirdLab.textColor = [UIColor blackColor];
    _thirdLab.textAlignment = NSTextAlignmentRight;
    _thirdLab.text = @"15538983107";
    
    _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0,_secondLab.current_y_h + 10 , MainScreenWidth, 1)];
    _lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImage * buttonImage = [UIImage imageNamed:@"首页更多"];

    CGFloat buttonImageViewWidth = CGImageGetWidth(buttonImage.CGImage);
    
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, _lineLab.current_y_h+9, 16, 16)];
    _imgView.image = [UIImage imageNamed:@"gl未选中"];

    _firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, _lineLab.current_y_h+5, 75,25)];
    [_firstBtn addTarget:self action:@selector(setDefaultKey:) forControlEvents:UIControlEventTouchUpInside];
    
    _defaultlab = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.current_x_w, _lineLab.current_y_h+5, 105,25)];
    _defaultlab.text = [NSString stringWithFormat:@"  %@",@"默认地址"];
    _defaultlab.textColor = [UIColor colorWithHexString:@"#999999"];
    _defaultlab.font = Font(13);
//    [_firstBtn setTitle:[NSString stringWithFormat:@"  %@",@"默认地址"] forState:UIControlStateNormal];
//    [_firstBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    _firstBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [_firstBtn setImage:[UIImage imageNamed:@"check_cb_no"] forState:UIControlStateNormal];

   BJimgView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth -150, _lineLab.current_y_h+9, 16,16)];
    BJimgView.image = [UIImage imageNamed:@"gl编辑"];
    _secondBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth -157, _lineLab.current_y_h+5, 75,25)];
    [_secondBtn setTitle:[NSString stringWithFormat:@"  %@",@"编辑"] forState:UIControlStateNormal];
    [_secondBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _secondBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_secondBtn addTarget:self action:@selector(setDefaultKey1:) forControlEvents:UIControlEventTouchUpInside];

    
   // [_secondBtn setImage:[UIImage imageNamed:@"gl编辑"] forState:UIControlStateNormal];
    //_secondBtn.backgroundColor = [UIColor cyanColor];;

    _thirdBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth -77, _lineLab.current_y_h+5, 75,25)];
    SCimgView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth -70, _lineLab.current_y_h+9, 16,16)];
    SCimgView.image = [UIImage imageNamed:@"gl删除"];
    [_thirdBtn setTitle:[NSString stringWithFormat:@"  %@",@"删除"] forState:UIControlStateNormal];
    [_thirdBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_thirdBtn addTarget:self action:@selector(setDefaultKey2:) forControlEvents:UIControlEventTouchUpInside];
  //  [_thirdBtn setImage:[UIImage imageNamed:@"gl删除"] forState:UIControlStateNormal];

}

//-------------------按钮触发事件-------------------

-(void)setDefaultKey:(UIButton *)sender{
    
    NSInteger temperNum = sender.tag - 100;
    _address_id = [NSString stringWithFormat:@"%@",_dataArray[temperNum][@"address_id"]];
    NSLog(@"%@",_address_id);

    for (int i = 0; i< _ImgArray.count; i++) {
        
        
        if (i == temperNum) {
            
            UIImageView *imagV = (UIImageView *)_ImgArray[i];
            if ([imagV.image isEqual:[UIImage imageNamed:@"gl选中"]]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已设置为默认收货地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                return;
                
            }else{
                
                imagV.image = [UIImage imageNamed:@"gl选中"];
                [self netWorkAdressSetDefault];
                
            }
            
        }else{
            
            UIImageView *imagV = (UIImageView *)_ImgArray[i];
            imagV.image = [UIImage imageNamed:@"check_cb_no"];
            //imagV.image = [UIImage imageNamed:@"check_cb_on"];
            imagV.image = [UIImage imageNamed:@"gl未选中"];
        }
    }
    
    
}

-(void)setDefaultKey1:(UIButton *)sender{
    
    NSInteger temperNum = sender.tag - 200;
    
    NSString *area = [NSString stringWithFormat:@"%@  %@  %@",_dataArray[temperNum][@"province"],_dataArray[temperNum][@"city"],_dataArray[temperNum][@"area"]];
    NSString *name = [NSString stringWithFormat:@"%@",_dataArray[temperNum][@"name"]];
    NSString *adress = [NSString stringWithFormat:@"%@",_dataArray[temperNum][@"address"]];
    NSString *phone = [NSString stringWithFormat:@"%@",_dataArray[temperNum][@"phone"]];
    NSString *is_default = [NSString stringWithFormat:@"%@",_dataArray[temperNum][@"is_default"]];
    _address_id = [NSString stringWithFormat:@"%@",_dataArray[temperNum][@"address_id"]];
   // NSLog(@"%@==%@==%@",_dataArray[temperNum][@"area"],_dataArray[temperNum][@"city"],_dataArray[temperNum][@"province"]);
  /*
    address = I;
    "address_id" = 25;
    area = "\U6da6\U5dde\U533a";
    city = "\U9547\U6c5f";
    ctime = 1479293327;
    "is_default" = 0;
    "is_del" = 0;
    location = "<null>";
    name = The;
    phone = 15538983107;
    province = "\U6c5f\U82cf";
    uid = 3;
*/
    NSLog(@"%@",area);
    EditAdressViewController *editV = [[EditAdressViewController alloc]initWithName:name adress:adress phone:phone area:area is_default:is_default address_id:_address_id];
    editV.dict = [_dataArray objectAtIndex:temperNum];
    [self.navigationController pushViewController:editV animated:YES];
}
-(void)setDefaultKey2:(UIButton *)sender{
    
    _tempNumber = sender.tag - 300 ;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除该地址码?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = _tempNumber;
    [alert show];
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==_tempNumber) {
        if (buttonIndex==0) {
            return;
        }else{
            [self netWorkAdressSetDelete];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    [self netWorkAdressGetMyList];
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


#pragma mark ---- 网络请求

//获取收货地址
- (void)netWorkAdressGetMyList {
    NSString *endUrlStr = YunKeTang_Address_address_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"50" forKey:@"count"];
    
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
            _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//设置为默认地址
- (void)netWorkAdressSetDefault {
    NSString *endUrlStr = YunKeTang_Address_address_setDefault;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_address_id forKey:@"address_id"];
    
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [self netWorkAdressGetMyList];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//删除收货地址
- (void)netWorkAdressSetDelete {
    NSString *endUrlStr = YunKeTang_Address_address_delete;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[[_dataArray objectAtIndex:_tempNumber] stringValueForKey:@"address_id"] forKey:@"address_id"];
    
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [self netWorkAdressGetMyList];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    _ImgArray = [[NSMutableArray alloc]init];
    [self interFace];
    [self addNav];
    [self addTableView];
}
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 40 - MACRO_UI_SAFEAREA) style:UITableViewStyleGrouped];
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
    
    //新增收货地址
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 40 - MACRO_UI_SAFEAREA, MainScreenWidth, 40)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [btn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    UIView *safeView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - MACRO_UI_SAFEAREA, MainScreenWidth, MACRO_UI_SAFEAREA)];
    safeView.backgroundColor = BasidColor;
    [self.view addSubview:safeView];
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
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [self detail]; 
        
        [_ImgArray addObject:_imgView];
        
        if ([_dataArray[indexPath.section][@"is_default"] isEqualToString:@"1"]) {
            _imgView.image = [UIImage imageNamed:@"gl选中"];
        }

        [cell.contentView addSubview:self.imgView];
        [cell.contentView addSubview:SCimgView];
        [cell.contentView addSubview:BJimgView];
        [cell.contentView addSubview:self.defaultlab];
        [cell.contentView addSubview:self.firstLab];
        [cell.contentView addSubview:self.secondLab];
        [cell.contentView addSubview:self.thirdLab];
        [cell.contentView addSubview:self.lineLab];
        [cell.contentView addSubview:self.firstBtn];
        [cell.contentView addSubview:self.secondBtn];
        [cell.contentView addSubview:self.thirdBtn];
        self.firstBtn.tag = 100 +indexPath.section;
        self.secondBtn.tag = 200 +indexPath.section;
        self.thirdBtn.tag = 300 +indexPath.section;
        
        self.firstLab.text = _dataArray[indexPath.section][@"name"];
        self.secondLab.text = [NSString stringWithFormat:@"%@%@  %@",_dataArray[indexPath.section][@"province"],_dataArray[indexPath.section][@"city"],_dataArray[indexPath.section][@"address"]] ;
        self.thirdLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"phone"]];
    //}
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *cellDict = [_dataArray objectAtIndex:indexPath.section];
    self.seleAdressCell(cellDict);
    [self backPressed];
}



- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"管理收货地址";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,156)];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
