//
//  TKPopView.m
//  EduClass
//
//  Created by maqihan on 2019/1/3.
//  Copyright © 2019 talkcloud. All rights reserved.
//

#import "TKPopView.h"
#import "TKPopViewCell.h"
#import "TKEduSessionHandle.h"

#define ThemeKP(args) [@"TKToolsBox." stringByAppendingString:args]
#define Fit(height) (IS_PAD ? (height) : (height) *0.6)

@interface TKPopView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong , nonatomic) UICollectionView           *collectionView;
@property (strong , nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong , nonatomic) NSArray *dataArray;

@property (strong , nonatomic) UIView *containerView;
@property (strong , nonatomic) UIView *targetView;

@end


@implementation TKPopView
static NSString * const reuseID = @"TKPopViewCellID";

+ (TKPopView *)showPopViewAddedTo:(UIView *)containerView pointingAtView:(UIView *)targetView
{
    NSAssert(containerView, @"containerView must not be nil.");
    NSAssert(targetView, @"targetView must not be nil.");

    TKPopView *popView = [[self alloc] initWithFrame:containerView.bounds];
    popView.backgroundColor = [UIColor clearColor];
    popView.containerView = containerView;
    popView.targetView    = targetView;
    [containerView addSubview:popView];
    //
    [popView showUsingAnimation];
    
    return popView;
}

+ (BOOL)dismissForView:(UIView *)view;
{
    TKPopView *popView = [self popViewForView:view];
    if (popView) {
        [popView hideUsingAnimation];
        return YES;
    }
    return NO;
}

+ (TKPopView *)popViewForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            TKPopView *popView = (TKPopView *)subview;
            return popView;
        }
    }
    return nil;
}

- (void)updateConstraints
{
    CGRect frame  = [self.targetView.superview convertRect:self.targetView.frame toView:self];
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(frame) - CGRectGetWidth(self.frame)/2, CGRectGetMaxY(frame));
    
    if (self.popViewType == TKPopViewType_ToolBox) {
        
        CGFloat width = [TKEduClassRoom shareInstance].roomJson.roomtype == TKRoomTypeOneToMore ? 443 : 352;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(Fit(width), Fit(111))));
            make.top.equalTo(@(centerPoint.y + 25));
            make.centerX.equalTo(@(centerPoint.x));
        }];
        
    }else{
        
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(Fit(352), Fit(111))));
            make.top.equalTo(@(centerPoint.y + 25));
            make.centerX.equalTo(@(centerPoint.x));
        }];
    }
    
    [super updateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[TKPopViewCell class] forCellWithReuseIdentifier:reuseID];
    }
    return self;
}

- (void)setPopViewType:(TKPopViewType)popViewType
{
    _popViewType = popViewType;
    
    if (popViewType == TKPopViewType_ToolBox) {
        //工具箱数据
        
        if ([TKEduClassRoom shareInstance].roomJson.roomtype == TKRoomTypeOneToMore) {
            
            self.dataArray =  @[@{@"icon":@"TKToolsBox.toolbox_item_0",
                                  @"title":MTLocalized(@"tool.datiqiqi")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_1",
                                  @"title":MTLocalized(@"tool.zhuanpan")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_2",
                                  @"title":MTLocalized(@"tool.jishiqi")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_3",
                                  @"title":MTLocalized(@"tool.qiangdaqi")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_4",
                                  @"title":MTLocalized(@"tool.xiaobaiban")}];
            
        } else {
            
            self.dataArray =  @[@{@"icon":@"TKToolsBox.toolbox_item_0",
                                  @"title":MTLocalized(@"tool.datiqiqi")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_1",
                                  @"title":MTLocalized(@"tool.zhuanpan")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_2",
                                  @"title":MTLocalized(@"tool.jishiqi")},
                                
                                @{@"icon":@"TKToolsBox.toolbox_item_4",
                                  @"title":MTLocalized(@"tool.xiaobaiban")}];
        }
        
    }else{
        self.dataArray =  @[@{@"icon_0":@"TKToolsBox.control_item_0_0",
                              @"icon_1":@"TKToolsBox.control_item_0_1",
                              @"title":MTLocalized(@"Button.MuteAll")},
                            
                            @{@"icon_0":@"TKToolsBox.control_item_1_0",
                              @"icon_1":@"TKToolsBox.control_item_1_1",
                              @"title":MTLocalized(@"Button.MuteAudio")},
                            
                            @{@"icon_0":@"TKToolsBox.control_item_2_0",
                              @"icon_1":@"TKToolsBox.control_item_2_1",
                              @"title":MTLocalized(@"Button.Reward")},
                            
                            @{@"icon_0":@"TKToolsBox.control_item_3_0",
                              @"icon_1":@"TKToolsBox.control_item_3_1",
                              @"title":MTLocalized(@"Button.Reset")},];
    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsDisplay];
    [self.collectionView reloadData];
}

