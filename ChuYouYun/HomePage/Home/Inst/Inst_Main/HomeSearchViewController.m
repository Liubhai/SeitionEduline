//
//  HomeSearchViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/28.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "TKProgressHUD+Add.h"
#import "SYGTextField.h"

#import "HomeSearchCell.h"
#import "SearchGetViewController.h"
#import "ClassSearchGoodViewController.h"



@interface HomeSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)SYGTextField *searchText;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *dataSource;
@property (strong ,nonatomic)NSArray *netArray;
@property (strong ,nonatomic)NSArray *headerTitleArray;
@property (strong ,nonatomic)NSMutableArray *divArray;
@property (strong ,nonatomic)NSArray *hotSearchArray;

@property (strong ,nonatomic)UIButton *seletedButton;
@property (strong ,nonatomic)UILabel  *HDLabel;

@end

@implementation HomeSearchViewController

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
    [self addArray];
    [self addNav];
}

- (void)addArray {
    
    _dataArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    _headerTitleArray = @[@"历史记录"];
    _typeStr = @"1";
    [self getDataSource];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _typeStr = @"0";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameAndPassword:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
//    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
//    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setImage:Image(@"ic_back@2x") forState:UIControlStateNormal];
    backButton.titleLabel.font = Font(15);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 47.5, 20, 40, 40)];
    //    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = Font(15 * WideEachUnit);
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:searchButton];
    
    
    //添加分类筛选的按钮
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 61, 30)];
    [typeButton setTitle:@"课程" forState:UIControlStateNormal];
    [typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [typeButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
    typeButton.titleLabel.font = Font(14);
    
    typeButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 20);
    
    typeButton.layer.borderWidth = 1;
    typeButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [typeButton addTarget:self action:@selector(typeButton:) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:typeButton];
    _typeButton = typeButton;
    typeButton.hidden = YES;

    
//    //添加搜索
   _searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(47.5 * WideEachUnit, 20, MainScreenWidth - 95, 36)];
    if (iPhone6Plus) {
        _searchText.frame = CGRectMake(47.5 * WideEachUnit, 20, MainScreenWidth - 105, 36);
    }
    _searchText.placeholder = @"搜课程";
    _searchText.font = Font(14 * WideEachUnit);
    [_searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    [_searchText sygDrawPlaceholderInRect:CGRectMake(0, 10 * WideEachUnit, 0, 0)];
    _searchText.delegate = self;
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.layer.cornerRadius = 18;
    _searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [_searchText.leftView addSubview:button];
    [SYGView addSubview:_searchText];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        _searchText.frame = CGRectMake(47.5 * WideEachUnit, 40, MainScreenWidth - 95, 36);
        searchButton.frame = CGRectMake(MainScreenWidth - 47.5, 40, 40, 40);
    }

}

- (void)addTypeView {
    
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 44 * WideEachUnit)];
    if (iPhoneX) {
        typeView.frame = CGRectMake(0, 88, MainScreenWidth, 44);
    }
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    
    NSArray *typeArray = @[@"点播",@"直播",@"机构",@"老师"];
    
    CGFloat typeW = MainScreenWidth / typeArray.count;
    CGFloat buttonW = MainScreenWidth / typeArray.count;
    CGFloat space = (typeW - buttonW)/ 2;
    space = 0;
    CGFloat buttonH = 44 * WideEachUnit;
    
    for (int i = 0 ; i < typeArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * typeW + space, 5, buttonW, buttonH)];
        [button setTitle:typeArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(16 * WideEachUnit);
        [button setTitleColor:BasidColor forState:UIControlStateSelected];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
//        button.layer.cornerRadius = 5;
//        button.layer.borderWidth = 1;
//        button.layer.masksToBounds = YES;
//        button.layer.borderColor = BasidColor.CGColor;
        button.tag = 521 + i;
        
        [typeView addSubview:button];
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [self typeButtonClick:button];
        }
        
    }
    
    //添加滑块
    _HDLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonW / 2 - 16 * WideEachUnit, 43 * WideEachUnit, 32 * WideEachUnit, 1 * WideEachUnit)];
    _HDLabel.backgroundColor = BasidColor;
    [typeView addSubview:_HDLabel];
    _HDLabel.hidden = YES;
    
    
}


