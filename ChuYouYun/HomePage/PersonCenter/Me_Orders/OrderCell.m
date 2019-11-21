//
//  OrderCell.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "OrderCell.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"


@implementation OrderCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    
    //机构图像
    _schoolImage = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 20, 20)];
    [self addSubview:_schoolImage];
    
    //机构
    _schoolName = [[UILabel alloc] initWithFrame:CGRectMake(40, SpaceBaside, 200, 20)];
    [self addSubview:_schoolName];
    _schoolName.text = @"";
    _schoolName.font = Font(12);
    _schoolName.backgroundColor = [UIColor whiteColor];
    
    //机构按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 12.5, 15, 15)];
    _rightButton.backgroundColor = [UIColor whiteColor];
    [_rightButton setBackgroundImage:Image(@"ic_more@3x") forState:UIControlStateNormal];
    [self addSubview:_rightButton];
    _rightButton.hidden = YES;
    
    
    //机构按钮
    _schoolButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2, 35)];
    _schoolButton.backgroundColor = [UIColor clearColor];
    [self addSubview:_schoolButton];
    
    
    //状态
    _status = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, SpaceBaside, 90, 20)];
    [self addSubview:_status];
    _status.text = @"付款";
    _status.font = Font(13);
    _status.textAlignment = NSTextAlignmentRight;
    _status.backgroundColor = [UIColor whiteColor];
    _status.textColor = BasidColor;
    
    

    
    //添加背景色
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, 90)];
    midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:midView];
    
    
    //添加横线
    UIButton *lineButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [midView addSubview:lineButton1];
    
    
    //图片
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, 50, 100, 70)];
    _headerImage.image = Image(@"你好");
    [self addSubview:_headerImage];
    
    //标题
    _name = [[UILabel alloc] initWithFrame:CGRectMake(120,50,MainScreenWidth - 130, 38)];
    [self addSubview:_name];
    _name.text = @"使用一应";
    _name.font = Font(14);
    _name.numberOfLines = 2;
    _name.textColor = [UIColor blackColor];
    
    //名字
    _content = [[UILabel alloc] initWithFrame:CGRectMake(80, 70,MainScreenWidth - 90, 30)];
    [self addSubview:_content];
    _content.font = Font(12);
    _content.numberOfLines = 2;
    _content.textColor = [UIColor grayColor];
    _content.text = @"你是你上午我问问我我等你过个";
    _content.hidden = YES;
    
    //价格
    _price = [[UILabel alloc] initWithFrame:CGRectMake(120, 90,MainScreenWidth - 140, 30)];
    [self addSubview:_price];
    _price.font = Font(12);
//    _price.textAlignment = NSTextAlignmentRight;
    _price.textColor = [UIColor grayColor];
    _price.text = @"888育币";
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 130, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineButton];
    
    //添加实际价格
    UILabel *real = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 140,50, 30)];
    [self addSubview:real];
    real.font = Font(12);
    real.textColor = [UIColor colorWithHexString:@"#888"];
    real.text = @"实付款：";
    
    _realPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(real.frame), 140,MainScreenWidth / 2 -CGRectGetMaxX(real.frame) - 10 , 30)];
    [self addSubview:_realPrice];
    _realPrice.font = Font(14);
    _realPrice.textColor = BasidColor;
    _realPrice.text = @"实付款：";
    
    
    
    //取消
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 160, 142.5, 70, 25)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = 4;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.titleLabel.font = Font(15);
    _cancelButton.layer.borderColor = BasidColor.CGColor;
    [_cancelButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [self addSubview:_cancelButton];

    
    //付款
    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 142.5, 70, 25)];
    [_actionButton setTitle:@"付款" forState:UIControlStateNormal];
    _actionButton.layer.cornerRadius = 4;
    _actionButton.layer.borderWidth = 1;
    _actionButton.titleLabel.font = Font(15);
    _actionButton.layer.borderColor = BasidColor.CGColor;
    [_actionButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [self addSubview:_actionButton];
    
    //添加最后的View
    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, MainScreenWidth, 10)];
    lastView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f2"];
    [self addSubview:lastView];
    
    //单机构或者多机构的配置
    if ([MoreOrSingle integerValue] == 1) {
        _schoolImage.hidden = YES;
        _schoolName.hidden = YES;
    } else {
        _schoolImage.hidden = NO;
        _schoolName.hidden = NO;
    }
    
}

