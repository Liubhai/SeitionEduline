//
//  TestChooseTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestChooseTableViewCell.h"
#import "SYG.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@implementation TestChooseTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //添加标题
    _optionButton = [[UIButton alloc] initWithFrame:CGRectMake(25 * WideEachUnit, 25 * WideEachUnit,25 * WideEachUnit, 25 * WideEachUnit)];
    _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
    _optionButton.titleLabel.font = Font(15 * WideEachUnit );
    _optionButton.layer.cornerRadius = 12.5 * WideEachUnit;
    _optionButton.layer.masksToBounds = YES;
    _optionButton.userInteractionEnabled = NO;
    [_optionButton setTitle:@"A" forState:UIControlStateNormal];
    [self addSubview:_optionButton];
    
    
    //作答
    _questionStem = [[UILabel alloc] initWithFrame:CGRectMake(65 * WideEachUnit, 25 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 25 * WideEachUnit)];
    _questionStem.text = @"梅雨节节，引起一片欧陆";
    _questionStem.font = [UIFont systemFontOfSize:15 * WideEachUnit];
    _questionStem.textColor = [UIColor colorWithHexString:@"#888"];
    [self setIntroductionText:@"梅雨节节，引起一片欧陆"];
    [self addSubview:_questionStem];
    
    
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(65 * WideEachUnit, 0, 50 * WideEachUnit, 75 * WideEachUnit)];
    [self addSubview:_photoView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 10 * WideEachUnit, 50 * WideEachUnit, 55 * WideEachUnit)];
    _headerImageView.backgroundColor = [UIColor redColor];
    [_photoView addSubview:_headerImageView];
    
}


-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _questionStem.text = text;
    //设置label的最大行数
    _questionStem.numberOfLines = 0;
    
    CGRect labelSize = [_questionStem.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 80 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15 * WideEachUnit]} context:nil];
    
    if (labelSize.size.height > 25 * WideEachUnit) {//说明按原来的来弄
        _questionStem.frame = CGRectMake(65 * WideEachUnit,25 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit,labelSize.size.height);
        _optionButton.frame = CGRectMake(25 * WideEachUnit, 12.5 * WideEachUnit + labelSize.size.height / 2 , 25 * WideEachUnit, 25 * WideEachUnit);
        self.frame = CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit + labelSize.size.height);
    } else {
        _questionStem.frame = CGRectMake(65 * WideEachUnit,25 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit,25 * WideEachUnit);
        _optionButton.frame = CGRectMake(25 * WideEachUnit, 25 * WideEachUnit, 25 * WideEachUnit, 25 * WideEachUnit);
        self.frame = CGRectMake(0, 0, MainScreenWidth, 75 * WideEachUnit);
    }

}

- (void)dataWithTitle:(NSString *)title WithNumber:(NSInteger)number{
    
    NSArray *optionsArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
    [_optionButton setTitle:optionsArray[number] forState:UIControlStateNormal];
    
    NSString *text = [Passport filterHTML:title];
    [self setIntroductionText:text];
    
    if ([title rangeOfString:@"img"].location != NSNotFound) {
        _headerImageView.hidden = NO;
        _photoView.hidden = NO;
        
        //图片的处理
        NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
        NSString *originalStr = title;
        NSString *textStr = [originalStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
        
        if (textStr.length>2) {
            NSString *str2 = [textStr substringWithRange:NSMakeRange(0, 3)];
            if ([str2 isEqualToString:@"<p>"]) {
                textStr = [textStr substringFromIndex:3];
            }
        }
        
        NSArray*array = [textStr componentsSeparatedByString:@" "];//从字符A中分隔
        NSString *allUrlStr = [array objectAtIndex:1];
        NSString *urlStr = [allUrlStr substringFromIndex:5];
        urlStr = [urlStr substringToIndex:urlStr.length - 1];
        _currentUrl = urlStr;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        _headerImageView.userInteractionEnabled = YES;
        //添加手势
        [_headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        
    } else {
        _headerImageView.hidden = YES;
        _photoView.hidden = YES;
    }
}


//最先答题的时候的选中
- (void)cellChangeWithType:(NSInteger)whichSubject WithArray:(NSArray *)array WithNumber:(NSInteger)indexPathRow {
    if (array.count == 0) {
        return;
    }
    if (whichSubject == 1) {//单选
        if ([[array objectAtIndex:indexPathRow] integerValue] == 1) {
            _optionButton.backgroundColor = BasidColor;
        } else {
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        }
    } else if (whichSubject == 2) {//多选
        if ([[array objectAtIndex:indexPathRow] integerValue] == 1) {
            _optionButton.backgroundColor = BasidColor;
        } else {
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        }
    } else if (whichSubject == 3) {
        if ([[array objectAtIndex:indexPathRow] integerValue] == 1) {
            _optionButton.backgroundColor = BasidColor;
        } else {
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        }
    }
    
}

//后面解析的时候
- (void)cellChangeWithType:(NSInteger)whichSubject WithArray:(NSArray *)array WithNumber:(NSInteger)indexPathRow WithType:(NSString *)examType {
    if (array.count == 0) {
        return;
    }
    
    //作为参照物
    NSArray *optionsArray = @[@"A",@"B",@"C",@"D",@"E",@"F"];
    
    if (whichSubject == 1) {//单选
        NSInteger index = 100;
        for (int i = 0 ; i < optionsArray.count ; i ++) {
            NSString *optionStr = [optionsArray objectAtIndex:i];
            if ([[array objectAtIndex:0] isEqualToString:optionStr]) {
                index = i;
            }
        }
        
        if (indexPathRow == index) {//说明是同一个
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#6bbc7c"];
        } else {
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        }
    } else if (whichSubject == 2) {//多选
        
        NSMutableArray *indexArray = [NSMutableArray array];
        
        for (int i = 0 ; i < array.count ; i ++) {
            NSString *trustStr = [array objectAtIndex:i];
            for (int k = 0 ; k < optionsArray.count ; k ++) {
                NSString *referStr = [optionsArray objectAtIndex:k];
                if ([trustStr isEqualToString:referStr]) {
                    [indexArray addObject:[NSString stringWithFormat:@"%d",k]];
                    continue;
                }
            }
        }
        
        _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        for (int i = 0 ; i < indexArray.count ; i ++) {
            NSInteger index = [[indexArray objectAtIndex:i] integerValue];
            if (indexPathRow == index) {
                _optionButton.backgroundColor = [UIColor colorWithHexString:@"#6bbc7c"];
            }
        }

        
    } else if (whichSubject == 3) {//判断
        NSInteger index = 100;
        for (int i = 0 ; i < optionsArray.count ; i ++) {
            NSString *optionStr = [optionsArray objectAtIndex:i];
            if ([[array objectAtIndex:0] isEqualToString:optionStr]) {
                index = i;
            }
        }
        
        if (indexPathRow == index) {//说明是同一个
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#6bbc7c"];
        } else {
            _optionButton.backgroundColor = [UIColor colorWithHexString:@"#e1e1e6"];
        }
    }
}

#pragma mark --- 手势

- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    NSArray *imageArray = @[_currentUrl];
    int count = (int)imageArray.count;
//    if (imageArray.count > 3) {
//        count = 3;
//    }
//    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
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
