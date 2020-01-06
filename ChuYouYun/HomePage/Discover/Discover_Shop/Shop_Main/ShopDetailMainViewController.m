//
//  ShopDetailMainViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "ShopDetailMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "ShopDetailInfoViewController.h"
#import "ShopDetailCommentViewController.h"
#import "DLViewController.h"
#import "ManageAddressViewController.h"
#import "ShopOrderDetailVC.h"




@interface ShopDetailMainViewController ()<UIScrollViewDelegate> {
    BOOL      isHaveDefault;
    NSString  *_adress_id;
}

@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UIView       *WZView;
@property (strong ,nonatomic)UIView       *informationView;
@property (strong ,nonatomic)UIView       *allWindowView;
@property (strong ,nonatomic)UIWebView    *webView;

@property (strong ,nonatomic)UIButton   *balanceSeleButton;
@property (strong ,nonatomic)UILabel    *pricePay;

@property (strong ,nonatomic)UIButton     *detailButton;
@property (strong ,nonatomic)UIButton     *evaluationButton;

@property (assign ,nonatomic)NSInteger   numValue;
@property (assign ,nonatomic)CGFloat     buttonW;
@property (strong ,nonatomic)UIButton    *HDButton;
@property (strong ,nonatomic)UIButton    *seletedButton;
@property (strong ,nonatomic)UILabel     *numberLabel;
@property (strong ,nonatomic)UILabel     *adressLabel;

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;

//营销数据
@property (strong ,nonatomic)NSString        *order_switch;
@property (strong ,nonatomic)NSArray         *subVcArray;
@property (assign ,nonatomic)CGFloat         infoHight;
@property (assign ,nonatomic)CGFloat         commentHight;

@property (strong ,nonatomic)NSArray        *addressArray;
@property (strong ,nonatomic)NSDictionary   *addressDict;

@property (strong ,nonatomic)NSString       *sokteStr;//库存字段
@property (strong ,nonatomic)NSDictionary   *userAccountDict;
@property (strong ,nonatomic)NSDictionary   *wxPayDict;

@end

@implementation ShopDetailMainViewController


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
    [self addImageView];
    [self addInformationView];
    [self addWZView];
    [self addControllerSrcollView];
    [self netWorkUserGetAccount];
    [self netWorkAdressGetMyList];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = [_dict stringValueForKey:@"title"];
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, 210 * WideEachUnit)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_dict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageView];
}

