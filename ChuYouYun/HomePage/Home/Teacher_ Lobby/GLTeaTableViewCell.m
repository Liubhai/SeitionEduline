//
//  GLTeaTableViewCell.m
//  dafengche
//
//  Created by IOS on 17/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "GLTeaTableViewCell.h"
#import "SYG.h"

@interface GLTeaTableViewCell ()

@property (strong ,nonatomic)NSDictionary *dict;

@end
@implementation GLTeaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//注册cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GLTeaTableViewCell"];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.img];
        [self addSubview:self.nameLab];
        [self addSubview:self.JGLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.areaLab];
        [self addSubview:self.lineButton];
        [self addSubview:self.instView];
        [self addSubview:self.instLabel];
        [self addSubview:self.instButton];
        [self addSubview:self.boundaryView];
        [self addSubview:self.arrowsButton];
        
        if ([MoreOrSingle integerValue] == 1) {
            _instView.hidden = YES;
            self.instLabel.hidden = YES;
            self.instView.frame = CGRectMake(0, 130, MainScreenWidth, 10 * WideEachUnit);
            self.boundaryView.frame = CGRectMake(0, 120, MainScreenWidth, 10 * WideEachUnit);
            self.lineButton.hidden = YES;
            self.areaLab.hidden = YES;
            
        } else {
            
        }

    }
    return self;
}


-(UIImageView *)img{

    if (!_img) {
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
    }
    return _img;
}
-(UILabel *)nameLab{
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 10, 27, MainScreenWidth - _img.current_x_w - 20, 30)];
        _nameLab.textColor = [UIColor colorWithHexString:@"#888"];
        _nameLab.font = Font(14);
        _nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLab;
}
-(UILabel *)JGLab{
    
    if (!_JGLab) {
        _JGLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 110, 12, 95, 15)];
        _JGLab.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _JGLab.font = Font(13);
        _JGLab.textAlignment = NSTextAlignmentRight;
        _JGLab.hidden = YES;
    }
    return _JGLab;
}
-(UILabel *)tagLab1{
    
    if (!_tagLab1) {
        _tagLab1 = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 10,_nameLab.current_y_h + 3,55, 20)];
        _tagLab1.textColor = [UIColor colorWithHexString:@"#888"];
        _tagLab1.font = Font(10);
//        [_tagLab1.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
//        [_tagLab1.layer setBorderWidth:0.5];
        _tagLab1.layer.cornerRadius = 3;
        [_tagLab1.layer setMasksToBounds:YES];
        _tagLab1.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        _tagLab1.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab1;
}
-(UILabel *)tagLab2{
    
    if (!_tagLab2) {
        _tagLab2 = [[UILabel alloc]initWithFrame:CGRectMake(_tagLab1.current_x_w + 10,_nameLab.current_y_h + 3,55, 20)];
        _tagLab2.textColor = [UIColor colorWithHexString:@"#888"];
        _tagLab2.font = Font(10);
//        [_tagLab2.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
//        [_tagLab2.layer setBorderWidth:0.5];
        _tagLab2.layer.cornerRadius = 3;
        [_tagLab2.layer setMasksToBounds:YES];
        _tagLab2.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        _tagLab2.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab2;
}

-(UILabel *)tagLab3{
    
    if (!_tagLab3) {
        _tagLab3 = [[UILabel alloc]initWithFrame:CGRectMake(_tagLab2.current_x_w + 5,_nameLab.current_y_h + 3,55, 20)];
        _tagLab3.textColor = [UIColor colorWithHexString:@"#888"];
        _tagLab3.font = Font(13);
//        [_tagLab3.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
//        [_tagLab3.layer setBorderWidth:0.5];
        _tagLab3.layer.cornerRadius = 3;
        [_tagLab3.layer setMasksToBounds:YES];
        _tagLab3.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
        _tagLab3.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab3;
}

-(UILabel *)tagLab4{
    
    if (!_tagLab4) {
        _tagLab4 = [[UILabel alloc]initWithFrame:CGRectMake(_tagLab3.current_x_w + 5,_nameLab.current_y_h + 3,55, 20)];
        _tagLab4.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _tagLab4.font = Font(13);
        [_tagLab4.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
        [_tagLab4.layer setBorderWidth:0.5];
        [_tagLab4.layer setMasksToBounds:YES];
        _tagLab4.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLab4;
}

-(UILabel *)contentLab{
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(15,_img.current_y_h + 10,MainScreenWidth - 30 , 30)];
        _contentLab.textColor = [UIColor colorWithHexString:@"#666"];
        _contentLab.font = Font(12);
        _contentLab.numberOfLines = 2;
        _contentLab.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLab;
}

-(UILabel *)areaLab{
    
    if (!_areaLab) {
        _areaLab = [[UILabel alloc]initWithFrame:CGRectMake(_img.current_x_w + 5,_contentLab.current_y_h + 10,MainScreenWidth - _img.current_x_w - 20, 15)];
        _areaLab.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _areaLab.font = Font(13);
        _areaLab.textAlignment = NSTextAlignmentRight;
    }
    return _areaLab;
}

-(UIButton *)lineButton {
    if (!_lineButton) {
        _lineButton = [[UIButton alloc]initWithFrame:CGRectMake(0,_contentLab.current_y_h + 9,MainScreenWidth, 1)];
        _lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _lineButton.backgroundColor = [UIColor redColor];
    }
    return _lineButton;
}

//机构相关


- (UIView *)instView {
    if (!_instView) {
        _instView = [[UILabel alloc]initWithFrame:CGRectMake(0,_contentLab.current_y_h + 10,MainScreenWidth - 0, 36)];
        _instView.backgroundColor = [UIColor whiteColor];
    }
    if ([MoreOrSingle integerValue] == 1) {
        _instView.frame = CGRectMake(0,_contentLab.current_y_h,MainScreenWidth - 0, 0);
    }
    return _instView;
}


- (UILabel *)instLabel {
    if (!_instLabel) {
        _instLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,_contentLab.current_y_h + 10,MainScreenWidth - 30, 36)];
        _instLabel.backgroundColor = [UIColor whiteColor];
        _instLabel.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
        _instLabel.backgroundColor = [UIColor whiteColor];
        _instLabel.userInteractionEnabled = YES;
        _instLabel.textColor = BasidColor;
        _instLabel.font = Font(13);
    }
    if ([MoreOrSingle integerValue] == 1) {
        _instLabel.frame = CGRectMake(0,_contentLab.current_y_h,MainScreenWidth - 0, 0);
    }
    return _instLabel;
}

-(UIButton *)instButton {
    if (_instButton) {
        _instButton = [[UIButton alloc] initWithFrame:CGRectMake(0,_contentLab.current_y_h + 10,MainScreenWidth - 0, 36)];
        _instButton.backgroundColor = [UIColor redColor];
    }
    if ([MoreOrSingle integerValue] == 1) {
        _instButton.frame = CGRectMake(0,_contentLab.current_y_h,MainScreenWidth - 0, 0);
    }
    return _instButton;
}

-(UIButton *)arrowsButton {
    if (!_arrowsButton) {
        _arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, _contentLab.current_y_h + 10, 50, 36)];
        [_arrowsButton setImage:Image(@"") forState:UIControlStateNormal];
    }
    if ([MoreOrSingle integerValue] == 1) {
        _arrowsButton.frame = CGRectMake(0,_contentLab.current_y_h,MainScreenWidth - 0, 0);
    }
    return _arrowsButton;
}


