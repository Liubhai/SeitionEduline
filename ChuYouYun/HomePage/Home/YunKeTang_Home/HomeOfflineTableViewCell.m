//
//  HomeOfflineTableViewCell.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/11.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "HomeOfflineTableViewCell.h"
#import "SYG.h"

@implementation HomeOfflineTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 120, 70)];
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
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _faceImageView.bottom - 20, MainScreenWidth - _titleLabel.left - 15, 20)];
    _priceLabel.font = SYSTEMFONT(15);
    [self addSubview:_priceLabel];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 15 - 100, 0, 100, 15)];
    _countLabel.centerY = _priceLabel.centerY;
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.font = SYSTEMFONT(11);
    _countLabel.textColor = RGBHex(0x696969);
    [self addSubview:_countLabel];
}

- (void)setOfflineInfo:(NSDictionary *)dict order_switch:(NSString *)order_switch {
    
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:[dict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
    NSString *timeString = [YunKeTang_Api_Tool timeForYYYYMMDD:[NSString stringWithFormat:@"%@",[dict objectForKey:@"listingtime"]]];
    _titleLabel.text = [NSString stringWithFormat:@"%@ %@",timeString,[dict objectForKey:@"course_name"]];
    _titleLabel.frame = CGRectMake(_faceImageView.right + 13, _faceImageView.top, MainScreenWidth - 10, 40);
    [_titleLabel sizeToFit];
    [_titleLabel setHeight:_titleLabel.size.height];
    
    NSRange timeRange = [_titleLabel.text rangeOfString:timeString];
    
    NSMutableAttributedString *pass = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    [pass addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x2C92F8)} range:timeRange];
    
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:pass];
    
    _priceLabel.text = [dict stringValueForKey:@"price"];
    if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
        _priceLabel.text = @"免费";
        _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
    } else {
        NSString *t_price = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"t_price"]];
        _priceLabel.text = [NSString stringWithFormat:@"%@育币 %@",[dict stringValueForKey:@"price"],t_price];
        _priceLabel.textColor = PriceColor;
        NSRange t_priceRange = [_priceLabel.text rangeOfString:t_price];
        NSMutableAttributedString *t_pricePass = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
        [t_pricePass addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x8C8C8C),NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSFontAttributeName: SYSTEMFONT(12)} range:t_priceRange];
        _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:t_pricePass];
    }
    
//    NSString *eoprice = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"mz_price"] objectForKey:@"eoPrice"]];
//    if (SWNOTEmptyStr(eoprice)) {
//        if ([eoprice integerValue]>0) {
//            _priceLabel.text = [[dict objectForKey:@"mz_price"] objectForKey:@"selPrice"];
//            if ([[[dict objectForKey:@"mz_price"] objectForKey:@"selPrice"] floatValue] == 0) {
//                _priceLabel.text = @"免费";
//                _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
//            } else {
//                _priceLabel.text = [NSString stringWithFormat:@"%@育币",[[dict objectForKey:@"mz_price"] objectForKey:@"selPrice"]];
//                _priceLabel.textColor = PriceColor;
//            }
//        } else {
//            _priceLabel.text = [dict stringValueForKey:@"price"];
//            if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
//                _priceLabel.text = @"免费";
//                _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
//            } else {
//                _priceLabel.text = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"price"]];
//                _priceLabel.textColor = PriceColor;
//            }
//        }
//    } else {
//        _priceLabel.text = [dict stringValueForKey:@"price"];
//        if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
//            _priceLabel.text = @"免费";
//            _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
//        } else {
//            NSString *t_price = [NSString stringWithFormat:@"%@育币",[dict stringValueForKey:@"t_price"]];
//            _priceLabel.text = [NSString stringWithFormat:@"%@育币 %@",[dict stringValueForKey:@"price"],t_price];
//            _priceLabel.textColor = PriceColor;
//            NSRange t_priceRange = [_priceLabel.text rangeOfString:t_price];
//            NSMutableAttributedString *t_pricePass = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
//            [t_pricePass addAttributes:@{NSForegroundColorAttributeName: RGBHex(0x8C8C8C),NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:t_priceRange];
//            _priceLabel.attributedText = [[NSAttributedString alloc] initWithAttributedString:t_pricePass];
//        }
//    }
    
    _countLabel.text = [NSString stringWithFormat:@"%@人预约",[dict stringValueForKey:@"course_order_count"]];
    if ([order_switch integerValue] == 1) {
        _countLabel.text = [NSString stringWithFormat:@"%@人预约",[dict stringValueForKey:@"course_order_count_mark"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