- (void)addInformationView {
    _informationView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), MainScreenWidth, 150 * WideEachUnit)];
    _informationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_informationView];
    _informationView.userInteractionEnabled = YES;
    
    
    //名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    name.text = [_dict stringValueForKey:@"title"];
    name.font = Font(16);
    name.numberOfLines = 0;
    [name sizeToFit];
    name.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, name.size.height > 20 * WideEachUnit ? name.size.height : 20 * WideEachUnit);
    [_informationView addSubview:name];
    
    //价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    price.text = [NSString stringWithFormat:@"积分：%@",[_dict stringValueForKey:@"price"]];
    price.font = Font(11);
    price.textColor = RGBHex(0xF80232);
    CGFloat priceWidth = [price.text sizeWithFont:Font(11)].width + 4;
    price.frame = CGRectMake(10 * WideEachUnit, name.bottom + 10, priceWidth, 20 * WideEachUnit);
    price.textAlignment = NSTextAlignmentLeft;
    [_informationView addSubview:price];
    
    //快递费
    UILabel *courierFees = [[UILabel alloc] initWithFrame:CGRectMake(price.right + 7, 40 * WideEachUnit, 110 * WideEachUnit, 20 * WideEachUnit)];
    courierFees.text = [NSString stringWithFormat:@"(快递费用:%@积分)", [_dict stringValueForKey:@"fare"]];
    courierFees.font = Font(10);
    courierFees.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    CGFloat courierFreesWidth = [courierFees.text sizeWithFont:Font(10)].width + 4;
    courierFees.frame = CGRectMake(price.right + 7, 40 * WideEachUnit, courierFreesWidth, 20 * WideEachUnit);
    courierFees.centerY = price.centerY;
    courierFees.textAlignment = NSTextAlignmentLeft;
    [_informationView addSubview:courierFees];
    
    //兑换次数
    UILabel *exchangeNum = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    exchangeNum.text = [NSString stringWithFormat:@"兑换次数:%@", [_dict stringValueForKey:@"num"]];
    exchangeNum.font = Font(10);
    exchangeNum.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    CGFloat exchangeNumWidth = [exchangeNum.text sizeWithFont:Font(10)].width;
    exchangeNum.textAlignment = NSTextAlignmentRight;
    exchangeNum.frame = CGRectMake(MainScreenWidth - 16 - exchangeNumWidth, 40 * WideEachUnit, exchangeNumWidth, 20 * WideEachUnit);
    exchangeNum.centerY = price.centerY;
    [_informationView addSubview:exchangeNum];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, price.bottom + 10, MainScreenWidth, 5)];
    firstLineView.backgroundColor = RGBHex(0xF6F6F6);
    [_informationView addSubview:firstLineView];
    
    //兑换数量
    UILabel *exchangeNumBer = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 70 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    exchangeNumBer.text = @"兑换数量";
    exchangeNumBer.font = Font(12);
    exchangeNumBer.textColor = [UIColor colorWithHexString:@"#575757"];
    CGFloat exchangeNumBerWidth = [exchangeNumBer.text sizeWithFont:Font(12)].width + 4;
    exchangeNumBer.frame = CGRectMake(10 * WideEachUnit, firstLineView.bottom, exchangeNumBerWidth, 20 * WideEachUnit);
    exchangeNumBer.centerY = firstLineView.bottom + 63 / 2.0;
    [_informationView addSubview:exchangeNumBer];
    
    
    //加，减
    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(exchangeNumBer.right + 10, 70 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    cutBtn.backgroundColor = RGBHex(0xF6F6F6);
    [_informationView addSubview:cutBtn];
    [cutBtn setTitle:@"-" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[UIColor colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
    [cutBtn.titleLabel setFont:[UIFont systemFontOfSize:15 * verticalrate]];
    cutBtn.tag = 1;
    [cutBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    cutBtn.centerY = exchangeNumBer.centerY;
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(cutBtn.current_x_w + 4,cutBtn.current_y,50 * WideEachUnit, 20 * WideEachUnit)];
    [_informationView addSubview:_numberLabel];
    _numberLabel.centerY = exchangeNumBer.centerY;
    _numValue = 1;
    _numberLabel.text = [NSString stringWithFormat:@"%ld",_numValue];
    _numberLabel.textColor = [UIColor colorWithHexString:@"#7B7B7B"];
    _numberLabel.font = [UIFont systemFontOfSize:13*verticalrate];
    _numberLabel.backgroundColor = RGBHex(0xF6F6F6);
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(_numberLabel.current_x_w + 4, 70 * WideEachUnit, 20 * WideEachUnit, 20 * WideEachUnit)];
    addBtn.backgroundColor = RGBHex(0xF6F6F6);
    [_informationView addSubview:addBtn];
    addBtn.centerY = exchangeNumBer.centerY;
    addBtn.tag = 2;
    [addBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
    addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2 * WideEachUnit, 0);
    
    //库存
    UILabel *inventoryNum = [[UILabel alloc] initWithFrame:CGRectMake(120 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    inventoryNum.text = [NSString stringWithFormat:@"(剩余库存:%@)", [_dict stringValueForKey:@"stock"]];
    inventoryNum.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
    inventoryNum.font = Font(10);
    CGFloat inventoryNumWidth = [inventoryNum.text sizeWithFont:Font(10)].width + 4;
    inventoryNum.frame = CGRectMake(addBtn.right + 7, 40 * WideEachUnit, inventoryNumWidth, 20 * WideEachUnit);
    [_informationView addSubview:inventoryNum];
    inventoryNum.centerY = exchangeNumBer.centerY;
    
    
    //添加兑换的按钮
    UIButton *exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 64 * WideEachUnit - 16 * WideEachUnit, 65 * WideEachUnit, 64 * WideEachUnit, 23 * WideEachUnit)];
    [exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(exchangeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    exchangeButton.titleLabel.font = Font(10);
    exchangeButton.backgroundColor = RGBHex(0xD3423F);
    exchangeButton.centerY = exchangeNumBer.centerY;
    [_informationView addSubview:exchangeButton];
    
    //添加隔带
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, firstLineView.bottom + 63, MainScreenWidth, 5 * WideEachUnit)];
    lineButton.backgroundColor = RGBHex(0xF6F6F6);
    [_informationView addSubview:lineButton];
    
    _informationView.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), MainScreenWidth, lineButton.bottom);
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_informationView.frame), MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    _WZView = WZView;
    //添加按钮
    NSArray *titleArray = @[@"详情",@"商品评价"];
    CGFloat ButtonH = 20;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 7, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
        
        if (i == 0) {
            _detailButton = button;
        } else if (i == 1) {
            _evaluationButton = button;
        }
        
        
        //添加分割线
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW + ButtonW * i, 10, 1, ButtonH - 6)];
        lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [WZView addSubview:lineButton];
        
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 27 + 3, ButtonW, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    _HDButton.hidden = YES;
}


