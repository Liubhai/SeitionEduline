//
//  BRAVideoDownShowNotXibTableViewCell.m
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BRAVideoDownShowNotXibTableViewCell.h"
#import "HWCircleView.h"
#import "Masonry.h"
@interface BRAVideoDownShowNotXibTableViewCell()
@property (nonatomic, strong) HWCircleView *circleProgressView;
@end
@implementation BRAVideoDownShowNotXibTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)br_updateProgress:(float)progress{
    if (progress >= 0) {
        _circleProgressView.hidden = NO;
        _circleProgressView.progress = MIN(progress, 1);
        _mStatusLabel.hidden = YES;
    }
    else{
        _circleProgressView.hidden = YES;
        _mStatusLabel.hidden = NO;
    }
}
- (void)br_selectedDownFile{
    if (self.br_selectedBlock) {
        self.br_selectedBlock(self);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGRect progressFrame = self.circleProgressView.frame;
    progressFrame.origin.x = self.bounds.size.width - progressFrame.size.width - 20;
    progressFrame.origin.y = (self.bounds.size.height - progressFrame.size.height) / 2.0;
    self.circleProgressView.frame = progressFrame;
//    _circleProgressView.center = _mStatusLabel.center;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        
        self.nNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nNameLabel];
        [self.nNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12));
            make.centerY.equalTo(self.contentView);
        }];
        self.nNameLabel.font = [UIFont systemFontOfSize:15];
        self.mStatusLabel = [UILabel new];
        [self.contentView addSubview:self.mStatusLabel];
        [self.mStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.left.equalTo(self.nNameLabel.mas_right).offset(5);
        }];
        self.mStatusLabel.layer.cornerRadius = 5.0;
        self.mStatusLabel.clipsToBounds = YES;
        self.mStatusLabel.layer.borderWidth = 1;
        self.mStatusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.mStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.mStatusLabel.font = [UIFont systemFontOfSize:13];
        self.mStatusLabel.textColor = [UIColor darkGrayColor];
        _circleProgressView = [[HWCircleView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _circleProgressView.cLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_circleProgressView];
        _circleProgressView.hidden = YES;
        _mStatusLabel.text = @"下载";
        _circleProgressView.userInteractionEnabled = NO;
        _mStatusLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(br_selectedDownFile)];
        [_mStatusLabel addGestureRecognizer:tap];
    }
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