- (void)typeButtonClick:(UIButton *)button {

    self.seletedButton.selected = NO;
//    self.seletedButton.backgroundColor = [UIColor whiteColor];
    button.selected = YES;
//    button.backgroundColor = BasidColor;
    self.seletedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
//        _HDLabel.frame = CGRectMake(MainScreenWidth / 4 *( button.tag - 520) - 16 * WideEachUnit, 43 * WideEachUnit, 32 * WideEachUnit, 1 * WideEachUnit);
    }];

    _typeStr = [NSString stringWithFormat:@"%ld",button.tag - 520];
    if (button.tag == 521) {//课程
        
    } else if (button.tag == 522){//直播
        
    } else if (button.tag == 523) {//老师
        
    } else if (button.tag == 524) {//机构
        
    }


}



- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 170)];
    _headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headerView];
    _headerView.hidden = NO;
    
    //添加 文本
    UILabel *hotL = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside * WideEachUnit, MainScreenWidth, 20 * WideEachUnit)];
    hotL.text = @"热词搜索";
    hotL.font = Font(14 * WideEachUnit);
    hotL.textColor = [UIColor grayColor];
    [_headerView addSubview:hotL];
    
    //添加热门学科
    CGFloat ButtonW = (MainScreenWidth - 4 * SpaceBaside * WideEachUnit ) / 3;
    CGFloat ButtonH = 40 * WideEachUnit;
//    NSArray *titleArray = @[@"小学",@"初中",@"高中",@"大学",@"英语",@"数学",@"舞蹈",@"瑜伽",@"职业"];
    for (int i = 0 ; i < _hotSearchArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SpaceBaside + ButtonW) * (i % 3), 35 * WideEachUnit + (ButtonH + SpaceBaside) * (i / 3), ButtonW, ButtonH)];
        [button setTitle:_hotSearchArray[i][@"sk_name"] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(14 * WideEachUnit);
        [_headerView addSubview:button];
        [button addTarget:self action:@selector(headerButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    //设置头部的大小
    if (_hotSearchArray.count % 3 == 0) {
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit * (_hotSearchArray.count / 3) + 20 * WideEachUnit);
        if (_hotSearchArray.count == 0) {
            _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit * (_hotSearchArray.count / 3) + 40 * WideEachUnit);
        }

    } else {
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit * (_hotSearchArray.count / 3 + 1) + 20 * WideEachUnit);
    }
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SpaceBaside * WideEachUnit, 64, MainScreenWidth - 2 * SpaceBaside * WideEachUnit, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(SpaceBaside * WideEachUnit, 88, MainScreenWidth - 2 * SpaceBaside * WideEachUnit, MainScreenHeight - 88);
    }
    _tableView.rowHeight = 50 * WideEachUnit;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headerView;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_dataArray.count) {
        return @"搜索所得";
    }
    
    return nil;
    return _headerTitleArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_dataSource.count) {
        return 0;
    }
    NSArray *array = _dataSource[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit, 40 * WideEachUnit)];
    hearView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 20 * WideEachUnit, 40 * WideEachUnit)];
    title.text = @"历史搜索";
    title.textColor = [UIColor grayColor];
    title.font = Font(14 * WideEachUnit);
    [hearView addSubview:title];
    
    return hearView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    //自定义cell类
    HomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[HomeSearchCell alloc] initWithReuseIdentifier:CellID];
    }

    
    if (!_dataArray.count && !_netArray.count) {
        
        cell.contentLabel.text = _dataSource[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            if (indexPath.row == _divArray.count - 1) {
                cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            }
        }

    } else {
        
        cell.contentLabel.text = _dataSource[indexPath.section][indexPath.row][@"video_title"];
        
        NSLog(@"dic---%@",_divArray);
        if (indexPath.section == 1) {
            if (indexPath.row == _divArray.count - 1) {
                cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            }
        } else if (indexPath.section == 0) {
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        }

    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (!_dataArray.count) {
        if (indexPath.row == _divArray.count - 1) {//清除缓存
            [self removeBenDi];
            return;
        }
    } else {//有推荐
        if (indexPath.section == 0) {//推荐的
            [self readIn];
        } else {
            if (indexPath.row == _divArray.count - 1) {//清除缓存
                [self removeBenDi];
                return;
            }
        }
    }

    NSLog(@"%@",_typeStr);
    ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
    searchGetVc.typeStr = _typeStr;
    if (_netArray.count) {
        searchGetVc.searchStr = _dataSource[indexPath.section][indexPath.row][@"video_title"];
    } else {
        searchGetVc.searchStr = _dataSource[indexPath.section][indexPath.row];
    }

    [self.navigationController pushViewController:searchGetVc animated:YES];

}


#pragma mark --- 事件监听

