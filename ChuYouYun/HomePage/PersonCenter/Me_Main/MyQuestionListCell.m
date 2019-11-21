//
//  MyQuestionListCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "MyQuestionListCell.h"

#define myquestionspace 15

@implementation MyQuestionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeSubViewUI];
    }
    return self;
}

- (void)makeSubViewUI {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(myquestionspace, myquestionspace, MainScreenWidth - myquestionspace * 2, 15)];
    _titleLabel.font = SYSTEMFONT(15);
    _titleLabel.textColor = RGBHex(0x333333);
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 10, _titleLabel.width, 15)];
    _fromLabel.font = SYSTEMFONT(15);
    _fromLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _fromLabel.numberOfLines = 0;
    [self addSubview:_fromLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _fromLabel.bottom + 10, _titleLabel.width, 23)];
    _timeLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _timeLabel.font = SYSTEMFONT(12);
    [self addSubview:_timeLabel];
    
    _scanCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - myquestionspace - 20, _timeLabel.top, 20, 23)];
    _scanCountLabel.font = SYSTEMFONT(12);
    [self addSubview:_scanCountLabel];
    
    _scanCountImage = [[UIImageView alloc] initWithFrame:CGRectMake(_scanCountLabel.left - 23, _timeLabel.top, 23, 23)];
    _scanCountImage.image = Image(@"browse");
    [self addSubview:_scanCountImage];
    
    _commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scanCountImage.left - 20, _timeLabel.top, 20, 23)];
    _commentCountLabel.font = SYSTEMFONT(12);
    [self addSubview:_commentCountLabel];
    
    _commentCountImage = [[UIImageView alloc] initWithFrame:CGRectMake(_commentCountLabel.left - 23, _timeLabel.top, 23, 23)];
    _commentCountImage.image = Image(@"code");
    [self addSubview:_commentCountImage];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _timeLabel.bottom, MainScreenWidth, 10)];
    _lineView.backgroundColor = RGBHex(0xEEEEEE);
    [self addSubview:_lineView];
}

- (void)setQuestionListCellInfo:(NSDictionary *)questionInfo typeString:(NSString *)typeString {
    if (SWNOTEmptyDictionary(questionInfo)) {
        
        _titleLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"qst_description"]];
        [_titleLabel setWidth:MainScreenWidth - myquestionspace * 2];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        [_titleLabel setHeight:_titleLabel.height];
        
        _fromLabel.text = [NSString stringWithFormat:@"源自:%@",[questionInfo objectForKey:@"video_title"]];
        if ([typeString isEqualToString:@"2"]) {
            _fromLabel.text = [NSString stringWithFormat:@"源自:%@->%@",[questionInfo objectForKey:@"video_title"],[[questionInfo objectForKey:@"wenti"] objectForKey:@"qst_description"]];
        }
        [_fromLabel setWidth:MainScreenWidth - myquestionspace * 2];
        _fromLabel.numberOfLines = 0;
        [_fromLabel sizeToFit];
        [_fromLabel setTop:_titleLabel.bottom + 10];
        [_fromLabel setHeight:_fromLabel.height];
        
        [_timeLabel setTop:_fromLabel.bottom + 10];
        [_scanCountLabel setTop:_timeLabel.top];
        [_scanCountImage setTop:_timeLabel.top];
        [_commentCountImage setTop:_timeLabel.top];
        [_commentCountLabel setTop:_timeLabel.top];
        
        _timeLabel.text = [YunKeTang_Api_Tool formateTime:[NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"ctime"]]];
        _scanCountLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"qcount"]];
        _commentCountLabel.text = [NSString stringWithFormat:@"%@",[questionInfo objectForKey:@"qst_comment_count"]];
        if ([typeString isEqualToString:@"2"]) {
            _scanCountLabel.text = [NSString stringWithFormat:@"%@",[[questionInfo objectForKey:@"wenti"] objectForKey:@"qst_help_count"]];
            _commentCountLabel.text = [NSString stringWithFormat:@"%@",[[questionInfo objectForKey:@"wenti"] objectForKey:@"qst_comment_count"]];
        }
        CGFloat scanWidth = [_scanCountLabel.text sizeWithFont:_scanCountLabel.font].width + 4;
        CGFloat commentWidth = [_commentCountLabel.text sizeWithFont:_commentCountLabel.font].width + 4;
        
        [_scanCountLabel setWidth:scanWidth];
        [_scanCountLabel setRight:MainScreenWidth - myquestionspace];
        [_scanCountImage setRight:_scanCountLabel.left];
        
        [_commentCountLabel setWidth:commentWidth];
        [_commentCountLabel setRight:_scanCountImage.left - 20];
        [_commentCountImage setRight:_commentCountLabel.left];
        
        [_lineView setTop:_timeLabel.bottom];
        
        [self setHeight:_lineView.bottom];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
