//
//  TestMainTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestMainTableViewCell.h"
#import "SYG.h"


#define cellW MainScreenWidth - 20 * WideEachUnit


@implementation TestMainTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    self.layer.shadowOffset = CGSizeMake(0, 3);//偏移距离
    self.layer.shadowOpacity = 0.5;//不透明度
    self.layer.shadowRadius = 3;//半径
    self.userInteractionEnabled = YES;
    
    
    //头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellW - 100 * WideEachUnit, 25 * WideEachUnit, 80 * WideEachUnit, 80 * WideEachUnit)];
    _headImageView.image = Image(@"文档图标");
    _headImageView.layer.cornerRadius = 40 * WideEachUnit;
    _headImageView.layer.masksToBounds = YES;
    [self addSubview:_headImageView];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 40 * WideEachUnit,cellW - 100 * WideEachUnit - 20 * WideEachUnit, 20 * WideEachUnit)];
    _titleLabel.font = Font(20 * WideEachUnit);
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_titleLabel];
    
    //时间
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 70 * WideEachUnit, MainScreenWidth - 120 *
                                                              WideEachUnit, 15)];
    [self addSubview:_contentLabel];
    _contentLabel.font = Font(16 * WideEachUnit);
    _contentLabel.textColor = [UIColor grayColor];
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSLog(@"-----%@",dict);
    
    _titleLabel.text = [dict stringValueForKey:@"title"];
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    _timeLabel.text = [NSString stringWithFormat:@"更新时间：%@",timeStr];
    _downLabel.text = [NSString stringWithFormat:@"兑换次数：%@",[dict stringValueForKey:@"exchange_num"]];
    
    NSString *typeStr = [[dict dictionaryValueForKey:@"attach_info"] stringValueForKey:@"extension"];
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {//解锁的
        
        _typeLabel.text = [NSString stringWithFormat:@"文件格式：%@",typeStr];
        [_downButton setTitle:@"下载" forState:UIControlStateNormal];
        
    } else {
        [_downButton setTitle:@"兑换" forState:UIControlStateNormal];
        _typeLabel.text = [NSString stringWithFormat:@"需要积分：%@",[dict stringValueForKey:@"price"]];
    }
    _sizeLabel.text = [NSString stringWithFormat:@"文件大小：%@", [[dict dictionaryValueForKey:@"attach_info"] stringValueForKey:@"size"]];
    
    NSString *urlStr = dict[@"cover"];
    
    if ([urlStr isEqualToString:@""]) {//没有图片
        if ([typeStr isEqualToString:@"ppt"] || [typeStr isEqualToString:@"pptx"]) {
            _headImageView.image = Image(@"ppt");
        } else if ([typeStr isEqualToString:@"excel"]) {
            _headImageView.image = Image(@"excel");
        } else if ([typeStr isEqualToString:@"pdf"]) {
            _headImageView.image = Image(@"pdf");
        } else if ([typeStr isEqualToString:@"word"]) {
            _headImageView.image = Image(@"word");
        } else if ([typeStr isEqualToString:@"txt"]) {
            _headImageView.image = Image(@"txt");
        } else if ([typeStr isEqualToString:@"docx"]) {
            _headImageView.image = Image(@"word");
        }
        
    } else {//有图片
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        
    }
    
    
    
    
    
}



@end
