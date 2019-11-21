//
//  ZhiBoBigRoomViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoBigRoomViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "HomeInstitutionViewController.h"

#import "InstatutionCollectionViewCell.h"
#import "ZhiBoMainViewController.h"

#import "ZhiBoClassView.h"
#import "ZhiBoTeacherView.h"
#import "ZhiBoMoreView.h"
#import "ZhiBoClassTypeViewController.h"
#import "ZhiBoClassTeacherViewController.h"
#import "ZhiBoClassMoreViewController.h"
#import "DLViewController.h"



@interface ZhiBoBigRoomViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate> {
    BOOL isClass;
    BOOL isTeacher;
    BOOL isMore;
    NSInteger Number;
}

@property (strong ,nonatomic)UICollectionView *collectionView;
@property (strong ,nonatomic)UIView           *headerView;
@property (strong ,nonatomic)UIButton         *classButton;
@property (strong ,nonatomic)UIButton         *teacherButton;
@property (strong ,nonatomic)UIButton         *moreButton;
@property (strong ,nonatomic)UIImageView      *imageView;

@property (strong ,nonatomic)NSMutableArray   *dataArray;
@property (strong ,nonatomic)NSString         *typeID;
@property (strong ,nonatomic)NSString         *teacherID;
@property (strong ,nonatomic)NSString         *moreTypeID;
@property (strong ,nonatomic)NSString         *moreRankID;

//营销数据
@property (strong ,nonatomic)NSString         *order_switch;

@end

static NSString *cellID = @"cell";

@implementation ZhiBoBigRoomViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, MainScreenHeight - 120)];
        _imageView.image = Image(@"云课堂_空数据.png");
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
    [self addHeaderView];
    [self addCollectionView];
    [self netWorkConfigGetMarketStatus];
    [self netWorkLiveGetList:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    
    isClass = NO;
    isTeacher = NO;
    isMore = NO;
    Number = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassTypeID:) name:@"NSNotificationZhiBoClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherID:) name:@"NSNotificationZhiBoTeacherID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreID:) name:@"NSNotificationZhiBoMoreTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonType:) name:@"NSNotificationZhiBoClassTypeButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherButtonType:) name:@"NSNotificationZhiBoTeacherButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreButtonType:) name:@"NSNotificationZhiBoMoreButton" object:nil];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, NavigationBarSubViewHeight, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, NavigationBarSubViewHeight, MainScreenWidth - 100, 30)];
    WZLabel.text = @"直播大厅";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, MainScreenWidth, 45)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    
    NSArray *titleArray = @[@"分类",@"讲师",@"筛选条件"];
    NSArray *imageArray = @[@"ic_dropdown_live@3x",@"ic_dropdown_live@3x",@"ic_dropdown_live@3x"];
    CGFloat ButtonH = 45;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(16);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self dealButtonImageAndTitleUI:button];
        [_headerView addSubview:button];
        if (i == 0) {
            _classButton = button;
            [button addTarget:self action:@selector(classButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 1) {
            _teacherButton = button;
            [button addTarget:self action:@selector(teacherButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        } else if (i == 2) {
            _moreButton = button;
            [button addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_headerView addSubview:lineButton];
}


- (void)addCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((MainScreenWidth - 3 * SpaceBaside) / 2, 180);
    layout.headerReferenceSize = CGSizeMake(MainScreenWidth, 10);
    layout.footerReferenceSize = CGSizeMake(MainScreenWidth, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SpaceBaside, 109, MainScreenWidth - 2 * SpaceBaside, MainScreenHeight - 109) collectionViewLayout:layout];
    if (iPhoneX) {
        _collectionView.frame = CGRectMake(SpaceBaside, 88 + 45 , MainScreenWidth - 2 * SpaceBaside, MainScreenHeight - 88 - 45);
    }
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[InstatutionCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    [self.collectionView addFooterWithTarget:self action:@selector(footerMore)];
    
}

- (void)footerMore {
    Number ++;
    [self netWorkLiveGetList:Number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView footerEndRefreshing];
        [self.collectionView reloadData];
    });
}

#pragma mark --- UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    InstatutionCollectionViewCell *cell = (InstatutionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSLog(@"%@",_dataArray);
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [cell dataWithDict:dict WithOrderSwitch:_order_switch];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    NSLog(@"%ld",(long)indexPath.item);
    NSString *Cid = nil;
    Cid = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
    NSString *Price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
    
    NSString *Title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
    NSString *ImageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
    
    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
}


