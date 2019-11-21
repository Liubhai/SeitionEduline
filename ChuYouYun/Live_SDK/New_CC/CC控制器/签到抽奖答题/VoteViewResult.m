//
//  VoteViewResult.m
//  NewCCDemo
//
//  Created by cc on 2017/1/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "VoteViewResult.h"
#import "CC _header.h"


@interface VoteViewResult()

@property(nonatomic,strong)UIImageView              *resultImage;
@property(nonatomic,strong)UIView                   *bgView;
@property(nonatomic,strong)UILabel                  *label;
@property(nonatomic,strong)UIView                   *lineView;
@property(nonatomic,strong)UIButton                 *closeBtn;
@property(nonatomic,strong)UIView                   *labelBgView;
@property(nonatomic,strong)UILabel                  *centerLabel;
@property(nonatomic,strong)UIView                   *view;

@property(nonatomic,strong)UILabel                  *myLabel;
@property(nonatomic,strong)UILabel                  *correctLabel;

@property(nonatomic,copy)  CloseBtnClicked          closeblock;
@property(nonatomic,assign)NSDictionary             *resultDic;
@property(nonatomic,assign)NSInteger                mySelectIndex;
@property(nonatomic,strong)NSMutableArray           *mySelectIndexArray;

@end

//答题
@implementation VoteViewResult

-(instancetype) initWithResultDic:(NSDictionary *)resultDic mySelectIndex:(NSInteger)mySelectIndex mySelectIndexArray:(NSMutableArray *)mySelectIndexArray closeblock:(CloseBtnClicked)closeblock {
    self = [super init];
    if(self) {
        self.mySelectIndex          = mySelectIndex;
        self.resultDic              = resultDic;
        self.closeblock             = closeblock;
        self.mySelectIndexArray     = [mySelectIndexArray mutableCopy];
        [self initUI];
    }
    return self;
}

