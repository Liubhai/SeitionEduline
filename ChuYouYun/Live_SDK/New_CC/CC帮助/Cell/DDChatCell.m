//
//  DDChatCell.m
//  ChuYouYun
//
//  Created by 赛新科技 on 2017/5/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "DDChatCell.h"
#import "Utility.h"
#import "UIImage+Extension.h"

#define kContentFontSize        16.0f   //内容字体大小
#define kPadding                5.0f    //控件间隙
#define kEdgeInsetsWidth       20.0f   //内容内边距宽度
#define kWidth [UIScreen mainScreen].bounds.size.width //获取设备的物理宽度
#define kHeight [UIScreen mainScreen].bounds.size.height //获取设备的物理高度

@interface DDChatCell ()

/** 名称 */
@property (nonatomic, retain) UILabel      *titleLabel;
/** 背景图 */
@property (nonatomic, retain) UIButton      *bgButton;
/** 文字内容视图 */
@property (nonatomic, retain) UILabel       *contentLabel;

@end

@implementation DDChatCell

#pragma mark - life cirle method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    //初始化名称视图
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:kContentFontSize];
    _titleLabel.numberOfLines = 1;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.contentView addSubview:_titleLabel];
    
    //初始化正文视图
    _bgButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_bgButton];
    
    //初始化正文视图
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
    _contentLabel.numberOfLines = 0;
    [_bgButton addSubview:_contentLabel];
}

#pragma mark - class method
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"chatCell";
    DDChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DDChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

/** 计算cell 的高度 */
+ (CGFloat)heightOfCellWithMessage:(NSString *)message
{
    CGFloat height = 0;
    
    float textMaxWidth = kWidth-kPadding *2-60; //60是消息框体距离右侧或者左侧的距离
    
    NSMutableAttributedString *attrStr = [Utility emotionStrWithString:message y:-8];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:kContentFontSize]
                    range:NSMakeRange(0, attrStr.length)];
    CGSize textSize = [attrStr boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:nil].size;
    height = (textSize.height+kEdgeInsetsWidth*2) + 30;
    
    if (height < 90) {
        height = 90;
    }
    return height;
}

#pragma mark - setter and getter
- (void)showMessage:(NSString *)message fromSelf:(BOOL)fromSelf title:(NSString *)title
{
    if(fromSelf) {
        _titleLabel.frame = CGRectMake(kPadding + 60,10,kWidth-kPadding *2-60,20);
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        
    } else {
        _titleLabel.frame = CGRectMake(kPadding,10,kWidth-kPadding *2-60,20);
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    // 1、计算文字的宽高
    float textMaxWidth = kWidth-kPadding *2-60; //60是消息框体距离右侧或者左侧的距离
    
    NSMutableAttributedString *attrStr = [Utility emotionStrWithString:message y:-8];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:kContentFontSize]
                    range:NSMakeRange(0, attrStr.length)];
    CGSize textSize = [attrStr boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:nil].size;
    
    _contentLabel.attributedText = attrStr;
    // 2、计算背景图片的frame，X坐标发送和接收计算方式不一样
    CGFloat bgY = 30;
    CGFloat width = textSize.width + kEdgeInsetsWidth*2;
    CGFloat height = textSize.height + kEdgeInsetsWidth*2;
    UIImage *bgImage; //声明一个背景图片对象
    // 3、判断是否为自己发送，来设置frame以及背景图片
    if (fromSelf) { //如果是自己发送的
        _contentLabel.frame = CGRectMake(kEdgeInsetsWidth - 3, kEdgeInsetsWidth - 3, textSize.width, textSize.height);
        CGFloat bgX = kWidth-kPadding*2-width;
        _bgButton.frame = CGRectMake(bgX,bgY, width, height);
        [_bgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bgImage = [UIImage resizableImageWithName:@"SenderAppNodeBkg_HL"];
    } else {
        _contentLabel.frame = CGRectMake(kEdgeInsetsWidth + 2, kEdgeInsetsWidth - 3, textSize.width, textSize.height);
        CGFloat bgX = kPadding;
        _bgButton.frame = CGRectMake(bgX, bgY, width, height);
        [_bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgImage = [UIImage resizableImageWithName:@"ReceiverTextNodeBkg"];
    }
    [_bgButton setBackgroundImage:bgImage forState:UIControlStateNormal];
}

@end 
