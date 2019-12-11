//
//  ClassCourseListCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassCourseListCell.h"

/** 两边边距 */
#define space 20 * WideEachUnit
/** 封面宽 */
#define faceImageWidth 108 * WideEachUnit
/** 封面高 */
#define faceImageHeight 60 * HigtEachUnit
/** 封面和文字之间间距 */
#define faceToThemeSpace 10 * WideEachUnit


@implementation ClassCourseListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView {  
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, 8, faceImageWidth, faceImageHeight)];
    _faceImageView.image = Image(@"站位图");
    [self addSubview:_faceImageView];
    
    _themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + faceToThemeSpace, _faceImageView.top + 4.5, MainScreenWidth - space * 2 - (_faceImageView.right + faceToThemeSpace), 15)];
    _themeLabel.font = SYSTEMFONT(12);
    _themeLabel.textColor = RGBHex(0x414141);
    _themeLabel.text = @"Swift语言学习教程";
    _themeLabel.centerY = 8 + _faceImageView.height / 6.0;
    [self addSubview:_themeLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - space - 100, _themeLabel.top, 100, 15)];
    _priceLabel.font = SYSTEMFONT(13);
    _priceLabel.textColor = RGBHex(0xFF0000);
    _priceLabel.text = @"育币100";
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.centerY = _themeLabel.centerY;
    [self addSubview:_priceLabel];
    
    _courseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_themeLabel.left, 0, 100, 15)];
    _courseTimeLabel.text = @"课时：14节";
    _courseTimeLabel.textColor = RGBHex(0xA3A3A3);
    _courseTimeLabel.font = SYSTEMFONT(11);
    _courseTimeLabel.centerY = 8 + _faceImageView.height / 2.0;
    [self addSubview:_courseTimeLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(_themeLabel.left, 0, MainScreenWidth - _themeLabel.left - space, 15)];
    _introLabel.text = @"我是一个简介哦我是一个简介哦我是一个简介哦我是一个简介哦我是一个简介哦";
    _introLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _introLabel.textColor = RGBHex(0xADACB4);
    _introLabel.font = SYSTEMFONT(10);
    _introLabel.centerY = 8 + _faceImageView.height * 5 / 6.0;
    [self addSubview:_introLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(space, _faceImageView.bottom + 7.5, MainScreenWidth - space * 2, 0.5)];
    _lineView.backgroundColor = EdulineLineColor;
    [self addSubview:_lineView];
}

- (void)setCourseInfo:(NSDictionary *)dict {
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"imageurl"]]] placeholderImage:Image(@"站位图")];
    _themeLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"video_title"]];
    _priceLabel.text = [NSString stringWithFormat:@"育币%@",[dict objectForKey:@"t_price"]];
    CGFloat priceWidth = [_priceLabel.text sizeWithFont:_priceLabel.font].width + 4;
    [_priceLabel setWidth:priceWidth];
    [_priceLabel setRight:MainScreenWidth - 20];
    [_themeLabel setWidth:MainScreenWidth - space * 2 - (_faceImageView.right + faceToThemeSpace) - priceWidth];
    _courseTimeLabel.text = [NSString stringWithFormat:@"课时：%@节",[dict objectForKey:@"sectionNum"]];
    _introLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"video_intro"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
