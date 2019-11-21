//
//  HomeLiveTableViewCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/10.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "HomeLiveTableViewCell.h"
#import "SYG.h"

@implementation HomeLiveTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    _grayLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70 + 15 - 4.5 - 32, 1, 32)];
    _grayLineLabel.backgroundColor = RGBHex(0xD8D8D8);
    [self addSubview:_grayLineLabel];
    
    _circleGrayIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, _grayLineLabel.top - 5, 5, 5)];
    _circleGrayIcon.image = Image(@"哈哈circle@3x");
    _circleGrayIcon.centerX = _grayLineLabel.centerX;
    [self addSubview:_circleGrayIcon];
    
    _livingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, 28, 28)];
    _livingImageView.centerX = _grayLineLabel.centerX;
    _livingImageView.animationImages = @[Image(@"live1"),Image(@"live2")];
    _livingImageView.animationDuration = 0.4;
    [self addSubview:_livingImageView];
    
    _liveStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _livingImageView.bottom, 33, 14)];
    _liveStatusLabel.text = @"直播中";
    _liveStatusLabel.textColor = RGBHex(0x696969);
    _liveStatusLabel.font = SYSTEMFONT(10);
    _liveStatusLabel.textAlignment = NSTextAlignmentCenter;
    _liveStatusLabel.centerX = _grayLineLabel.centerX;
    [self addSubview:_liveStatusLabel];
    
    _dayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, 60, 14)];
    _dayTimeLabel.textColor = RGBHex(0x696969);
    _dayTimeLabel.font = SYSTEMFONT(10);
    _dayTimeLabel.text = @"9月30号";
    _dayTimeLabel.textAlignment = NSTextAlignmentCenter;
    _dayTimeLabel.centerX = _grayLineLabel.centerX;
    [self addSubview:_dayTimeLabel];
    
    _secondTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12 + 7.5, 60, 19)];
    _secondTimeLabel.textColor = RGBHex(0x575757);
    _secondTimeLabel.font = SYSTEMFONT(13);
    _secondTimeLabel.text = @"19:30";
    _secondTimeLabel.textAlignment = NSTextAlignmentCenter;
    _secondTimeLabel.centerX = _grayLineLabel.centerX;
    [self addSubview:_secondTimeLabel];
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_grayLineLabel.right + 30, 7.5, 120, 70)];
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.layer.cornerRadius = 4;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.backgroundColor = [UIColor grayColor];
    [self addSubview:_faceImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_faceImageView.right + 13, _faceImageView.top, MainScreenWidth - 10, 40)];
    _titleLabel.textColor = RGBHex(0x454545);
    _titleLabel.font = SYSTEMFONT(14);
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _faceImageView.bottom - 20, 100, 20)];
    _priceLabel.font = SYSTEMFONT(15);
    [self addSubview:_priceLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 0, 100, 15)];
    _countLabel.centerY = _priceLabel.centerY;
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.font = SYSTEMFONT(11);
    _countLabel.textColor = RGBHex(0x696969);
    [self addSubview:_countLabel];
    
    _livingImageView.hidden = YES;
    _liveStatusLabel.hidden = YES;
}

- (void)setLiveInfo:(NSDictionary *)dict order_switch:(NSString *)order_switch liveTime:(NSString *)liveTime {
    
//    [_livingImageView startAnimating];
    _dayTimeLabel.text = [YunKeTang_Api_Tool timeForYYYYMMDD:liveTime];
    _secondTimeLabel.text = [YunKeTang_Api_Tool timeForHHmm:liveTime];
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:[dict stringValueForKey:@"imageurl"]] placeholderImage:Image(@"站位图")];
    _titleLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"video_title"]];
    _titleLabel.frame = CGRectMake(_faceImageView.right + 13, _faceImageView.top, MainScreenWidth - 10, 40);
    [_titleLabel sizeToFit];
    [_titleLabel setHeight:_titleLabel.size.height];
    
    NSString *eoprice = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"mz_price"] objectForKey:@"eoPrice"]];
    if (SWNOTEmptyStr(eoprice)) {
        if ([eoprice integerValue] > 0) {
            _priceLabel.text = [[dict objectForKey:@"mz_price"] objectForKey:@"selPrice"];
            if ([[[dict objectForKey:@"mz_price"] objectForKey:@"selPrice"] floatValue] == 0) {
                _priceLabel.text = @"免费";
                _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
            } else {
                _priceLabel.text = [NSString stringWithFormat:@"%@育币",[[dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
                _priceLabel.textColor = PriceColor;
            }
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"t_price"]];
            _priceLabel.font = Font(12);
            _priceLabel.textAlignment = NSTextAlignmentLeft;
            _priceLabel.textColor = [UIColor colorWithHexString:@"#f01414"];
            if ([[dict stringValueForKey:@"t_price"] floatValue] == 0) {
                _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
                _priceLabel.text = @"免费";
            }
        }
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"t_price"]];
        _priceLabel.font = Font(12);
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = [UIColor colorWithHexString:@"#f01414"];
        if ([[dict stringValueForKey:@"t_price"] floatValue] == 0) {
            _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
            _priceLabel.text = @"免费";
        }
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%@人预约",[dict stringValueForKey:@"video_order_count"]];
    if ([order_switch integerValue] == 1) {
        _countLabel.text = [NSString stringWithFormat:@"%@人预约",[dict stringValueForKey:@"video_order_count_mark"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
