
//  Good_ClassCatalogViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassCatalogViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "ZFDownloadManager.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "DLViewController.h"

//人脸识别
#import "DetectionViewController.h"
#import "NetAccessModel.h"

#import "Good_PersonFaceRegisterViewController.h"
#import "Good_ClassCatalogTableViewCell.h"
#import "TestCurrentViewController.h"
#import "ClassAndLivePayViewController.h"

@interface Good_ClassCatalogViewController ()<UITableViewDataSource,UITableViewDelegate,Good_ClassCatalogTableViewCellDelegate>
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
    int  recodeNum;
    
    UIButton *button0;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    
    NSInteger Num;
    BOOL      isScene;//是否配置（人脸识别）
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
    
    UIImage   *faceImage;
}

@property (strong ,nonatomic)UIImageView     *imageView;

@property (strong ,nonatomic)NSDictionary    *dataSource;
@property (strong ,nonatomic)NSArray         *dataArray;
@property (strong ,nonatomic)NSMutableArray  *newsDataArray;
@property (strong ,nonatomic)NSMutableArray  *sectionArray;
@property (strong ,nonatomic)NSMutableArray  *boolArray;
@property (strong ,nonatomic)NSMutableArray  *selectedArray;



@property (strong ,nonatomic)NSString        *ID;
@property (strong ,nonatomic)NSString        *sectionID;
@property (strong ,nonatomic)NSArray         *getFaceSceneArray;
@property (strong ,nonatomic)NSString        *faceID;
@property (strong ,nonatomic)NSDictionary    *existDict;
@property (strong ,nonatomic)NSDictionary    *cellDict;
@property (strong ,nonatomic)NSDictionary    *testDataSource;

@property (strong ,nonatomic)NSString        *free_course_opt;
@property (strong ,nonatomic)NSTimer         *timer;


@end

