//
//  StudyRecodeTableViewCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/12.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "StudyRecodeTableViewCell.h"

@implementation StudyRecodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    
    _editingButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    _editingButton.centerY = 77 / 2.0;
    [_editingButton setImage:Image(@"choice_selected") forState:UIControlStateSelected];
    [_editingButton setImage:Image(@"choice_normal") forState:0];
    _editingButton.selected = NO;
    _editingButton.hidden = YES;
    
    [self addSubview:_editingButton];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 118, 67)];
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 3;
    _faceImageView.image = Image(@"站位图");
    [self addSubview:_faceImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 15, _faceImageView.top, MainScreenWidth - _faceImageView.right - 15, 15)];
    _titleLabel.textColor = RGBHex(0x333333);
    _titleLabel.font = SYSTEMFONT(13);
    _titleLabel.text = @"测试数据你懂的请不要说话";
    [self addSubview:_titleLabel];
    
    _courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 10, _titleLabel.width, 14)];
    _courseLabel.font = SYSTEMFONT(12);
    _courseLabel.textColor = RGBHex(0x808080);
    _courseLabel.text = @"第一章 | 第五课时";
    [self addSubview:_courseLabel];
    
    _timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.left, _faceImageView.bottom - 12, 12, 12)];
    _timeIcon.image = Image(@"history");
    [self addSubview:_timeIcon];
    
    _studyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_timeIcon.right + 5, 0, MainScreenWidth - _timeIcon.right - 5 - 15, 12)];
    _studyTimeLabel.textColor = RGBHex(0x808080);
    _studyTimeLabel.font = SYSTEMFONT(10);
    _studyTimeLabel.text = @"学习至00:43:22";
    _studyTimeLabel.centerY = _timeIcon.centerY;
    [self addSubview:_studyTimeLabel];
}

- (void)setStudyRecodeInfo:(NSDictionary *)studyInfo editing:(BOOL)editing selected:(BOOL)selected {
    if (editing) {
        _editingButton.hidden = NO;
        _editingButton.selected = selected;
        _faceImageView.frame = CGRectMake(48, 5, 118, 67);
        _titleLabel.frame = CGRectMake(_faceImageView.right + 15, _faceImageView.top, MainScreenWidth - _faceImageView.right - 15, 15);
        _courseLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 10, _titleLabel.width, 14);
        _timeIcon.frame = CGRectMake(_titleLabel.left, _faceImageView.bottom - 12, 12, 12);
        _studyTimeLabel.frame = CGRectMake(_timeIcon.right + 5, 0, MainScreenWidth - _timeIcon.right - 5 - 15, 12);
        _studyTimeLabel.centerY = _timeIcon.centerY;
    } else {
        _editingButton.hidden = YES;
        _faceImageView.frame = CGRectMake(15, 5, 118, 67);
        _titleLabel.frame = CGRectMake(_faceImageView.right + 15, _faceImageView.top, MainScreenWidth - _faceImageView.right - 15, 15);
        _courseLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 10, _titleLabel.width, 14);
        _timeIcon.frame = CGRectMake(_titleLabel.left, _faceImageView.bottom - 12, 12, 12);
        _studyTimeLabel.frame = CGRectMake(_timeIcon.right + 5, 0, MainScreenWidth - _timeIcon.right - 5 - 15, 12);
        _studyTimeLabel.centerY = _timeIcon.centerY;
    }
    NSString *coverImageString = [NSString stringWithFormat:@"%@",[[studyInfo objectForKey:@"video_info"] objectForKey:@"cover"]];
    if (SWNOTEmptyStr(coverImageString)) {
        [_faceImageView sd_setImageWithURL:[NSURL URLWithString:coverImageString] placeholderImage:Image(@"站位图")];
    } else {
        _faceImageView.image = Image(@"站位图");
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@",[[studyInfo objectForKey:@"video_info"] objectForKey:@"video_title"]];
    NSString *topCate = [NSString stringWithFormat:@"%@",[[studyInfo objectForKey:@"video_section"] objectForKey:@"top_cate"]];
    if (SWNOTEmptyStr(topCate)) {
        topCate = [NSString stringWithFormat:@"%@ | ",topCate];
    }
    NSString *nextCate = [NSString stringWithFormat:@"%@",[[studyInfo objectForKey:@"video_section"] objectForKey:@"next_cate"]];
    NSString *cateString = [NSString stringWithFormat:@"%@%@",topCate,nextCate];
    NSRange topCateRange = [cateString rangeOfString:topCate];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:cateString];
    [pass addAttributes:@{NSForegroundColorAttributeName: BasidColor} range:topCateRange];
    _courseLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    _courseLabel.numberOfLines = 0;
    [_courseLabel sizeToFit];
    if (_courseLabel.height > 14) {
        [_courseLabel setHeight:_courseLabel.height];
    } else {
        [_courseLabel setHeight:14];
    }
    
    NSString *timeCount = [NSString stringWithFormat:@"%@",[studyInfo objectForKey:@"learntime"]];
    _studyTimeLabel.text = [NSString stringWithFormat:@"学习至%@",[YunKeTang_Api_Tool timeChangeWithSecondsFormat:[timeCount integerValue]]];
}

- (void)editingButtonClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(editingButtonClick:)]) {
        [_delegate editingButtonClick:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
