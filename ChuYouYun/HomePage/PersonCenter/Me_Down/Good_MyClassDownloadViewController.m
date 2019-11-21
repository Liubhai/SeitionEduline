//
//  Good_MyClassDownloadViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyClassDownloadViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "base64.h"

#import "Good_MyClassDownloadTableViewCell.h"

@interface Good_MyClassDownloadViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    UILabel *lable;
    
    BOOL _isOn0;
    BOOL _isOn1;
    BOOL _isOn2;
    BOOL _isOn3;
    BOOL _isOn4;
    BOOL _isOn5;
    int _number;
    
    UIButton *button0;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    
    BOOL     isScene;//是否配置（人脸识别）
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
    
    UIImage   *faceImage;
}

@property (strong ,nonatomic)UITableView   *tableView;

@property (strong ,nonatomic)NSArray       *dataArray;
@property (strong ,nonatomic)NSArray       *sectionArray;

@end

@implementation Good_MyClassDownloadViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    [self addTableView];
    //    [self addWZView];
    //    [self addControllerSrcollView];
}
- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _sectionArray = @[@"正在下载",@"下载完成"];
    _isOn0 = NO;
    _isOn1 = NO;
    _isOn2 = NO;
    _isOn3 = NO;
    _isOn4 = NO;
    _isOn5 = NO;
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
    titleText.text = @"选择下载";
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

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50 * WideEachUnit;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark  --- 表格视图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit)];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableHeadView.tag = section;
    
    //添加标题
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 50 * WideEachUnit, 50 * WideEachUnit)];
    sectionTitle.text = _sectionArray[section];
    sectionTitle.textColor = [UIColor colorWithHexString:@"333"];
    sectionTitle.font = Font(14 * WideEachUnit);
    [tableHeadView addSubview:sectionTitle];
    
    //添加箭头
    UIButton *arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit, 0, 40 * WideEachUnit, 50 * WideEachUnit)];
    [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];//灰色乡下@2x
    [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];//灰色乡下@2x
    [tableHeadView addSubview:arrowsButton];
    
    //给整个View添加手势
    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
    
    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (_isOn0) {
    //        if (section == 0) {
    //            return 0;
    //        }
    //    }
    //    if (_isOn1) {
    //        if (section == 1) {
    //            return 0;
    //        }
    //    }
    //    if (_isOn2) {
    //        if (section == 2) {
    //            return 0;
    //        }
    //    }
    //    if (_isOn3) {
    //        if (section == 3) {
    //            return 0;
    //        }
    //    }
    //    if (_isOn4) {
    //        if (section == 4) {
    //            return 0;
    //        }
    //    }
    //    if (_isOn5) {
    //        if (section == 5) {
    //            return 0;
    //        }
    //    }
    //
    //    NSArray *sectionArray = _dataArray[section];
    //    return sectionArray.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    Good_MyClassDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Good_MyClassDownloadTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataSourceWithDict:dic];
    return cell;
}


#pragma mark --- 手势
- (void)tableHeadViewClick:(UITapGestureRecognizer *)not {
    NSInteger notTag = not.view.tag;
    if (notTag == 0) {
        _isOn0 = !_isOn0;
    } else if (notTag == 1) {
        _isOn1 = !_isOn1;
    } else if (notTag == 2) {
        _isOn2 = !_isOn2;
    } else if (notTag == 3) {
        _isOn3 = !_isOn3;
    } else if (notTag == 4) {
        _isOn4 = !_isOn4;
    } else if (notTag == 5) {
        _isOn5 = !_isOn5;
    }
    [_tableView reloadData];
}



#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
    
//        NSString *key = @"a16byteslongkey!a16byteslongkey!";
//        NSString *plaintext = @"iphone";
//        NSString *ciphertext = [Mcrypt_128 AES128Decrypt:NetKey];
//        NSLog(@"ciphertext: %@", ciphertext);
//        plaintext = [Mcrypt_128 AES128Encrypt:key];
//        NSLog(@"plaintext: %@", plaintext);
    
    
    
//    //获取key
//    NSString *key = NetKey;
//    //获取当前时间戳
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
//
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [dict setObject:@"1" forKey:@"allKey"];
//
//    NSString *dicStr = [self dictionaryToJson:dict];
//
//
//    NSString *allStr = [NSString stringWithFormat:@"%@|%@",timeSp,dict];
//
////    NSString *keyStr = [Mcrypt_128 AES128Encrypt:allStr];
//
//    NSData *encodeData = [keyStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
//
//    NSString *d5 = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
//    NSString *d6 = [d5 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//

    
    
    
    
    
//    //解密
//    NSString *JieMiStr = @"MMFG7dHPL9iaCuxQOpY8SvQE089R36hSyxE1WzQmH1E=";
//
//    NSString *d51 = [JieMiStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
//    NSString *d61 = [d51 stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
//
//    NSData *JieMiData = [d61 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *Jime = [JieMiData base64EncodedStringWithOptions:0];
    
    
//    NSString *JimeStr = [Mcrypt_128 AES128Decrypt:d61];
    
//    NSLog(@"解密----%@",JimeStr);
    
    
    
//    NSString *str =@"ABC123!@#中文";
//    NSString *key =@"F8hfdtgfu**0Ka0";
//    NSData*password = [[key dataUsingEncoding:NSUTF8StringEncoding] MD5Sum];
//    CCCryptorStatusstatus = kCCSuccess;
//    NSData*data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    //加密
//    NSData* result = [data dataEncryptedUsingAlgorithm:kCCAlgorithmAES128
//                                                   key:password
//                                               options:kCCOptionPKCS7Padding|kCCOptionECBMode
//                                                 error:&status];
//    //解密：
//    NSData*encrypted = [result decryptedDataUsingAlgorithm:kCCAlgorithmAES128
//                                                      key:password //字符串key够16位，可以直接传进去，不用转成NSdata也行
//                                                  options:kCCOptionPKCS7Padding|kCCOptionECBMode
//                                                    error:&status];
//   NSString *plainString = [[NSStringalloc]initWithData:encryptedencoding:NSUTF8StringEncoding];
//    NSLog(@"%@", plainString);  //输出：ABC123!@#中文
    
    
}

//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


#pragma mark --- 网络请求




@end