@implementation Good_ClassCatalogViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, 200)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据 （小）"];
        if (iPhone6) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 50, 200, 200);
        } else if (iPhone6Plus) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 30, 200, 200);
        } else if (iPhone5o5Co5S) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 0, 200, 200);
        }
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWorkVideoGetCatalog];
    [self netWorkVideoGetInfoAgain];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _free_course_opt = @"1";
    _canPlayRecordVideo = YES;
    [self interFace];
    [self addTableView];
    [self netWorkVideoGetCatalog];
    [self netWorkVideoGetInfo];
    [self netWorkConfigFreeCourseLoginSwitch];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _sectionArray = [NSMutableArray array];
    _newsDataArray = [NSMutableArray array];
    _boolArray = [NSMutableArray array];
    _selectedArray = [NSMutableArray array];
    _isOn0 = NO;
    _isOn1 = NO;
    _isOn2 = NO;
    _isOn3 = NO;
    _isOn4 = NO;
    _isOn5 = NO;
    indexPathSection = 0;
    indexPathRow = 0;
    recodeNum = 0;
    
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AilYunPlayerEnd:) name:@"AilYunPlayerPlayEnd" object:nil];
    // 停止播放并停止记录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AilYunPlayerStop) name:@"AilYunPlayerStop" object:nil];
    // 记录的时间传递给 recodeNum
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recodeNumChanged:) name:@"recodeNumChange" object:nil];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    tableHeadView.backgroundColor = [UIColor whiteColor];
    tableHeadView.tag = section;
    
    if (_isClassCourse) {
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(3, 17 * WideEachUnit, 3, 16 * WideEachUnit)];
        blueView.backgroundColor = BasidColor;
        blueView.layer.masksToBounds = YES;
        blueView.layer.cornerRadius = 2;
        [tableHeadView addSubview:blueView];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit - 55 * WideEachUnit, 10 * WideEachUnit, 50 * WideEachUnit, 30 * HigtEachUnit)];
        price.font = SYSTEMFONT(14);
        [tableHeadView addSubview:price];
        NSString *buyString = [_videoInfoDict stringValueForKey:@"is_buy"];
        if ([buyString integerValue] == 1) {//已经解锁整个课程
            if ([[_dataArray[section] stringValueForKey:@"is_free"] integerValue] == 1) {
                price.hidden = NO;
                price.layer.borderColor = BasidColor.CGColor;
                price.textColor = BasidColor;
            } else {
                price.hidden = NO;
                price.text = @"已购";
                price.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
                price.textColor = [UIColor colorWithHexString:@"#888"];
            }
        } else {//没有解锁全部课程
            if ([[_videoInfoDict stringValueForKey:@"price"] floatValue] == 0) {//免费的或者是管理员
                if ([[_dataArray[section] stringValueForKey:@"is_free"] integerValue] == 1) {
                    price.hidden = NO;
                    price.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
                    price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                } else {
                    price.hidden = YES;
                }
            } else {
                if ([[_dataArray[section] stringValueForKey:@"is_free"] integerValue] == 1) {
                    price.hidden = NO;
                    price.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
                    price.textColor = [UIColor colorWithHexString:@"#47b37d"];
                } else {
                    price.hidden = NO;
                    if ([[_dataArray[section] stringValueForKey:@"is_buy"] integerValue] == 1) {
                        price.text = @"已购";
                        price.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
                        price.textColor = [UIColor colorWithHexString:@"#888"];
                    } else {
                        if ([_dataArray[section][@"course_hour_price"] floatValue] == 0) {
                            price.hidden = YES;
                        } else {
                            price.text = [NSString stringWithFormat:@"%.2f育币",[_dataArray[section][@"course_hour_price"] floatValue]];
                            price.layer.borderColor = [UIColor redColor].CGColor;
                            price.textColor = [UIColor redColor];
                        }
                    }
                }
            }
        }
        CGFloat priceWidth = [price.text sizeWithFont:price.font].width + 4;
        price.frame = CGRectMake(MainScreenWidth - 50 * WideEachUnit - 5 * WideEachUnit - priceWidth * WideEachUnit, 10 * WideEachUnit, priceWidth * WideEachUnit, 30 * HigtEachUnit);
    }
    
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
    arrowsButton.userInteractionEnabled = YES;
    arrowsButton.enabled = NO;
    if (section == 0) {
        if (_isOn0) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    } else if (section == 1) {
        if (_isOn1) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 2) {
        if (_isOn2) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 3) {
        if (_isOn3) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 4) {
        if (_isOn4) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }
    
    //给整个View添加手势
    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
    
    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isClassCourse) {
        NSArray *secitonArray = _newsDataArray[indexPath.section];
        NSDictionary *dic = [secitonArray objectAtIndex:indexPath.row];
        return 50 * WideEachUnit + [[dic objectForKey:@"child"] count] * 50 * WideEachUnit;
    }
    return 50 * WideEachUnit;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return _.count;
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isOn0) {
        if (section == 0) {
            return 0;
        }
    }
    if (_isOn1) {
        if (section == 1) {
            return 0;
        }
    }
    if (_isOn2) {
        if (section == 2) {
            return 0;
        }
    }
    if (_isOn3) {
        if (section == 3) {
            return 0;
        }
    }
    if (_isOn4) {
        if (section == 4) {
            return 0;
        }
    }
    if (_isOn5) {
        if (section == 5) {
            return 0;
        }
    }
    
    NSArray *sectionArray = _newsDataArray[section];
    return sectionArray.count;
    //
    //    return _newsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    CellIdentifier = [NSString stringWithFormat:@"culture----%ld",indexPath.row];
    //自定义cell类
    Good_ClassCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Good_ClassCatalogTableViewCell alloc] initWithReuseIdentifier:CellIdentifier isClassNew:_isClassCourse cellSection:indexPath.section cellRow:indexPath.row];
    }
    
    NSArray *secitonArray = _newsDataArray[indexPath.section];
    NSDictionary *dic = [secitonArray objectAtIndex:indexPath.row];
    [cell dataSourceWithDict:dic withBuyString:[_videoInfoDict stringValueForKey:@"is_buy"] WithLiveInfo:_videoInfoDict];
    if (_isClassCourse) {
        cell.delegate = self;
    }
    //    if (indexPath.section == _newsDataArray.count - 1 && indexPath.row == secitonArray.count - 1) {//最后一个cell
    //        CGFloat tableHight = tableView.contentSize.height;
    //        self.vcHight(tableHight);
    //    } else {
    //        CGFloat tableHight = tableView.contentSize.height;
    //        self.vcHight(tableHight);
    //    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isClassCourse) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
    recodeNum = 0;
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_free_course_opt integerValue] == 1) {
        if (!UserOathToken) {
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    Num ++;
    [_tableView reloadData];
    indexPathRow = indexPath.row;
    indexPathSection = indexPath.section;
    NSDictionary *cellDict = _newsDataArray[indexPathSection][indexPathRow];
    _cellDict = cellDict;
    
    if ([[cellDict stringValueForKey:@"type"] integerValue] == 6 || [[cellDict stringValueForKey:@"is_baidudoc"] integerValue] == 1) {
        //点击了
        //    self.didSele(@"didSele");
        
        for (int i = 0 ; i < _selectedArray.count ; i ++) {
            if (i == indexPath.section) {
                NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[_selectedArray objectAtIndex:indexPath.section]];
                for (int k = 0 ; k < sectionArray.count ; k ++) {
                    if (k == indexPath.row) {
                        [sectionArray replaceObjectAtIndex:k  withObject:[NSNumber numberWithBool:YES]];
                    }else {
                        [sectionArray replaceObjectAtIndex:k withObject:[NSNumber numberWithBool:NO]];
                    }
                }
                [_selectedArray replaceObjectAtIndex:indexPath.section withObject:sectionArray];
            } else {
                NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[_selectedArray objectAtIndex:i]];
                for (int i = 0 ; i < sectionArray.count ; i ++) {
                    [sectionArray replaceObjectAtIndex:i  withObject:[NSNumber numberWithBool:NO]];
                }
                [_selectedArray replaceObjectAtIndex:i withObject:sectionArray];
            }
        }
        
        // 判断流程
        // 首先判断 课程是否解锁 课时是否免费 课时是否解锁
        // 课程价格为0 课时价格为0 然后判断是不是顺序课 is_order 没有登录而且没有解锁是试看
        
        if ([[_videoInfoDict stringValueForKey:@"is_buy"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_free"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//全部解锁过了
            if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                    __weak Good_ClassCatalogViewController *weakSelf = self;
                    weakSelf.videoDataSource(_cellDict);
                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                        [self addRecode];
                    } else {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                        [self.timer fire];
                    }
                } else {
                    if (indexPathSection == 0 && indexPathRow == 0) {
                        [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        [TKProgressHUD showError:@"暂时不能观看,请先解锁上一个课时" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                }
            } else {
                __weak Good_ClassCatalogViewController *weakSelf = self;
                weakSelf.videoDataSource(_cellDict);
                if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                    [self addRecode];
                } else {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                    [self.timer fire];
                }
            }
        } else {
            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6 || [[cellDict stringValueForKey:@"type"] integerValue] == 2) {
                if ([[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                    [self isPromptBuy];
                } else {
                    [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
            } else {
                if ([[_videoInfoDict stringValueForKey:@"price"] floatValue] != 0 && [[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                    [self isPromptBuy];
                } else {
                    if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                        if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                            __weak Good_ClassCatalogViewController *weakSelf = self;
                            weakSelf.videoDataSource(_cellDict);
                            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                                [self addRecode];
                            } else {
                                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                [self.timer fire];
                            }
                        } else {
                            [TKProgressHUD showError:@"暂时不能观看" toView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                    } else {
                        __weak Good_ClassCatalogViewController *weakSelf = self;
                        weakSelf.videoDataSource(_cellDict);
                        if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                            [self addRecode];
                        } else {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                            [self.timer fire];
                        }
                    }
                }
                
            }
        }
        
        //人脸识别的判断
        if (isScene) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *faceStr = [defaults objectForKey:@"Video_Face"];
            if ([faceStr isEqualToString:@"face"]) {//说明已经扫过脸了
                //            [self postNotificationAndStudyRecord];
            } else {
                //            [self NetWorkGetFaceStatus];
            }
            
        } else {
            
        }
    } else {
        NSString *endUrlStr = course_getSectionHour;
        NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
        
        NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [mutabDict setObject:[NSString stringWithFormat:@"%@",[cellDict objectForKey:@"id"]] forKey:@"id"];
        
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
                NSDictionary *pass = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                NSMutableDictionary *pass1 = [NSMutableDictionary dictionaryWithDictionary:_cellDict];
                [pass1 setObject:[pass objectForKey:@"video_address"] forKey:@"video_address"];
                _cellDict = [NSDictionary dictionaryWithDictionary:pass1];
                //点击了
                //    self.didSele(@"didSele");
                
                for (int i = 0 ; i < _selectedArray.count ; i ++) {
                    if (i == indexPath.section) {
                        NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[_selectedArray objectAtIndex:indexPath.section]];
                        for (int k = 0 ; k < sectionArray.count ; k ++) {
                            if (k == indexPath.row) {
                                [sectionArray replaceObjectAtIndex:k  withObject:[NSNumber numberWithBool:YES]];
                            }else {
                                [sectionArray replaceObjectAtIndex:k withObject:[NSNumber numberWithBool:NO]];
                            }
                        }
                        [_selectedArray replaceObjectAtIndex:indexPath.section withObject:sectionArray];
                    } else {
                        NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[_selectedArray objectAtIndex:i]];
                        for (int i = 0 ; i < sectionArray.count ; i ++) {
                            [sectionArray replaceObjectAtIndex:i  withObject:[NSNumber numberWithBool:NO]];
                        }
                        [_selectedArray replaceObjectAtIndex:i withObject:sectionArray];
                    }
                }
                
                // 判断流程
                // 首先判断 课程是否解锁 课时是否免费 课时是否解锁
                // 课程价格为0 课时价格为0 然后判断是不是顺序课 is_order 没有登录而且没有解锁是试看
                
                if ([[_videoInfoDict stringValueForKey:@"is_buy"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_free"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//全部解锁过了
                    if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                        if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                            __weak Good_ClassCatalogViewController *weakSelf = self;
                            weakSelf.videoDataSource(_cellDict);
                            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                                [self addRecode];
                            } else {
                                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                [self.timer fire];
                            }
                        } else {
                            if (indexPathSection == 0 && indexPathRow == 0) {
                                [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                                return;
                            } else {
                                [TKProgressHUD showError:@"暂时不能观看,请先解锁上一个课时" toView:[UIApplication sharedApplication].keyWindow];
                                return;
                            }
                        }
                    } else {
                        __weak Good_ClassCatalogViewController *weakSelf = self;
                        weakSelf.videoDataSource(_cellDict);
                        if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                            [self addRecode];
                        } else {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                            [self.timer fire];
                        }
                    }
                } else {
                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6 || [[cellDict stringValueForKey:@"type"] integerValue] == 2) {
                        if ([[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                            [self isPromptBuy];
                        } else {
                            [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                    } else {
                        if ([[_videoInfoDict stringValueForKey:@"price"] floatValue] != 0 && [[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                            [self isPromptBuy];
                        } else {
                            if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                                if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                                    __weak Good_ClassCatalogViewController *weakSelf = self;
                                    weakSelf.videoDataSource(_cellDict);
                                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                                        [self addRecode];
                                    } else {
                                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                        [self.timer fire];
                                    }
                                } else {
                                    [TKProgressHUD showError:@"暂时不能观看" toView:[UIApplication sharedApplication].keyWindow];
                                    return;
                                }
                            } else {
                                __weak Good_ClassCatalogViewController *weakSelf = self;
                                weakSelf.videoDataSource(_cellDict);
                                if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                                    [self addRecode];
                                } else {
                                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                    [self.timer fire];
                                }
                            }
                        }
                        
                    }
                }
                
                //人脸识别的判断
                if (isScene) {
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    NSString *faceStr = [defaults objectForKey:@"Video_Face"];
                    if ([faceStr isEqualToString:@"face"]) {//说明已经扫过脸了
                        //            [self postNotificationAndStudyRecord];
                    } else {
                        //            [self NetWorkGetFaceStatus];
                    }
                    
                } else {
                    
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        }];
        [op start];
    }
    
}

