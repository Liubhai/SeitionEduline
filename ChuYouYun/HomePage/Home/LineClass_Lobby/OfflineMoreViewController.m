//
//  OfflineMoreViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OfflineMoreViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"

@interface OfflineMoreViewController (){
    CGFloat rankButtonX;
    NSInteger Number;
    BOOL isOne;
    UIButton *typeSeleButton;
    UIButton *rankSeleButton;
    UIButton *sureSeleButton;
}

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView       *typeView;
@property (strong ,nonatomic)UIView       *rankView;
@property (strong ,nonatomic)UIView       *buttonView;
@property (strong ,nonatomic)UIButton     *oneTimeButton;
@property (strong ,nonatomic)UIButton     *twoTimeButton;

@property (strong ,nonatomic)NSArray      *dataArray;

@property (strong ,nonatomic)NSArray      *typeArray;
@property (strong ,nonatomic)NSArray      *rankArray;

@property (strong ,nonatomic)NSString     *typeStr;
@property (strong ,nonatomic)NSString     *rankStr;

@property (strong ,nonatomic)NSDictionary *timeDict;
@property (strong ,nonatomic)NSString     *oneStr;
@property (strong ,nonatomic)NSString     *twoStr;



@end

@implementation OfflineMoreViewController

-(instancetype)initWithTypeStr:(NSString *)typeStr withMoreStr:(NSString *)moreStr{
    
    self = [super init];
    if (self) {
        _typeStr = typeStr;
        _rankStr = moreStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addScrollView];
    [self addTypeView];
    [self addRankView];
    [self addButtonView];
    [self addClearButton];
//    [self netWorkGetScreen];
    [self netWorkLineVideoScreen];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    _dataArray = [NSMutableArray array];
    rankButtonX = 10 * WideEachUnit;
    Number = 0;
    isOne = YES;
    _oneStr = @"";
    _twoStr = @"";
    
    NSLog(@"---%@",_typeStr);
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"OfflineClassMoreRemove" object:nil];
}

- (void)addScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 245 * WideEachUnit)];
    if (iPhoneX) {
        _scrollView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 245 * WideEachUnit);
    }
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
}

