//
//  MemberCenterViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/10/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "OpenMemberViewController.h"
#import "ZhiBoMainViewController.h"
#import "ClassSearchGoodViewController.h"
#import "Good_ClassMainViewController.h"
#import "DLViewController.h"


@interface MemberCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UIButton *seleButton;//会员等级的选中按钮 （cell中）
    BOOL isRefresh;
    NSInteger seleNumber;//当前选中的按钮的个数
}

@property (strong ,nonatomic)UITableView      *tableView;
@property (strong ,nonatomic)UIView           *headerView;

@property (strong ,nonatomic)NSArray          *VipListArray;//会员等级的数组
@property (strong ,nonatomic)NSArray          *getNewUserVipListArray;//最新会员等级的数组
@property (strong ,nonatomic)NSString         *currentVipIdStr;
@property (assign ,nonatomic)NSInteger        currentUserVipNumber;//当前用户在会员等级中的位置
@property (strong ,nonatomic)NSArray          *currentVipCourseArray;//当前会员等级享受的课程

@property (strong ,nonatomic)UIButton         *openMemberButton;
@property (strong ,nonatomic)NSString         *order_switch;



@end

@implementation MemberCenterViewController

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
//    [self addHeaderView];
//    [self addTableView];
    
//    [self NetWorkGetUserVipList];
    [self netWorkUserGetUserVipList];
    [self netWorkConfigGetMarketStatus];
    
//    [self addMoneyView];
//    [self addRechargeView];
//    [self addPayView];
//    [self addDownView];
//    [self NetWorkAccount];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    isRefresh = NO;
    seleNumber = 0;
    _currentUserVipNumber = 0;
    
    NSLog(@"%@",_vipDict);
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"会员中心";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        
    }
    
}

#pragma mark --- 添加表格的头视图
- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 430 * WideEachUnit)];
    if (iPhoneX) {
        _headerView.frame = CGRectMake(0, 88, MainScreenWidth, 430);
    }
    _headerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_headerView];
    
    UIView *informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 110 * WideEachUnit)];
    informationView.backgroundColor = BasidColor;
    [_headerView addSubview:informationView];
    
    //添加用户名
    UILabel *userName = [[UILabel  alloc] initWithFrame:CGRectMake( 20 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 40, 20 * WideEachUnit)];
    userName.text = _userName;
    [userName setTextColor:[UIColor colorWithHexString:@"#fff"]];
    userName.font = [UIFont systemFontOfSize:18 * WideEachUnit];
    userName.textAlignment = NSTextAlignmentCenter;
    [informationView addSubview:userName];
    
    //添加好处
    UILabel *advantage = [[UILabel  alloc] initWithFrame:CGRectMake( 20 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 40, 15 * WideEachUnit)];
    if ([[_vipDict stringValueForKey:@"vip_type"] integerValue] == 0) {
        advantage.text = @"开通享会员专享免费课程";
    } else {
        advantage.text = [NSString stringWithFormat:@"到期时间：%@",[Passport formatterDate:[_vipDict stringValueForKey:@"vip_expire"]]];
    }
    [advantage setTextColor:[UIColor colorWithHexString:@"#fff"]];
    advantage.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    advantage.textAlignment = NSTextAlignmentCenter;
    [informationView addSubview:advantage];
    
    //添加开通会员的按钮
    UIButton *openMemberButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 65 * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit)];
    if ([[_vipDict stringValueForKey:@"vip_type"] integerValue] == 0) {
        [openMemberButton setTitle:@"开通会员" forState:UIControlStateNormal];
    } else {
        [openMemberButton setTitle:@"升级／续费" forState:UIControlStateNormal];
    }

    openMemberButton.titleLabel.font = Font(14 * WideEachUnit);
    openMemberButton.backgroundColor = [UIColor colorWithHexString:@"#f65549"];
    openMemberButton.layer.cornerRadius = 5 * WideEachUnit;
    [openMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openMemberButton addTarget:self action:@selector(openMemberButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [informationView addSubview:openMemberButton];
    _openMemberButton = openMemberButton;
    
    
    
    UIView *memberTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 110 * WideEachUnit, MainScreenWidth, 320 * WideEachUnit)];
    memberTypeView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:memberTypeView];
    
    //添加会员类型
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit)];
    [imageButton setImage:Image(@"vip_line@3x") forState:UIControlStateNormal];
    [memberTypeView addSubview:imageButton];
    
    //添加会员类型字段
    UILabel *Member = [[UILabel  alloc] initWithFrame:CGRectMake(0, 20 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit)];
    Member.text = @"会员类型";
    [Member setTextColor:[UIColor blackColor]];
    Member.font = [UIFont systemFontOfSize:18 * WideEachUnit];//因为图的原因 这里是不是应该吧字断的大小固定呢
    Member.textAlignment = NSTextAlignmentCenter;
    [memberTypeView addSubview:Member];
    
    CGFloat viewW = 110 * WideEachUnit;
    CGFloat viewH = viewW;
