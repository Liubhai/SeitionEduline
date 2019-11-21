//
//  SearchGetViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/1.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "SearchGetViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "TKProgressHUD+Add.h"

#import "MJRefresh.h"

#import "ClassRevampCell.h"
#import "LiveClassCell.h"
#import "SearchTeacherCell.h"
#import "InstitutionListCell.h"
#import "GLTeaTableViewCell.h"

#import "ZhiBoMainViewController.h"
#import "InstitutionMainViewController.h"
#import "TeacherMainViewController.h"
#import "Good_ClassMainViewController.h"

#import "SubjectView.h"
#import "DLViewController.h"




@interface SearchGetViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (assign ,nonatomic)CGFloat buttonW;
@property (assign ,nonatomic)NSInteger Number;

@property (strong ,nonatomic)UITableView *classTableView;
@property (strong ,nonatomic)UITableView *instationTableView;
@property (strong ,nonatomic)UITableView *teacherTableView;
@property (strong ,nonatomic)UIView *downView;
@property (assign ,nonatomic)CGFloat oldContentY;
@property (strong ,nonatomic)UIButton *typeButton;

@property (strong ,nonatomic)NSMutableArray *classArray;
@property (strong ,nonatomic)NSMutableArray *liveArray;
@property (strong ,nonatomic)NSMutableArray *teacherArray;
@property (strong ,nonatomic)NSMutableArray *instArray;
@property (strong ,nonatomic)NSArray *orderArray;

@property (strong ,nonatomic)UIImageView *classImageView;
@property (strong ,nonatomic)UIImageView *instImageView;
@property (strong ,nonatomic)UIImageView *teacherImageView;

@end

@implementation SearchGetViewController

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
    [self addNSNotification];
    [self interFace];
    [self addNav];
    [self addTypeView];
    [self addClassTableView];
    [self addTeacherTableView];
    [self addInstationTableView];
    [self addDownView];
    [self whichTableView];

}

- (void)addNSNotification {
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCateInfo:) name:@"SearchCateInfo" object:nil];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    _orderArray = @[@"default",@"hot"];
    _oldContentY = 0;
    _Number = 0;
    _orderStr = @"default";
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    //添加分类筛选的按钮
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 25, 61, 30)];
    NSString *Str0 = @"课程";
    NSString *Str1 = @"老师";
    NSString *Str2 = @"机构";
    if ([_typeStr integerValue] == 1) {
         [typeButton setTitle:Str0 forState:UIControlStateNormal];
    } else if ([_typeStr integerValue] == 4) {
         [typeButton setTitle:Str1 forState:UIControlStateNormal];
    } else if ([_typeStr integerValue] == 3) {
         [typeButton setTitle:Str2 forState:UIControlStateNormal];
    }
    
    [typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    typeButton.titleLabel.font = Font(14);
    [typeButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
    
    typeButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 20);
    
    typeButton.layer.borderWidth = 1;
    typeButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [typeButton addTarget:self action:@selector(typeButton:) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:typeButton];
    _typeButton = typeButton;
    typeButton.hidden = YES;
    
    
    //    //添加搜索
    _searchText = [[UITextField alloc] initWithFrame:CGRectMake(47.5, 20, MainScreenWidth - 90, 36)];
    _searchText.placeholder = @"搜索科目、老师、课程、机构";
    [_searchText setValue:Font(14) forKeyPath:@"_placeholderLabel.font"];
    _searchText.delegate = self;
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.layer.borderWidth = 1;
    _searchText.layer.cornerRadius = 18;
    _searchText.textColor = [UIColor grayColor];
    _searchText.font = Font(16);
    _searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setBackgroundImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [_searchText.leftView addSubview:button];
    
    [SYGView addSubview:_searchText];
    
    NSLog(@"---%@",_searchStr);
    if (_searchStr != nil) {
        _searchText.text = _searchStr;
    }
    
    //添加透明的按钮
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 150, 30)];
    clearButton.backgroundColor = [UIColor clearColor];
    [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_searchText addSubview:clearButton];
    clearButton.hidden = YES;
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearButtonClick {
     [self.navigationController popViewControllerAnimated:NO];
}