-(void)initUI {
    WS(ws)
    
    self.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
    _view = [[UIView alloc]init];
    _view.backgroundColor = CCRGBColor(255,81,44);
    _view.layer.cornerRadius = CCGetRealFromPt(6);
    [self addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws).offset(CCGetRealFromPt(75));
        make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(75));
        make.top.mas_equalTo(ws).offset(CCGetRealFromPt(668));
        if([self.resultDic[@"statisics"] count] == 5) {
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(104));
        } else if([self.resultDic[@"statisics"] count] == 4) {
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(162));
        } else if([self.resultDic[@"statisics"] count] == 3) {
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(220));
        } else if([self.resultDic[@"statisics"] count] == 2) {
            make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(278));
        }
    }];

    self.bgView = [UIView new];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    self.bgView.layer.cornerRadius = CCGetRealFromPt(6);
    [_view addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(1);
        make.top.mas_equalTo(ws.view).offset(1);
        make.right.mas_equalTo(ws.view).offset(-1);
        make.bottom.mas_equalTo(ws.view).offset(-(1 + CCGetRealFromPt(4)));
    }];
    
    [self.bgView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(70));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(80));
        make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(26));
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView addSubview:self.resultImage];
    [_resultImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.bgView);
        make.bottom.mas_equalTo(ws.view.mas_top).offset(CCGetRealFromPt(54));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(110), CCGetRealFromPt(110)));
    }];
    
    [self.bgView addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.bgView);//.offset(CCGetRealFromPt(0));
        make.right.mas_equalTo(ws.bgView);//.offset(-CCGetRealFromPt(0));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80), CCGetRealFromPt(80)));
    }];
    
    [self.bgView addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.bgView);
        make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(66));
        make.height.mas_equalTo(CCGetRealFromPt(36));
    }];
    
    [self.bgView addSubview:self.labelBgView];
    [_labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(105));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(105));
        make.top.mas_equalTo(ws.label.mas_bottom).offset(CCGetRealFromPt(24));
        make.height.mas_equalTo(CCGetRealFromPt(40));
    }];
    
    [_labelBgView addSubview:self.centerLabel];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.labelBgView);
    }];
    
    [self.bgView addSubview:self.myLabel];
    [_myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(60));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(271));
        make.top.mas_equalTo(ws.labelBgView.mas_bottom).offset(CCGetRealFromPt(32));
        make.height.mas_equalTo(CCGetRealFromPt(32));
    }];
    
    [self.bgView addSubview:self.correctLabel];
    [_correctLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(309));
        make.right.mas_equalTo(ws.bgView);
        make.top.mas_equalTo(ws.labelBgView.mas_bottom).offset(CCGetRealFromPt(32));
        make.height.mas_equalTo(CCGetRealFromPt(32));
    }];
    
    int result_1 = 0,result_2 = 0,result_3 = 0,result_4 = 0,result_5 = 0;
    float percent_1 = 0.0,percent_2 = 0.0,percent_3 = 0.0,percent_4 = 0.0,percent_5 = 0.0;
    NSArray *array = self.resultDic[@"statisics"];
    for(NSDictionary * dic in array) {
        if([dic[@"option"] integerValue] == 0) {
            result_1 = [dic[@"count"] intValue];
            percent_1 = [dic[@"percent"] floatValue];
        } else if([dic[@"option"] integerValue]== 1){
            result_2 = [dic[@"count"] intValue];
            percent_2 = [dic[@"percent"] floatValue];
        } else if([dic[@"option"] integerValue] == 2){
            result_3 = [dic[@"count"] intValue];
            percent_3 = [dic[@"percent"] floatValue];
        } else if([dic[@"option"] integerValue] == 3) {
            result_4 = [dic[@"count"] intValue];
            percent_4 = [dic[@"percent"] floatValue];
        } else if([dic[@"option"] integerValue] == 4) {
            result_5 = [dic[@"count"] intValue];
            percent_5 = [dic[@"percent"] floatValue];
        }
    }
    NSNumber *answerCount = self.resultDic[@"answerCount"];
    if(answerCount != nil) {
        self.centerLabel.text = [NSString stringWithFormat:@"答题结束，共%d人回答。",[answerCount intValue]];
    } else {
        self.centerLabel.text = [NSString stringWithFormat:@"答题结束，共%d人回答。",(result_1 + result_2 + result_3 + result_4 + result_5)];
    }
    BOOL correct = NO;
    if([self.resultDic[@"correctOption"] isKindOfClass:[NSNumber class]]) {
//        if(_mySelectIndex == [self.resultDic[@"correctOption"] integerValue] || _mySelectIndex == -1) {
        if(_mySelectIndex == [self.resultDic[@"correctOption"] integerValue]) {
            self.myLabel.textColor = CCRGBColor(18,184,143);
            correct = YES;
        } else {
            self.myLabel.textColor = CCRGBColor(252,81,43);
            correct = NO;
        }
    } else if ([self.resultDic[@"correctOption"] isKindOfClass:[NSArray class]]) {
        if([self sameWithArrayA:self.resultDic[@"correctOption"] arrayB:self.mySelectIndexArray]) {
            self.myLabel.textColor = CCRGBColor(18,184,143);
            correct = YES;
        } else {
            self.myLabel.textColor = CCRGBColor(252,81,43);
            correct = NO;
        }
    }
    
    self.correctLabel.textColor = CCRGBColor(18,184,143);
    NSInteger arrayCount = [array count];
    if(arrayCount >= 3) {
        if([self.resultDic[@"correctOption"] isKindOfClass:[NSNumber class]]) {
            if(_mySelectIndex != -1) {
                self.myLabel.text = [NSString stringWithFormat:@"您的答案:%c",((int)_mySelectIndex + 'A')];
            }
            if([self.resultDic[@"correctOption"] intValue] != -1) {
                self.correctLabel.text = [NSString stringWithFormat:@"正确答案:%c",[self.resultDic[@"correctOption"] intValue] + 'A'];
            }
        } else if([self.resultDic[@"correctOption"] isKindOfClass:[NSArray class]]) {
            NSArray *sortedMySelectIndexArray = [self.mySelectIndexArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSArray *sortedResultArray = [self.resultDic[@"correctOption"] sortedArrayUsingComparator: ^(id obj1, id obj2) {
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            if(sortedMySelectIndexArray != nil && [sortedMySelectIndexArray count] > 0) {
                NSString *str = @"您的答案:";
                for(id num in sortedMySelectIndexArray) {
                    str = [NSString stringWithFormat:@"%@%c",str,[num intValue] + 'A'];
                }
//                str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
                self.myLabel.text = str;
            }
            if(sortedResultArray != nil && [sortedResultArray count] > 0) {
                NSString *str = @"正确答案:";
                for(id num in sortedResultArray) {
                    str = [NSString stringWithFormat:@"%@%c",str,[num intValue] + 'A'];
                }
//                str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
                self.correctLabel.text = str;
            }
        }
        
        if(arrayCount >= 3) {
            [self addProgressViewWithLeftStr:@"A:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_1,percent_1] index:1 percent:percent_1];
            [self addProgressViewWithLeftStr:@"B:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_2,percent_2] index:2 percent:percent_2];
            [self addProgressViewWithLeftStr:@"C:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_3,percent_3] index:3 percent:percent_3];
        }
        if(arrayCount >= 4) {
            [self addProgressViewWithLeftStr:@"D:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_4,percent_4] index:4 percent:percent_4];
        }
        if(arrayCount >= 5) {
            [self addProgressViewWithLeftStr:@"E:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_5,percent_5] index:5 percent:percent_5];
        }
    } else if(arrayCount == 2) {
        UIImageView *imageViewMy = nil;
        if(correct == YES) {
            if(_mySelectIndex == 0) {
                imageViewMy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_right_same"]];
            } else if(_mySelectIndex == 1) {
                imageViewMy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_wrong_same"]];
            }
        } else if(correct == NO) {
            if(_mySelectIndex == 0) {
                imageViewMy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_right_different"]];
            } else if(_mySelectIndex == 1) {
                imageViewMy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_wrong_different"]];
            }
        }
        imageViewMy.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:imageViewMy];
        [imageViewMy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(247));
            make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(315));
            make.centerY.mas_equalTo(ws.myLabel);
            make.height.mas_equalTo(CCGetRealFromPt(32));
        }];

        UIImageView *imageViewCorrect = nil;
        if([self.resultDic[@"correctOption"] integerValue] == 0) {
            imageViewCorrect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_right_same"]];
        } else if([self.resultDic[@"correctOption"] integerValue] == 1) {
            imageViewCorrect = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_wrong_same"]];
        }
        imageViewCorrect.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:imageViewCorrect];
        [imageViewCorrect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(476));
            make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(86));
            make.centerY.mas_equalTo(ws.myLabel);
            make.height.mas_equalTo(CCGetRealFromPt(32));
        }];
        
        [self addProgressViewWithLeftStr:@"√:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_1,percent_1] index:1 percent:percent_1];
        [self addProgressViewWithLeftStr:@"X:" rightStr:[NSString stringWithFormat:@"%d人 (%0.1f%%)",result_2,percent_2] index:2 percent:percent_2];
    }

    [self layoutIfNeeded];
}

