//
//  InstitutionsTableViewCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/10/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "InstitutionsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InstitutionsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    _faceImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (68 - 37) / 2.0, 37, 37)];
    _faceImage.layer.masksToBounds = YES;
    _faceImage.layer.cornerRadius = 37 / 2.0;
    _faceImage.clipsToBounds = YES;
    _faceImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_faceImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImage.right + 12, _faceImage.top, MainScreenWidth - (_faceImage.right + 12), 37)];
    _nameLabel.font = SYSTEMFONT(14);
    _nameLabel.textColor = RGBHex(0x333333);
    [self addSubview:_nameLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, MainScreenWidth, 0.5)];
    _lineView.backgroundColor = RGBHex(0xF3F3F3);
    [self addSubview:_lineView];
}

- (void)setInstitutionInfo:(NSDictionary *)institutionInfo {
    if (SWNOTEmptyDictionary(institutionInfo)) {
        if (SWNOTEmptyStr([institutionInfo objectForKey:@"cover"])) {
            [_faceImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[institutionInfo objectForKey:@"cover"]]] placeholderImage:Image(@"站位图")];
        } else {
            _faceImage.image = Image(@"站位图");
        }
        _nameLabel.text = [NSString stringWithFormat:@"%@",[institutionInfo objectForKey:@"title"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
