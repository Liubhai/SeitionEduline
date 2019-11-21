//
//  ZhiBoClassMoreViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/18.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoClassMoreViewController.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"


@interface ZhiBoClassMoreViewController () {
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

@property (strong ,nonatomic)NSArray      *dataArray;

@property (strong ,nonatomic)NSArray      *typeArray;
@property (strong ,nonatomic)NSArray      *rankArray;

@property (strong ,nonatomic)NSString     *typeStr;
@property (strong ,nonatomic)NSString     *rankStr;

@end

@implementation ZhiBoClassMoreViewController

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
}

- (void)interFace {
    self.view.backgroundColor = [UIColor clearColor];
    _dataArray = [NSMutableArray array];
    rankButtonX = 10;
    Number = 0;
    isOne = YES;
    
    NSLog(@"---%@",_typeStr);
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelfView) name:@"ZhiBoClassMoreRemove" object:nil];
}

- (void)addScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 109 - 200)];
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_scrollView];
    
}

- (void)addTypeView {
    _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    _typeView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_typeView];
    
    UILabel *staus = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    staus.text = @"状态";
    staus.font = Font(15);
    [_typeView addSubview:staus];
    
    NSArray *titleArray = @[@"正在直播",@"免费直播"];
    _typeArray = @[@"living",@"free"];
    
    CGFloat buttonW = (MainScreenWidth / 2 - 10 - 7.5 - 15) / 2;
    CGFloat buttonH = 30;
    //添加按钮
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (15 + buttonW), 40, buttonW, buttonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        button.titleLabel.font = Font(14);
        button.layer.cornerRadius = 3;
        button.tag = i;
        [button addTarget:self action:@selector(typeButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#266194"] forState:UIControlStateSelected];
        [_typeView addSubview:button];
        
        if ([_typeStr isEqualToString:@"living"]) {
            if (i == 0) {
                [self typeButtonCilck:button];
            }
        } else if ([_typeStr isEqualToString:@"free"]) {
            if (i == 1) {
                [self typeButtonCilck:button];
            }
        } else {
            
        }
        
    }
    
}

- (void)addRankView {
    _rankView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_typeView.frame), MainScreenWidth, 100)];
    _rankView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_rankView];
    
    //添加线
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_rankView addSubview:line];
    
    
    UILabel *staus = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 20)];
    staus.text = @"排序";
    staus.font = Font(15);
    [_rankView addSubview:staus];
    
    NSArray *titleArray = @[@"综合排序",@"最新",@"热门",@"价格从高到低",@"价格从低到高",@"最近直播"];
    _rankArray = @[@"default",@"new",@"hot",@"t_price_down",@"t_price",@"newest"];
    
    
    CGFloat buttonW = (MainScreenWidth / 2 - 10 - 7.5 - 15) / 2;
    CGFloat buttonH = 30;
    //添加按钮
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (15 + buttonW), 40, buttonW, buttonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        button.titleLabel.font = Font(14);
        button.layer.cornerRadius = 3;
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
        
        titleSize.height = 30;
        titleSize.width += 20;
        
        button.frame = CGRectMake(rankButtonX, 40 + 40 * Number, titleSize.width,30);
        
        if (rankButtonX + titleSize.width + 15 > MainScreenWidth) {//说明应该下一排 （第二排）
            Number ++;
            button.frame = CGRectMake(SpaceBaside, 40 + 40 * Number, titleSize.width,30);
        }
        
        rankButtonX = CGRectGetMaxX(button.frame) + 15;
        
        _rankView.frame = CGRectMake(0, CGRectGetMaxY(_typeView.frame), MainScreenWidth, CGRectGetMaxY(button.frame) + SpaceBaside);
        
    }

    
}

- (void)addButtonView {
    _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_rankView.frame), MainScreenWidth, 70)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_buttonView];
    
    //添加线
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_buttonView addSubview:line];
    
    
    NSArray *titleArray = @[@"重置",@"确定"];
    
    CGFloat buttonW = 81;
    CGFloat buttonH = 30;
    //添加按钮
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 10, 30, buttonW, buttonH)];

        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(14);
        button.layer.cornerRadius = 3;
        button.tag = i;
        [button setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
        if (i == 0) {
            button.frame = CGRectMake(MainScreenWidth - buttonW * 2 - SpaceBaside * 2, 30, buttonW, buttonH);
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithHexString:@"#d2d2d2"].CGColor;
        } else {
            button.frame = CGRectMake(MainScreenWidth - buttonW * 1 - SpaceBaside * 1, 30, buttonW, buttonH);
            button.backgroundColor = BasidColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(sureButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:button];
        
    }
    
    _scrollView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_buttonView.frame));

    
    
    
}

- (void)addClearButton {
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_scrollView.frame), MainScreenWidth, MainScreenHeight - 109 - CGRectGetMaxY(_scrollView.frame))];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationZhiBoMoreButton" object:nil];
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
        rankButtonX = 10;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationZhiBoMoreTypeID" object:dict];
        [self removeSelfView];
    }
}



@end
