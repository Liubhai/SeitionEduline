//
//  RefundViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "RefundViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "BigWindCar.h"
#import "TKProgressHUD+Add.h"
#import "ZhiyiHTTPRequest.h"
#import "BuyAgreementViewController.h"


@interface RefundViewController ()<UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITextView *textView;
@property (strong ,nonatomic)UILabel *hintLabel;
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIView      *chooseView;
@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *photoImageView;

@property (strong ,nonatomic)UIView *oneView;
@property (strong ,nonatomic)UIView *twoView;
@property (strong ,nonatomic)UIView *thereView;
@property (strong ,nonatomic)UIView *fourView;
@property (strong ,nonatomic)UIView *fiveView;

@property (strong ,nonatomic)UIButton *agreeButton;
@property (strong ,nonatomic)UILabel  *pease;
@property (strong ,nonatomic)NSString *peaseNumber;
@property (strong ,nonatomic)UIImage *image;

@property (strong ,nonatomic)NSMutableArray *tableTitleArray;
@property (strong ,nonatomic)NSMutableArray *imageArray;
@property (strong ,nonatomic)NSMutableArray *photoIDArray;
@property (strong ,nonatomic)NSDictionary   *orderDetailDict;
@property (strong ,nonatomic)NSString       *imageAllIDStr;
@property (strong ,nonatomic)NSString       *currutImageID;
@property (strong ,nonatomic)NSMutableArray *imageIDArray;
@property (strong ,nonatomic)NSString       *imageID;
@property (strong ,nonatomic)NSString       *titleStr;

//请求下来的数据
@property (strong ,nonatomic)NSString       *reasonStr;
@property (strong ,nonatomic)UILabel       *payType;
@property (strong ,nonatomic)UILabel       *oldPrice;
@property (strong ,nonatomic)NSString       *dayStr;


@end

@implementation RefundViewController

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
    [self addOneView];
    [self addTwoView];
    [self addThereView];
    [self addFourView];
    [self addFiveView];
//    [self addWZView];
//    [self addTableView];
//    [self NetWorkGetOrder];
    [self netWorkOrderRefundInfo];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableTitleArray = [NSMutableArray array];
    NSArray *titleArray = @[@"讲师不专业",@"课程不是想学习的",@"7天无理由退款",@"其他原因"];
    for (int i = 0 ; i < 4 ; i ++) {
        [_tableTitleArray addObject:titleArray[i]];
    }
    _imageArray = [NSMutableArray array];
    _imageIDArray = [NSMutableArray array];
    _photoIDArray = [NSMutableArray array];
    _peaseNumber = @"100";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"退款申请";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 25, 60, 30)];
    [sureButton setTitle:@"申请" forState:UIControlStateNormal];
    sureButton.titleLabel.font = Font(16);
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:sureButton];
    sureButton.hidden = YES;
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight);
        backButton.frame = CGRectMake(5, 35, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UITableView

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 64 + 170 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 4 * 36 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(10 * WideEachUnit, 88 + 170 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 4 * 36 * WideEachUnit);
    }
    _tableView.rowHeight = 36 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 4 * WideEachUnit;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView withHight:36];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"cellClassThere";
    //自定义cell类
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text = [_tableTitleArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#757575"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = Font(12 * WideEachUnit);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _titleStr = _tableTitleArray[indexPath.row];
    _pease.text = _titleStr;
    _peaseNumber = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self missView];
}


- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    _allView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(missView) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    [self addTableView];
}