- (void)addTypeView {
    
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 44 * WideEachUnit)];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    
    NSArray *typeArray = @[@"点播",@"直播",@"机构",@"老师"];
    
    CGFloat typeW = MainScreenWidth / typeArray.count;
    CGFloat buttonW = MainScreenWidth / typeArray.count;
    CGFloat space = (typeW - buttonW)/ 2;
    space = 0;
    CGFloat buttonH = 44 * WideEachUnit;
    
    for (int i = 0 ; i < typeArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * typeW + space, 0, buttonW, buttonH)];
        [button setTitle:typeArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(16 * WideEachUnit);
        [button setTitleColor:BasidColor forState:UIControlStateSelected];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
//        button.layer.borderWidth = 1;
        button.layer.masksToBounds = YES;
//        button.layer.borderColor = BasidColor.CGColor;
        button.tag = 521 + i;
        
        [typeView addSubview:button];
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == [_typeStr integerValue] - 1) {
            [self typeButtonClick:button];
        }
        
    }

}


#pragma mark --- 表格视图
- (void)addClassTableView {
    
    _classTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 92 * WideEachUnit, MainScreenWidth, MainScreenHeight -  64 - 92 * WideEachUnit) style:UITableViewStyleGrouped];
    _classTableView.delegate = self;
    _classTableView.dataSource = self;
    _classTableView.rowHeight = 100 * WideEachUnit;
    [self.view addSubview:_classTableView];
    [_classTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)addTeacherTableView {
    _teacherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 92 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 92 * WideEachUnit) style:UITableViewStyleGrouped];
    _teacherTableView.delegate = self;
    _teacherTableView.dataSource = self;
    _teacherTableView.rowHeight = 130;
    [self.view addSubview:_teacherTableView];
    [_teacherTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)addInstationTableView {
    _instationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 92 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 92 * WideEachUnit) style:UITableViewStyleGrouped];
    _instationTableView.delegate = self;
    _instationTableView.dataSource = self;
    _instationTableView.rowHeight = 106;
    [self.view addSubview:_instationTableView];
    [_instationTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)whichTableView {

    if ([_typeStr isEqualToString:@"1"]) {//课程
        _classTableView.hidden = NO;
        _teacherTableView.hidden = YES;
        _instationTableView.hidden = YES;
        [_classTableView reloadData];
    } else if ([_typeStr isEqualToString:@"2"]) {
        _classTableView.hidden = NO;
        _teacherTableView.hidden = YES;
        _instationTableView.hidden = YES;
        [_classTableView reloadData];
    } else if ([_typeStr isEqualToString:@"4"]) {
        _classTableView.hidden = YES;
        _teacherTableView.hidden = NO;
        _instationTableView.hidden = YES;
        [_teacherTableView reloadData];
    } else if ([_typeStr isEqualToString:@"3"]) {
        _classTableView.hidden = YES;
        _teacherTableView.hidden = YES;
        _instationTableView.hidden = NO;
        [_instationTableView reloadData];
    }
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, 48 * WideEachUnit)];
    _downView.backgroundColor = BasidColor;
    [self.view addSubview:_downView];
    
    NSInteger Num = 2;
    CGFloat ButtonH = 48 * WideEachUnit;
    CGFloat ButtonW = MainScreenWidth / Num;
    NSArray *titleArray = @[@"全部科目",@"智能排序",@"筛选"];
    if (_cateStr) {
        titleArray = @[_cateStr,@"智能排序",@"筛选"];
    }
    NSArray *imageArray = @[@"资讯分类@2x",@"智能排序",@"筛选"];
    
    for (int i = 0 ; i < Num ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];
        button.tag = i * 100;
        button.titleLabel.font = Font(14 * WideEachUnit);
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        
        CGFloat imageW = 20 * WideEachUnit;
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,MainScreenWidth / 6 - imageW / 2,20 * WideEachUnit,MainScreenWidth / 6 - imageW / 2);
//        button.titleEdgeInsets = UIEdgeInsetsMake(ButtonH / 2, -ButtonH / 2, 0, 0);
        
        [button addTarget:self action:@selector(buttonType:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        //添加title
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonH - 20 * WideEachUnit, ButtonW, 20 * WideEachUnit)];
        name.text = titleArray[i];
        name.font = Font(14 * WideEachUnit);
        name.textColor = [UIColor whiteColor];
        name.textAlignment = NSTextAlignmentCenter;
        [button addSubview:name];
        
        if (i == 0) {//全部分类
            _allCateButton = button;
            _allCate = name;
        } else if (i == 1) {
            _allRankButton = button;
            _allRank = name;
        }
        
    }
    
}