- (void)addTypeView {
    _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80 * WideEachUnit)];
    if (iPhoneX) {
        _typeView.frame = CGRectMake(0, 0, MainScreenWidth, 80 * WideEachUnit);
    }
    _typeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_typeView];
    
    UILabel *staus = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside * WideEachUnit, SpaceBaside * WideEachUnit, MainScreenWidth - 2 * SpaceBaside * WideEachUnit, 20 * WideEachUnit)];
    staus.text = @"开班时间";
    staus.font = Font(15 * WideEachUnit);
    [_typeView addSubview:staus];
    
    NSString *oneStr = [Passport formatterDate:_timeDict[@"listingtime"]];
    NSString *twoStr = [Passport formatterDate:_timeDict[@"uctime"]];
    NSArray *titleArray = @[oneStr,twoStr];
    _typeArray = @[_oneStr,_twoStr];
    _typeArray = @[@"本月内",@"三月内",@"六月内",@"不限"];
    
    CGFloat buttonW = (MainScreenWidth / 2 - 10 * WideEachUnit - 7.5 * WideEachUnit - 15 * WideEachUnit) / 2;
    CGFloat buttonH = 30 * WideEachUnit;
    //添加按钮
    for (int i = 0 ; i < _typeArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside * WideEachUnit + i * (15 + buttonW) * WideEachUnit, 40 * WideEachUnit, buttonW, buttonH)];
        [button setTitle:_typeArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        button.titleLabel.font = Font(13 * WideEachUnit);
        button.layer.cornerRadius = 3 * WideEachUnit;
        button.tag = i;
        [button addTarget:self action:@selector(typeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#266194"] forState:UIControlStateSelected];
        [_typeView addSubview:button];
        
        if (i == 0) {
            _oneTimeButton = button;
        } else if (i == 1) {
            _twoTimeButton = button;
        }
        
        NSLog(@"type ---%@",_typeStr);
        NSLog(@"one ---%@",_oneStr);
        
        
        if ([_typeStr isEqualToString:@""]) {
            
        } else {
            if ([_typeStr isEqualToString:@"本月内"]) {
                if (i == 0) {
                    [self typeButtonCilck:button];
                }
            } else if ([_typeStr isEqualToString:@"三月内"]) {
                if (i == 1) {
                    [self typeButtonCilck:button];
                }
            } else if ([_typeStr isEqualToString:@"六月内"]) {
                if (i == 2) {
                    [self typeButtonCilck:button];
                }
            } else if ([_typeStr isEqualToString:@"不限"]){
                if (i == 3) {
                    [self typeButtonCilck:button];
                }
            }
        }
        
    }
    
}

- (void)addRankView {
    _rankView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_typeView.frame), MainScreenWidth, 100 * WideEachUnit)];
    _rankView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_rankView];
    
    //添加线
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_rankView addSubview:line];
    
    
    UILabel *staus = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside * WideEachUnit, 20 * WideEachUnit)];
    staus.text = @"排序";
    staus.font = Font(15 * WideEachUnit);
    [_rankView addSubview:staus];
    
    NSArray *titleArray = @[@"综合排序",@"最新",@"热门",@"价格从高到低",@"价格从低到高"];
    _rankArray = @[@"default",@"new",@"hot",@"t_price_down",@"t_price",@"newest"];
    
    
    CGFloat buttonW = (MainScreenWidth / 2 - 10 * WideEachUnit - 7.5 * WideEachUnit - 15 * WideEachUnit) / 2;
    CGFloat buttonH = 30 * WideEachUnit;
    //添加按钮
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside * WideEachUnit + i * (15 + buttonW) * WideEachUnit, 40 * WideEachUnit, buttonW, buttonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.layer.cornerRadius = 3 * WideEachUnit;
        button.tag = i;
        [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#266194"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(rankButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_rankView addSubview:button];
        
        
        if ([_rankStr isEqualToString:@"default"]) {
            if (i == 0) {
                [self rankButtonCilck:button];
            }
        } else if ([_rankStr isEqualToString:@"new"]) {
            if (i == 1) {
                [self rankButtonCilck:button];
            }
        } else if ([_rankStr isEqualToString:@"hot"]) {
            if (i == 2) {
                [self rankButtonCilck:button];
            }
        } else if ([_rankStr isEqualToString:@"t_price_down"]) {
            if (i == 3) {
                [self rankButtonCilck:button];
            }
        } else if ([_rankStr isEqualToString:@"t_price"]) {
            if (i == 4) {
                [self rankButtonCilck:button];
            }
        } else if ([_rankStr isEqualToString:@"newest"]) {
            if (i == 5) {
                [self rankButtonCilck:button];
            }
        } else {
            
        }
        
        //重要的是下面这部分哦！
        NSString *title = [NSString stringWithFormat:@"%@",titleArray[i]];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:button.titleLabel.font.fontName size:button.titleLabel.font.pointSize]}];
        
        titleSize.height = 30 * WideEachUnit;
        titleSize.width += 20 * WideEachUnit;
        
        button.frame = CGRectMake(rankButtonX, 40 * WideEachUnit + 40 * Number * WideEachUnit, titleSize.width,30 * WideEachUnit);
        
        if (rankButtonX + titleSize.width + 15 * WideEachUnit > MainScreenWidth) {//说明应该下一排 （第二排）
            Number ++;
            button.frame = CGRectMake(SpaceBaside * WideEachUnit, 40 * WideEachUnit + 40 * Number * WideEachUnit, titleSize.width,30 * WideEachUnit);
        }
        
        rankButtonX = CGRectGetMaxX(button.frame) + 15 * WideEachUnit;
        
        _rankView.frame = CGRectMake(0, CGRectGetMaxY(_typeView.frame), MainScreenWidth, CGRectGetMaxY(button.frame) + SpaceBaside);
        
    }
    
    
}