//分离带
- (UIView *)boundaryView {
    if (!_boundaryView) {
        _boundaryView = [[UILabel alloc]initWithFrame:CGRectMake(0,_instView.current_y_h + 5,MainScreenWidth - 0, 10)];
        _boundaryView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _boundaryView;
}

- (void)dataWithDict:(NSDictionary *)dict {
    
    _dict = dict;
    self.nameLab.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"name"]];
    if ([[dict dictionaryValueForKey:@"school_info"] count]) {
        self.JGLab.text = [NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    }
    
    self.img.image = [UIImage imageNamed:@"站位图"];//展位图
    NSString *url = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"headimg"]];
    [self.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"站位图"]];
    self.img.layer.cornerRadius = 30;
    self.img.layer.masksToBounds = YES;
    
//    NSString *tagstr1 = [NSString stringWithFormat:@"%@年教龄",[dict stringValueForKey:@"teacher_age"]];
//    CGRect frames = self.tagLab1.frame;
//    frames.size.width = tagstr1.length *10 +5;
//    self.tagLab1.frame = frames;
//    self.tagLab1.text = tagstr1;
//    self.tagLab1.font = Font(10);
//    if ([tagstr1 isEqualToString:@"<null>"]) {
//        self.tagLab1.text = @"未知";
//    } else {
//        self.tagLab1.text = tagstr1;
//    }
//
//    NSString *tagstr2 = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"teach_evaluation"]];
//    CGRect frame2 = self.tagLab2.frame;
//    frame2.size.width = tagstr2.length *10 +5;
//    frame2.origin.x = frames.origin.x + frames.size.width + 10;
//    self.tagLab2.frame = frame2;
//    self.tagLab2.text = tagstr2;
//    self.tagLab2.font = Font(10);
//    if (self.tagLab2.text.length > 4) {
//        self.tagLab2.text = [tagstr2 substringToIndex:4];
//        frame2.size.width = 4 *10 +5;
//        frame2.origin.x = frames.origin.x + frames.size.width + 10;
//        self.tagLab2.frame = frame2;
//    }
//
//    if ([tagstr2 isEqualToString:@"<null>"]) {
//        self.tagLab2.text = @"未知";
//    } else {
//        self.tagLab2.text = tagstr2;
//    }
//
//    NSString *tagstr3 = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"graduate_school"]];
//    CGRect frame3 = self.tagLab3.frame;
//    frame3.size.width = tagstr3.length *10 +5;
//    frame3.origin.x = frame2.origin.x + frame2.size.width + 10;
//    self.tagLab3.font = Font(10);
//
//    self.tagLab3.frame = frame3;
//    if (tagstr3.length > 4) {
//        self.tagLab3.text = [tagstr3 substringToIndex:4];
//        frame3.size.width = 4 *10 +5;
//        frame3.origin.x = frame2.origin.x + frame2.size.width + 10;
//        self.tagLab3.frame = frame3;
//    }
//
//    if ([tagstr3 isEqualToString:@"<null>"]) {
//        self.tagLab3.text = @"未知";
//    } else {
//        self.tagLab3.text = tagstr3;
//    }
    
    self.contentLab.text = nil;
    if ([[dict stringValueForKey:@"info"] isEqual:[NSNull null]]) {
        self.contentLab.text = @"";
    } else {
        self.contentLab.text = [Passport filterHTML:[dict stringValueForKey:@"info"]];
    }
    self.contentLab.font = Font(12);
    
    NSString *area = [NSString stringWithFormat:@"%@",[[dict dictionaryValueForKey:@"ext_info"] stringValueForKey:@"location"]];
    
    self.areaLab.text = [NSString stringWithFormat:@"%@",area];
    self.instLabel.text = [NSString stringWithFormat:@"机构信息：%@",[[dict dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    
}

//- (void)instLabelClick:(UIGestureRecognizer *)tap {
//    self.cellDict(_dict, tap);
//}




@end