#pragma mark ---界面
- (void)addOneView {
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 80 * WideEachUnit)];
    if (iPhoneX) {
        oneView.frame = CGRectMake(0, 88, MainScreenWidth, 80 * WideEachUnit);
    }
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    _oneView = oneView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, 60 * WideEachUnit , 50 * WideEachUnit)];
    NSString *urlStr = _orderDict[@"cover"];
    if ([_downLineClass isEqualToString:@"lineClass"]) {//线下课
        urlStr = [_orderDict stringValueForKey:@"cover"];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [oneView addSubview:imageView];

    UILabel *className = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 18 * WideEachUnit, 15 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(imageView.frame) - 18 * WideEachUnit - 10 * WideEachUnit, 30 * WideEachUnit)];
    className.numberOfLines = 2;
    className.text = [NSString stringWithFormat:@"课程：%@",_orderDict[@"video_name"]];
    if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 4) {//课程
        if ([[_orderDict stringValueForKey:@"course_hour_id"] integerValue] != 0) {//单课时
            className.text = [NSString stringWithFormat:@"课程：%@---%@",_orderDict[@"video_name"],_orderDict[@"course_hour_title"]];
        }
    } else if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 3) {//直播
        if ([[_orderDict stringValueForKey:@"course_hour_id"] integerValue] != 0) {//单课时
            className.text = [NSString stringWithFormat:@"课程：%@---%@",_orderDict[@"video_name"],_orderDict[@"course_hour_title"]];
        }
    }
    if ([_downLineClass isEqualToString:@"lineClass"]) {//线下课
        className.text = [_orderDict stringValueForKey:@"video_name"];
    }
    className.textColor = [UIColor colorWithHexString:@"#333"];
    className.font = Font(12 * WideEachUnit);
    className.backgroundColor = [UIColor clearColor];
    [oneView addSubview:className];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 18 * WideEachUnit, 45 * WideEachUnit,MainScreenWidth - CGRectGetMaxX(imageView.frame) - 18 * WideEachUnit - 10 * WideEachUnit , 20 * WideEachUnit)];
    price.text = [NSString stringWithFormat:@"育币:%@",_orderDict[@"price"]];
    if ([_orderDict[@"price"] integerValue] == 0) {
        
    }
    price.font = Font(12 * WideEachUnit);
    price.textColor = [UIColor colorWithHexString:@"#888"];
    [oneView addSubview:price];
    
    if ([[_orderDict objectForKey:@"order_type"] integerValue] == 6) {
        [imageView setWidth:0];
        imageView.hidden = YES;
        [className setLeft:10 *WideEachUnit];
        [price setLeft:10 *WideEachUnit];
    }
}

- (void)addTwoView {
    _twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_oneView.frame) + SpaceBaside *WideEachUnit, MainScreenWidth, 95 * WideEachUnit)];
    _twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_twoView];
    
    
    UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit , 22 * WideEachUnit)];
    reason.text = @"退款原因";
    reason.font = Font(14 * WideEachUnit);
    reason.textColor = [UIColor colorWithHexString:@"#656565"];
    [_twoView addSubview:reason];
    
    
    UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 44 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 36 * WideEachUnit)];
    chooseView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    chooseView.layer.cornerRadius = 4 * WideEachUnit;
    chooseView.layer.borderWidth = 1 * WideEachUnit;
    chooseView.layer.borderColor = [UIColor colorWithHexString:@"#eee"].CGColor;
    [_twoView addSubview:chooseView];
    _chooseView = chooseView;
    
    
    UILabel *pease = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0,MainScreenWidth / 2 , 36 * WideEachUnit)];
    pease.text = @"请选择";
    pease.font = Font(12 * WideEachUnit);
    pease.textColor = [UIColor colorWithHexString:@"#656565"];
    [chooseView addSubview:pease];
    _pease = pease;
    _chooseView = chooseView;
    
    UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(chooseView.frame.size.width - 36 * WideEachUnit, 0, 36 * WideEachUnit, 36 * WideEachUnit)];