//    NSArray *titleArray = @[@"青铜会员",@"白银会员",@"黄金会员",@"白金会员",@"钻石会员"];
//    NSArray *imageArray = @[@"bronze@3x",@"silver@3x",@"gold@3x",@"platinum@3x",@"diamond@3x",@"diamond@3x"];
    
    for (int i = 0 ; i < _VipListArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12.5 * WideEachUnit + (i % 3) * (viewW + 10 * WideEachUnit), 70 * WideEachUnit + (i / 3) * (viewH + 22 * WideEachUnit), viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
//        view.layer.cornerRadius = 5 * WideEachUnit;
//        view.layer.masksToBounds = NO;
//        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//        view.layer.borderWidth = 1 * WideEachUnit;
        view.tag = i;
        [memberTypeView addSubview:view];
        
        
        //添加透明的uilbel
        UILabel *clearLabel = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        clearLabel.layer.cornerRadius = 5 * WideEachUnit;
        clearLabel.layer.masksToBounds = NO;
        clearLabel.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        clearLabel.layer.borderWidth = 1 * WideEachUnit;
        [view addSubview:clearLabel];
        
        
        //添加图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(35 * WideEachUnit, -15 * WideEachUnit, 40 * WideEachUnit, 40 * WideEachUnit)];
        NSString *urlStr = [[_VipListArray objectAtIndex:i] stringValueForKey:@"cover" defaultValue:@""];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        imageView.layer.cornerRadius = 20 * WideEachUnit;
        imageView.layer.masksToBounds = YES;
        [view addSubview:imageView];
        [imageView bringSubviewToFront:view];
        
        
        //添加等级的名字
        UILabel *memberName = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 35 * WideEachUnit, viewW - 20 * WideEachUnit, 20 * WideEachUnit)];
        memberName.text = [[_VipListArray objectAtIndex:i] stringValueForKey:@"title"];
        [memberName setTextColor:[UIColor colorWithHexString:@"#333"]];
        memberName.font = [UIFont systemFontOfSize:16 * WideEachUnit];
        memberName.textAlignment = NSTextAlignmentCenter;
        [view addSubview:memberName];
        
        //添加每个月多少钱
        UILabel *monthMoney = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 60 * WideEachUnit, viewW - 20 * WideEachUnit, 20 * WideEachUnit)];
        NSString *money = [NSString stringWithFormat:@"%@育币／月",[[_VipListArray objectAtIndex:i] stringValueForKey:@"vip_month"]];
        [monthMoney setTextColor:[UIColor colorWithHexString:@"#656565"]];
        monthMoney.font = [UIFont systemFontOfSize:10 * WideEachUnit];
        monthMoney.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *mutal = [[NSMutableAttributedString alloc] initWithString:money];
        [mutal addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(0, money.length - 4)];
        monthMoney.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutal];
        [view addSubview:monthMoney];
        
        //添加每年多少钱
        UILabel *yearMoney = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 80 * WideEachUnit, viewW - 20 * WideEachUnit, 20 * WideEachUnit)];
        NSString *yearMoneyString = [NSString stringWithFormat:@"%@育币／年",[[_VipListArray objectAtIndex:i] stringValueForKey:@"vip_year"]];
        [yearMoney setTextColor:[UIColor colorWithHexString:@"#656565"]];
        yearMoney.font = [UIFont systemFontOfSize:10 * WideEachUnit];
        yearMoney.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *yearMutal = [[NSMutableAttributedString alloc] initWithString:yearMoneyString];
        [yearMutal addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(0, yearMoneyString.length - 4)];
        yearMoney.attributedText = [[NSAttributedString alloc] initWithAttributedString:yearMutal];
        [view addSubview:yearMoney];
        
        //添加手势
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)]];
        
        memberTypeView.frame = CGRectMake(0, 110 * WideEachUnit, MainScreenWidth, CGRectGetMaxY(view.frame) + 20 * WideEachUnit);
        
    }
    
    //最终确定视图的大小
    _headerView.frame = CGRectMake(0, 64, MainScreenWidth, CGRectGetMaxY(memberTypeView.frame));
    
}