- (void)classCourseCellTableViewCellSelected:(NSDictionary *)classCourseCellDict cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow classCellRow:(NSInteger)classCellRow{
    [self.timer invalidate];
    self.timer = nil;
    recodeNum = 0;
    if ([_free_course_opt integerValue] == 1) {
        if (!UserOathToken) {
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    Num ++;
    [_tableView reloadData];
    indexPathRow = cellSection;
    indexPathSection = cellRow;
    NSDictionary *cellDict = [NSDictionary dictionaryWithDictionary:classCourseCellDict];
    _cellDict = cellDict;
    
    if ([[cellDict stringValueForKey:@"type"] integerValue] == 6 || [[cellDict stringValueForKey:@"is_baidudoc"] integerValue] == 1) {
        
        // 判断流程
        // 首先判断 课程是否解锁 课时是否免费 课时是否解锁
        // 课程价格为0 课时价格为0 然后判断是不是顺序课 is_order 没有登录而且没有解锁是试看
        
        if ([[_videoInfoDict stringValueForKey:@"is_buy"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_free"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//全部解锁过了
            if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                    __weak Good_ClassCatalogViewController *weakSelf = self;
                    weakSelf.videoDataSource(_cellDict);
                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                        [self addRecode];
                    } else {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                        [self.timer fire];
                    }
                } else {
                    if (indexPathSection == 0 && indexPathRow == 0 && classCellRow == 0) {
                        [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        [TKProgressHUD showError:@"暂时不能观看,请先解锁上一个课时" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                }
            } else {
                __weak Good_ClassCatalogViewController *weakSelf = self;
                weakSelf.videoDataSource(_cellDict);
                if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                    [self addRecode];
                } else {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                    [self.timer fire];
                }
            }
        } else {
            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6 || [[cellDict stringValueForKey:@"type"] integerValue] == 2) {
                if ([[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                    [self isPromptBuy];
                } else {
                    [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
            } else {
                if ([[_videoInfoDict stringValueForKey:@"price"] floatValue] != 0 && [[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                    [self isPromptBuy];
                } else {
                    if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                        if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                            __weak Good_ClassCatalogViewController *weakSelf = self;
                            weakSelf.videoDataSource(_cellDict);
                            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                                [self addRecode];
                            } else {
                                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                [self.timer fire];
                            }
                        } else {
                            [TKProgressHUD showError:@"暂时不能观看" toView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                    } else {
                        __weak Good_ClassCatalogViewController *weakSelf = self;
                        weakSelf.videoDataSource(_cellDict);
                        if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                            [self addRecode];
                        } else {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                            [self.timer fire];
                        }
                    }
                }
                
            }
        }
        
        //人脸识别的判断
        if (isScene) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *faceStr = [defaults objectForKey:@"Video_Face"];
            if ([faceStr isEqualToString:@"face"]) {//说明已经扫过脸了
                //            [self postNotificationAndStudyRecord];
            } else {
                //            [self NetWorkGetFaceStatus];
            }
            
        } else {
            
        }
    } else {
        NSString *endUrlStr = course_getSectionHour;
        NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
        
        NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [mutabDict setObject:[NSString stringWithFormat:@"%@",[cellDict objectForKey:@"id"]] forKey:@"id"];
        
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
                NSDictionary *pass = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                NSMutableDictionary *pass1 = [NSMutableDictionary dictionaryWithDictionary:_cellDict];
                [pass1 setObject:[pass objectForKey:@"video_address"] forKey:@"video_address"];
                _cellDict = [NSDictionary dictionaryWithDictionary:pass1];
                
                // 判断流程
                // 首先判断 课程是否解锁 课时是否免费 课时是否解锁
                // 课程价格为0 课时价格为0 然后判断是不是顺序课 is_order 没有登录而且没有解锁是试看
                
                if ([[_videoInfoDict stringValueForKey:@"is_buy"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_free"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//全部解锁过了
                    if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                        if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                            __weak Good_ClassCatalogViewController *weakSelf = self;
                            weakSelf.videoDataSource(_cellDict);
                            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                                [self addRecode];
                            } else {
                                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                [self.timer fire];
                            }
                        } else {
                            if (indexPathSection == 0 && indexPathRow == 0 && classCellRow == 0) {
                                [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                                return;
                            } else {
                                [TKProgressHUD showError:@"暂时不能观看,请先解锁上一个课时" toView:[UIApplication sharedApplication].keyWindow];
                                return;
                            }
                        }
                    } else {
                        __weak Good_ClassCatalogViewController *weakSelf = self;
                        weakSelf.videoDataSource(_cellDict);
                        if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                            [self addRecode];
                        } else {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                            [self.timer fire];
                        }
                    }
                } else {
                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6 || [[cellDict stringValueForKey:@"type"] integerValue] == 2) {
                        if ([[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                            [self isPromptBuy];
                        } else {
                            [TKProgressHUD showError:@"请先解锁整个课程" toView:[UIApplication sharedApplication].keyWindow];
                            return;
                        }
                    } else {
                        if ([[_videoInfoDict stringValueForKey:@"price"] floatValue] != 0 && [[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                            [self isPromptBuy];
                        } else {
                            if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                                if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                                    __weak Good_ClassCatalogViewController *weakSelf = self;
                                    weakSelf.videoDataSource(_cellDict);
                                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                                        [self addRecode];
                                    } else {
                                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                        [self.timer fire];
                                    }
                                } else {
                                    [TKProgressHUD showError:@"暂时不能观看" toView:[UIApplication sharedApplication].keyWindow];
                                    return;
                                }
                            } else {
                                __weak Good_ClassCatalogViewController *weakSelf = self;
                                weakSelf.videoDataSource(_cellDict);
                                if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 6) {
                                    [self addRecode];
                                } else {
                                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                                    [self.timer fire];
                                }
                            }
                        }
                        
                    }
                }
                
                //人脸识别的判断
                if (isScene) {
                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                    NSString *faceStr = [defaults objectForKey:@"Video_Face"];
                    if ([faceStr isEqualToString:@"face"]) {//说明已经扫过脸了
                        //            [self postNotificationAndStudyRecord];
                    } else {
                        //            [self NetWorkGetFaceStatus];
                    }
                    
                } else {
                    
                }
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        }];
        [op start];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        if (self.vc.canScrollAfterVideoPlay == YES) {
            self.cellTabelCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            self.vc.canScroll = YES;
        }
    }
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

#pragma mark --- 通知
- (void)NSNotificationVideoDataSource {
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationVideoDataSource" object:nil userInfo:_newsDataArray[indexPathSection][indexPathRow]];
    NSDictionary *dict = _newsDataArray[indexPathSection][indexPathRow];
    __weak Good_ClassCatalogViewController *weakSelf = self;
    weakSelf.videoDataSource(dict);
    
    //    NSString *downUrl = [dict stringValueForKey:@"video_address"];
    //    NSString *downTitle = [dict stringValueForKey:@"title"];
    //    if ([downUrl rangeOfString:YunKeTang_EdulineOssCnShangHai].location != NSNotFound) {//有 （说明要下载）
    //        NSURL *imagegurl = [NSURL URLWithString:downUrl];
    //        NSData *data = [NSData dataWithContentsOfURL:imagegurl];
    //        UIImage *videoImage = [[UIImage alloc] initWithData:data];
    //        //此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    //        [[ZFDownloadManager sharedDownloadManager] downFileUrl:downUrl filename:downTitle fileimage:videoImage withType:@"1"];
    //        // 设置最多同时下载个数（默认是3）
    //        [ZFDownloadManager sharedDownloadManager].maxCount = 1;
    //    }
}

- (void)AilYunPlayerEnd:(NSNotification *)not {
    NSString *notStr = (NSString *)not.object;
    if ([notStr integerValue] == 100) {
        [self.timer invalidate];
        self.timer = nil;
        recodeNum = 0;
        [self netWorkVideoGetCatalog];
        [self performSelector:@selector(autoPlayNextCourse) withObject:nil afterDelay:1.5];
    }
}

- (void)AilYunPlayerStop {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark  --- 下面的导航栏隐藏
- (void)appNavigationBarHidden {
    //让下面的导航栏去掉
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark --- 提示
- (void)isPromptGo {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([[_cellDict stringValueForKey:@"video_type"] integerValue] == 6) {//考试
        
        if ([[_cellDict stringValueForKey:@"is_order"] integerValue] && [[_cellDict stringValueForKey:@"lock"] integerValue] != 1) {
            [TKProgressHUD showError:@"暂时无法考试" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"考试提示" message:@"是否现在前去考试？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self gotoTest];
        }];
        [alertController addAction:sureAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)isPromptBuy {//跳转解锁
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
    vc.dict = _videoInfoDict;
    if (_isClassCourse) {
        vc.typeStr = @"5";
    } else {
        vc.typeStr = @"1";
    }
    vc.cellDict = _cellDict;
    vc.cid = _ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoTest {
    [self netWorkExamsGetPaperInfo];
}



#pragma mark --- 人脸识别相关操作

- (void)isScanFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此操作需扫脸验证" message:@"是否需要扫脸进行观看？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self faceScan];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)isBoundFace {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此操作需扫脸验证" message:@"您还没有绑定您的个人信息，是否开始添加？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self gotoBoundFace];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //        [self NetWorkGetPaperInfo];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 进去人脸识别
- (void)gotoBoundFace {
    Good_PersonFaceRegisterViewController *vc = [[Good_PersonFaceRegisterViewController alloc] init];
    vc.typeStr = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- 人脸识别登录
- (void)faceScan {
    __weak typeof(self) weakSelf = self;
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    dvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* bestImage = [UIImage imageWithData:data];
            NSLog(@"bestImage = %@",bestImage);
            faceImage = bestImage;
            [self netWorkUserUpLoad];
            NSString* bestImageStr = [[images[@"bestImage"] lastObject] copy];
            
            //检测活动的方法
            [[NetAccessModel sharedInstance] detectUserLivenessWithFaceImageStr:bestImageStr completion:^(NSError *error, id resultObject) {
                if (error == nil) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                    if ([dict[@"result_num"] integerValue] > 0) {
                        NSDictionary* d = dict[@"result"][0];
                        NSLog(@"faceliveness = %f",[d[@"face_probability"] floatValue]);
                        if (d[@"faceliveness"] != nil && [d[@"faceliveness"] floatValue] > 0.834963 ) {
                        } else {
                        }
                    }
                }
            }];
        }
    };
    [self presentViewController:dvc animated:YES completion:nil];
    
}

#pragma mark --- 添加记录
- (void)addRecode {
    recodeNum ++;
    recodeNum ++;
    [self netWorkUserAddRecord];
}

#pragma mark --- 网络请求 (人脸识别的图片上传的接口)
//获得图片的ID
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
        
        NSData *dataImg=UIImageJPEGRepresentation(faceImage, 1.0);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            _faceID = [dict stringValueForKey:@"attach_id"];
            if ([[_existDict stringValueForKey:@"is_exist"] integerValue] == 1 || [[_existDict stringValueForKey:@"is_exist"] integerValue] == 2) {//扫脸登录
                [self netWorkYouTuFaceverify];
            } else if ([[_existDict stringValueForKey:@"is_exist"] integerValue] == 0) {//扫脸绑定
                
            }
            
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//获取列表
- (void)netWorkVideoGetCatalog {
    
    NSString *endUrlStr = YunKeTang_Video_video_getCatalog;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_dataSource isKindOfClass:[NSArray class]]) {
                _dataArray = (NSArray *)_dataSource;
                if (_dataArray.count == 0) {
                    self.imageView.hidden = NO;
                } else {
                    self.imageView.hidden = YES;
                }
                [_newsDataArray removeAllObjects];
                for (int i = 0 ; i < _dataArray.count; i ++ ) {
                    NSArray *classArray = [[_dataArray objectAtIndex:i] arrayValueForKey:@"child"];
                    if (classArray == nil) {
                        classArray = @[];//置空
                        [_newsDataArray addObject:classArray];
                    } else {
                        [_newsDataArray addObject:classArray];
                    }
                    
                    NSString *title = [[_dataArray objectAtIndex:i] stringValueForKey:@"title"];
                    [_sectionArray addObject:title];
                    
                    NSMutableArray *boolArray = [NSMutableArray array];
                    for (int k = 0 ; k < classArray.count ; k ++) {
                        
                        if (i == 0 && k == 0) {
                            [boolArray addObject:[NSNumber numberWithBool:YES]];
                        } else {
                            [boolArray addObject:[NSNumber numberWithBool:NO]];
                        }
                    }
                    [_boolArray addObject:boolArray];
                }
            }
        } else {
            
        }
        [_tableView reloadData];
        [self judgePlayWhichVideo];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//添加学习记录
- (void)netWorkUserAddRecord {
    
    NSString *endUrlStr = YunKeTang_User_user_addRecord;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    _sectionID = [NSString stringWithFormat:@"%@",[_cellDict objectForKey:@"id"]];//[[[[_dataArray objectAtIndex:indexPathSection] arrayValueForKey:@"child"] objectAtIndex:indexPathRow] stringValueForKey:@"id"];
    [mutabDict setObject:_sectionID forKey:@"sid"];
    [mutabDict setValue:_ID forKey:@"vid"];
    [mutabDict setValue:[NSString stringWithFormat:@"%d",recodeNum] forKey:@"time"];
    
    //计算总时长
    NSString *durationStr = [_cellDict stringValueForKey:@"duration"];
    NSArray *durationArray = [durationStr componentsSeparatedByString:@":"];
    NSInteger totalTime = 0;
    totalTime = [durationArray[0] integerValue] * 3600 + [durationArray[1] integerValue] * 60 + [durationArray[1] integerValue];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",totalTime] forKey:@"totaltime"];
    [mutabDict setValue:[_cellDict stringValueForKey:@"video_type"] forKey:@"type"];
    
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            //成功
            [self netWorkVideoGetCatalog];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

#pragma mark --- 网络请求
- (void)netWorkVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _videoInfoDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_videoInfoDict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_videoInfoDict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _videoInfoDict = [_videoInfoDict dictionaryValueForKey:@"data"];
            } else {
                _videoInfoDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD showError:@"请求错误" toView:self.view];
    }];
    [op start];
}


