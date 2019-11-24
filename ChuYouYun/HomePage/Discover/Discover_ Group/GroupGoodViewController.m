//
//  GroupGoodViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GroupGoodViewController.h"
#import "JXSegment.h"
#import "JXPageView.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "BigWindCar.h"


#import "GroupTableViewCell.h"


@interface GroupGoodViewController ()<JXSegmentDelegate,JXPageViewDataSource,JXPageViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    JXPageView *pageView;
    JXSegment *segment;
    NSInteger Number;
}

@property(nonatomic,strong) NSArray *channelArray;
@property (strong ,nonnull) UITableView *tableView;

@property (strong ,nonatomic)NSString *ID;

@property (strong ,nonatomic)NSMutableArray *dataSource;
@property (strong ,nonatomic)NSArray *cateArray;//分类的集合
@property (strong ,nonatomic)NSMutableArray *titleArray;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *dataArr;

@end

@implementation GroupGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self netWorkCate];
//    [self NetWork];
    
}

- (void)interFace {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    Number = 0;
}

- (void)addSegmentView {
    
    segment = [[JXSegment alloc] initWithFrame:CGRectMake(0, 60, MainScreenWidth, 40)];
    [segment updateChannels:self.titleArray];
    
    segment.delegate = self;
    [self.view addSubview:segment];
    
    pageView =[[JXPageView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, self.view.bounds.size.height - 100)];
    pageView.datasource = self;
    pageView.delegate = self;
    [pageView reloadData];
    //    [pageView changeToItemAtIndex:0];
    [self.view addSubview:pageView];
}

#pragma mark - JXPageViewDataSource
-(NSInteger)numberOfItemInJXPageView:(JXPageView *)pageView{
    return self.cateArray.count;
}

-(UIView*)pageView:(JXPageView *)pageView viewAtIndex:(NSInteger)index{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[self randomColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 100) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.tag = index;
    tableView.dataSource = self;
    [view addSubview:tableView];
    _tableView = tableView;
    
    
    return view;
}

#pragma mark - JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index{
    [pageView changeToItemAtIndex:index];
    NSLog(@"%ld",index);
    _ID = _cateArray[index][@"zy_topic_category_id"];
//    [self getData:_ID andNum:1];
    Number = index;
    [_tableView reloadData];
}

#pragma mark - JXPageViewDelegate
- (void)didScrollToIndex:(NSInteger)index{
    [segment didChengeToIndex:index];
    NSLog(@"%ld",index);
    _ID = _cateArray[index][@"zy_topic_category_id"];
    NSLog(@"%@",_ID);
//    [self getData:_ID andNum:1];
    Number = index;
    [self netWork];
}

#pragma mark - UITableViewDataSource


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataSource[Number];
    return array.count;
//    return _dataSource[Number].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GroupTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataSource[Number][indexPath.row];
    [cell dataSourceWithDict:dic];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",tableView.tag);
    [_tableView reloadData];
    
}



- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    
}


#pragma mark --- 文字中找出图片

//获取webView中的所有图片URL
- (NSArray *) filterHTML:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    //标签匹配
    NSString *parten = @"<img (.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"\"(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        if (match.count==0) {
            return nil;
        }
        
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    return imageurlArray;
}


#pragma mark --- 网络请求

- (void)netWorkCate {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    //    [MBProgressHUD showError:@"数据加载中...." toView:self.view];
    
    [manager BigWinCar_GroupCate:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD showError:@"加载成功..." toView:self.view];
        _cateArray = responseObject[@"data"];
        for (int i = 0 ; i < _cateArray.count ; i ++) {
            NSString *titleStr = _cateArray[i][@"title"];
            [_titleArray addObject:titleStr];
        }
//        [self addTitleView];
        [self addSegmentView];
        [self netWork];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
    
}

- (void)netWork {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    [manager BigWinCar_GroupList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = responseObject[@"data"];
            for (int i = 0 ; i < _dataArray.count ; i ++) {
                NSArray *array = [[_dataArray objectAtIndex:i] arrayValueForKey:@"group_list"];
                if (array == nil) {
                    array = @[];
                } else {
                    [_dataSource addObject:array];
                }
            }
//            [self addControllerSrcollView];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
        [_tableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [self JXSegment:segment didSelectIndex:Number];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
    
}



@end