#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)classButtonCilck:(UIButton *)button {
    [_classButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_teacherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isClass = !isClass;
    
    if (isClass) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassTeacherRemove" object:@"remove"];
        [_teacherButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_teacherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isTeacher = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        ZhiBoClassTypeViewController *vc = [[ZhiBoClassTypeViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - (MACRO_UI_UPHEIGHT + 45));
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
        //传通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }

}

- (void)teacherButtonCilck:(UIButton *)button {
    
    [_teacherButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_teacherButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isTeacher = !isTeacher;
    
    if (isTeacher) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassMoreRemove" object:@"remove"];
        [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isMore = NO;
        
        ZhiBoClassTeacherViewController *vc = [[ZhiBoClassTeacherViewController alloc] init];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - (MACRO_UI_UPHEIGHT + 45));
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassTeacherRemove" object:@"remove"];
          [_teacherButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
    

}

- (void)moreButtonCilck:(UIButton *)button {
    [_moreButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
    
    [_teacherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isMore = !isMore;
    
    if (isMore) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassTypeRemove" object:@"remove"];
        [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isClass = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassTeacherRemove" object:@"remove"];
        [_teacherButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        [_teacherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isTeacher = NO;
        
        ZhiBoClassMoreViewController *vc = [[ZhiBoClassMoreViewController alloc] initWithTypeStr:_moreTypeID withMoreStr:_moreRankID];
        vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - (MACRO_UI_UPHEIGHT + 45));
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
    } else {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiBoClassMoreRemove" object:@"remove"];
          [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    }
}

#pragma mark --- 通知
- (void)getClassTypeID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _typeID = dict[@"id"];
    NSString *title = dict[@"title"];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_classButton setTitle:title forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_classButton];
    isClass = NO;
    [self netWorkLiveGetList:1];
}

- (void)getTeacherID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _teacherID = dict[@"id"];
    NSString *title = dict[@"name"];
    if (title.length > 3) {
        title = [title substringToIndex:2];
        title = [NSString stringWithFormat:@"%@..",title];
    }
    [_teacherButton setTitle:title forState:UIControlStateNormal];
    [_teacherButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_teacherButton];
    isTeacher = NO;
    [self netWorkLiveGetList:1];
}

- (void)getMoreID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _moreTypeID = dict[@"typeStr"];
    _moreRankID = dict[@"rankStr"];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_moreButton];
    isMore = NO;
    [self netWorkLiveGetList:1];
}

- (void)classButtonType:(NSNotification *)not {
    [_classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClass = NO;
}

- (void)teacherButtonType:(NSNotification *)not {
    [_teacherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_teacherButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isTeacher = NO;
}

- (void)moreButtonType:(NSNotification *)not {
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isMore = NO;
}

#pragma mark --- 网络请求
- (void)netWorkLiveGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Live_live_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_typeID == nil) {
    } else {
        [mutabDict setObject:_typeID forKey:@"cate_id"];
    }
    if (_teacherID == nil) {
    } else {
        [mutabDict setObject:_teacherID forKey:@"teacher_id"];
    }
    if (_moreTypeID == nil) {
    } else {
        [mutabDict setObject:_moreTypeID forKey:@"status"];
    }
    
    if (_moreRankID == nil) {
    } else {
        [mutabDict setObject:_moreRankID forKey:@"order"];
    }
     [mutabDict setObject:@"20" forKey:@"count"];
     [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if (Num == 1) {
                _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
            } else {
                NSMutableArray *array = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                [_dataArray addObjectsFromArray:array];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


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
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)dealButtonImageAndTitleUI:(UIButton *)sender {
    CGFloat labelWidth = [sender.titleLabel.text sizeWithFont:sender.titleLabel.font].width;
    if (labelWidth>(sender.size.width - sender.currentImage.size.width)) {
        labelWidth = 71.5 * WideEachUnit;
    }
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -sender.currentImage.size.width, 0, sender.currentImage.size.width)];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth)];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