//    downButton.backgroundColor = [UIColor ];
    [downButton setImage:Image(@"icon_dropdown@3x") forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(downButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [chooseView addSubview:downButton];
    
}

- (void)addThereView {
    
    _thereView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_twoView.frame) + SpaceBaside *WideEachUnit, MainScreenWidth, (44 + 140 + 48) * WideEachUnit)];
    _thereView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_thereView];
    
    
    UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit , 22 * WideEachUnit)];
    reason.text = @"退款说明";
    reason.font = Font(14 * WideEachUnit);
    reason.textColor = [UIColor colorWithHexString:@"#656565"];
    [_thereView addSubview:reason];
    
    UIView *TextView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 44 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 140 * WideEachUnit)];
    TextView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    [_thereView addSubview:TextView];
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit, 140 * WideEachUnit)];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor colorWithHexString:@"#eee"].CGColor;
    _textView.layer.cornerRadius = 4 * WideEachUnit;
    _textView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    [TextView addSubview:_textView];


    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 5, MainScreenWidth - 5 * SpaceBaside, 20)];
    hintLabel.text = @"请您在此描述问题";
    [_textView addSubview:hintLabel];
    hintLabel.font = Font(12 * WideEachUnit);
    hintLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    _hintLabel = hintLabel;
    
    _photoImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 70 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 70 * WideEachUnit)];
    _photoImageView.backgroundColor = [UIColor whiteColor];
    _photoImageView.layer.borderWidth = 1;
    _photoImageView.layer.borderColor = [UIColor colorWithHexString:@"#eee"].CGColor;
    _photoImageView.layer.cornerRadius = 4 * WideEachUnit;
    _photoImageView.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    _photoImageView.hidden = YES;
    [TextView addSubview:_photoImageView];
    
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 194 * WideEachUnit, 40 * WideEachUnit, 28 * WideEachUnit)];
    cameraButton.backgroundColor = [UIColor whiteColor];
    [cameraButton setImage:Image(@"icon_camera@3x") forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_thereView addSubview:cameraButton];

    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cameraButton.frame) + 10 * WideEachUnit, 194 * WideEachUnit, 40 * WideEachUnit, 28 * WideEachUnit)];
    photoButton.backgroundColor = [UIColor whiteColor];
    [photoButton setImage:Image(@"icon_picture@3x") forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_thereView addSubview:photoButton];
    
}

- (void)addFourView {
    _fourView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_thereView.frame) + SpaceBaside *WideEachUnit, MainScreenWidth, (44) * WideEachUnit)];
    _fourView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_fourView];
    
    
    UILabel *reason = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit,14 * 5.5 * WideEachUnit , 22 * WideEachUnit)];
    reason.text = @"退款渠道：";
    reason.font = Font(14 * WideEachUnit);
    reason.textColor = [UIColor colorWithHexString:@"#656565"];
    [_fourView addSubview:reason];
    
    UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reason.frame), 10 * WideEachUnit,MainScreenWidth / 3 * 2 - CGRectGetMaxX(reason.frame) , 22 * WideEachUnit)];
    payType.text = @"支付宝";
    payType.font = Font(14 * WideEachUnit);
    payType.textColor = BasidColor;
    payType.backgroundColor = [UIColor whiteColor];
    [_fourView addSubview:payType];
    _payType = payType;
    
    
    UILabel *oldPrice = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 3 * 2, 10 * WideEachUnit,MainScreenWidth / 3 - 10 * WideEachUnit , 22 * WideEachUnit)];
//    oldPrice.text = @"退款金额：12元";
    oldPrice.text = [NSString stringWithFormat:@"退款金额:%@",_orderDict[@"price"]];
    oldPrice.font = Font(14 * WideEachUnit);
    oldPrice.textColor = [UIColor colorWithHexString:@"#656565"];
    oldPrice.textAlignment = NSTextAlignmentRight;
    [_fourView addSubview:oldPrice];
    _oldPrice = oldPrice;
}

