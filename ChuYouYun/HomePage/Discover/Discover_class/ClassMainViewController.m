//
//  ClassMainViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassMainViewController.h"
#import "ClassMainCollectionCell.h"
#import "ClassDetailViewController.h"

#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"

#import "ComboTypeChooseViewController.h"
#import "DLViewController.h"

@interface ClassMainViewController () {
    NSInteger page;
    BOOL isClassType;
    BOOL isScreen;
    
}

@property (nonatomic, strong) UIButton *classTypeButton;
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) NSArray *chooseTypeArray;
@property (nonatomic, strong) NSArray *chooseTitleArray;

@property (nonatomic, strong) UIView *chooseBackView;

@end

@implementation ClassMainViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherID:) name:@"NSNotificationComboClassTypeID" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherButtonType:) name:@"NSNotificationComboClassTypeButton" object:nil];
    //排序规则（default，new，price，price_down）
    _chooseTypeArray = @[@"default",@"new",@"price",@"price_down"];
    _chooseTitleArray = @[@"默认排序",@"最新",@"价格递增",@"价格递减"];
    page = 1;
    _dataSource = [NSMutableArray new];
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"套餐";
    
    _cate_ID = @"0";
    //排序规则（default，new，price，price_down）
    _screeningStr = @"default";
    
    _classTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth / 2.0, 44.5)];
    _classTypeButton.titleLabel.font = Font(14 * WideEachUnit);
    _classTypeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_classTypeButton setTitle:@"全部" forState:UIControlStateNormal];
    [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_classTypeButton];
    [_classTypeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2.0, MACRO_UI_UPHEIGHT, MainScreenWidth / 2.0, 44.5)];
    _chooseButton.titleLabel.font = Font(14 * WideEachUnit);
    _chooseButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_chooseButton setTitle:@"默认排序" forState:UIControlStateNormal];
    [_chooseButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_chooseButton];
    [_chooseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_classTypeButton];
    [self.view addSubview:_chooseButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _classTypeButton.bottom, MainScreenWidth, 0.5)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    
    UICollectionViewFlowLayout *cellLayout = [[UICollectionViewFlowLayout alloc] init];
    cellLayout.itemSize = CGSizeMake((MainScreenWidth - 6) / 2.0, (MainScreenWidth/2.0 - 3 - 20) * 90 / 165.0 + 13 + 7 + 10 + 15 + 13 + 9);
    cellLayout.minimumInteritemSpacing = 6;
    cellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45) collectionViewLayout:cellLayout];
    [_collectionView registerClass:[ClassMainCollectionCell class] forCellWithReuseIdentifier:@"ClassMainCollectionCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView addHeaderWithTarget:self action:@selector(headerRefreshData)];
    [_collectionView addFooterWithTarget:self action:@selector(footerRefreshData)];
    [self.view addSubview:_collectionView];
    [_collectionView headerBeginRefreshing];
    
    _chooseBackView = [[UIView alloc] initWithFrame:CGRectMake(0, line.bottom, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 45)];
    _chooseBackView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
    [self.view addSubview:_chooseBackView];
    _chooseBackView.hidden = YES;
    
    for (int i = 0; i < _chooseTypeArray.count; i++) {
        UILabel *chooseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 40, MainScreenWidth, 40)];
        chooseTypeLabel.userInteractionEnabled = YES;
        chooseTypeLabel.backgroundColor = [UIColor whiteColor];
        chooseTypeLabel.font = Font(14);
        chooseTypeLabel.text = [NSString stringWithFormat:@"   %@",_chooseTitleArray[i]];
        chooseTypeLabel.tag = 666 + i;
        chooseTypeLabel.textColor = [UIColor colorWithHexString:@"#757575"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTypeLabelTap:)];
        [chooseTypeLabel addGestureRecognizer:tap];
        [_chooseBackView addSubview:chooseTypeLabel];
    }
}

// MARK: - 默认排序等点击事件
- (void)chooseTypeLabelTap:(UITapGestureRecognizer *)tap {
    _screeningStr = _chooseTypeArray[tap.view.tag - 666];
    
    NSString *title = _chooseTitleArray[tap.view.tag - 666];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_chooseButton setTitle:title forState:UIControlStateNormal];
    [_chooseButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_chooseButton];
    isScreen = NO;
    _chooseBackView.hidden = !isScreen;
    [self headerRefreshData];
}