#pragma mark --- 添加表格
- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_currentVipCourseArray.count % 2 == 0) {
            return 80 * WideEachUnit + 170 * WideEachUnit * (_currentVipCourseArray.count / 2) + 50 * WideEachUnit;
        } else {
            return 80 * WideEachUnit + 170 * WideEachUnit * (_currentVipCourseArray.count / 2 + 1) + 50 * WideEachUnit;
        }

    } else if (indexPath.section == 1) {
        return 160 * WideEachUnit;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1 * WideEachUnit;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    //添加会员类型
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit)];
    [imageButton setImage:Image(@"vip_line@3x") forState:UIControlStateNormal];
    [cell addSubview:imageButton];
    
    //添加会员类型字段
    UILabel *Member = [[UILabel  alloc] initWithFrame:CGRectMake(0, 15 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit)];
    Member.text = @"会员特权";
    if (indexPath.section == 1) {
        Member.text = @"最新会员";
    }
    [Member setTextColor:[UIColor blackColor]];
    Member.font = [UIFont systemFontOfSize:18 * WideEachUnit];//因为图的原因 这里是不是应该吧字断的大小固定呢
    Member.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:Member];
    
    if (indexPath.section == 0) {
        
//        NSArray *titleArray = @[@"青铜",@"白银",@"黄金",@"白金",@"钻石"];
        
        UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 25 * WideEachUnit)];
        [cell addSubview:cellScrollView];
        
        
        CGFloat buttonW = 60 * WideEachUnit;
        CGFloat buttonH = 25 * WideEachUnit;
        CGFloat space = (MainScreenWidth - buttonW * _VipListArray.count - 20 * WideEachUnit) / (_VipListArray.count - 1);
        if (_VipListArray.count == 1) {
            space = 10;
        }
