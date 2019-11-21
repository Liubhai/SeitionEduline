//
//  OfflineDetailTwoCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/8.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "OfflineDetailTwoCell.h"
#import "SYG.h"

@interface OfflineDetailTwoCell() <UIScrollViewDelegate>

@property (assign ,nonatomic)CGFloat setoff;
@property (assign ,nonatomic)NSInteger Number;

@end


@implementation OfflineDetailTwoCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //    self.backgroundColor = [UIColor whiteColor];
    
    
    _Number = 1;
    
    _detailButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    [_detailButton setTitle:@"课程详情" forState:UIControlStateNormal];
    _detailButton.titleLabel.font = Font(16 * WideEachUnit);
    [_detailButton setTitleColor:BasidColor forState:UIControlStateSelected];
    [_detailButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(detailButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_detailButton];
    
    _commentButton = [[UIButton alloc] initWithFrame:CGRectMake(100 * WideEachUnit, 10 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    [_commentButton setTitle:@"课程评价" forState:UIControlStateNormal];
    _commentButton.titleLabel.font = Font(16 * WideEachUnit);
    [_commentButton setTitleColor:BasidColor forState:UIControlStateSelected];
    [_commentButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(commentButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 39 * WideEachUnit, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 2,10);
    [self addSubview:_scrollView];
    
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, 200 * WideEachUnit)];
    _commentView.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:_commentView];
    
    
    _detail = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _detail.textColor = [UIColor blackColor];
    _detail.backgroundColor = [UIColor whiteColor];
    _detail.font = Font(13 * WideEachUnit);
    [_scrollView addSubview:_detail];
    
    
    if (_setoff == MainScreenWidth) {
        _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
    }
    
    
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    _detail.text = [dict stringValueForKey:@"course_intro"];
    [self setIntroductionText:[dict stringValueForKey:@"course_intro"]];
    NSLog(@"----%@",dict);
}

- (void)dataWithArray:(NSArray *)array {
    NSLog(@"----%@",array);
    [self addCommentView:array];
}

- (void)dataWithAgain:(CGFloat)cellHight {
    if (cellHight > 60 * WideEachUnit) {
        _setoff = MainScreenWidth;
        _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
    } else {
//         _scrollView.contentOffset = CGPointMake(0, 0);
    }
}
#pragma mark --- 文本自适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _detail.text = text;
    //设置label的最大行数
    _detail.numberOfLines = 0;
    
    CGRect labelSize = [_detail.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    NSLog(@"----%lf",labelSize.size.height);
    
    _detail.frame = CGRectMake(10 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, labelSize.size.height );
    
    NSLog(@"----%lf",_detail.frame.size.height);
    
    if (labelSize.size.height < 60 * WideEachUnit) {
        labelSize.size.height = 60 * WideEachUnit;
    }
    
    _scrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, labelSize.size.height + 20 * WideEachUnit);
    _detail.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, labelSize.size.height );
    
    self.frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 60 * WideEachUnit);
}

- (void)addCommentView:(NSArray *)array {
    
    NSLog(@"个数---%ld",array.count);
    
    _commentView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, array.count * 100 * WideEachUnit);
    _scrollView.frame = CGRectMake(0, 40 * WideEachUnit, MainScreenWidth, array.count * 100 * WideEachUnit);
    
    for (int i = 0; i < array.count ; i ++) {
        //名字 文本
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 60 * WideEachUnit , 60 * WideEachUnit)];
        imageButton.backgroundColor = [UIColor redColor];
        imageButton.layer.cornerRadius = 30;
        imageButton.layer.masksToBounds = YES;
        [_commentView addSubview:imageButton];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit,70 * WideEachUnit, 60 * WideEachUnit , 20 * WideEachUnit)];
        name.font = Font(14 * WideEachUnit);
        name.textColor = [UIColor grayColor];
        name.textAlignment = NSTextAlignmentCenter;
        [_commentView addSubview:name];
        
        
        //分数
        UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageButton.frame) + SpaceBaside * WideEachUnit, SpaceBaside * WideEachUnit, MainScreenWidth - 90 * WideEachUnit , 20 * WideEachUnit)];
        score.text = @"综合：5分 专业水平：5分 授课技巧：5分 教学态度：5分";
        score.font = Font(12 * WideEachUnit);
        score.textColor = BlackNotColor;
        [_commentView addSubview:score];
        
        //详情
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageButton.frame) + 10 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 90 * WideEachUnit , 40 * WideEachUnit)];
        comment.font = Font(14 * WideEachUnit);
        comment.textColor = [UIColor grayColor];
        comment.numberOfLines = 2;
        [_commentView addSubview:comment];
    }
    
}

- (void)detailButtonCilck {
    
}

- (void)commentButtonCilck {
    
}


#pragma mark ---- 滚动试图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView = _scrollView;
    NSLog(@"---%lf",scrollView.contentOffset.x);
    
    if (scrollView.contentOffset.x == MainScreenWidth) {//就是点评页面
        _detailButton.selected = NO;
        _commentButton.selected = YES;
        
//        CGFloat cellH = _scrollView.bounds.size.height + 40 * WideEachUnit;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationOfflineDetailCellHight" object:[NSString stringWithFormat:@"%f",cellH]];
        
    } else {//详情页面
        _detailButton.selected = YES;
        _commentButton.selected = NO;
    }
    
    _setoff = scrollView.contentOffset.x;
    
}



@end