//人脸识别的请求
//获取人脸识别的配置接口
- (void)netWorkCongigGetFaceScene {
    NSString *endUrlStr = YunKeTang_config_getFaceScene;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *hexStr = [Passport getHexByDecimal:[timeSp integerValue]];
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,hexStr]];
    [mutabDict setObject:hexStr forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
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
        NSDictionary *sceneDict = [NSDictionary dictionary];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                sceneDict = [dict dictionaryValueForKey:@"data"];
            } else {
                sceneDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        BOOL isScene = NO;
        _getFaceSceneArray = [sceneDict arrayValueForKey:@"open_scene"];
        for (NSString *typeStr in _getFaceSceneArray) {
            if ([typeStr isEqualToString:@"video"]) {//说明配置的视频相关的
                isScene = YES;
                [self netWorkYouTuIsExist];
            }
        }
        if (!isScene) {
            [self NSNotificationVideoDataSource];
            if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                if ([[_cellDict stringValueForKey:@"type"] integerValue] == 3 || [[_cellDict stringValueForKey:@"type"] integerValue] == 4 || [[_cellDict stringValueForKey:@"type"] integerValue] == 5) {
                    [self addRecode];
                } else {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                    [self.timer fire];
                }
            } else {
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)netWorkYouTuIsExist {
    NSString *endUrlStr = YunKeTang_YouTu_youtu_isExist;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
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
            _existDict = dict;
        }
        if ([[dict stringValueForKey:@"is_exist"] integerValue] == 1) {//已经创建了人脸识别
            //            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            //            NSString *faceStr = [defaults objectForKey:@"Video_Face"];
            //            if ([faceStr isEqualToString:@"face"]) {//说明已经扫过脸了
            //                [self netWorkExamsGetPaperInfo];
            //            } else {
            //                [self isScanFace];
            //            }
            [self isScanFace];
        } else if ([[dict stringValueForKey:@"is_exist"] integerValue] == 0) {//还没有创建的 （需要提醒）
            [self isBoundFace];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}


// 人脸对比
- (void)netWorkYouTuFaceverify {
    NSString *endUrlStr = YunKeTang_YouTu_youtu_faceverify;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_faceID forKey:@"attach_id"];
    
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
        NSDictionary *errorDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([[dict stringValueForKey:@"ismatch"] integerValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setObject:@"face" forKey:@"Video_Face"];
                [self NSNotificationVideoDataSource];
                [self netWorkUserAddRecord];
            } else {//不是同一个人
                [TKProgressHUD showError:[errorDict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
    [self appNavigationBarHidden];
}


//创建人脸
- (void)NetWorkYouTuCreatePerson {
    
    NSString *endUrlStr = YunKeTang_YouTu_youtu_createPerson;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *oath_token_Str = nil;
    //    if (_tokenAndTokenSerectDict != nil) {//说明是从登录界面过来创建人脸的
    //        oath_token_Str = [NSString stringWithFormat:@"%@:%@",[_tokenAndTokenSerectDict stringValueForKey:@"oauth_token"],[_tokenAndTokenSerectDict stringValueForKey:@"oauth_token_secret"]];
    //    } else {//直接添加人脸的（从绑定进入）
    //        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    //    }
    oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    [mutabDict setObject:_faceID forKey:@"attach_id"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:@"创建成功" toView:[UIApplication sharedApplication].keyWindow];
            [self NSNotificationVideoDataSource];
            [self netWorkUserAddRecord];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)netWorkVideoGetInfoAgain {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _videoInfoDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_videoInfoDict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_videoInfoDict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _videoInfoDict = [_videoInfoDict dictionaryValueForKey:@"data"];
            } else {
                _videoInfoDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [self netWorkVideoGetCatalog];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD showError:@"请求错误" toView:self.view];
    }];
    [op start];
}


