//
//  LibraryCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LibraryCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "Passport.h"



@implementation LibraryCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 15 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit)];
    _headImageView.image = Image(@"WORD@3x");
    _headImageView.layer.cornerRadius = 25 * WideEachUnit;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_headImageView];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 15 * WideEachUnit,MainScreenWidth - 2 * SpaceBaside - CGRectGetWidth(_headImageView.frame) - 70 * WideEachUnit, 20 * WideEachUnit)];
    _titleLabel.text = @"2014物业管理师考试参考答案";
    _titleLabel.font = Font(16);
    _titleLabel.textColor = BlackNotColor;
    [self addSubview:_titleLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 38 * WideEachUnit, MainScreenWidth - 2 * SpaceBaside, 20 * WideEachUnit)];
    [self addSubview:_timeLabel];
    _timeLabel.text = @"2016-10-10";
    _timeLabel.font = Font(14);
    _timeLabel.textColor = [UIColor grayColor];
    
//    //文件大小
//    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 50, MainScreenWidth - 2 * SpaceBaside, 15)];
//    [self addSubview:_sizeLabel];
//    _sizeLabel.text = @"文件大小：3M";
//    _sizeLabel.textColor = [UIColor grayColor];
//    _sizeLabel.font = Font(12);
//
   // 文件类型
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 65,MainScreenWidth - 80, 15)];
    [self addSubview:_typeLabel];
    _typeLabel.text = @"文件格式：pdf";
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.font = Font(12);

//    //下载次数
//    _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 10, 80,MainScreenWidth - 80, 15)];
//    [self addSubview:_downLabel];
//    _downLabel.font = Font(12);
//    _downLabel.text = @"下载次数：99";
//    _downLabel.textColor = [UIColor grayColor];
//
    //下载按钮
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 55 * WideEachUnit, 34 * WideEachUnit, 45 * WideEachUnit, 22 * WideEachUnit)];
    [_downButton setTitle:@"下载" forState:UIControlStateNormal];
    _downButton.titleLabel.font = Font(12 * WideEachUnit);
    [_downButton setTitleColor:[UIColor colorWithHexString:@"#9e9e9e"] forState:UIControlStateNormal];
    _downButton.layer.borderWidth = 1;
    _downButton.layer.cornerRadius = 3;
    _downButton.layer.borderColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
    [self addSubview:_downButton];
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSLog(@"-----%@",dict);
    
    _titleLabel.text = [dict stringValueForKey:@"title"];
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    _timeLabel.text = [NSString stringWithFormat:@"%@",timeStr];
    _timeLabel.text = [NSString stringWithFormat:@"兑换次数：%@",[dict stringValueForKey:@"exchange_num"]];
    _downLabel.text = [NSString stringWithFormat:@"兑换次数：%@",[dict stringValueForKey:@"exchange_num"]];
    _typeLabel.text = [NSString stringWithFormat:@"需要积分：%@",[dict stringValueForKey:@"price"]];
    
    NSString *typeStr = [[dict dictionaryValueForKey:@"attach_info"] stringValueForKey:@"extension"];
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁的
        
        _typeLabel.text = [NSString stringWithFormat:@"文件格式：%@",typeStr];
        [_downButton setTitle:@"下载" forState:UIControlStateNormal];
        
    } else {
        [_downButton setTitle:@"兑换" forState:UIControlStateNormal];
        _typeLabel.text = [NSString stringWithFormat:@"需要积分：%@",[dict stringValueForKey:@"price"]];
    }
    
    _typeLabel.text = [NSString stringWithFormat:@"需要积分：%@",[dict stringValueForKey:@"price"]];
    _sizeLabel.text = [NSString stringWithFormat:@"文件大小：%@", [[dict dictionaryValueForKey:@"attach_info"] stringValueForKey:@"size"]];
    
    NSString *urlStr = [dict stringValueForKey:@"cover"];
    
    if ([urlStr isEqualToString:@""]) {//没有图片
        if ([typeStr isEqualToString:@"ppt"] || [typeStr isEqualToString:@"pptx"]) {
            _headImageView.image = Image(@"ppt");
        } else if ([typeStr isEqualToString:@"excel"] || [typeStr isEqualToString:@"xls"]) {
            _headImageView.image = Image(@"Excel.png");
        } else if ([typeStr isEqualToString:@"pdf"]) {
            _headImageView.image = Image(@"pdf");
        } else if ([typeStr isEqualToString:@"word"]) {
            _headImageView.image = Image(@"word");
        } else if ([typeStr isEqualToString:@"txt"]) {
            _headImageView.image = Image(@"txt");
        } else if ([typeStr isEqualToString:@"docx"]) {
            _headImageView.image = Image(@"word");
        } else if ([typeStr isEqualToString:@"zip"]) {
            _headImageView.image = Image(@"zip");
        } else if ([typeStr isEqualToString:@"jpg"]) {
            _headImageView.image = Image(@"word");
        } else {
            _headImageView.image = Image(@"other.png");
        }
    } else {//有图片
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    }
}

- (void)dataWithModel:(ZFFileModel *)Model withState:(NSString *)state {
    
    _titleLabel.text = Model.fileName;
    _sizeLabel.text = Model.fileSize;
    NSString *timeStr = Model.time;
    _timeLabel.text = [NSString stringWithFormat:@"%@",timeStr];
    
    NSString *typeStr = Model.fileType;
    if ([typeStr isEqualToString:@"ppt"] || [typeStr isEqualToString:@"pptx"]) {
        _headImageView.image = Image(@"ppt");
    } else if ([typeStr isEqualToString:@"excel"] || [typeStr isEqualToString:@"xls"]) {
        _headImageView.image = Image(@"Excel.png");
    } else if ([typeStr isEqualToString:@"pdf"]) {
        _headImageView.image = Image(@"pdf");
    } else if ([typeStr isEqualToString:@"word"]) {
        _headImageView.image = Image(@"word");
    } else if ([typeStr isEqualToString:@"txt"]) {
        _headImageView.image = Image(@"txt");
    } else if ([typeStr isEqualToString:@"docx"]) {
        _headImageView.image = Image(@"word");
    } else if ([typeStr isEqualToString:@"zip"]) {
        _headImageView.image = Image(@"zip");
    } else if ([typeStr isEqualToString:@"jpg"]) {
        _headImageView.image = Image(@"word");
    } else {
        _headImageView.image = Image(@"other.png");
    }
    _downButton.frame = CGRectMake(MainScreenWidth - 47 * WideEachUnit, 29 * WideEachUnit, 32 * WideEachUnit, 32 * WideEachUnit);
    _downButton.layer.borderWidth = 0;
    [_downButton setTitle:@"" forState:UIControlStateNormal];
    if ([state integerValue] == 1) {//下载完成了
        [_downButton setImage:Image(@"libDownDele") forState:UIControlStateNormal];
    } else if ([state integerValue] == 2) {//下载未完成
        [_downButton setImage:Image(@"libDownDele") forState:UIControlStateNormal];
    }
    
}


@end