//        
//        CGFloat space = 10 * WideEachUnit;
//        CGFloat buttonW = (MainScreenWidth - (_VipListArray.count + 1) * space) / _VipListArray.count;
//        CGFloat buttonH = 25 * WideEachUnit;
        
        for (int i = 0; i < _VipListArray.count ; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + (buttonW + space) * i, 0 * WideEachUnit, buttonW, buttonH)];
            [button setTitle:[[_VipListArray objectAtIndex:i] stringValueForKey:@"title"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = Font(13 * WideEachUnit);
            button.layer.cornerRadius = buttonH / 2;
            button.layer.masksToBounds = YES;
            button.tag = i;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
            [cellScrollView addSubview:button];
            cellScrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 25 * WideEachUnit);
            
            if (isRefresh) {
                if (i == seleNumber) {
                    button.selected = YES;
                    button.backgroundColor = BasidColor;
                }
            } else {
                if (i == 0) {
                    [self buttonCilck:button];
                }
            }
        
        }
        
        CGFloat viewW = 172.5 * WideEachUnit;
        CGFloat viewH = 160 * WideEachUnit;
        CGFloat imageViewW = 172.5 * WideEachUnit;
        CGFloat imgaeViewH = 110 * WideEachUnit;
        
        for (int i = 0 ; i < _currentVipCourseArray.count ; i ++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit + (i % 2) * (viewW + 10 * WideEachUnit), 80* WideEachUnit + (i / 2) * (viewH + 10 * WideEachUnit), viewW, viewH)];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 3 * WideEachUnit;
            view.layer.masksToBounds = YES;
            view.tag = i;
            [cell addSubview:view];
            
            //添加图像
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,imageViewW, imgaeViewH)];
            NSString *urlStr = [[_currentVipCourseArray objectAtIndex:i] stringValueForKey:@"imageurl"];
            [cellImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
            [view addSubview:cellImageView];
            
            //添加名字
            UILabel *cellName = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 115 * WideEachUnit, viewW - 20 * WideEachUnit, 20 * WideEachUnit)];
            cellName.text = [[_currentVipCourseArray objectAtIndex:i] stringValueForKey:@"video_title"];
            [cellName setTextColor:[UIColor colorWithHexString:@"#656565"]];
            cellName.font = [UIFont systemFontOfSize:13 * WideEachUnit];
            [view addSubview:cellName];
            
            
            //添加报名人数
            UILabel *cellApply = [[UILabel  alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 135 * WideEachUnit, viewW / 2 - 10 * WideEachUnit, 20 * WideEachUnit)];
            cellApply.text =  [NSString stringWithFormat:@"%@人报名",[[_currentVipCourseArray objectAtIndex:i] stringValueForKey:@"video_order_count"]];
            if ([_order_switch integerValue] == 1) {
                 cellApply.text =  [NSString stringWithFormat:@"%@人报名",[[_currentVipCourseArray objectAtIndex:i] stringValueForKey:@"video_order_count_mark"]];
            }
            [cellApply setTextColor:[UIColor colorWithHexString:@"#656565"]];
            cellApply.font = [UIFont systemFontOfSize:10 * WideEachUnit];
            [view addSubview:cellApply];
            
            //添加课程价格
            UILabel *cellPrice = [[UILabel  alloc] initWithFrame:CGRectMake(viewW / 2, 135 * WideEachUnit, viewW / 2 - 10 * WideEachUnit, 20 * WideEachUnit)];
            cellPrice.text = @"免费";
            if ([[[_currentVipCourseArray objectAtIndex:i] stringValueForKey:@"price"] floatValue] == 0) {
                cellPrice.text = @"免费";
                cellPrice.textColor = [UIColor colorWithHexString:@"#47b37d"];
            } else {
                cellPrice.text = [NSString stringWithFormat:@"育币%@",[[_currentVipCourseArray objectAtIndex:i] stringValueForKey:@"price"]];
                [cellPrice setTextColor:[UIColor redColor]];
            }

            cellPrice.font = [UIFont systemFontOfSize:10 * WideEachUnit];
            cellPrice.textAlignment = NSTextAlignmentRight;
            [view addSubview:cellPrice];
            
            //添加手势
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellViewClick:)]];
            
        }
        
        //添加查看更多的按钮
        UIButton *cellMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50 * WideEachUnit, 80 * WideEachUnit + 170 * WideEachUnit * (_currentVipCourseArray.count / 2) * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit)];
        if (_currentVipCourseArray.count % 2 == 0) {//能整除
            cellMoreButton.frame = CGRectMake(MainScreenWidth / 2 - 50 * WideEachUnit, 80 * WideEachUnit + 170 * WideEachUnit * (_currentVipCourseArray.count / 2) * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit);
        } else {//不能整除
            cellMoreButton.frame = CGRectMake(MainScreenWidth / 2 - 50 * WideEachUnit, 80 * WideEachUnit + 170 * WideEachUnit * (_currentVipCourseArray.count / 2 + 1) * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit);
        }
        [cellMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        cellMoreButton.backgroundColor = [UIColor whiteColor];
        cellMoreButton.titleLabel.font = Font(13 * WideEachUnit);
        cellMoreButton.layer.cornerRadius = 3 * WideEachUnit;
        cellMoreButton.layer.masksToBounds = YES;
        cellMoreButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        cellMoreButton.layer.borderWidth = 1 * WideEachUnit;
        [cellMoreButton setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        [cellMoreButton addTarget:self action:@selector(cellMoreButtonCilck) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cellMoreButton];
        
    } else if (indexPath.section == 1) {
        
        CGFloat headerImageViewW = 50 * WideEachUnit;
        CGFloat headerImageViewH = 50 * WideEachUnit;
        CGFloat headerImageViewSpace = 10 * WideEachUnit;
        for (int i = 0 ; i < _getNewUserVipListArray.count ; i ++) {
            UIImageView *cellHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5 * WideEachUnit + (headerImageViewW + headerImageViewSpace) * i , 60 * WideEachUnit, headerImageViewW, headerImageViewH)];
            NSString *urlStr = [[_getNewUserVipListArray objectAtIndex:i] stringValueForKey:@"user_head_portrait"];
            [cellHeaderImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
            cellHeaderImageView.layer.cornerRadius = 25 * WideEachUnit;
            cellHeaderImageView.layer.masksToBounds = YES;
            [cell addSubview:cellHeaderImageView];
            
            //添加用户的名字
            UILabel *userName = [[UILabel  alloc] initWithFrame:CGRectMake(12.5 * WideEachUnit + (headerImageViewW + headerImageViewSpace) * i , 120 * WideEachUnit, headerImageViewW, 20 * WideEachUnit)];
            userName.text = [NSString stringWithFormat:@"%@",[[_getNewUserVipListArray objectAtIndex:i] stringValueForKey:@"uname"]];
            [userName setTextColor:[UIColor colorWithHexString:@"#656565"]];
            userName.font = [UIFont systemFontOfSize:12 * WideEachUnit];
            userName.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:userName];
            
        }
        
    }
    
    return cell;
}