//考试试题的详情
- (void)netWorkExamsGetPaperInfo {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_cellDict stringValueForKey:@"eid"] forKey:@"paper_id"];
    [mutabDict setObject:@"2" forKey:@"exams_type"];//默认为考试模式
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    [TKProgressHUD showMessag:@"加载中...." toView:[UIApplication sharedApplication].keyWindow];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        _testDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_testDataSource dictionaryValueForKey:@"paper_options"].allKeys.count == 0) {
            [TKProgressHUD showError:@"考试数据为空" toView:[UIApplication sharedApplication].keyWindow];
            return ;
        }
        if ([[_testDataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions"].allKeys.count == 0) {
            [TKProgressHUD showError:@"考试数据为空" toView:[UIApplication sharedApplication].keyWindow];
            return ;
        }
        TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
        vc.examsType = @"2";
        vc.dataSource = _testDataSource;
        vc.classTestType = @"classGoin";
        NSLog(@"%@",self.navigationController.viewControllers);
        if (self.navigationController.viewControllers.count == 4) {
            vc.classTestType = @"Search_ClassGoin";
        }
        //        vc.testDict = _testDict;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [TKProgressHUD showError:@"加载失败" toView:[UIApplication sharedApplication].keyWindow];
    }];
    [op start];
}

- (void)netWorkConfigFreeCourseLoginSwitch {
    
    NSString *endUrlStr = YunKeTang_config_freeCourseLoginSwitch;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
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
            if ([[dict stringValueForKey:@"free_course_opt"] integerValue] == 1) {
                _free_course_opt = @"1";
            } else if ([[dict stringValueForKey:@"free_course_opt"] integerValue] == 0) {
                _free_course_opt = @"0";
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)judgePlayWhichVideo {
    if (SWNOTEmptyStr(_sid) && SWNOTEmptyArr(_newsDataArray) && _canPlayRecordVideo) {
        _canPlayRecordVideo = NO;
        for (int i = 0; i < _newsDataArray.count; i++) {
            NSArray *courseArray = _newsDataArray[i];
            for (int j = 0; j < courseArray.count; j++) {
                NSDictionary *dict = courseArray[j];
                if ([_sid isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]]) {
                    __weak Good_ClassCatalogViewController *weakSelf = self;
                    _cellDict = dict;
                    weakSelf.videoDataSource(dict);
                    _sid = @"";
                    return;
                }
            }
        }
    }
}

