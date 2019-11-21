//
//  InstCourseViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstCourseViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "Passport.h"

//#import "PaiKeTableViewCell.h"
#import "InstCourseCell.h"
#import "SchedulingCell.h"
#import "MyHttpRequest.h"
#import "Passport.h"
#import "TKProgressHUD+Add.h"
#import "CalendarViewController.h"




@interface InstCourseViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    NSArray *_menuarr;
    UIButton *menubtn;
    int numsender;
    int tempNumber;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *lookArray;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)UIScrollView *headScrollow;
@property (strong ,nonatomic)NSArray *mornAndAfterArray;


///顶部btn集合
@property (strong, nonatomic) NSArray *btns;
@property (strong ,nonatomic)NSString *timeSp;
@property (strong ,nonatomic)NSMutableArray *dayArray;
@property (strong ,nonatomic)NSMutableArray *timeSpArray;

@property (strong ,nonatomic)NSMutableArray *mornArray;
@property (strong ,nonatomic)NSMutableArray *afterArray;

@property (strong ,nonatomic)UIButton *dateButton;

@end

@implementation InstCourseViewController


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
    [self addNotication];
    [self addNav];
    [self getTime];
    [self addscrollow];
    [self addTableView];
    
}

-  (void)addNotication {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDate:) name:@"NSNotificationGetDate" object:nil];
    
}

#pragma mark --- 通知

- (void)getDate:(NSNotification *)not {
    
    NSLog(@"%@",not.object);
    NSString *timeStr = not.object;
    
    //设置按钮的日期
    [_dateButton setTitle:timeStr forState:UIControlStateNormal];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSLog(@"%@",formatter);
    
     NSDate *date = [formatter dateFromString:timeStr];
     NSLog(@"%@",date);
    
//    NSString *timeSp = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    

}

-(void)addscrollow{
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,66, MainScreenWidth,40*MainScreenWidth/375)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
    
}
- (void)addTableView {
//    _headScrollow.current_y_h+15*MainScreenWidth/375 - 10
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - _headScrollow.current_y_h-15) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 90 *horizontalrate;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
}
#pragma mark -- UITableViewDatasoure

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _mornAndAfterArray[section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArray.count == 0) {
        return 0;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArray.count == 0) {
        return 0;
    }
    NSArray *numArray = _dataArray[section];
    return numArray.count;
    
//    return _dataArray.count;
//    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * cellStr = @"WDTableViewCell";
    SchedulingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[SchedulingCell alloc] initWithReuseIdentifier:cellStr];
    }
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    [cell dataWithDict:dict];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
    //classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
    //classDVc.isLoad = @"123";
    // [self.navigationController pushViewController:classDVc animated:YES];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    _timeSpArray = [NSMutableArray array];
    _dayArray = [NSMutableArray array];
    _mornArray = [NSMutableArray array];
    _afterArray = [NSMutableArray array];
    _mornAndAfterArray = @[@"上午",@"下午"];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 25, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,106)];
//    [backButton setTitle:@"排课" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
//    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    //设置button上字体的偏移量
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"排课";
    title.font = Font(20);
    title.textColor = [UIColor whiteColor];
    [SYGView addSubview:title];
    
    NSDate *dateNow = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:dateNow];
    
    
    UIButton *dateButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 110, 25, 100, 30)];
    [dateButton setTitle:dateString forState:UIControlStateNormal];
    [dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SYGView addSubview:dateButton];
    [dateButton addTarget:self action:@selector(dateButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    _dateButton = dateButton;
    
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getTime {
    
    NSDate *dateNow = [NSDate date];
    _timeSp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    //获取最近5天的
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    for (int i = 0 ; i < 5 ; i ++) {
        NSDate* theDate;
        theDate = [dateNow initWithTimeIntervalSinceNow: +oneDay*i];
        NSString *dateStr = [NSString stringWithFormat:@"%@",theDate];
        NSString *dayStr = [dateStr substringWithRange:NSMakeRange(5, 5)];
//        NSLog(@"--%@",dayStr);
        [_dayArray addObject:dayStr];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[theDate timeIntervalSince1970]];
        [_timeSpArray addObject:timeSp];
    }
}

-(void)creatMenu{
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    _menuarr = [NSArray arrayWithObjects:@"10月12日",@"10月12日",@"10月12日",@"10月12日", @"10月12日",nil];
    
    _menuarr = _dayArray;
    
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    for (int i=0; i<_menuarr.count; i++) {
        menubtn = [[UIButton alloc]init];
        menubtn.frame = CGRectMake(65*horizontalrate*i+(i+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), 0, 65*horizontalrate, 40*MainScreenWidth/375);
        [menubtn setTitle:_menuarr[i] forState:UIControlStateNormal];
        [_headScrollow addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:15*MainScreenWidth/375];
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
    }
    self.btns = [marr copy];
    int tempNum;
    tempNum = (int)_menuarr.count;
    _headScrollow.contentSize = CGSizeMake(65*horizontalrate*tempNum+(tempNum+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), _headScrollow.bounds.size.height);
    
}
-(void)change:(UIButton *)button{
    
    int tempNum;
    tempNum = (int)_menuarr.count;
    //请求数据
    //    [self requestData:tempNum andTimespan:@""];
    for (int i=0; i<_menuarr.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    numsender = (int)button.tag-100;
    if (numsender>1) {
        if (numsender == 2) {
            if (numsender > tempNumber) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    _headScrollow.contentOffset = CGPointMake(65*horizontalrate*1+(0+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), 0);
                    [button setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
                }];
                
            }else if (numsender < tempNumber){
                [UIView animateWithDuration:0.2 animations:^{
                    _headScrollow.contentOffset = CGPointMake(0, 0);
                    [button setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
                }];
            }
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [button setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
            //_headScrollow.contentOffset = CGPointMake(65*horizontalrate*1+(0+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), 0);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            [button setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
            _headScrollow.contentOffset = CGPointMake(0, 0);
            
        }];
    }
    tempNumber = numsender;
    
    //网络请求
    NSLog(@"%@",_dataArray);
    if (_dataArray.count == 0) {
        
    } else {
        [_dataArray removeAllObjects];
    }
    
    if (_mornArray.count != 0) {
        [_mornArray removeAllObjects];
    }
    
    if (_afterArray.count != 0) {
        [_afterArray removeAllObjects];
    }

//    NSString *timeSp = _timeSpArray[tempNumber];
    
}

- (void)dateButtonCilck:(UIButton *)button {
    CalendarViewController *calendVc = [[CalendarViewController alloc] init];
    calendVc.schoolID = _schoolID;
    [self.navigationController pushViewController:calendVc animated:YES];
    
}

#pragma mark --- 网络请

@end