#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openMemberButtonCilck {
    OpenMemberViewController *vc = [[OpenMemberViewController alloc] init];
    vc.vipDict = _vipDict;
    if ([_openMemberButton.titleLabel.text isEqualToString:@"开通会员"]) {
        vc.vipArray = _VipListArray;
        vc.vipMoneyArray = _VipListArray;
    } else if ([_openMemberButton.titleLabel.text isEqualToString:@"升级／续费"]) {
        NSString *Str = [_vipDict stringValueForKey:@"vip_type_txt"];
        BOOL isHaveVipName = NO;
        for (int i = 0; i < _VipListArray.count ; i ++) {
            NSString *vipName = [[_VipListArray objectAtIndex:i] stringValueForKey:@"title"];
            if ([Str isEqualToString:vipName]) {//说明就是当前等级
                isHaveVipName = YES;
                _currentUserVipNumber = i;
            }
        }
        
        NSMutableArray *vipMutableArray = [NSMutableArray array];
        for (int i = (int)_currentUserVipNumber ; i < _VipListArray.count ; i ++) {
            NSDictionary *dict = [_VipListArray objectAtIndex:i];
            [vipMutableArray addObject:dict];
        }
        vc.vipArray = vipMutableArray;
        vc.vipMoneyArray = vipMutableArray;
        vc.openOrRenew = @"openOrRenew";
        vc.currentSeleVip = 0;//最前面一个（也就是0）

    } else {
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//手势
- (void)viewClick:(UITapGestureRecognizer *)tap {
    NSLog(@"---%ld",tap.view.tag);
    OpenMemberViewController *vc = [[OpenMemberViewController alloc] init];
    vc.vipDict = _vipDict;
    if ([_openMemberButton.titleLabel.text isEqualToString:@"开通会员"]) {
        vc.vipArray = _VipListArray;
        vc.vipMoneyArray = _VipListArray;
        vc.currentSeleVip = tap.view.tag;
    } else if ([_openMemberButton.titleLabel.text isEqualToString:@"升级／续费"]) {
        NSString *Str = [_vipDict stringValueForKey:@"vip_type_txt"];
        BOOL isHaveVipName = NO;
        for (int i = 0; i < _VipListArray.count ; i ++) {
            NSString *vipName = [[_VipListArray objectAtIndex:i] stringValueForKey:@"title"];
            if ([Str isEqualToString:vipName]) {//说明就是当前等级
                isHaveVipName = YES;
                _currentUserVipNumber = i;
            }
        }
        
        NSMutableArray *vipMutableArray = [NSMutableArray array];
        NSInteger beginDex = 0;
        if (tap.view.tag > _currentUserVipNumber) {
            beginDex = tap.view.tag;
            vc.upgradeStr = @"2";
        } else {
            beginDex = _currentUserVipNumber;
            vc.upgradeStr = @"1";
        }
        for (int i = (int)beginDex ; i < _VipListArray.count ; i ++) {
            NSDictionary *dict = [_VipListArray objectAtIndex:i];
            [vipMutableArray addObject:dict];
        }
        vc.vipArray = vipMutableArray;
        vc.vipMoneyArray = vipMutableArray;
        vc.openOrRenew = @"openOrRenew";
        vc.currentSeleVip = 0;//最前面一个（也就是0）

    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    seleButton.selected = NO;
    seleButton.backgroundColor = [UIColor whiteColor];
    button.selected = YES;
    seleButton = button;
    button.backgroundColor = BasidColor;
    
    seleNumber = button.tag;
    _currentVipIdStr = [[_VipListArray objectAtIndex:button.tag] stringValueForKey:@"id"];
    
    [self netWorkUserVipCourse];
}

//手势
- (void)cellViewClick:(UITapGestureRecognizer *)tap {
    if ([HASALIPAY isEqualToString:@"0"]) {
        if (!UserOathToken) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
            alert.tag = 100;
            [alert show];
            return;
        }
    }
    NSInteger viewTag = tap.view.tag;
    if ([[[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"type"] integerValue] == 1) {//点播
        NSString *ID = [NSString stringWithFormat:@"%@",[[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"id"]];
        NSString *price = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"price"];
        NSString *title = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"video_title"];
        NSString *videoUrl = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"video_address"];
        NSString *imageUrl = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"imageurl"];
        
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = ID;
        vc.price = price;
        vc.title = title;
        vc.videoUrl = videoUrl;
        vc.imageUrl = imageUrl;
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([[[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"type"] integerValue] == 2) {//直播
        NSString *Cid = nil;
        Cid = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"id"];
        NSString *Price = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"price"];
        NSString *Title = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"video_title"];
        NSString *ImageUrl = [[_currentVipCourseArray objectAtIndex:viewTag] stringValueForKey:@"imageurl"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)viewTag andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    }
}