- (void)showUsingAnimation
{
    if (![NSThread isMainThread]) {
        return;
    }

    [self animateIn:YES completion:^(BOOL finished) {
    }];
}

- (void)hideUsingAnimation
{
    if (![NSThread isMainThread]) {
        return;
    }
    

    if ([self.delegate respondsToSelector:@selector(popViewWillHidden:)]) {
        [self.delegate popViewWillHidden:self];
    }
    
    [self animateIn:NO completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(popViewWasHidden:)]) {
            [self.delegate popViewWasHidden:self];
        }
    }];
}

- (void)animateIn:(BOOL)animatingIn completion:(void(^)(BOOL finished))completion
{
    //初始化状态
    if (animatingIn) {
        self.collectionView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.collectionView.alpha     = 0.5;
        self.alpha                    = 0.0;
        
    } else{
        
        self.collectionView.transform = CGAffineTransformIdentity;
        self.collectionView.alpha     = 1;
        self.alpha                    = 1;
    }
    
    dispatch_block_t animations = ^{
        if (animatingIn) {
            self.collectionView.transform = CGAffineTransformIdentity;
            self.collectionView.alpha     = 1;
            self.alpha                    = 1;
            [self setNeedsDisplay];

        } else{
            self.collectionView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
            self.collectionView.alpha     = 0.5;
            self.alpha                    = 0.0;
            [self setNeedsDisplay];
        }
    };

    [UIView animateWithDuration:0.3 delay:0. usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TKPopViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    NSDictionary *dict   = self.dataArray[indexPath.item];
    cell.itemTitle.text  = dict[@"title"];
    
    if (self.popViewType == TKPopViewType_ToolBox) {
        cell.itemImage.sakura.image(dict[@"icon"]);

    }else{
        cell.itemImage.sakura.image(dict[@"icon_0"]);
        NSInteger num = [TKEduSessionHandle shareInstance].onPlatformNum - 1;
        BOOL mute     = [TKEduSessionHandle shareInstance].isMuteAudio;

        if (num > 0) {
            cell.itemImage.sakura.image(dict[@"icon_1"]);
            if (!mute && indexPath.item == 0) {
                cell.itemImage.sakura.image(dict[@"icon_0"]);
            }

            if (mute && indexPath.item == 1) {
                cell.itemImage.sakura.image(dict[@"icon_0"]);
            }
        }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Fit(50), CGRectGetHeight(collectionView.frame));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, Fit(27), 0, Fit(27));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return (CGRectGetWidth(collectionView.frame)-Fit(27)*2 - Fit(50) * self.dataArray.count) / (self.dataArray.count - 1);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(TKPopViewDelegate)]) {
        [self.delegate popView:self didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGRect frame  = self.collectionView.frame;
    UIColor *color = self.collectionView.backgroundColor;
    [color set]; //设置线条颜色
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - 10)];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(frame) - 8, CGRectGetMinY(frame))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(frame) + 8, CGRectGetMinY(frame))];
    [path addLineToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - 10)];
    [path closePath];
    [path fill];
    
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [path stroke];
}

#pragma mark - touches

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[self class] dismissForView:self.containerView];
}

#pragma mark - Getter

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing      = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = NO;
        _collectionView.dataSource =self;
        _collectionView.delegate   =self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.sakura.backgroundColor(ThemeKP(@"popViewBackColor"));
        _collectionView.layer.cornerRadius = Fit(20);
        _collectionView.clipsToBounds = YES;
    }
    return _collectionView;
}


- (void)dealloc
{
    
}

@end