- (void)autoPlayNextCourse {
    if (SWNOTEmptyDictionary(_cellDict) && SWNOTEmptyArr(_newsDataArray)) {
        NSString *courseId = [NSString stringWithFormat:@"%@",[_cellDict objectForKey:@"id"]];
        int currentSection = 0;// 当前播放课时在数组中的section
        int currentRow = 0;// 当前播放课时在数组中的row
        for (int i = 0; i < _newsDataArray.count; i++) {
            NSArray *courseArray = _newsDataArray[i];
            for (int j = 0; j < courseArray.count; j++) {
                NSDictionary *dict = courseArray[j];
                if ([courseId isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]]) {
                    if (j < (courseArray.count - 1)) {
                        currentRow = j + 1;
                        currentSection = i;
                        NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:currentRow inSection:currentSection];
                        [self autoDidselectedNextIndexPath:currentIndex];
                    } else {
                        if (i < (_newsDataArray.count - 1)) {
                            currentSection = i + 1;
                            currentRow = 0;
                            NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:currentRow inSection:currentSection];
                            [self autoDidselectedNextIndexPath:currentIndex];
                        }
                    }
                    break;
                }
            }
        }
    }
}

- (void)autoDidselectedNextIndexPath:(NSIndexPath *)indexPath {
    //
    [self.timer invalidate];
    self.timer = nil;
    recodeNum = 0;
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_free_course_opt integerValue] == 1) {
        if (!UserOathToken) {
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    //点击了
    //    self.didSele(@"didSele");
    
    for (int i = 0 ; i < _selectedArray.count ; i ++) {
        if (i == indexPath.section) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[_selectedArray objectAtIndex:indexPath.section]];
            for (int k = 0 ; k < sectionArray.count ; k ++) {
                if (k == indexPath.row) {
                    [sectionArray replaceObjectAtIndex:k  withObject:[NSNumber numberWithBool:YES]];
                }else {
                    [sectionArray replaceObjectAtIndex:k withObject:[NSNumber numberWithBool:NO]];
                }
            }
            [_selectedArray replaceObjectAtIndex:indexPath.section withObject:sectionArray];
        } else {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[_selectedArray objectAtIndex:i]];
            for (int i = 0 ; i < sectionArray.count ; i ++) {
                [sectionArray replaceObjectAtIndex:i  withObject:[NSNumber numberWithBool:NO]];
            }
            [_selectedArray replaceObjectAtIndex:i withObject:sectionArray];
        }
    }
    
    Num ++;
    [_tableView reloadData];
    indexPathRow = indexPath.row;
    indexPathSection = indexPath.section;
    NSDictionary *cellDict = _newsDataArray[indexPathSection][indexPathRow];
    _cellDict = cellDict;
    // 判断流程
    // 首先判断 课程是否解锁 课时是否免费 课时是否解锁
    // 课程价格为0 课时价格为0 然后判断是不是顺序课 is_order 没有登录而且没有解锁是试看
    
    if ([[_videoInfoDict stringValueForKey:@"is_buy"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_free"] integerValue] == 1 || [[_cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {//全部解锁过了
        if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
            if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                __weak Good_ClassCatalogViewController *weakSelf = self;
                weakSelf.videoDataSource(_cellDict);
                if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                    [self addRecode];
                } else {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                    [self.timer fire];
                }
            } else {
                [TKProgressHUD showError:@"暂时不能观看" toView:[UIApplication sharedApplication].keyWindow];
                return;
            }
        } else {
            __weak Good_ClassCatalogViewController *weakSelf = self;
            weakSelf.videoDataSource(_cellDict);
            if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                [self addRecode];
            } else {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                [self.timer fire];
            }
        }
    } else {
        if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5 || [[cellDict stringValueForKey:@"type"] integerValue] == 2) {
            [self isPromptBuy];
        } else {
            if ([[_videoInfoDict stringValueForKey:@"price"] floatValue] != 0 && [[_cellDict stringValueForKey:@"course_hour_price"] floatValue] != 0) {
                [self isPromptBuy];
            } else {
                if ([[_videoInfoDict stringValueForKey:@"is_order"] integerValue] == 1) {
                    if ([[_cellDict stringValueForKey:@"lock"] integerValue] == 1) {
                        __weak Good_ClassCatalogViewController *weakSelf = self;
                        weakSelf.videoDataSource(_cellDict);
                        if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                            [self addRecode];
                        } else {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                            [self.timer fire];
                        }
                    } else {
                        [TKProgressHUD showError:@"暂时不能观看" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    }
                } else {
                    __weak Good_ClassCatalogViewController *weakSelf = self;
                    weakSelf.videoDataSource(_cellDict);
                    if ([[cellDict stringValueForKey:@"type"] integerValue] == 3 || [[cellDict stringValueForKey:@"type"] integerValue] == 4 || [[cellDict stringValueForKey:@"type"] integerValue] == 5) {
                        [self addRecode];
                    } else {
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(addRecode) userInfo:nil repeats:YES];
                        [self.timer fire];
                    }
                }
            }
            
        }
    }
}

// 播放的时候如果有记录 就传递记录时间给 recodeNum
- (void)recodeNumChanged:(NSNotification *)notice {
    NSDictionary *dict = notice.userInfo;
    if (SWNOTEmptyStr([dict objectForKey:@"recodeNum"])) {
        recodeNum = (int)[[NSString stringWithFormat:@"%@",[dict objectForKey:@"recodeNum"]] integerValue];
    }
}

@end