-(BOOL)sameWithArrayA:(NSMutableArray *)arrayA arrayB:(NSMutableArray *)arrayB {
    if([arrayA count] != [arrayB count]) {
        return NO;
    }
    for(id item in arrayA) {
        if(![arrayB containsObject:item]) {
            return NO;
        }
    }
    return YES;
}

-(void)addProgressViewWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr index:(NSInteger)index     percent:(CGFloat)percent{
    WS(ws)
    if([rightStr rangeOfString:@"(0.0%)"].location != NSNotFound) {
        rightStr = [rightStr stringByReplacingOccurrencesOfString:@"(0.0%)" withString:@"(0%)"];
    }
    if([rightStr rangeOfString:@"(100.0%)"].location != NSNotFound) {
        rightStr = [rightStr stringByReplacingOccurrencesOfString:@"(100.0%)" withString:@"(100%)"];
    }
    UIView *progressBgView = [UIView new];
    progressBgView.backgroundColor = CCRGBAColor(255,100,61,0.2);
    [self.bgView addSubview:progressBgView];
    [progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(111));
        if(index == 1) {
            make.top.mas_equalTo(ws.myLabel.mas_bottom).offset(CCGetRealFromPt(32));
        } else if(index == 2) {
            make.top.mas_equalTo(ws.myLabel.mas_bottom).offset(CCGetRealFromPt(90));
        } else if(index == 3) {
            make.top.mas_equalTo(ws.myLabel.mas_bottom).offset(CCGetRealFromPt(148));
        } else if(index == 4) {
            make.top.mas_equalTo(ws.myLabel.mas_bottom).offset(CCGetRealFromPt(206));
        } else if(index == 5) {
            make.top.mas_equalTo(ws.myLabel.mas_bottom).offset(CCGetRealFromPt(264));
        }
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(200));
        make.height.mas_equalTo(CCGetRealFromPt(28));
    }];
    
    UIView *progressView = [UIView new];
    progressView.backgroundColor = CCRGBColor(255,100,61);
    [self.bgView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(progressBgView);
        make.width.mas_equalTo(progressBgView).multipliedBy(percent / 100.0f);
    }];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = leftStr;
    leftLabel.textColor = CCRGBColor(51,51,51);
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = [UIFont boldSystemFontOfSize:FontSize_24];
    [self.bgView addSubview:leftLabel];

    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(60));
        make.centerY.mas_equalTo(progressBgView);
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(499));
        make.height.mas_equalTo(CCGetRealFromPt(24));
    }];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:rightStr];
    NSRange range = [rightStr rangeOfString:@"人"];
    [text addAttribute:NSForegroundColorAttributeName value:CCRGBColor(102,102,102) range:NSMakeRange(0, range.location + range.length)];
    [text addAttribute:NSForegroundColorAttributeName value:CCRGBColor(51,51,51) range:NSMakeRange(range.location + range.length, rightStr.length - (range.location + range.length))];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, rightStr.length)];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.attributedText = text;
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = [UIFont systemFontOfSize:FontSize_24];
    [self.bgView addSubview:rightLabel];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(progressBgView.mas_right).offset(CCGetRealFromPt(16));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(10));
        make.centerY.and.height.mas_equalTo(leftLabel);
    }];
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = CCClearColor;
        _closeBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"qs_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

