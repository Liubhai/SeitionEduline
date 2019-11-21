//
//  ClassCommentListCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassCommentListCell.h"

@implementation ClassCommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubView];
    }
    return self;
}

// MARK: - 创建子视图
- (void)makeSubView {
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 50, 50)];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 25;
    _headerImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_headerImageView];
    
    _namelabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImageView.right + 10, 0, 200, 50)];
    _namelabel.textColor = RGBHex(0x343434);
    _namelabel.font = [UIFont fontWithName:@"Alibaba-PuHuiTi-M" size:14];
    _namelabel.text = @"会飞的猪儿虫";
    _namelabel.centerY = _headerImageView.centerY;
    [self addSubview:_namelabel];
    
    _timelabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 200, 0, 200, 50)];
    _timelabel.centerY = _headerImageView.centerY;
    _timelabel.textColor = RGBHex(0xC0BEBE);
    _timelabel.font = SYSTEMFONT(12);
    _timelabel.textAlignment = NSTextAlignmentRight;
    _timelabel.text = @"2017-11-07 08:17";
    [self addSubview:_timelabel];
    
    _contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImageView.left, _headerImageView.bottom + 10, MainScreenWidth - 40, 33)];
    _contentlabel.textColor = RGBHex(0x5B5B5B);
    _contentlabel.font = SYSTEMFONT(14);
    _contentlabel.numberOfLines = 0;
    _contentlabel.text = @"我们居然们同样的问题，真巧啊，我和你一样都砸等答案呢，好开心";
    [self addSubview:_contentlabel];
    
    _lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentlabel.bottom + 13, MainScreenWidth, 0.5)];
    _lineView.backgroundColor = EdulineLineColor;
    [self addSubview:_lineView];
    
    _scanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, _lineView.bottom + 5, 23, 23)];
    _scanImageView.image = Image(@"browse");
    [self addSubview:_scanImageView];
    
    _scanCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(_scanImageView.right + 10, _lineView.bottom, 100, 33)];
    _scanCountlabel.textColor = RGBHex(0x909090);
    _scanCountlabel.text = @"320";
    _scanCountlabel.font = SYSTEMFONT(14);
    [self addSubview:_scanCountlabel];
    
    _commentCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 100, _lineView.bottom, 100, 33)];
    _commentCountlabel.textColor = RGBHex(0x909090);
    _commentCountlabel.text = @"320";
    _commentCountlabel.textAlignment = NSTextAlignmentRight;
    _commentCountlabel.font = SYSTEMFONT(14);
    [self addSubview:_commentCountlabel];
    
    _commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_commentCountlabel.left - 10 - 23, _scanImageView.top, 23, 23)];
    _commentImageView.image = Image(@"code");
    [self addSubview:_commentImageView];
    
    _grayLinelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _commentCountlabel.bottom, MainScreenWidth, 10)];
    _grayLinelabel.backgroundColor = EdulineLineColor;
    [self addSubview:_grayLinelabel];
}

- (void)setCommentInfo:(NSDictionary *)dict {
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"userface"]]] placeholderImage:Image(@"站位图")];
    _namelabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
    _scanCountlabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zan_count"]];
    _commentCountlabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comment_count"]];
    _contentlabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"to_comment"]];
    _timelabel.text = [Passport formatterDate:[NSString stringWithFormat:@"%@",[dict objectForKey:@"ctime"]]];
    
    CGFloat commentCountWidth = [_commentCountlabel.text sizeWithFont:_commentCountlabel.font].width;
    [_commentCountlabel setWidth:commentCountWidth];
    [_commentImageView setLeft:_commentCountlabel.left - 10 - 23];
    [_contentlabel setWidth:MainScreenWidth - 40];
    [_contentlabel sizeToFit];
    if (_contentlabel.height>33) {
        [_contentlabel setHeight:_contentlabel.height];
        [self setHeight:162.5 + _contentlabel.height - 33];
    } else {
        [_contentlabel setHeight:33];
        [self setHeight:162.5];
    }
    [_lineView setTop:_contentlabel.bottom + 13];
    [_scanImageView setTop:_lineView.bottom + 5];
    [_scanCountlabel setTop:_lineView.bottom];
    [_commentImageView setTop:_scanImageView.top];
    [_commentCountlabel setTop:_scanCountlabel.top];
    [_grayLinelabel setTop:_commentCountlabel.bottom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