#pragma mark -- 加载更多
- (void)footerRefreshing
{
//    _numder++;
//    [self requestData:_numder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (_classTableView.hidden == NO) {
            
            [_classTableView reloadData];
            [_classTableView footerEndRefreshing];
        } else if (_teacherTableView.hidden == NO) {
            
            [_teacherTableView reloadData];
            [_teacherTableView footerEndRefreshing];
        } else if (_instationTableView.hidden == NO) {
            
            [_instationTableView reloadData];
            [_instationTableView footerEndRefreshing];
        }

    });
}

#pragma mark --- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_classTableView.hidden == NO) {
        return _classArray.count;
    } else if (_teacherTableView.hidden == NO) {
        return _teacherArray.count;
    } else if (_instationTableView.hidden == NO) {
        return _instArray.count;
    }
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_typeStr isEqualToString:@"1"]) {//课程
        
        static NSString *CellID = @"cellClass";
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _classArray[indexPath.row];
        [cell dataWithDict:dict withType:@"1"];
        return cell;

    } else if ([_typeStr integerValue] == 2) {//直播
        
        static NSString *CellID = @"cellClassLive";
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _classArray[indexPath.row];
        [cell dataWithDict:dict withType:@"2"];
        return cell;

        
    } else if ([_typeStr isEqualToString:@"4"]) {//老师
        static NSString * CellStr = @"GLTeaTableViewCell";
        GLTeaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
        if (cell == nil) {
            if ([_teacherTableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [_teacherTableView setSeparatorInset:UIEdgeInsetsZero];
            }
            cell = [[GLTeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
        }
        //    cell.contentLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inro"]];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.nameLab.text = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"name"]];
        NSLog(@"===33333==%@",_teacherArray[indexPath.row]);
        
        if ([_teacherArray[indexPath.row][@"school_info"] count]) {
            cell.JGLab.text = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"school_info"][@"title"]];
            
        }
        cell.img.image = [UIImage imageNamed:@"站位图"];//展位图
        NSString *url = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"headimg"]];
        [cell.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"站位图"]];
        cell.img.layer.cornerRadius = 50;
        cell.img.layer.masksToBounds = YES;
        
        NSString *tagstr1 = [NSString stringWithFormat:@"%@年教龄",_teacherArray[indexPath.row][@"teacher_age"]];
        CGRect frames = cell.tagLab1.frame;
        frames.size.width = tagstr1.length *13 +10;
        cell.tagLab1.frame = frames;
        cell.tagLab1.text = tagstr1;
        
        NSString *tagstr2 = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"teach_evaluation"]];
        CGRect frame2 = cell.tagLab2.frame;
        frame2.size.width = tagstr2.length *13 +5;
        frame2.origin.x = frames.origin.x + frames.size.width + 10;
        cell.tagLab2.frame = frame2;
        cell.tagLab2.text = tagstr2;
        
        NSString *tagstr3 = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"graduate_school"]];
        CGRect frame3 = cell.tagLab3.frame;
        frame3.size.width = tagstr3.length *13 +5;
        frame3.origin.x = frame2.origin.x + frame2.size.width + 10;
        
        cell.tagLab3.frame = frame3;
        cell.tagLab3.text = tagstr3;
        
        //    NSString *tagstr4 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"school_info"][@"title"]];
        //    CGRect frame4 = cell.tagLab4.frame;
        //    frame4.size.width = tagstr4.length *13 +5;
        //    frame4.origin.x = frame3.origin.x + frame3.size.width + 5;
        //    cell.tagLab4.frame = frame4;
        //    cell.tagLab4.text = tagstr4;
        
        cell.contentLab.text = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"inro"]];
        NSString *count = [NSString stringWithFormat:@"播放%@次",_teacherArray[indexPath.row][@"review_count"]];
        NSString *area = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"ext_info"][@"location"]];
        
        cell.areaLab.text = [NSString stringWithFormat:@"%@",area];
        
        return cell;

        
        
    } else if ([_typeStr isEqualToString:@"3"]) {
        static NSString *CellIdentifier = @"culture";
        //自定义cell类
        InstitutionListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //自定义cell类
        if (cell == nil) {
            cell = [[InstitutionListCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *dict = _instArray[indexPath.row];
        [cell dataSourceWith:dict];
        
        return cell;

    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_typeStr isEqualToString:@"1"]) {//课程
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (!UserOathToken) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                alert.tag = 100;
                [alert show];
                return;
            }
        }
        NSString *ID = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
        NSString *price = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
        NSString *title = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
        NSString *videoUrl = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"video_address"];
        NSString *imageUrl = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
        
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = ID;
        vc.videoTitle = title;
        vc.price = price;
        vc.imageUrl = imageUrl;
        vc.videoUrl = videoUrl;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([_typeStr isEqualToString:@"2"]) {
        if ([HASALIPAY isEqualToString:@"0"]) {
            if (!UserOathToken) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查看详情需要登录,是否前往登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
                alert.tag = 100;
                [alert show];
                return;
            }
        }
        NSString *Cid = [NSString stringWithFormat:@"%@",[[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"]];
        NSString *Price = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
        NSString *Title = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
        NSString *ImageUrl = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
        
    }else if ([_typeStr isEqualToString:@"4"]) {
        NSString *ID = [[_teacherArray objectAtIndex:indexPath.row] stringValueForKey:@"id"];
        TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc] initWithNumID:ID];
        [self.navigationController pushViewController:teacherMainVc animated:YES];
        
    } else if ([_typeStr isEqualToString:@"3"]) {

        InstitutionMainViewController *instMainVc = [[InstitutionMainViewController alloc] init];
        instMainVc.schoolID = [[_instArray objectAtIndex:indexPath.row] stringValueForKey:@"school_id"];
        instMainVc.uID = [[_instArray objectAtIndex:indexPath.row] stringValueForKey:@"uid"];
        [self.navigationController pushViewController:instMainVc animated:YES];
    }
 
}

