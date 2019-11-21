//
//  ShopDetailCommentViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/6.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "ShopDetailCommentViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "ShopDetailCommentTableViewCell.h"
#import "DLViewController.h"

@interface ShopDetailCommentViewController ()<UITableViewDelegate,UITableViewDataSource> {
    CGRect  _keyboardRect;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray     *dataArray;
@property (strong ,nonatomic)UIView      *headerView;
@property (strong ,nonatomic)UIView      *allWindowView;
@property (strong ,nonatomic)UIView      *moreView;
@property (strong ,nonatomic)UITextView  *textView;

@property (strong ,nonatomic)NSDictionary *dict;

@end

@implementation ShopDetailCommentViewController

-(instancetype)initWithDict:(NSDictionary *)dict {
    if (!self) {
        self = [super init];
        _dict = dict;
    }
    _dict = dict;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addHeaderView];
    [self addTableView];
    [self netWorkGoodsCommentList:1];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addHeaderView {
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    
    //添加空白处理以及评论
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, 40 * WideEachUnit)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"评价该商品" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_headerView addSubview:button];
    [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit - 360) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 88 - 34 + 36);
    }
    if (iPhone6) {
         _tableView.frame = CGRectMake(0, 64 + 45 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 45 - 360);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 85 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headerView;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ShopDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[ShopDetailCommentTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict];
    if (indexPath.row == _dataArray.count - 1) {//最后一个cell
//        CGFloat tableHight = tableView.contentSize.height;
//        self.vcHight(tableHight);
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    [self addAllWindow];
}

- (void)subitButtonCilck:(UIButton *)button {
    [self netWorkGoodsComment];
}

#pragma mark --- 弹出框
- (void)addAllWindow {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit,MainScreenHeight - 190 * WideEachUnit,MainScreenWidth,190 * WideEachUnit)];
//    moreView.center = app.keyWindow.center;
//    moreView.center = CGPointMake(MainScreenWidth / 2, MainScreenHeight / 3);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    _moreView = moreView;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, 180 * WideEachUnit, 20 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(12 * WideEachUnit);
    title.text = @"评价该商品";
//    title.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:title];
    
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [textBackView addSubview:_textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, CGRectGetMaxY(textBackView.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 25 * WideEachUnit)];
    [subitButton setTitle:@"提交" forState:UIControlStateNormal];
    [subitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subitButton.backgroundColor = BasidColor;
    [subitButton addTarget:self action:@selector(subitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
    
}


#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 键盘
- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.textView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardRect = [aValue CGRectValue];
    CGFloat y = _keyboardRect.size.height;
    CGFloat x = _keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",(int)y);
    NSLog(@"键盘宽度是  %d",(int)x);
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.frame = CGRectMake(0, MainScreenHeight - 190 * WideEachUnit - y, MainScreenWidth, 190 * WideEachUnit);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.frame = CGRectMake(0, MainScreenHeight - 190 * WideEachUnit, MainScreenWidth, 190 * WideEachUnit);
    }];
}


#pragma mark --- 网络请求
- (void)netWorkGoodsCommentList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Goods_goods_getComment;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_dict stringValueForKey:@"goods_id"] forKey:@"goods_id"];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setObject:@"5" forKey:@"limit"];
    
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
                _dataArray = [dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)netWorkGoodsComment {
    
    NSString *endUrlStr = YunKeTang_Goods_goods_comment;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_dict stringValueForKey:@"goods_id"] forKey:@"goods_id"];
    [mutabDict setObject:_textView.text forKey:@"comment"];
    
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
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_allWindowView removeFromSuperview];
        });

        [self netWorkGoodsCommentList:1];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
