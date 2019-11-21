//
//  EvaluateCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "EvaluateCell.h"

#define myquestionspace15 15

@implementation EvaluateCell
//NSString *starStr = [NSString stringWithFormat:@"10%@@2x",[dict stringValueForKey:@"star"]];

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubViewUI];
    }
    return self;
}

- (void)makeSubViewUI {
    
    _starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myquestionspace15, myquestionspace15, 63, 10)];
    [self addSubview:_starImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(myquestionspace15, _starImageView.bottom + 5, MainScreenWidth - myquestionspace15 * 2, 15)];
    _titleLabel.font = SYSTEMFONT(13);
    _titleLabel.textColor = RGBHex(0x333333);
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 10, _titleLabel.width, 15)];
    _fromLabel.font = SYSTEMFONT(14);
    _fromLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _fromLabel.numberOfLines = 0;
    [self addSubview:_fromLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _fromLabel.bottom + 10, _titleLabel.width, 23)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _timeLabel.font = SYSTEMFONT(12);
    [self addSubview:_timeLabel];
    
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - myquestionspace15 - 20, _timeLabel.top, 20, 23)];
    _commentCountLabel.font = SYSTEMFONT(12);
    [self addSubview:_commentCountLabel];
    
    _commentCountImage = [[UIImageView alloc] initWithFrame:CGRectMake(_commentCountLabel.left - 23, _timeLabel.top, 23, 23)];
    _commentCountImage.image = Image(@"code");
    [self addSubview:_commentCountImage];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _timeLabel.bottom, MainScreenWidth, 1)];
    _lineView.backgroundColor = RGBHex(0xEEEEEE);
    [self addSubview:_lineView];
}

- (void)setEvaluateListCellInfo:(NSDictionary *)questionInfo typeString:(NSString *)typeString {
    if (SWNOTEmptyDictionary(questionInfo)) {
        
        NSString *starStr = [NSString stringWithFormat:@"10%@@2x",[questionInfo stringValueForKey:@"star"]];
        _starImageView.image = Image(starStr);
        
        _titleLabel.text = [NSString stringWithFormat:@"源自:%@",[questionInfo objectForKey:@"video_title"]];
        [_titleLabel setWidth:MainScreenWidth - myquestionspace15 * 2];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        [_titleLabel setHeight:_titleLabel.height];
        
        _fromLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"review_description"]];
        
        [_fromLabel setWidth:MainScreenWidth - myquestionspace15 * 2];
        _fromLabel.numberOfLines = 0;
        [_fromLabel sizeToFit];
        [_fromLabel setTop:_titleLabel.bottom + 10];
        [_fromLabel setHeight:_fromLabel.height];
        
        [_timeLabel setTop:_fromLabel.bottom + 10];
        [_commentCountImage setTop:_timeLabel.top];
        [_commentCountLabel setTop:_timeLabel.top];
        
        _timeLabel.text = [YunKeTang_Api_Tool formateTime:[NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"ctime"]]];
        _commentCountLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"review_comment_count"]];

        CGFloat commentWidth = [_commentCountLabel.text sizeWithFont:_commentCountLabel.font].width + 4;
        
        [_commentCountLabel setWidth:commentWidth];
        [_commentCountLabel setRight:MainScreenWidth - myquestionspace15];
        [_commentCountImage setRight:_commentCountLabel.left];
        
        [_lineView setTop:_timeLabel.bottom];
        
        [self setHeight:_lineView.bottom];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
