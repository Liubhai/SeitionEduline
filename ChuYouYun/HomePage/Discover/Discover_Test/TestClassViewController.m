//
//  TestClassViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestClassViewController.h"
#import "BigWindCar.h"
#import "SYG.h"

@interface TestClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UIView      *tabView;//放表格的视图
@property (strong, nonatomic)UITableView *oneTableView;
@property (strong ,nonatomic)UITableView *twoTableView;
@property (strong ,nonatomic)UITableView *thereTableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *oneTableArray;
@property (strong ,nonatomic)NSMutableArray *twoTableArray;
@property (strong ,nonatomic)NSMutableArray *thereTableArray;

@property (strong ,nonatomic)NSMutableArray *oneSeleArray;
@property (strong ,nonatomic)NSMutableArray *twoSeleArray;
@property (strong ,nonatomic)NSMutableArray *thereSeleArray;

@end

@implementation TestClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addAllView];
    [self addTabView];
    [self addClearButton];
//    [self netWorkGetCateList];
//    [self NetWorkGetSubjectCategory];
    [self netWorkExamsGetCategory];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    _dataArray = [NSMutableArray array];
    _oneTableArray = [NSMutableArray array];
    _twoTableArray = [NSMutableArray array];
    _thereTableArray = [NSMutableArray array];
    
    _oneSeleArray = [NSMutableArray array];
    _twoSeleArray = [NSMutableArray array];
    _thereSeleArray = [NSMutableArray array];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"TestClassTypeRemove" object:nil];
}

- (void)addAllView {
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 4 * 40)];
    _tabView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    _tabView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tabView];
}

