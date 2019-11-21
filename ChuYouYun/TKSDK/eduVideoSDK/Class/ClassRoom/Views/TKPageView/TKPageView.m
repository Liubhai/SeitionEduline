//
//  TKPageView.m
//  EduClass
//
//  Created by lyy on 2018/5/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//


#import "TKPageView.h"
#import "TKPageTableViewCell.h"

#define ThemeKP(args) [@"ClassRoom.PageView." stringByAppendingString:args]
#define tWidth 66
#define cellHeight 30

@interface TKPageView()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _tHeight;
}
@property (nonatomic, assign) int totalPages;

@property (nonatomic, strong) UIView       * backView;

@property (nonatomic, strong) UIImageView  *contentView;

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, assign) TKPageShowType pageShowType;


@end

@implementation TKPageView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        if (!self.backView) {
            
            self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            self.backView.alpha = 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
            [self.backView addGestureRecognizer: tap];
            
        }
        
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];

        
    }
    
    return self;
}
- (void)touchOutSide{
    [self dissMissView];
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showOnView:(UIButton *)view totalPages:(int)totalPages pageShowType:(TKPageShowType)type
{
    
    self.totalPages = totalPages;
    self.pageShowType = type;
   
    if (totalPages>5) {
        _tHeight = cellHeight*5+30;
    }else{
        _tHeight = cellHeight*totalPages+30;
    }
    
    [self initContent];
    [self initTableView];
    
    CGRect absoluteRect = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    CGFloat x = (tWidth - absoluteRect.size.width)/2.0;
    
    
    
    [TKMainWindow addSubview:self.backView];
    [TKMainWindow addSubview:self];
    
    self.frame = CGRectMake(absoluteRect.origin.x-x, relyPoint.y - _tHeight- absoluteRect.size.height, tWidth, _tHeight);
    
    
    [UIView animateWithDuration: 0.25 animations:^{
        
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
       
    }];
    
}
- (void)layoutSubviews{
    self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
    self.tableView.frame = CGRectMake(1, 16, self.width-2, self.height-32);
}

- (void)initTableView{
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(1, 15 , tWidth-2, 0) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor  = [UIColor clearColor];
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [tableView registerNib:[UINib nibWithNibName:@"TKPageTableViewCell" bundle:nil] forCellReuseIdentifier:@"TKPageTableViewCellID"];
        
        [self.contentView addSubview:tableView];
        tableView;
        
    });

}

- (void)initContent
{
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.contentView = ({
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tWidth, 0)];
        [self addSubview:view];
        view.image = [UIImage tkResizedImageWithName:ThemeKP(@"cameraToolToolbarImage")];
        view.userInteractionEnabled = YES;
        view;
    });
    
}
#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.totalPages;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tHeight = cellHeight;
    return tHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{{
    
            
    TKPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TKPageTableViewCellID"];
    NSString *lineViewColor = self.pageShowType == TKDocumentPageShow?ThemeKP(@"cameraLineColor"):ThemeKP(@"cameraLineColor");
    
    NSString *titleLabelColor = self.pageShowType == TKDocumentPageShow?ThemeKP(@"titleColor"):ThemeKP(@"titleColor");
    [cell setTheContent:indexPath.row+1 lineViewColor:lineViewColor titleLabelColor:titleLabelColor];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.sakura.backgroundColor(ThemeKP(@"pageNumSelectColor"));
    
    return cell;
    
}}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.currentSelectPageNum) {
        self.currentSelectPageNum(indexPath.row+1);
        
    }
    [self performSelector:@selector(cancleSelect) withObject:nil afterDelay:0.1f];
    
    [self dissMissView];
    
}

- (void)cancleSelect
{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}




//移除从上向底部弹下去的UIView（包含遮罩）
- (void)dissMissView
{
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         self.backView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.backView removeFromSuperview];
                         [self removeFromSuperview];
                         if (self.dismissBlock) {
                             self.dismissBlock();
                         }
                     }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