- (void)addFiveView {
    _fiveView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_fourView.frame), MainScreenWidth, MainScreenHeight - CGRectGetMaxY(_fourView.frame))];
    _fiveView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_fiveView];
    
    UIButton *argeeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth / 3 * 2, 28 * WideEachUnit)];
    argeeButton.backgroundColor = [UIColor clearColor];
    [argeeButton setTitle:@"同意《云课堂在线退款服务协议》" forState:UIControlStateNormal];
    [argeeButton setTitle:[NSString stringWithFormat:@"同意《%@在线退款服务协议》",AppName] forState:UIControlStateNormal];
    argeeButton.titleLabel.font = Font(12 * WideEachUnit);
    [argeeButton setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
    [argeeButton setImage:Image(@"disagree@3x") forState:UIControlStateNormal];
    [argeeButton setImage:Image(@"agree@3x") forState:UIControlStateSelected];
    [argeeButton addTarget:self action:@selector(argeeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_fiveView addSubview:argeeButton];
    _agreeButton = argeeButton;
    _agreeButton.selected = YES;
    
    UIButton *pactButton = [[UIButton alloc] initWithFrame:CGRectMake(50 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth / 3 * 2, 28 * WideEachUnit)];
    pactButton.backgroundColor = [UIColor clearColor];
    [pactButton addTarget:self action:@selector(pactButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_fiveView addSubview:pactButton];
    
    UIButton *giveUpButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100 * WideEachUnit, 52 * WideEachUnit, 200 * WideEachUnit, 36 * WideEachUnit)];
    giveUpButton.backgroundColor = [UIColor clearColor];
    [giveUpButton setTitle:@"提交" forState:UIControlStateNormal];
    giveUpButton.titleLabel.font = Font(18 * WideEachUnit);
    giveUpButton.layer.cornerRadius = 4 * WideEachUnit;
    giveUpButton.backgroundColor = BasidColor;
    [giveUpButton addTarget:self action:@selector(commitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_fiveView addSubview:giveUpButton];
    
    if ([_orderDict[@"price"] floatValue] == 0) {
        giveUpButton.enabled = NO;
        giveUpButton.backgroundColor = [UIColor lightGrayColor];
    }
    
}

#pragma mark --- 视图管理

- (void)missView {
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_tableView removeFromSuperview];
}

#pragma mark --- 时间监听

- (void)sureButtonCilck:(UIButton *)button {
    if (!_agreeButton.selected) {
        [TKProgressHUD showError:@"请先同意服务协议" toView:self.view];
        return;
    }
    if (_textView.text.length == 0) {
        [TKProgressHUD showError:@"请填写申请原因" toView:self.view];
        return;
    }
}

- (void)downButtonCilck:(UIButton *)button {
//    [self addTableView];
    [self addMoreView];
}

- (void)cameraButtonCilck:(UIButton *)button {
    //创建图片选取控制器
    UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePickerVC setAllowsEditing:YES];
    imagePickerVC.delegate=self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)photoButtonCilck:(UIButton *)button {
    UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerVC setAllowsEditing:YES];
    imagePickerVC.delegate=self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

//回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [_imageArray addObject:_image];
    
    _photoImageView.hidden = NO;
    _textView.frame = CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit, 70 * WideEachUnit);

    [self dismissViewControllerAnimated:YES completion:nil];
    [self addImage];
    [self netWorkUserUpLoad];
}

- (void)argeeButtonCilck:(UIButton *)button {
    _agreeButton.selected = !_agreeButton.selected;
}

