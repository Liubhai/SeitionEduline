//
//  TopicXXTableViewCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "TopicXXTableViewCell.h"
#import "SYG.h"
#import "Passport.h"
#import "UIImageView+WebCache.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"



@implementation TopicXXTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot {
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, SpaceBaside, MainScreenWidth, 130)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside , MainScreenWidth - 4 * SpaceBaside, 20)];
    [_backView addSubview:_title];
    
    _setButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, SpaceBaside, 60, 30)];
    [_setButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
    [_backView addSubview:_setButton];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_title.frame) + SpaceBaside, MainScreenWidth - 2 * SpaceBaside, 30)];
    [_backView addSubview:_content];
    
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, MainScreenWidth, 80)];
    _photoView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_photoView];
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_photoView.frame), MainScreenWidth, 40)];
    _downView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_downView];
    
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside,80, 20)];
    [_downView addSubview:_name];
    _name.textColor = BlackNotColor;
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(90, SpaceBaside, 80, 20)];
    [_downView addSubview:_time];
    _time.textColor = [UIColor grayColor];
    _time.font = Font(13);
    
    
    //添加
    
    //观看的图片
    UIButton *GKButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth -70 , SpaceBaside + 5, 20, 10)];
    [GKButton setBackgroundImage:[UIImage imageNamed:@"观看@2x"] forState:UIControlStateNormal];
    [_downView addSubview:GKButton];
    _GKButton = GKButton;
    _GKButton.hidden = YES;
    
    //观看人数
    _GKLabel = [[UILabel alloc] initWithFrame:CGRectMake(GKButton.frame.origin.x+GKButton.frame.size.width+2, SpaceBaside, 30, 20)];
    _GKLabel.font = [UIFont systemFontOfSize:14];
    _GKLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _GKLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:_GKLabel];
    _GKLabel.hidden = YES;
    
    //评论人数
    _PLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 40,SpaceBaside, 30, 20)];
    _PLLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _PLLabel.textAlignment = NSTextAlignmentCenter;
    _PLLabel.font = [UIFont systemFontOfSize:14];
    [_downView addSubview:_PLLabel];

    
    //评论图片
    UIButton *PLButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 , SpaceBaside / 2, 30, 30)];
//    [PLButton setBackgroundImage:[UIImage imageNamed:@"问答评论评论@2x"] forState:UIControlStateNormal];
    [PLButton setImage:Image(@"问答评论评论@2x") forState:UIControlStateNormal];
    [_downView addSubview:PLButton];
    _PLButton = PLButton;
 
}

- (void)dataSourceWith:(NSDictionary *)dic {
    
    NSLog(@"%@",dic);
    _dict = dic;
    
    NSArray *imageArray = [dic arrayValueForKey:@"attach"];
    if (imageArray.count) {
        [self imageWithArray:imageArray];
    } else {
        [self cellWithOutImage];
    }
    
    _title.text = [dic stringValueForKey:@"title"];
    if ([[dic stringValueForKey:@"dist"] integerValue] == 1) {//为精华
        _title.text = [NSString stringWithFormat:@"【精华】%@",_title.text];
    }
    if ([[dic stringValueForKey:@"lock"] integerValue] == 1) {//锁定
        _title.text = [NSString stringWithFormat:@"【锁定】%@",_title.text];
    }
    if ([[dic stringValueForKey:@"top"] integerValue] == 1) {//置顶
        _title.text = [NSString stringWithFormat:@"【置顶】%@",_title.text];
    }

    _name.text = [dic stringValueForKey:@"name"];
    _content.text = [dic stringValueForKey:@"content" defaultValue:@""];
    _time.text = [Passport formatterDate:[dic stringValueForKey:@"addtime"]];
    _GKLabel.text = [dic stringValueForKey:@"isrecom"];
    _PLLabel.text = [dic stringValueForKey:@"replycount"];
    _setButton.tag = [[dic stringValueForKey:@"id"] integerValue];
    _PLButton.tag = [[dic stringValueForKey:@"id"] integerValue];
    
}

- (void)cellWithOutImage {
    _photoView.frame = CGRectMake(0, 0, 0, 0);
    _downView.frame = CGRectMake(0, CGRectGetMaxY(_content.frame), MainScreenWidth, 40);
    _backView.frame = CGRectMake(0, SpaceBaside, MainScreenWidth, 120);
    self.frame = CGRectMake(0, 0, MainScreenWidth, 140 - 10);
    
}

- (void)imageWithArray:(NSArray *)array {

    if (array == nil) {
        return;
    }
    
    NSLog(@"--------%ld",array.count);
    
    CGFloat ImageW = (MainScreenWidth - 4 * SpaceBaside) / 3;
    NSInteger Num = 0;
    
    if (array.count > 3) {
        Num = 3;
    } else {
        Num = array.count;
    }
    
    for (int i = 0 ; i < Num ; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside + (i % 3) * ImageW + (i % 3) * SpaceBaside, SpaceBaside + (i / 3) * ImageW + (i / 3) * SpaceBaside, ImageW, ImageW)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:Image(@"站位图")];
        [_photoView addSubview:imageView];
        [imageView setImageURLStr:array[i] placeholder:Image(@"站位图")];
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        
    }
    
    //确定图片的View 的大小
    _photoView.frame = CGRectMake(0, 80, MainScreenWidth, ImageW + 2 * SpaceBaside);
    _downView.frame = CGRectMake(0, CGRectGetMaxY(_photoView.frame) + SpaceBaside, MainScreenWidth, 40);
    _backView.frame = CGRectMake(0, SpaceBaside, MainScreenWidth, CGRectGetMaxY(_downView.frame) + 10);
    self.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_downView.frame) + 20);

}


- (void)imageClick:(UITapGestureRecognizer *)tap {

    NSArray *imageArray = [_dict arrayValueForKey:@"attach"];
    int count = (int)imageArray.count;
    if (imageArray.count > 3) {
        count = 3;
    }
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [imageArray[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = _photoView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

@end