- (void)WZButton:(UIButton *)button {
    
    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        _HDButton.frame = CGRectMake(button.tag * _buttonW, 27 + 3, _buttonW, 1);
        //        _pay_status = [NSString stringWithFormat:@"%ld",button.tag];
    }];
    //    [self NetWorkGetOrder];
    
    _controllerSrcollView.contentOffset = CGPointMake(button.tag * MainScreenWidth, 0);
    
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_WZView.frame),  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 2,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor redColor];
    
    ShopDetailInfoViewController * infoVc= [[ShopDetailInfoViewController alloc] initWithDict:_dict];
    infoVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [_controllerSrcollView addSubview:infoVc.view];
    [self addChildViewController:infoVc];

    ShopDetailCommentViewController * commentVc = [[ShopDetailCommentViewController alloc] initWithDict:_dict];
    commentVc.view.frame = CGRectMake(MainScreenWidth, -98, MainScreenWidth, MainScreenHeight * 2 + 500);
    [_controllerSrcollView addSubview:commentVc.view];
    [self addChildViewController:commentVc];
    
    _subVcArray = @[infoVc,commentVc];
}

- (void)addBolckInfo {
    ShopDetailInfoViewController *vc = _subVcArray[0];
    vc.vcHight = ^(CGFloat hight) {
        _infoHight = hight;
    };
}

- (void)addBolckComment {
    ShopDetailCommentViewController *vc = _subVcArray[1];
    vc.vcHight = ^(CGFloat hight) {
        _commentHight = hight;
    };
}

#pragma mark --- 事件监听
-(void)changeNum:(UIButton *)sender{
    
    if (sender.tag==1) {
        if (_numValue==1) {
            return;
        }
        _numValue--;
        _numberLabel.text = [NSString stringWithFormat:@"%ld",_numValue];
        
    }else{
        _numValue++;
        if (_numValue == [[_dict stringValueForKey:@"stock"] integerValue]) {
            _numberLabel.text = [NSString stringWithFormat:@"%@",[_dict stringValueForKey:@"stock"]];
        } else if (_numValue > [[_dict stringValueForKey:@"stock"] integerValue]) {
            _numValue --;
            _numberLabel.text = [NSString stringWithFormat:@"%@",[_dict stringValueForKey:@"stock"]];
        } else {
            _numberLabel.text = [NSString stringWithFormat:@"%ld",_numValue];
        }
    }
}
- (void)exchangeButtonCilck:(UIButton *)button {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([_scoreStaus integerValue] == 0) {
        [TKProgressHUD showError:@"积分不足,无法支付" toView:self.view];
        return;
    }
    ShopOrderDetailVC *vc = [[ShopOrderDetailVC alloc] init];
    vc.originDict = _dict;
    vc.scoreStaus = _scoreStaus;
    vc.percentage = _percentage;
    vc.isHaveDefault = isHaveDefault;
    vc.addressDict = _addressDict;
    vc.numValue = _numValue;
    vc.userAccountDict = [NSDictionary dictionaryWithDictionary:_userAccountDict];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)ger {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //要吧之前的按钮设置为未选中 不然颜色不会变
    self.seletedButton.selected = NO;
    
    NSLog(@"%lf",scrollView.contentOffset.x);
    
    if (_controllerSrcollView == scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x == 0) {
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(0, 27 + 3, _buttonW, 1);
            }];
            
            [_detailButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_evaluationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            [UIView animateWithDuration:0.25 animations:^{
                _HDButton.frame = CGRectMake(_buttonW, 27 + 3, _buttonW, 1);
            }];
            
            [_evaluationButton setTitleColor:BasidColor forState:UIControlStateNormal];
            [_detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
    }
}

#pragma mark ---   网络请求
//获取营销数据
- (void)netWorkConfigGetMarketStatus {
    
    NSString *endUrlStr = YunKeTang_config_getMarketStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _order_switch = [dict stringValueForKey:@"order_switch"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取用户的流水数据
- (void)netWorkUserGetAccount {
    
    NSString *endUrlStr = YunKeTang_User_user_getAccount;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"new" forKey:@"time"];
    
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
                _userAccountDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _userAccountDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

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
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                _addressArray = [dict arrayValueForKey:@"data"];
            } else {
                _addressArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            
            
            for (int i = 0; i < _addressArray.count ; i ++) {
                NSDictionary *indexDict = [_addressArray objectAtIndex:i];
                if ([[indexDict stringValueForKey:@"is_default"] integerValue] == 1) {
                    isHaveDefault = YES;
                    _addressDict = indexDict;
                    _adressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[_addressDict stringValueForKey:@"province"],[_addressDict stringValueForKey:@"city"],[_addressDict stringValueForKey:@"area"]];
                    _adress_id = [_addressDict stringValueForKey:@"address_id"];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
