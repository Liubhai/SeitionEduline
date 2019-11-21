//
//  ZhiBoClassView.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoClassView.h"
#import "BigWindCar.h"
#import "SYG.h"


@interface ZhiBoClassView ()<UITableViewDelegate,UITableViewDataSource>{
    CGRect _frame;
}
@property (strong ,nonatomic)UIView      *tabView;//放表格的视图
@property (strong, nonatomic)UITableView *oneTableView;
@property (strong ,nonatomic)UITableView *twoTableView;
@property (strong ,nonatomic)UITableView *thereTableView;

@property (strong ,nonatomic)NSMutableArray *oneTableArray;
@property (strong ,nonatomic)NSMutableArray *twoTableArray;
@property (strong ,nonatomic)NSMutableArray *thereTableArray;

@property (atomic, strong) NSMutableArray *downloadObjectArr;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSString *cateID;
@property (strong ,nonatomic)NSArray *videoArray;

@end


@implementation ZhiBoClassView

- (instancetype)initWithFrame:(CGRect)frame {
    _frame = frame;
//    self = [super init];
    if (self = [super initWithFrame:frame]) {
//        _cateID = cateID;
        [self interFace];
        [self addAllView];
        [self addTableView];
        [self addClearButton];
    }
    return self;
}

- (void)interFace {
    self.userInteractionEnabled = NO;
    _oneTableArray = [NSMutableArray array];
    _twoTableArray = [NSMutableArray array];
    _thereTableArray = [NSMutableArray array];
}

- (void)addAllView {
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 109 - 200)];
    _tabView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    _tabView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_tabView];
}

- (void)addTableView {
    CGFloat tableViewW = MainScreenWidth / 3;
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableViewW, MainScreenHeight - 109 - 200) style:UITableViewStyleGrouped];
    _oneTableView.backgroundColor = [UIColor greenColor];
    _oneTableView.dataSource = self;
    _oneTableView.delegate = self;
    _oneTableView.rowHeight = 40;
    [_tabView addSubview:_oneTableView];
    
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewW, 0, tableViewW, MainScreenHeight - 109 - 200) style:UITableViewStyleGrouped];
    _twoTableView.delegate = self;
    _twoTableView.dataSource = self;
    _twoTableView.backgroundColor = [UIColor yellowColor];
    [_tabView addSubview:_twoTableView];
    
    _thereTableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewW * 2, 0, tableViewW, MainScreenHeight - 109 - 200) style:UITableViewStyleGrouped];
    _thereTableView.delegate = self;
    _thereTableView.dataSource = self;
    _thereTableView.backgroundColor = [UIColor blueColor ];
    [_tabView addSubview:_thereTableView];
    
    //初始化
    _oneTableView.hidden = NO;
    _twoTableView.hidden = YES;
    _thereTableView.hidden = YES;
    
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 200, MainScreenWidth, 200)];
    clearButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [clearButton addTarget:self action:@selector(clearButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
//    if (_oneTableView == tableView) {
//        return _oneTableArray.count;
//    } else if (_twoTableView == tableView) {
//        return _twoTableArray.count;
//    } else if (_thereTableView == tableView) {
//        return _thereTableArray.count;
//    } else {
//        return 0;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_twoTableView.hidden == NO) {//有两级以上的情况
        if (_thereTableView.hidden == NO) {//三级分类
            static NSString *CellID = @"cellClassThere";
            //自定义cell类
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
            //自定义cell类
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            }
            cell.textLabel.text = @"石微刚";
            return cell;
        } else {//两级分类
            static NSString *CellID = @"cellClassTwo";
            //自定义cell类
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
            //自定义cell类
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            }
            cell.textLabel.text = @"石小刚";
            return cell;
        }
    } else {//只有一级的时候
        static NSString *CellID = @"cellClassOne";
        //自定义cell类
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        cell.textLabel.text = @"石院刚";
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_oneTableView == tableView) {//点击一级分类的时候
        _oneTableView.hidden = NO;
        _twoTableView.hidden = NO;
        _thereTableView.hidden = YES;
        [_oneTableView reloadData];
        [_twoTableView reloadData];
    } else if (_twoTableView == tableView) {//点击二级分类
        _oneTableView.hidden = NO;
        _twoTableView.hidden = NO;
        _thereTableView.hidden = NO;
        [_thereTableView reloadData];
        [_twoTableView reloadData];
    } else if (_thereTableView == tableView) {//点击三级分类
        //传值
        
        //通知
        [self removeFromSuperview];
    }
    
}

#pragma mark --- 事件点击
- (void)clearButtonCilck:(UIButton *)button {
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark --- 网络请求

@end