- (void)cellMoreButtonCilck {
    
    NSString *title = nil;
    NSString *cate_ID = nil;
    ClassSearchGoodViewController *searchGetVc = [[ClassSearchGoodViewController alloc] init];
    searchGetVc.typeStr = @"1";
    searchGetVc.currentVipId = _currentVipIdStr;
    searchGetVc.cateStr = title;
    searchGetVc.cate_ID = cate_ID;
    [self.navigationController pushViewController:searchGetVc animated:YES];
}

#pragma mark ----网络请求

//获取会员等级的数据
- (void)netWorkUserGetUserVipList {
    
    NSString *endUrlStr = YunKeTang_User_user_getUserVipList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:UserID forKey:@"user_id"];
    
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
                _VipListArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                _VipListArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        [self netWorkUserGetNewVipUser];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}
//获取会员课程
- (void)netWorkUserVipCourse {
    
    NSString *endUrlStr = YunKeTang_User_user_vipCourse;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_currentVipIdStr forKey:@"vip_id"];
    
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
                _currentVipCourseArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                _currentVipCourseArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }

        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }

        isRefresh = YES;
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}


//获取最新会员
- (void)netWorkUserGetNewVipUser {
    
    NSString *endUrlStr = YunKeTang_User_user_getNewVipUser;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:UserID forKey:@"user_id"];
    
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
                 _getNewUserVipListArray = (NSArray *)[dict arrayValueForKey:@"data"];
            } else {
                 _getNewUserVipListArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            [self addHeaderView];
            [self addTableView];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }

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
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