#pragma mark --- 滚动监听

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    NSLog(@"----%f",scrollView.contentOffset.y);
    int _lastPosition;
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        NSLog(@"ScrollUp now");
//        _downView.frame = CGRectMake(0, 64, MainScreenWidth, 48);
//        _classTableView.frame = CGRectMake(0, 64 + 48, MainScreenWidth, MainScreenHeight - 64 - 48);
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        NSLog(@"ScrollDown now");
//        _downView.frame = CGRectMake(0, 64 + 30, MainScreenWidth, 48);
//        _classTableView.frame = CGRectMake(0, 64 + 48 + 30, MainScreenWidth, MainScreenHeight - 64 - 48 - 30);
    }
    [_searchText resignFirstResponder];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldContentY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if( scrollView.contentOffset.y > _oldContentY) {
        [UIView animateWithDuration:0.1 animations:^{
            _downView.frame = CGRectMake(0, 64, MainScreenWidth, 48 * WideEachUnit);
            _classTableView.frame = CGRectMake(0, 64 + 48 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 48 * WideEachUnit + 35);
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            _downView.frame = CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, 48 * WideEachUnit);
            _classTableView.frame = CGRectMake(0, 64 + 92 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 92 * WideEachUnit);
        }];
    }

}



#pragma mark --- 通知

- (void)getCateInfo:(NSNotification *)Not {
    
    NSString *title = Not.userInfo[@"title"];
//    //改变下面全部分类的字样
//    [_allCateButton setTitle:title forState:UIControlStateNormal];
    _allCate.text = title;
    _cate_ID = Not.userInfo[@"id"];
    
}


#pragma mark --- 事件监听

