//
//  Good_QuesAndAnsTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndAnsTableViewCell.h"
#import "SYG.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@interface Good_QuesAndAnsTableViewCell()

@property (strong ,nonatomic)NSDictionary    *dict;

@end

@implementation Good_QuesAndAnsTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    
    //头像
    _HeadImage = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 12 * WideEachUnit, 35 * WideEachUnit, 35 * WideEachUnit)];
    [_HeadImage setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    _HeadImage.clipsToBounds = YES;
    _HeadImage.layer.cornerRadius = 17.5 * WideEachUnit;
    [self addSubview:_HeadImage];
    
    //名字
    _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_HeadImage.frame) + 10 * WideEachUnit, 22 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_HeadImage.frame) - 100 * WideEachUnit , 15 * WideEachUnit)];
    _NameLabel.textColor = [UIColor colorWithHexString:@"#666"];
    _NameLabel.font = Font(12 * WideEachUnit);
    _NameLabel.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_NameLabel];
    _NameLabel.text = @"张三";
    
    //时间
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 15 * WideEachUnit, 80 * WideEachUnit, 20 * WideEachUnit)];
    _TimeLabel.textColor = [UIColor colorWithHexString:@"#666"];
    _TimeLabel.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _TimeLabel.textAlignment = NSTextAlignmentLeft;
    _TimeLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_TimeLabel];
    
    //具体
    _JTLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_HeadImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20, 100)];
    _JTLabel.font = [UIFont systemFontOfSize:14 * WideEachUnit];
    _JTLabel.textColor = [UIColor colorWithHexString:@"#656565"];
    _JTLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_JTLabel];
    
    
    //图片
    _TPView = [[UIView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, MainScreenWidth - 30 * WideEachUnit, 0)];
    _TPView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_TPView];
    
    
    //观看的图片
    UIButton *GKButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70 * WideEachUnit , 0, 20 * WideEachUnit, 10 * WideEachUnit)];
    [GKButton setImage:[UIImage imageNamed:@"question_eyes@3x"] forState:UIControlStateNormal];
    [self addSubview:GKButton];
    _GKButton = GKButton;
    
    //观看人数
    _GKLabel = [[UILabel alloc] initWithFrame:CGRectMake(GKButton.frame.origin.x+GKButton.frame.size.width + 2 * WideEachUnit, 0, 40 * WideEachUnit, 20 * WideEachUnit)];
    _GKLabel.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _GKLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _GKLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_GKLabel];
    _GKLabel.backgroundColor = [UIColor whiteColor];
    
    //评论人数
    _PLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 130 * WideEachUnit, 0, 30 * WideEachUnit, 20 * WideEachUnit)];
    _PLLabel.textColor = [UIColor colorWithRed:130.f / 255 green:130.f / 255 blue:130.f / 255 alpha:1];
    _PLLabel.textAlignment = NSTextAlignmentLeft;
    _PLLabel.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    [self addSubview:_PLLabel];
    _PLLabel.backgroundColor = [UIColor whiteColor];
    
    //评论图片
    UIButton *PLButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 140 * WideEachUnit , 0, 20 * WideEachUnit, 20 * WideEachUnit)];
    //    [PLButton setBackgroundImage:[UIImage imageNamed:@"问答评论评论@2x"] forState:UIControlStateNormal];
    [PLButton setImage:[UIImage imageNamed:@"question_comment@3x"] forState:UIControlStateNormal];
    [self addSubview:PLButton];
    _PLButton = PLButton;
    
    
    //添加灰色地带
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 90 * WideEachUnit, MainScreenWidth , 10 * WideEachUnit)];
    _footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_footView];
    
}



//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.JTLabel.text = text;
    //设置label的最大行数
    self.JTLabel.numberOfLines = 3;
    //    CGSize size = CGSizeMake(MainScreenWidth - 20, MAXFLOAT);//(MainScreenWidth - 20, 1000) 这样的话为自适应
    //
    //    CGSize labelSize = [self.JTLabel.text sizeWithFont:self.JTLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    
    CGRect labelSize = [self.JTLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, 14 * WideEachUnit * 3 + 10 * WideEachUnit) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * WideEachUnit]} context:nil];
    if (labelSize.size.height > 60 * WideEachUnit) {
        labelSize.size.height = 60 * WideEachUnit;
    }
    
    if (text) {
        
    }
    
    //初步确定图片试图的大小
    _TPView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame) + 10, MainScreenWidth, 0);
    _JTLabel.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_HeadImage.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, labelSize.size.height);
    
    NSArray *photoArray = [_dict arrayValueForKey:@"wd_attr"];
    if (photoArray.count == 0) {
        
    } else {
        [self imageWithArray:photoArray];
        return;
    }
    
    //时间
    _TimeLabel.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 15 * WideEachUnit, 90 * WideEachUnit, 20 * WideEachUnit);
    
    _PLButton.frame = CGRectMake(MainScreenWidth - 110 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 18 * WideEachUnit, 17 * WideEachUnit, 17 * WideEachUnit);
    
    _PLLabel.frame = CGRectMake(MainScreenWidth - 90 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 15 * WideEachUnit, 30 * WideEachUnit, 20 * WideEachUnit);
    
    _GKButton.frame = CGRectMake(MainScreenWidth - 60 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 18 * WideEachUnit, 20 * WideEachUnit, 14 * WideEachUnit);

    _GKLabel.frame = CGRectMake(MainScreenWidth - 40 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 15 * WideEachUnit, 30 * WideEachUnit, 20 * WideEachUnit);
    _footView.frame = CGRectMake(0, CGRectGetMaxY(_TimeLabel.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
    
    frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height  + 45 * WideEachUnit + 45 * WideEachUnit + 20 * WideEachUnit);
    NSLog(@"cell高度------%lf",frame.size.height);
    
    self.frame = frame;
    
}