- (void)buttonClick:(UIButton *)sender {
    if (sender == _classTypeButton) {
        [_classTypeButton setTitleColor:BasidColor forState:UIControlStateNormal];
        [_classTypeButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
        
        [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        isClassType = !isClassType;
        
        if (isClassType) {
            [_chooseButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
            [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            isScreen = NO;
            _chooseBackView.hidden = !isScreen;
            ComboTypeChooseViewController *vc = [[ComboTypeChooseViewController alloc] init];
            vc.view.frame = CGRectMake(0, MACRO_UI_UPHEIGHT + 45, MainScreenWidth , MainScreenHeight - MACRO_UI_UPHEIGHT - 45);
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        } else {
            //传通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ComboClassTypeRemove" object:@"remove"];
            [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        }
    } else if (sender == _chooseButton) {
        [_chooseButton setTitleColor:BasidColor forState:UIControlStateNormal];
        [_chooseButton setImage:Image(@"ic_packup@3x") forState:UIControlStateNormal];
        
        [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        isScreen = !isScreen;
        _chooseBackView.hidden = !isScreen;
        if (isScreen) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ComboClassTypeRemove" object:@"remove"];
            [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
            [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            isClassType = NO;
        } else {
            [_chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_chooseButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
        }
    }
}

- (void)headerRefreshData {
    page = 1;
    [self getFirstPageData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
        [_collectionView headerEndRefreshing];
    });
}

- (void)footerRefreshData {
    page = page + 1;
    [self getMorePageData];
}
// MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassMainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassMainCollectionCell" forIndexPath:indexPath];
    [cell setClassMainInfo:_dataSource[indexPath.row] cellIndex:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
    vc.combo_id = [NSString stringWithFormat:@"%@",[_dataSource[indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getFirstPageData {
    NSString *endUrlStr = TAOCAN_List;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20"forKey:@"count"];
    [mutabDict setObject:@(page) forKey:@"page"];
    [mutabDict setObject:_cate_ID forKey:@"cateId"];
    [mutabDict setObject:_screeningStr forKey:@"orderBy"];
    
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
        if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject])) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject]];
            if ([[dict objectForKey:@"code"] integerValue]) {
                [_dataSource removeAllObjects];
                [_dataSource addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            }
            if (_dataSource.count<20) {
                [_collectionView setFooterHidden:YES];
            } else {
                [_collectionView setFooterHidden:NO];
            }
        } else {
            
        }
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)getMorePageData {
    NSString *endUrlStr = TAOCAN_List;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20"forKey:@"count"];
    [mutabDict setObject:@(page) forKey:@"page"];
    [mutabDict setObject:_cate_ID forKey:@"cateId"];
    [mutabDict setObject:_screeningStr forKey:@"orderBy"];
    
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
        if (SWNOTEmptyDictionary([YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject])) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject]];
            if ([[dict objectForKey:@"code"] integerValue]) {
                NSArray *pass = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
                [_dataSource addObjectsFromArray:pass];
                if (pass.count<20) {
                    [_collectionView setFooterHidden:YES];
                } else {
                    [_collectionView setFooterHidden:NO];
                }
            } else {
                page--;
            }
        } else {
            page--;
        }
        [_collectionView footerEndRefreshing];
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        page--;
        [_collectionView footerEndRefreshing];
        [_collectionView reloadData];
    }];
    [op start];
}

- (void)getTeacherID:(NSNotification *)not {
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    _cate_ID = dict[@"id"];
    NSString *title = dict[@"title"];
    if (title.length>6) {
        title = [NSString stringWithFormat:@"%@...",[title substringToIndex:4]];
    }
    [_classTypeButton setTitle:title forState:UIControlStateNormal];
    [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    [self dealButtonImageAndTitleUI:_classTypeButton];
    isClassType = NO;
    [self headerRefreshData];
}

- (void)teacherButtonType:(NSNotification *)not {
    [_classTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_classTypeButton setImage:Image(@"ic_dropdown_live@3x") forState:UIControlStateNormal];
    isClassType = NO;
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