- (void)dataSourceWith:(NSDictionary *)dict WithType:(NSString *)type {
    
    NSLog(@"%@",type);
    NSLog(@"dict ----- %@",dict);
    
    NSString *imageUrl = nil;
//    NSArray *school_info_array = dict[@"source_info"][@"school_info"];
    NSArray *school_info_array = [[dict dictionaryValueForKey:@"source_info"] arrayValueForKey:@"school_info"];
    if (school_info_array.count == 0) {
        
    } else {

    }
    
    imageUrl = [[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"cover"];
//    imageUrl = [dict stringValueForKey:@"cover"];
    [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
    _schoolName.text = [[[dict dictionaryValueForKey:@"line_class"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"];
    _schoolImage.hidden = YES;
    
    [self setIntroductionText:[[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    if ([[dict stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
        _schoolName.text = [[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"];
        imageUrl = [[[dict dictionaryValueForKey:@"line_class"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"cover"];
        [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
        [self setIntroductionText:[[[dict dictionaryValueForKey:@"line_class"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    } else {
        [self setIntroductionText:[[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    }
    

    
    NSString *urlStr = [[dict dictionaryValueForKey:@"source_info"] stringValueForKey:@"cover"];
    urlStr = [dict stringValueForKey:@"cover"];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    _name.text = [dict stringValueForKey:@"video_name"];
    //课时的判断
    if ([[dict stringValueForKey:@"course_hour_id"] integerValue] != 0) {//课时
            _name.text = [NSString stringWithFormat:@"%@---%@",[dict stringValueForKey:@"video_name"],[dict stringValueForKey:@"course_hour_title"]];
    }
    
    NSString *intro = [self filterHTML:[[dict dictionaryValueForKey:@"source_info"] stringValueForKey:@"video_intro"]];
    _content.text = intro;

    NSInteger payStatus = [[dict stringValueForKey:@"pay_status"] integerValue];
    if (payStatus == 1) {
        _status.text = @"未支付";
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_actionButton setTitle:@"去支付" forState:UIControlStateNormal];
    } else if (payStatus == 2) {
        _status.text = @"已取消";
        [_cancelButton setTitle:@"" forState:UIControlStateNormal];
        [_actionButton setTitle:@"查看" forState:UIControlStateNormal];
        _cancelButton.hidden = YES;
        _actionButton.enabled = NO;
        _actionButton.backgroundColor = [UIColor grayColor];
        [_actionButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        _actionButton.layer.borderColor = [UIColor grayColor].CGColor;
        
    } else if (payStatus == 3) {
        _status.text = @"已支付";
        _cancelButton.hidden = YES;
        if ([[dict stringValueForKey:@"price"] floatValue] == 0) {
            _actionButton.hidden = YES;
        } else {
            [_actionButton setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        if ([type isEqualToString:@"inst"]) {//机构
            _actionButton.hidden = YES;
        }
        
    } else if (payStatus == 4) {
        _status.text = @"退款审核中";
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"查看详情" forState:UIControlStateNormal];
        _actionButton.hidden = YES;
        
        if ([type isEqualToString:@"inst"]) {//机构
            _actionButton.hidden = YES;
        }
        
    } else if (payStatus == 5) {
        _status.text = @"退款成功";
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"退款查看" forState:UIControlStateNormal];
        _actionButton.hidden = YES;
    } else if (payStatus == 6) {
        _status.text = @"已驳回";
        _status.textColor = [UIColor redColor];
        _cancelButton.hidden = YES;
        [_actionButton setTitle:@"驳回原因" forState:UIControlStateNormal];
        _actionButton.hidden = YES;
    }
    _realPrice.text = [NSString stringWithFormat:@"育币 %@",[dict stringValueForKey:@"price"]];
//    _price.text = [NSString stringWithFormat:@"育币 %@",[[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"mzprice"] stringValueForKey:@"oriPrice"]];
    if (SWNOTEmptyStr([dict stringValueForKey:@"video_binfo"])) {
        _price.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_binfo"]];
    } else {
        _price.text = @"";
    }
    //添加手势
    
    if ([type integerValue] == 4) {
        
    } else {
//        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        
//        [self addGestureRecognizer:longPressGr];
    }
    
    
    //线下课判断
    NSString *orderTypeStr = [dict stringValueForKey:@"order_type"];
    if ([orderTypeStr integerValue] == 5) {//线下课
        if ([type isEqualToString:@"order"]) {
            NSString *urlStr = [dict stringValueForKey:@"cover"];
            [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
            _name.text = [dict stringValueForKey:@"video_name"];
//            _price.text = [NSString stringWithFormat:@"育币 %@",[dict stringValueForKey:@"price"]];
        } else if ([type isEqualToString:@"inst"]) {
            NSString *urlStr = [dict stringValueForKey:@"cover"];
            [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
            _name.text = [dict stringValueForKey:@"video_name"];
//            _price.text = [NSString stringWithFormat:@"育币 %@",[dict stringValueForKey:@"price"]];
            
            _schoolName.text = [dict  stringValueForKey:@"title"];
            imageUrl = [dict stringValueForKey:@"cover"];
            [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [self setIntroductionText:[[[dict dictionaryValueForKey:@"source_info"] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
        }
    }
    [_headerImage setWidth:100];
    [_name setLeft:120];
    [_price setLeft:120];
    if ([orderTypeStr integerValue] == 6) {
        [_headerImage setWidth:0];
        [_name setLeft:SpaceBaside];
        [_price setLeft:SpaceBaside];
    }
    
}

#pragma mark ---- 手势

- (void)longPressToDo:(UILongPressGestureRecognizer *)gest {
    [TKProgressHUD showSuccess:@"请不要按了" toView:self];
}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


//赋值 and 自动换行,计算出cell的高度
-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    self.schoolName.text = text;
    //设置label的最大行数
    self.schoolName.numberOfLines = 0;
    
    CGRect labelSize = [self.schoolName.text boundingRectWithSize:CGSizeMake(MainScreenWidth / 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    self.schoolName.frame = CGRectMake(self.schoolName.frame.origin.x, self.schoolName.frame.origin.y,labelSize.size.width, 20);
    
    _rightButton.frame = CGRectMake(CGRectGetMaxX(_schoolName.frame), 15, 10, 10);
    
}



@end