- (void)addTabView {
    CGFloat tableViewW = MainScreenWidth / 3;
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 4 * 40) style:UITableViewStyleGrouped];
    _oneTableView.backgroundColor = [UIColor whiteColor];
    _oneTableView.dataSource = self;
    _oneTableView.delegate = self;
    _oneTableView.rowHeight = 40 * WideEachUnit;
    _oneTableView.tag = 1;
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _oneTableView.showsVerticalScrollIndicator = NO;
    _oneTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_oneTableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_oneTableView];
    }
    
    
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewW + MainScreenWidth, 0, tableViewW, MainScreenHeight - 64 - 245 * WideEachUnit) style:UITableViewStyleGrouped];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.rowHeight = 40 * WideEachUnit;
    _twoTableView.tag = 2;
    _twoTableView.backgroundColor = [UIColor colorWithHexString:@"@f9f9f9"];
    _twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _twoTableView.showsVerticalScrollIndicator = NO;
    _twoTableView.showsHorizontalScrollIndicator = NO;
    [_tabView addSubview:_twoTableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_twoTableView];
    }
    
    _thereTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewW * 2 + MainScreenWidth, 0, tableViewW, MainScreenHeight - 64 - 245 * WideEachUnit) style:UITableViewStyleGrouped];
    _thereTableView.delegate = self;
    _thereTableView.dataSource = self;
    _thereTableView.rowHeight = 40 * WideEachUnit ;
    _thereTableView.tag = 3;
    _thereTableView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    _thereTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _thereTableView.showsVerticalScrollIndicator = NO;
    _thereTableView.showsHorizontalScrollIndicator = NO;
    [_tabView addSubview:_thereTableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_thereTableView];
    }
    
    //初始化
    _oneTableView.hidden = NO;
    _twoTableView.hidden = YES;
    _thereTableView.hidden = YES;
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 160, MainScreenWidth, MainScreenHeight - 160 - 109)];
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_oneTableView == tableView) {
        return _dataArray.count;
    } else if (_twoTableView == tableView) {
        return _twoTableArray.count;
    } else if (_thereTableView == tableView) {
        return _thereTableArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _oneTableView) {
        static NSString *CellID = @"cellClassOne";
        //自定义cell类
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"title"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#757575"];
        cell.textLabel.font = Font(14);
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.selectedBackgroundView.backgroundColor =  [UIColor redColor];
        
        if ([_oneSeleArray[indexPath.row] integerValue] == 0) {
            
        } else {
            cell.textLabel.textColor = BasidColor;
            cell.backgroundColor =  [UIColor colorWithHexString:@"#f9f9f9"];
        }
        
        return cell;
    } else if (tableView == _twoTableView) {
        static NSString *CellID = @"cellClassTwo";
        //自定义cell类
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        cell.textLabel.text = [[_twoTableArray objectAtIndex:indexPath.row] stringValueForKey:@"title"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#757575"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = Font(14);
        
        if ([_twoSeleArray[indexPath.row] integerValue] == 0) {
            
        } else {
            cell.textLabel.textColor = BasidColor;
            cell.backgroundColor =  [UIColor colorWithHexString:@"#f4f4f4"];
        }
        
        return cell;
    } else if (tableView == _thereTableView) {
        static NSString *CellID = @"cellClassThere";
        //自定义cell类
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        cell.textLabel.text = [[_thereTableArray objectAtIndex:indexPath.row] stringValueForKey:@"title"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#757575"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = Font(14);
        return cell;
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_oneTableView == tableView) {//点击一级分类的时候
        _oneTableView.hidden = NO;
        _twoTableView.hidden = NO;
        _thereTableView.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _oneTableView.frame = CGRectMake(0, 0, MainScreenWidth / 2, 160);
            _twoTableView.frame = CGRectMake(MainScreenWidth / 2, 0, MainScreenWidth / 2, MainScreenHeight - 245 * WideEachUnit - 64);
            _thereTableView.frame = CGRectMake(MainScreenWidth / 3 * 2 + MainScreenWidth, 0, MainScreenWidth / 3, MainScreenHeight - 245 * WideEachUnit - 64);
        }];
        
        //数据分析
        if ([[_dataArray objectAtIndex:indexPath.row] arrayValueForKey:@"child"] == nil) {
            NSDictionary *dict = _dataArray[indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTestClassTypeID" object:dict];
            [self removeSelfView];
            return;
        }
        
        //点击处理
        [_oneSeleArray removeAllObjects];
        for (int i = 0 ; i < _dataArray.count ; i ++) {
            if (i == indexPath.row) {
                [_oneSeleArray addObject:@"1"];
            } else {
                [_oneSeleArray addObject:@"0"];
            }
        }
        
        NSLog(@"%@",_oneSeleArray);
        
        [_oneTableView reloadData];
        _twoTableArray = _dataArray[indexPath.row][@"child"];
        for (int i = 0 ;i < _twoTableArray.count ; i ++) {
            [_twoSeleArray addObject:@"0"];
        }
        _twoTableView.frame = CGRectMake(MainScreenWidth / 2, 0, MainScreenWidth / 2, _twoTableArray.count * 40);
        [_twoTableView reloadData];
        
    } else if (_twoTableView == tableView) {

        
        
        if ([[_twoTableArray objectAtIndex:indexPath.row] arrayValueForKey:@"child"] == nil) {//说明只有2级
            NSDictionary *dict = _twoTableArray[indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTestClassTypeID" object:dict];
            [self removeSelfView];
        } else {
            _oneTableView.hidden = NO;
            _twoTableView.hidden = NO;
            _thereTableView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                _oneTableView.frame = CGRectMake(0, 0, MainScreenWidth / 3, _oneTableView.frame.size.height);
                _twoTableView.frame = CGRectMake(MainScreenWidth / 3, 0, MainScreenWidth / 3, _twoTableView.frame.size.height);
                _thereTableView.frame = CGRectMake(MainScreenWidth / 3 * 2, 0, MainScreenWidth / 3, MainScreenHeight - 200 - 109);
            }];
            
            //点击处理
            [_twoSeleArray removeAllObjects];
            for (int i = 0 ; i < _twoTableArray.count ; i ++) {
                if (i == indexPath.row) {
                    [_twoSeleArray addObject:@"1"];
                } else {
                    [_twoSeleArray addObject:@"0"];
                }
            }
            
            [_twoTableView reloadData];
            _thereTableArray = _twoTableArray[indexPath.row][@"child"];
            [_thereTableView reloadData];
        }
        
    } else if (_thereTableView == tableView) {//点击三级分类
        //通知
        //        [self.view removeFromSuperview];
        NSDictionary *dict = _thereTableArray[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTestClassTypeID" object:dict];
        [self removeSelfView];
        
    }
    
}

#pragma mark --- 事件点击
- (void)clearButtonCilck:(UIButton *)button {
    [self removeSelfView];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//   [self.view removeFromSuperview];
//}

#pragma mark --- 通知
-(void)removeSelfView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationTestClassTypeButton" object:nil];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark --- 网络请求

#pragma mark --- 网络请求
//获取考试里面的分类
- (void)NetWorkGetSubjectCategory {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [manager BigWinCar_GetPublicWay:dic mod:@"Exams" act:@"getSubjectCategory" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = [responseObject arrayValueForKey:@"data"];
            for (int i = 0 ; i < _dataArray.count ; i ++) {
                [_oneSeleArray addObject:@"0"];
            }
            [_oneTableView reloadData];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//获取考试的分类
- (void)netWorkExamsGetCategory {
    NSString *endUrlStr = YunKeTang_Exams_exams_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"50" forKey:@"count"];
    
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
        _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        for (int i = 0 ; i < _dataArray.count ; i ++) {
            [_oneSeleArray addObject:@"0"];
        }
        [_oneTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