- (void)backPressed {
    
     [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark --- UITextField

- (void)nameAndPassword:(NSNotification *)Not {

    //这里随时进行网络请求

    if (_searchText.text.length > 0) {
//        for (int i = 0 ; i < 3 ; i ++) {
//            [_dataArray addObject:_searchText.text];
//        }
//        [_dataSource removeAllObjects];
//        
//        [_dataSource addObject:_dataArray];

    } else if (_searchText.text.length == 0) {//没有的时候
        //置空数据
        _netArray = nil;
        [_dataSource removeAllObjects];
        [self getDataSource];
    }
    
    [_tableView reloadData];
}

- (void)getDataSource {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    NSArray *lookArray = [NSArray arrayWithContentsOfFile:plistPath];
    lookArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *divArray = [NSMutableArray arrayWithArray:lookArray];
    _divArray = divArray;
    if (divArray.count) {//当存储有值时 就在
        [divArray addObject:@"清除搜索历史"];
    }
    
    for (int i = 0 ; i < 1; i ++) {
        [_dataSource addObject:divArray];
    }
    [_tableView reloadData];

}

//存数据
- (void)readIn {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    NSMutableArray *seekArray = [NSMutableArray arrayWithContentsOfFile:plistPath];

    if (!seekArray.count) {//说明是第一次
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:_searchText.text];
        [div writeToFile:plistPath atomically:YES];
   
    } else {
        for ( NSString *key in seekArray) {
            
            if ([key isEqualToString:_searchText.text]) {//有数据不保存
                return;
            }
        }
        
        if (_searchText.text.length == 0) {
            return;
        }
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:_searchText.text];
        [div writeToFile:plistPath atomically:YES];
        
    }

}

- (void)readInWithButton:(UIButton *)button {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    NSMutableArray *seekArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    if (!seekArray.count) {//说明是第一次
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:button.titleLabel.text];
        [div writeToFile:plistPath atomically:YES];
        
    } else {
        
        for (NSString *key in seekArray) {
            if ([key isEqualToString:button.titleLabel.text]) {//有数据不保存
                return;
            }
        }
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:button.titleLabel.text];
        [div writeToFile:plistPath atomically:YES];
  
    }

}


- (void)removeBenDi {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *caches = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    [manager removeItemAtPath:caches error:nil];
    [_divArray removeAllObjects];
    [_tableView reloadData];
    
}

#pragma mark --- 事件监听

- (void)typeButton:(UIButton *)button {
    [self addMoreView];
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];

    //创建个VIew
    _buyView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, 100, 0)];
    _buyView.backgroundColor = BasidColor;
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //改变位置 动画
        _buyView.frame = CGRectMake(10 ,64 ,100, 128);
        
        //在view上面添加东西
        NSArray *GDArray = @[@"课程",@"机构",@"老师"];
        for (int i = 0 ; i < GDArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:GDArray[i] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = 521 + i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
    }];
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(10, 64, 100, 0);
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
 
}

- (void)SYGButton:(UIButton *)button {
    [_typeButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    _typeStr = [NSString stringWithFormat:@"%ld",(long)button.tag - 520];
    [self miss];
    if (button.tag == 521) {//课程
        
        
    } else if (button.tag == 522){//老师
        _typeStr = @"4";
        
    } else if (button.tag == 523) {//机构
        
    }
    
    
}

- (void)headerButton:(UIButton *)button {

    ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
    searchGetVc.searchStr = button.titleLabel.text;
    searchGetVc.typeStr = _typeStr;
    [self.navigationController pushViewController:searchGetVc animated:YES];
    
    //添加记录
    [self readInWithButton:button];
}

- (void)searchButtonPressed {
    NSLog(@"123");
    //点搜索按钮
    if (_searchText.text.length > 0) {
        //将数据存在本地
        [self readIn];
        ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
        searchGetVc.searchStr = _searchText.text;
        searchGetVc.typeStr = _typeStr;
        [self.navigationController pushViewController:searchGetVc animated:YES];
    } else {
        [TKProgressHUD showError:@"请输入要搜索的内容" toView:self.view];
        return;
    }
}

#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    if (_searchText.text.length > 0) {
        //将数据存在本地
        [self readIn];
        ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
        searchGetVc.searchStr = _searchText.text;
        searchGetVc.typeStr = _typeStr;
        [self.navigationController pushViewController:searchGetVc animated:YES];
    }
    
    [textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchText resignFirstResponder];
}


#pragma mark --- 网络请求


@end
