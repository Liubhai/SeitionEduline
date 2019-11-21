//
//  GroupDetailTableViewCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GroupDetailTableViewCell.h"
#import "syg.h"
#import "PhotosView.h"


@implementation GroupDetailTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{

    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    //添加整个VIew
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, MainScreenWidth, 400)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];

    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - 50, 20)];
    [backView addSubview:_titleLabel];
    
    //设置按钮
    _setButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, SpaceBaside, 20, 20)];
    [_setButton setBackgroundImage:Image(@"向下@2x") forState:UIControlStateNormal];
    [backView addSubview:_setButton];
    
    
    //图片试图
    _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 10)];
    _TPView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), MainScreenWidth, 100)];
    [backView addSubview:_TPView];
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TPView.frame), MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:_downView];

    //名字
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    [_downView addSubview:_NameLabel];
    
    //时间
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_NameLabel.frame) + SpaceBaside, SpaceBaside , 80, 20)];
    _TimeLabel.textColor = [UIColor colorWithRed:147.f / 255 green:147.f / 255 blue:147.f / 255 alpha:1];
    _TimeLabel.font = [UIFont systemFontOfSize:11];
    [_downView addSubview:_TimeLabel];
    
    
    //观看的图片
    UIButton *GKButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth -70 , SpaceBaside * 2, 20, 10)];
    [GKButton setBackgroundImage:[UIImage imageNamed:@"观看@2x"] forState:UIControlStateNormal];
    [_downView addSubview:GKButton];
    _GKButton = GKButton;
    
    //观看人数
    _GKLabel = [[UILabel alloc] initWithFrame:CGRectMake(GKButton.frame.origin.x+GKButton.frame.size.width+2, SpaceBaside * 2, 30, 20)];
    _GKLabel.font = [UIFont systemFontOfSize:14];
    _GKLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _GKLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:_GKLabel];
    
    //评论人数
    _PLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 118,SpaceBaside * 2, 30, 20)];
    _PLLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _PLLabel.textAlignment = NSTextAlignmentCenter;
    _PLLabel.font = [UIFont systemFontOfSize:14];
    [_downView addSubview:_PLLabel];
    
    //评论图片
    UIButton *PLButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 140 , SpaceBaside * 2, 20, 20)];
    [PLButton setBackgroundImage:[UIImage imageNamed:@"问答评论评论@2x"] forState:UIControlStateNormal];
    [_downView addSubview:PLButton];
    _PLButton = PLButton;
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.contentLabel.text = text;
    //设置label的最大行数
    self.contentLabel.numberOfLines = 2;
    CGSize size = CGSizeMake(MainScreenWidth - 20, 80);//(MainScreenWidth - 20, 1000) 这样的话为自适应
    
    CGSize labelSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应的高度
    //
    NSLog(@"%lf",labelSize.height);
    
    //这里解决了点击的时候出现横线的bug
    if (labelSize.height > 30) {
        frame.size.height = labelSize.height + 50 + 10 + 10 + 3;
    } else {
        frame.size.height = 20 + 50 + 10 + 10 + 3;
    }

//    _PLButton.frame = CGRectMake(MainScreenWidth - 150, CGRectGetMaxY(_contentLabel.frame) + SpaceBaside + 5, 17, 17);
//    _GKButton.frame = CGRectMake(MainScreenWidth - 80, CGRectGetMaxY(_contentLabel.frame) + SpaceBaside + 5 , 20, 14);
//    _PLLabel.frame = CGRectMake(MainScreenWidth - 130, CGRectGetMaxY(_contentLabel.frame) + SpaceBaside , 30, 20);
//    _GKLabel.frame = CGRectMake(MainScreenWidth - 58, CGRectGetMaxY(_contentLabel.frame) + SpaceBaside , 55, 20);
    _downView.frame = CGRectMake(0, CGRectGetMaxY(_TPView.frame), MainScreenWidth, 50);
    
//    _backView.frame = CGRectMake(0, 5, MainScreenWidth, CGRectGetMaxY(_GKLabel.frame) + 10);
    
    self.frame = frame;
    
}

- (void)imageWithArray:(NSArray *)array {
    
    CGFloat Space = 10;
    CGFloat JJ = 14;
    CGFloat BWirth = (MainScreenWidth - (2 * Space) - 2 * JJ) / 3;
    
    //先设置图片的大小
//    _TPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    if (array == nil) {//如果数组为空，说明图片试图的尺寸为0
        _TPView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), 0, 0);
        
        _NameLabel.frame = CGRectMake(SpaceBaside, CGRectGetMaxY(_titleLabel.frame) + SpaceBaside, 100, 20);
        _TimeLabel.frame = CGRectMake(CGRectGetMaxX(_NameLabel.frame) + SpaceBaside,CGRectGetMaxY(_titleLabel.frame) + SpaceBaside , 80, 20);
        
        _PLButton.frame = CGRectMake(MainScreenWidth - 140, CGRectGetMaxY(_titleLabel.frame) + 10, 20, 20);
        _GKButton.frame = CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_titleLabel.frame) + 10, 20, 20);
        _PLLabel.frame = CGRectMake(MainScreenWidth - 120, CGRectGetMaxY(_titleLabel.frame) + 10, 30, 20);
        _GKLabel.frame = CGRectMake(MainScreenWidth - 50, CGRectGetMaxY(_titleLabel.frame) + 10, 35, 20);
        
        _backView.frame = CGRectMake(0, 5, MainScreenWidth, CGRectGetMaxY(_GKLabel.frame));
        self.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_PLButton.frame) + 10);
//
    }else {
        //这个的图片是正方形
         _TPView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), MainScreenWidth, 500);

        
        for (int i = 0 ; i < array.count ; i ++) {
            UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(JJ + (i % 3) * BWirth + (i % 3) * Space, Space + (i / 3) * BWirth + (i / 3) * Space, BWirth, BWirth)];
//            [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            button.image = Image(array[i]);
            [_TPView addSubview:button];
            
            //图片试图的大小
            _TPView.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), MainScreenWidth, CGRectGetHeight(button.frame));
            
            _downView.frame = CGRectMake(0, CGRectGetMaxY(_TPView.frame), MainScreenWidth, 40);
            
            //确定backView的大小
            _backView.frame = CGRectMake(0, 5, MainScreenWidth, CGRectGetMaxY(_downView.frame) + 5);
            
            NSLog(@"----%lf",CGRectGetMaxY(_downView.frame) + 5);
            
            self.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_downView.frame) + 10 + 3 + 3 );
            
        }
        
        
    }
    
    //cell的具体可以根据点赞和评论的位置来定
    
    
    
}


@end