- (void)imageWithArray:(NSArray *)array {
    CGFloat Space = 10;
    CGFloat JJ = 14;
    CGFloat BWirth = (MainScreenWidth - 30 * WideEachUnit - (2 * Space)) / 3;
    
    if (array == nil) {//如果数组为空，说明图片试图的尺寸为0
        _TPView.frame = CGRectMake(0, CGRectGetMaxY(_JTLabel.frame), 0, 0);
        _PLButton.frame = CGRectMake(MainScreenWidth - 140, CGRectGetMaxY(_JTLabel.frame), 20, 20);
        _GKButton.frame = CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_JTLabel.frame), 20, 20);
        _PLLabel.frame = CGRectMake(MainScreenWidth - 120, CGRectGetMaxY(_JTLabel.frame), 30, 20);
        _GKLabel.frame = CGRectMake(MainScreenWidth - 50, CGRectGetMaxY(_JTLabel.frame), 35, 20);
        
    }else {
        //这个的图片是正方形
        for (int i = 0 ; i < array.count ; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + (i % 3) * BWirth + (i % 3) * Space, Space + (i / 3) * BWirth + (i / 3) * Space, BWirth, BWirth)];
            if ([[array objectAtIndex:i] boolValue] == [NSNumber numberWithInt:0]) {
                imageView.image = Image(@"站位图");
            } else {
                 [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",array[i]]] placeholderImage:Image(@"站位图")];
            }

            [_TPView addSubview:imageView];
            
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        }
        
        //图片试图的大小
        if (array.count % 3 == 0) {
             _TPView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, (array.count / 3) * (BWirth + Space));
        } else {
             _TPView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_JTLabel.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, (array.count / 3 + 1) * (BWirth + Space));
        }
        
        //确定点赞和评论的位置
        
        _TimeLabel.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_TPView.frame) + 10 * WideEachUnit, 90 * WideEachUnit, 20 * WideEachUnit);
        _PLButton.frame = CGRectMake(MainScreenWidth - 140, CGRectGetMaxY(_TPView.frame) + 10 * WideEachUnit, 20, 20);
        _GKButton.frame = CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_TPView.frame) + 10 * WideEachUnit, 20, 20);
        _PLLabel.frame = CGRectMake(MainScreenWidth - 120, CGRectGetMaxY(_TPView.frame) + 10 * WideEachUnit, 30, 20);
        _GKLabel.frame = CGRectMake(MainScreenWidth - 48, CGRectGetMaxY(_TPView.frame) + 10 * WideEachUnit, 35, 20);
        
        _footView.frame = CGRectMake(0, CGRectGetMaxY(_GKLabel.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
        //确定backView的大小
        _backView.frame = CGRectMake(0, 5, MainScreenWidth, CGRectGetMaxY(_GKLabel.frame));
        self.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_footView.frame));
    }
    
    //cell的具体可以根据点赞和评论的位置来定
}


- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    NSArray *imageArray = [_dict arrayValueForKey:@"wd_attr"];
    
//    for (int i = 0 ; i < imageArray.count ; i ++) {
//        NSString *index = imageArray[i];
//        if (index) {
//            return;
//        }
//    }
    
    int count = (int)imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSLog(@"---%@",imageArray[i]);
        NSString *url = [imageArray[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = _TPView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];

    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}


- (void)dataWithDict:(NSDictionary *)dict {
    _dict = dict;
    if ([[dict stringValueForKey:@"userface"] isEqual:[NSNull null]]) {
        
    } else {
        [_HeadImage sd_setImageWithURL:[NSURL URLWithString:[dict stringValueForKey:@"userface"]] forState:UIControlStateNormal];
    }
    _NameLabel.text = [dict stringValueForKey:@"uname"];
    _TimeLabel.text = [dict stringValueForKey:@"ctime"];
    
    _GKLabel.text = [dict stringValueForKey:@"wd_browse_count"];
    _PLLabel.text = [dict stringValueForKey:@"wd_comment_count"];
    
    NSString *text = [dict stringValueForKey:@"wd_description"];
    [self setIntroductionText:[Passport filterHTML:text]];
    
    
}


@end