- (void)addButtonView {
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rankView.frame), MainScreenWidth, 70 * WideEachUnit)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_buttonView];
    
    //添加线
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_buttonView addSubview:line];
    
    
    NSArray *titleArray = @[@"重置",@"确定"];
    
    CGFloat buttonW = 81 * WideEachUnit;
    CGFloat buttonH = 30 * WideEachUnit;
    //添加按钮
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 10 * WideEachUnit, 30 * WideEachUnit, buttonW, buttonH)];
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.layer.cornerRadius = 3 * WideEachUnit;
        button.tag = i;
        [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        if (i == 0) {
            button.frame = CGRectMake(MainScreenWidth - buttonW * 2 - SpaceBaside * 2 * WideEachUnit, 30 * WideEachUnit, buttonW, buttonH);
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
        } else {
            button.frame = CGRectMake(MainScreenWidth - buttonW * 1 - SpaceBaside * 1 * WideEachUnit, 30 * WideEachUnit, buttonW, buttonH);
            button.backgroundColor = BasidColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(sureButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:button];
        
    }
    
    _scrollView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_buttonView.frame));
    
    
    
    
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_scrollView.frame), MainScreenWidth, MainScreenHeight - 64 - 45 * WideEachUnit - CGRectGetMaxY(_scrollView.frame))];
    clearButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [clearButton addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
}

- (void)button {
    NSString *str = @"这是按钮的标题";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    //对按钮的外形做了设定，不喜可删~
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [[UIColor blackColor] CGColor];
    btn.layer.cornerRadius = 3;
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:str forState:UIControlStateNormal];
    
    //重要的是下面这部分哦！
    CGSize titleSize = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
    
    titleSize.height = 20;
    titleSize.width += 20;
    
    btn.frame = CGRectMake(100, 100, titleSize.width, titleSize.height);
    [self.view addSubview:btn];
}


#pragma mark --- 通知
-(void)removeSelfView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationOfflineMoreButton" object:nil];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}



#pragma mark --- 事件点击
- (void)typeButtonCilck:(UIButton *)button {
    typeSeleButton.selected = NO;
    typeSeleButton.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
    button.selected = YES;
    button.backgroundColor = [UIColor colorWithHexString:@"#c6e0f7"];
    typeSeleButton = button;
    
    _typeStr = _typeArray[button.tag];
    
}

- (void)rankButtonCilck:(UIButton *)button {
    rankSeleButton.selected = NO;
    rankSeleButton.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
    button.selected = YES;
    button.backgroundColor = [UIColor colorWithHexString:@"#c6e0f7"];
    rankSeleButton = button;
    
    _rankStr = _rankArray[button.tag];
}

- (void)sureButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//重置
        _typeStr = nil;
        _rankStr = nil;
        rankButtonX = 10 * WideEachUnit;
        Number = 0;
        
        [_typeView removeFromSuperview];
        [_rankView removeFromSuperview];
        [_buttonView removeFromSuperview];
        
        [self addTypeView];
        [self addRankView];
        [self addButtonView];
        
        
    } else {//确定
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (_typeStr == nil) {
        } else {
            [dict setObject:_typeStr forKey:@"typeStr"];
        }
        if (_rankStr == nil) {
        } else {
            [dict setObject:_rankStr forKey:@"rankStr"];
        }
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationOfflineMoreTypeID" object:dict];
        [self removeSelfView];
    }
}


#pragma mark --- 网络请求
//线下课列表数据
- (void)netWorkLineVideoScreen {
    
    NSString *endUrlStr = YunKeTang_LineVideo_lineVideo_screen;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _timeDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _timeDict = [_timeDict dictionaryValueForKey:@"time"];
            if (_timeDict.allKeys.count > 0) {
                 [self addTypeView];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