- (void)pactButtonClick {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addImage {
    
    NSLog(@"----%@",_imageArray);
    if (_imageArray.count == 0) {
        _textView.frame = CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit, 140 * WideEachUnit);
        _photoImageView.hidden = YES;
    }
    for (int i = 0 ; i < _imageArray.count ; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit + (50 * WideEachUnit + 10 * WideEachUnit) * i , 10 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
        imageView.image = _imageArray[i];
        [_photoImageView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(45 * WideEachUnit, -5 * WideEachUnit, 10 * WideEachUnit, 10 * WideEachUnit)];
        [button setBackgroundImage:Image(@"icon_close@3x") forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(imageButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
    }
}

- (void)commitButtonCilck:(UIButton *)button {
    if (!_agreeButton.selected) {
        [TKProgressHUD showError:@"请先同意服务协议" toView:self.view];
        return;
    }
    [self netWorkOrderRefund];
}

- (void)imageButtonCilck:(UIButton *)button {
    [_imageArray removeObjectAtIndex:button.tag];
    [self addImage];
}

#pragma mark --- 通知

- (void)textChange:(NSNotification *)Not {
    
    if (_textView.text.length > 0 ) {
        _hintLabel.hidden = YES;
    } else {
        _hintLabel.hidden = NO;
    }
    
}

#pragma mark --- 键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark ----网络请求


- (void)getImageIDStr {
    if (_photoIDArray.count) {
        for (int i = 0 ; i < _photoIDArray.count ; i++) {
            if (i == 0) {
                _imageAllIDStr = _photoIDArray[0];
            } else {
                _imageAllIDStr = [NSString stringWithFormat:@"%@,%@",_imageAllIDStr,_photoIDArray[i]];
            }
        }
    }
}


#pragma mark --- 网络请求


- (void)netWorkOrderRefundInfo {
    
    NSString *endUrlStr = YunKeTang_Order_order_refundInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_orderDict[@"id"] forKey:@"order_id"];
    if ([_orderDict[@"order_type"] integerValue] == 3) {
        [mutabDict setValue:@"3" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 4) {
        [mutabDict setValue:@"4" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 5) {
        [mutabDict setValue:@"5" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 6) {
        [mutabDict setValue:@"6" forKey:@"order_type"];
    }  else if ([_orderDict[@"order_type"] integerValue] == 2) {
        [mutabDict setValue:@"2" forKey:@"order_type"];
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _orderDetailDict = dict;
            _dayStr = [NSString stringWithFormat:@"%@天无理由退款",dict[@"refundConfig"]];
            NSLog(@"%@",_tableTitleArray);
            [_tableTitleArray removeObjectAtIndex:2];
            [_tableTitleArray insertObject:_dayStr atIndex:2];
            NSLog(@"%@",_tableTitleArray);
            
            _payType.text = dict[@"pay_type"];
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//申请退款
- (void)netWorkOrderRefund {
    
    NSString *endUrlStr = YunKeTang_Order_order_refund;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    [mutabDict setValue:_orderDict[@"id"] forKey:@"order_id"];
    if ([_orderDict[@"order_type"] integerValue] == 3) {//直播
        [mutabDict setValue:@"3" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 4) {//课程
        [mutabDict setValue:@"4" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 5) {//线下课
        [mutabDict setValue:@"5" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 6) {
        [mutabDict setValue:@"6" forKey:@"order_type"];
    } else if ([_orderDict[@"order_type"] integerValue] == 2) {
        [mutabDict setValue:@"2" forKey:@"order_type"];
    }
    
    if ([_peaseNumber integerValue] == 100) {
        [TKProgressHUD showError:@"请填写退款理由" toView:self.view];
        return;
    } else {
        if ([_peaseNumber integerValue] == 0) {
            _peaseNumber = @"1";
        }
        [mutabDict setValue:[NSString stringWithFormat:@"%@",_peaseNumber] forKey:@"refund_reason"];
    }
    
    if (_textView.text.length == 0) {
        [TKProgressHUD showError:@"请填写退款说明" toView:self.view];
        return;
    } else {
        [mutabDict setValue:_textView.text forKey:@"refund_note"];
    }
    if (_imageIDArray.count) {
        NSString *imageIDs = nil;
        for (int i = 0 ; i < _imageIDArray.count ; i++) {
            if (i == 0) {
                imageIDs = _imageIDArray[0];
            } else {
                imageIDs = [NSString stringWithFormat:@"%@,%@",imageIDs,
                            _imageIDArray[i]];
            }
        }
        [mutabDict setObject:imageIDs forKey:@"voucher"];//机构附件id
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//上传图片
- (void)netWorkUserUpLoad {
    
    NSString *endUrlStr = YunKeTang_Attach_attach_upload;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSString *encryptStr1 = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [requestSerializer setValue:encryptStr1 forHTTPHeaderField:HeaderKey];
    [requestSerializer setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    manger.requestSerializer = requestSerializer;
    [manger POST:allUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *dataImg=UIImageJPEGRepresentation(_image, 1.0);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            _imageID = [dict stringValueForKey:@"attach_id"];
            [_imageIDArray addObject:_imageID];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}




@end