-(void)closeBtnClicked {
    if(self.closeblock) {
        self.closeblock();
    }
}

-(UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = @"答题统计";
        _label.textColor = CCRGBColor(51,51,51);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize_36];
    }
    return _label;
}

-(UILabel *)myLabel {
    if(!_myLabel) {
        _myLabel = [UILabel new];
        _myLabel.text = @"您的答案:";
        _myLabel.textAlignment = NSTextAlignmentLeft;
        _myLabel.font = [UIFont systemFontOfSize:FontSize_32];
    }
    return _myLabel;
}

-(UILabel *)correctLabel {
    if(!_correctLabel) {
        _correctLabel = [UILabel new];
        _correctLabel.text = @"正确答案:";
        _correctLabel.textAlignment = NSTextAlignmentLeft;
        _correctLabel.font = [UIFont systemFontOfSize:FontSize_32];
    }
    return _correctLabel;
}

-(UILabel *)centerLabel {
    if(!_centerLabel) {
        _centerLabel = [UILabel new];
        _centerLabel.textColor = CCRGBColor(102,102,102);
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:FontSize_24];
    }
    return _centerLabel;
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIView *)labelBgView {
    if(!_labelBgView) {
        _labelBgView = [UIView new];
        _labelBgView.backgroundColor = CCRGBAColor(255,224,217,0.3);
        _labelBgView.layer.masksToBounds = YES;
        _labelBgView.layer.cornerRadius = CCGetRealFromPt(20);
    }
    return _labelBgView;
}

-(UIView *)lineView {
    if(!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CCRGBAColor(255,102,51,0.5);
    }
    return _lineView;
}

-(UIImageView *)resultImage {
    if(!_resultImage) {
        _resultImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_statistical"]];
        _resultImage.backgroundColor = CCClearColor;
        _resultImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _resultImage;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return;
}

@end