- (void)typeButtonClick:(UIButton *)button {
    
    self.seletedButton.selected = NO;
//    self.seletedButton.backgroundColor = [UIColor whiteColor];
    button.selected = YES;
//    button.backgroundColor = BasidColor;
    self.seletedButton = button;
    _classType = [NSString stringWithFormat:@"%ld",(long)button.tag + 1];
    NSLog(@"%@",_classType);
    
    _typeStr = [NSString stringWithFormat:@"%ld",(long)button.tag - 520];
    NSLog(@"%@",_typeStr);
    
    [UIView animateWithDuration:0.25 animations:^{
        _HDButton.frame = CGRectMake(button.tag * _buttonW, 27 + 3, _buttonW, 1);
    }];
    
    [self whichTableView];
}


- (void)buttonType:(UIButton *)button {
    switch (button.tag) {
        case 0:
            [self cate];
            break;
        case 100:
            [self rank];
            break;
        case 200:
            [self screen];
            break;
        default:
            break;
    }
    
}

- (void)buttonWithOne:(UIButton *)button {

    self.selectedOne.selected = NO;
    self.selectedOne.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    button.selected = YES;
    self.selectedOne = button;
    if (button.selected == YES) {
        button.layer.borderColor = [UIColor orangeColor].CGColor;
    }
}

- (void)buttonWithTwo:(UIButton *)button {
    
    self.selectedTwo.selected = NO;
    self.selectedTwo .layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    button.selected = YES;
    self.selectedTwo = button;
    if (button.selected == YES) {
        button.layer.borderColor = [UIColor orangeColor].CGColor;
    }
}

- (void)buttonWithThere:(UIButton *)button {
    
    self.selectedThere.selected = NO;
    self.selectedThere.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    button.selected = YES;
    self.selectedThere = button;
    if (button.selected == YES) {
        button.layer.borderColor = [UIColor orangeColor].CGColor;
    }
}


#pragma mark --- 底部试图的添加
- (void)cate {
    [self cateButtonClick];
}

- (void)rank {
    
    [self addRankView];
}

- (void)screen {
    [self addScreenView];
}

- (void)cateButtonClick {
    
    SubjectView *subjectView = [[SubjectView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:subjectView];
}

- (void)rankButton:(UIButton *)button {
    
    NSString *title = button.titleLabel.text;
    _allRank.text = title;
    NSInteger Num = button.tag;
    _orderStr = _orderArray[Num];
    [self miss];
    
}

- (void)addRankView {
    
    [self addViewAndButton];
    NSArray *titleArray = @[@"智能排序",@"人气最高"];
    NSInteger Num = titleArray.count;
    
    _rankView = [[UIView alloc] init];
    _rankView.frame = CGRectMake(0, MainScreenHeight , MainScreenWidth,Num * 40 + (Num + 1) * 3);
    _rankView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    [_allView addSubview:_rankView];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _rankView.frame = CGRectMake(0, MainScreenHeight - 88  + 3, MainScreenWidth, Num * 40 + (Num + 1) * 3);
        for (int i = 0 ; i < Num ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * (Num + 1),MainScreenWidth, 40)];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
//            button.tag = [_SYGArray[i][@"zy_topic_category_id"] integerValue];
            [button addTarget:self action:@selector(rankButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_rankView addSubview:button];
            button.tag = i;
        }
        
        //添加中间的分割线
        for (int i = 0; i < Num; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , MainScreenWidth, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_rankView addSubview:XButton];
        }
    }];
 
}

#pragma mark --- 添加筛选界面

- (void)addScreenView {
    [self addViewAndButton];
    
    _screenView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, MainScreenHeight - 200 - 48)];
    _screenView.backgroundColor = [UIColor whiteColor];
    [_allView addSubview:_screenView];
    
    [UIView animateWithDuration:0.25 animations:^{
        _screenView.frame = CGRectMake(0, 200, MainScreenWidth, MainScreenHeight - 200 - 48);
    }];
    
    //添加重置
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 0, 40, 40)];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    resetButton.titleLabel.font = Font(14);
    [resetButton addTarget:self action:@selector(screenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    resetButton.tag = 66;
    [_screenView addSubview:resetButton];
    
    //添加确定
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 40, 0, 40, 40)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = Font(14);
    sureButton.tag = 88;
    [sureButton addTarget:self action:@selector(screenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_screenView addSubview:sureButton];
    
    //添加分割线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor grayColor];
    [_screenView addSubview:lineButton];
    
    [self addScreenScrollView];
    
}

- (void)addViewAndButton {
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];

}

- (void)addScreenScrollView {
    
    //添加滚动视图
    _screenScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, MainScreenWidth, MainScreenHeight - 200 - 48 - 40)];
    _screenScrollView.backgroundColor = [UIColor whiteColor];
    [_screenView addSubview:_screenScrollView];
    
    CGFloat ViewH = 70;
    CGFloat ButtonW = 60;
    CGFloat ButtonH = 25;
    
    NSArray *titleArray = @[@"老师资质",@"教龄范围",@"老师性别",@"老师身份",@"授课方式"];
    
    NSArray *buttonArray = @[@"美女",@"帅哥",@"女神"];
    
    for (int i = 0 ; i < 3; i ++) {
        UIView *kindView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewH * i + 2 * i, MainScreenWidth, ViewH)];
        kindView.backgroundColor = [UIColor whiteColor];
        [_screenScrollView addSubview:kindView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - SpaceBaside, 30)];
        title.text = titleArray[i];
        title.font = Font(15);
        [kindView addSubview:title];
        
        for (int k = 0 ; k < 3; k ++) {
            UIButton *kindButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (ButtonW + SpaceBaside / 2) * k, 30, ButtonW, ButtonH)];
            kindButton.titleLabel.font = Font(13);
            kindButton.layer.borderWidth = 1;
            kindButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            [kindButton setTitle:buttonArray[k] forState:UIControlStateNormal];
            [kindButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
            [kindButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            
            if (i == 0) {
                [kindButton addTarget:self action:@selector(buttonWithOne:) forControlEvents:UIControlEventTouchUpInside];
                if (k == 0) {
                    [self buttonWithOne:kindButton];
                }
            } else if (i == 1) {
                [kindButton addTarget:self action:@selector(buttonWithTwo:) forControlEvents:UIControlEventTouchUpInside];
                if (k == 0) {
                    [self buttonWithTwo:kindButton];
                }
            } else if (i == 2) {
                [kindButton addTarget:self action:@selector(buttonWithThere:) forControlEvents:UIControlEventTouchUpInside];
                if (k == 0) {
                    [self buttonWithThere:kindButton];
                }
            }
            [kindView addSubview:kindButton];
            
        }
        
    }

}


- (void)removeRankView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _rankView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 3 * 40 + 5 * (3 - 1));
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_rankView removeFromSuperview];
        
    });
    
    
}

- (void)miss {
    [UIView animateWithDuration:0.25 animations:^{
        _rankView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 1 * 40 + 5 * 3);
        _screenView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, MainScreenHeight - 200 - 48);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_rankView removeFromSuperview];
    });
    
    
}

//重置按钮 使筛选界面
- (void)missResetView {
    [_screenScrollView removeFromSuperview];
}


#pragma mark --- 事件监听

- (void)typeButton:(UIButton *)button {
    [self addTypeMoreView];
}

- (void)addTypeMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(missType) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    
    //创建个VIew
    _buyView = [[UIView alloc] initWithFrame:CGRectMake(50, 64, 100, 0)];
    _buyView.backgroundColor = BasidColor;
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //改变位置 动画
        _buyView.frame = CGRectMake(50 ,64 ,100, 128);
        
        //在view上面添加东西
        NSArray *GDArray = @[@"课程",@"老师",@"机构"];
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


- (void)missType {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(50, 64, 100, 0);
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    }); 
}

- (void)SYGButton:(UIButton *)button {
    [_typeButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    [self missType];
    if (button.tag == 521) {//课程
        _typeStr = @"1";
    } else if (button.tag == 522){//老师
        _typeStr = @"4";
    } else if (button.tag == 523) {//机构
        _typeStr = @"3";
    }
    [self whichTableView];
    
}

#pragma mark --- 筛选

- (void)screenButtonClick:(UIButton *)button {
    
    NSInteger Num = button.tag;
    if (Num == 66) {//重置
        [self missResetView];
        [self addScreenScrollView];
        
    } else if (Num == 88) {//确定
        [self miss];
    }
    
}


#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    if (_searchText.text.length > 0) {
        
    } else {
        
    }
    
    [textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }
}

@end
