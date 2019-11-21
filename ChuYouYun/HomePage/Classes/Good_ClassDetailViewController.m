//
//  Good_ClassDetailViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassDetailViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "TeacherMainViewController.h"
#import "InstitutionMainViewController.h"

@interface Good_ClassDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate> {
    BOOL isUnwindClass;
    BOOL isUnwindTeacher;
    BOOL isHaveImage;
    BOOL isHaveTeacherImage;
}

@property (strong ,nonatomic)UIView         *classDetailView;
@property (strong ,nonatomic)UIView         *teacherView;
@property (strong ,nonatomic)UIView         *classIntroView;
@property (strong ,nonatomic)UIWebView      *classWebView;
@property (strong ,nonatomic)UILabel        *className;
@property (strong ,nonatomic)UILabel        *personNumber;
@property (strong ,nonatomic)UIButton       *unwindClassButton;
@property (strong ,nonatomic)UILabel        *price;
@property (strong ,nonatomic)UILabel        *teacherName;
@property (strong ,nonatomic)UIImageView    *teacherImage;
@property (strong ,nonatomic)UIWebView      *teacherWebView;
@property (strong ,nonatomic)UIButton       *unwindTeacherButton;
@property (strong ,nonatomic)UILabel        *classAndFans;
@property (strong ,nonatomic)UILabel        *teacherInfo;
@property (strong ,nonatomic)UIView         *introduceView;
@property (strong ,nonatomic)UIButton       *instLineButton;//隔离带

@property (strong ,nonatomic)UIImageView    *instImage;
@property (strong ,nonatomic)UILabel        *instName;
@property (strong ,nonatomic)UIView         *instView;
@property (strong ,nonatomic)UIView         *serviceView;
@property (strong ,nonatomic)UILabel        *instClassAndFans;
@property (strong ,nonatomic)UILabel        *classContent;

@property (strong ,nonatomic)NSString       *ID;
@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong ,nonatomic)NSDictionary   *schoolDict;
@property (strong ,nonatomic)NSString       *teacherID;
@property (strong ,nonatomic)NSDictionary   *teacherDict;
@property (strong ,nonatomic)NSDictionary   *serviceDict;
@property (strong ,nonatomic)NSString       *serviceOpen;

@property (assign ,nonatomic)CGFloat        webHight;
@property (assign ,nonatomic)CGFloat        teacherWebHight;
@property (assign ,nonatomic)CGFloat        scrollHight;
@property (assign ,nonatomic)CGFloat        classIntroViewHight;
@property (assign ,nonatomic)CGFloat        teacherInfoViewHight;

@end

@implementation Good_ClassDetailViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight)];
    _mainScroll.delegate = self;
    _mainScroll.backgroundColor = [UIColor whiteColor];
    _mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScroll];
    [self interFace];
    [self addClassIntroView];
    [self addTeacherView];
    [self netWorkVideoGetInfo];
    [self netWorkGetThirdServiceUrl];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    isUnwindClass = NO;
    isUnwindTeacher = NO;
}

- (void)addClassDetailView {
    _classDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
    _classDetailView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_classDetailView];
    
    //添加名字
    UILabel *className = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 18 * WideEachUnit)];
    className.textColor = [UIColor colorWithHexString:@"#332"];
    className.backgroundColor = [UIColor whiteColor];
    className.text = @"";
    [_classDetailView addSubview:className];
    _className = className;
    
    //添加学习人数
    UILabel *personNumber = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(className.frame) + 12 * WideEachUnit, 120 * WideEachUnit, 14 * WideEachUnit)];
    personNumber.textColor = [UIColor colorWithHexString:@"#888"];
    personNumber.font = Font(14 * WideEachUnit);
    personNumber.text = @"在学0人";
    [_classDetailView addSubview:personNumber];
    _personNumber = personNumber;
    
    //价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(personNumber.frame) + 12 * WideEachUnit, 120 * WideEachUnit, 18 * WideEachUnit)];
    price.textColor = [UIColor colorWithHexString:@"#f01414"];
    price.font = Font(18 * WideEachUnit);
    price.backgroundColor = [UIColor whiteColor];
    price.text = @"育币0";
    [_classDetailView addSubview:price];
    _price = price;
    
}

- (void)addTeacherView {
    _teacherView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_classDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 265 * WideEachUnit)];
    _teacherView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_teacherView];
    
    //讲师信息
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.backgroundColor = [UIColor whiteColor];
    title.font = Font(15 * WideEachUnit);
    title.text = @"讲师信息";
    [_teacherView addSubview:title];
    
    //添加横线
    UIButton *teacherTitleLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 38 * WideEachUnit, MainScreenWidth, 1)];
    teacherTitleLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_teacherView addSubview:teacherTitleLineButton];
    
    //添加讲师头像
    UIImageView *teacherImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 42 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    teacherImage.backgroundColor = [UIColor whiteColor];
    teacherImage.layer.cornerRadius = 25 * WideEachUnit;
    teacherImage.layer.masksToBounds = YES;
    [_teacherView addSubview:teacherImage];
    _teacherImage = teacherImage;
    [teacherImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherViewClick:)]];
    _teacherView.userInteractionEnabled = YES;
    _teacherImage.userInteractionEnabled = YES;
    
    //
    
    //讲师名字
    UILabel *teacherName = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    teacherName.textColor = [UIColor colorWithHexString:@"#333"];
    teacherName.backgroundColor = [UIColor whiteColor];
    teacherName.font = Font(14 * WideEachUnit);
    teacherName.text = @"";
    _teacherName = teacherName;
    [_teacherView addSubview:teacherName];
    
    //讲师课程数和粉丝数
    UILabel *classAndFans = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, 67 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    classAndFans.textColor = [UIColor colorWithHexString:@"#888"];
    classAndFans.backgroundColor = [UIColor whiteColor];
    classAndFans.font = Font(12 * WideEachUnit);
    classAndFans.text = @"0课程    0粉丝";
    [_teacherView addSubview:classAndFans];
    _classAndFans = classAndFans;
    
    //添加灰色的视图
    UIView *introduceView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 60 * WideEachUnit)];
    introduceView.backgroundColor = [UIColor whiteColor];
    [_teacherView addSubview:introduceView];
    _introduceView = introduceView;
    
    _teacherInfo = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0, MainScreenWidth - 0 * WideEachUnit, 30 * WideEachUnit)];
    _teacherInfo.backgroundColor = [UIColor whiteColor];
    _teacherInfo.font = Font(13);
    _teacherInfo.textColor = [UIColor colorWithHexString:@"#333"];
    [introduceView addSubview:_teacherInfo];
    
    _teacherWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit, 30 * WideEachUnit)];
    _teacherWebView.backgroundColor = [UIColor whiteColor];
    _teacherWebView.delegate = self;
    _teacherWebView.scrollView.scrollEnabled = NO;
    [introduceView addSubview:_teacherWebView];
    _teacherWebView.hidden = YES;
    
    
    //添加讲师展开的按钮
    _unwindTeacherButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit, 105, 30 * WideEachUnit, 30 * WideEachUnit)];
    _unwindTeacherButton.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    _unwindTeacherButton.tag = 2;
    [_unwindTeacherButton addTarget:self action:@selector(unwindButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_unwindTeacherButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
    [introduceView addSubview:_unwindTeacherButton];
    _unwindTeacherButton.hidden = YES;
    
    //配置单机构或者多机构
    if ([MoreOrSingle integerValue] == 1) {
        return;
    }
    
    //添加隔离带
    UIButton *instLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_introduceView.frame), MainScreenWidth, 10 * WideEachUnit)];
    instLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_teacherView addSubview:instLineButton];
    _instLineButton = instLineButton;
    
    
    UIView *instView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introduceView.frame) + 15 * WideEachUnit, MainScreenWidth, 80 * WideEachUnit)];
    instView.backgroundColor = [UIColor whiteColor];
    [_teacherView addSubview:instView];
    _instView = instView;
    
    //所属机构
    UILabel *instTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    instTitle.textColor = [UIColor colorWithHexString:@"#333"];
    instTitle.backgroundColor = [UIColor whiteColor];
    instTitle.font = Font(15 * WideEachUnit);
    instTitle.text = @"所属机构";
    [instView addSubview:instTitle];
    
    //添加横线
    UIButton *instTitleLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 35 * WideEachUnit, MainScreenWidth, 1)];
    instTitleLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_instView addSubview:instTitleLineButton];
    
    //所属机构图像
    UIImageView *instImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(instTitle.frame) + 20 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    instImage.backgroundColor = [UIColor whiteColor];
    instImage.layer.cornerRadius = 25 * WideEachUnit;
    instImage.layer.masksToBounds = YES;
    [instView addSubview:instImage];
    _instImage = instImage;
    [instImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(instViewClick:)]];
    self.view.userInteractionEnabled = YES;
    _teacherView.userInteractionEnabled = YES;
    instView.userInteractionEnabled = YES;
    _instImage.userInteractionEnabled = YES;
    
    //添加透明的按钮
    UIButton *instImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 * WideEachUnit, 50 * WideEachUnit)];
    instImageButton.backgroundColor = [UIColor clearColor];
    [instImageButton addTarget:self action:@selector(instImageButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [instImage addSubview:instImageButton];
    
    
    
    //讲师名字
    UILabel *instName = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, CGRectGetMaxY(instTitle.frame) + 25 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    instName.textColor = [UIColor colorWithHexString:@"#333"];
    instName.backgroundColor = [UIColor whiteColor];
    instName.font = Font(14 * WideEachUnit);
    instName.text = @"";
    [instView addSubview:instName];
    _instName = instName;
    
    //讲师课程数和粉丝数
    UILabel *instClassAndFans = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, CGRectGetMaxY(instName.frame) + 8 * WideEachUnit - 3 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    instClassAndFans.textColor = [UIColor colorWithHexString:@"#888"];
    instClassAndFans.backgroundColor = [UIColor whiteColor];
    instClassAndFans.font = Font(12 * WideEachUnit);
    instClassAndFans.text = @"0课程    好评度";
    [instView addSubview:instClassAndFans];
    _instClassAndFans = instClassAndFans;
    
    
    //    //添加客服
    //    UIView *serviceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherView.frame) + 10 * WideEachUnit, MainScreenWidth, 80 * WideEachUnit)];
    //    serviceView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:serviceView];
    //    [serviceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceViewClick:)]];
    //    _serviceView = serviceView;
    //    _serviceView.hidden = YES;
    //
    //    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 20 * WideEachUnit, 40 * WideEachUnit, 40 * WideEachUnit)];
    //    serviceLabel.textColor = [UIColor blackColor];
    //    serviceLabel.font = Font(15 * WideEachUnit);
    //    serviceLabel.text = @"客服:";
    //    [serviceView addSubview:serviceLabel];
    //
    //    UIImageView *serviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55 * WideEachUnit, 25 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    //    serviceImageView.image = Image(@"kefu");
    //    [serviceView addSubview:serviceImageView];
}

- (void)addClassIntroView {
    _classIntroView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit)];
    _classIntroView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_classIntroView];
    
    //课程简介
    UILabel *classTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    classTitle.textColor = BlackNotColor;
    classTitle.backgroundColor = [UIColor whiteColor];
    classTitle.font = Font(15 * WideEachUnit);
    classTitle.text = @"课程简介";
    [_classIntroView addSubview:classTitle];
    classTitle.hidden = YES;
    
    //课程简介
    UILabel *classContent = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 42 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 50 * WideEachUnit)];
    classContent.textColor = [UIColor colorWithHexString:@"#333"];
    classContent.backgroundColor = [UIColor whiteColor];
    classContent.font = Font(13);
    classContent.numberOfLines = 0;
    classContent.text = @"";
    [_classIntroView addSubview:classContent];
    _classContent = classContent;
    
    
    //添加webView
    _classWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 50 * WideEachUnit)];
    _classWebView.backgroundColor = [UIColor whiteColor];
    _classWebView.delegate = self;
    _classWebView.scrollView.scrollEnabled = NO;
    [_classIntroView addSubview:_classWebView];
    _classWebView.hidden = YES;
    
    
    //添加展开按钮
    _unwindClassButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 45, 42, 40, 15)];
    _unwindClassButton.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    _unwindClassButton.backgroundColor = [UIColor whiteColor];
    _unwindClassButton.tag = 1;
    [_unwindClassButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
    [_unwindClassButton addTarget:self action:@selector(unwindButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_classIntroView addSubview:_unwindClassButton];
    _unwindClassButton.hidden = YES;
    
}

//课程详情的自适应
- (void)MyselfDecision_TeacherInfo:(NSString *)textStr {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)
                              };
    NSData *data = [textStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];   // 调整行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attributedString.length)];
    //文本赋值
    _teacherInfo.text = textStr;
    //设置label的最大行数
    _teacherInfo.numberOfLines = 0;
    _teacherInfo.attributedText = attributedString;
    
    CGRect labelSize = [_teacherInfo.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    _teacherInfoViewHight = labelSize.size.height;
    if (labelSize.size.height > 7 * 16) {//说明很多内容
        _unwindTeacherButton.hidden = NO;
        _teacherInfo.frame = CGRectMake(0 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,7 * 16);
        _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 0 * WideEachUnit + 7 * 16);
        _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
        _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
        _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 7 * 16 + 65 * WideEachUnit);
        if ([MoreOrSingle integerValue] == 1) {
            _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit - 55 * WideEachUnit + 7 * 16);
        }
    } else {
        _unwindTeacherButton.hidden = YES;
        _teacherInfo.frame = CGRectMake(0 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,labelSize.size.height);
        _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 0 * WideEachUnit + labelSize.size.height );
        _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
        _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
        _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + labelSize.size.height + 65 * WideEachUnit);
        if ([MoreOrSingle integerValue] == 1) {
            _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit - 55 * WideEachUnit + labelSize.size.height);
        }
        if (isHaveTeacherImage) {
            _unwindTeacherButton.frame = CGRectMake(MainScreenWidth - 50 * WideEachUnit,labelSize.size.height - 20 * WideEachUnit , 30 * WideEachUnit, 30 * WideEachUnit);
            _unwindTeacherButton.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if (isHaveTeacherImage) {
        _unwindTeacherButton.hidden = NO;
        _teacherInfo.frame = CGRectMake(0 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,labelSize.size.height);
        _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + labelSize.size.height + 65 * WideEachUnit);
    }
    
    NSLog(@"%lf",CGRectGetMaxY(_classIntroView.frame));
    _scrollHight = CGRectGetMaxY(_teacherView.frame) + 10 * WideEachUnit - 70 * WideEachUnit;
    NSString *hightStr = [NSString stringWithFormat:@"%lf",_scrollHight];
    if ([_serviceOpen integerValue] == 1) {
        hightStr = [NSString stringWithFormat:@"%lf",_scrollHight + 90 * WideEachUnit];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_ClassDetailHight" object:hightStr];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, [hightStr floatValue] > _tabelHeight ? [hightStr floatValue] : _tabelHeight + 10);
}

//课程详情的自适应
- (void)MyselfDecision_ClassContent:(NSString *)textStr {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)
                              };
    NSData *data = [textStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];   // 调整行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attributedString.length)];
    //文本赋值
    _classContent.text = textStr;
    //设置label的最大行数
    _classContent.numberOfLines = 0;
    _classContent.attributedText = attributedString;
    
    CGRect labelSize = [_classContent.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    _classIntroViewHight = labelSize.size.height;
    if (labelSize.size.height > 3 * 16) {//说明很多
        _unwindClassButton.hidden = NO;
        _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,48);
        _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + 48 );
        
    } else {
        _unwindClassButton.hidden = YES;
        _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,labelSize.size.height);
        _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + labelSize.size.height );
    }
    
    if (isHaveImage) {
        _unwindClassButton.hidden = NO;
        _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,48);
        _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + 48 );
    }
}

#pragma mark --- 检测文本中是否有图片
- (void)isHaveImage {
    NSString *originalStr =  [_dataSource stringValueForKey:@"video_intro"];
    NSString *imageStr1 = @"<img src=\"/data/upload";
    NSString *imageStr2 = @"src=\"/data/upload";
    if ([originalStr rangeOfString:imageStr1].location != NSNotFound || [originalStr rangeOfString:imageStr2].location != NSNotFound ) {//有
        isHaveImage = YES;
    } else {
        isHaveImage = NO;
    }
}

//网页视图
- (void)webViewSetOfContent {
    //    NSString *videoIntroStr = [_dataSource stringValueForKey:@"video_intro"];
    //图片的处理
    //    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"http://www.yishixue.com/data/upload"];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *originalStr =  [_dataSource stringValueForKey:@"video_intro"];
    NSString *textStr = [originalStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    
    if (textStr.length>2) {
        NSString *str2 = [textStr substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            textStr = [textStr substringFromIndex:3];
        }
    }
    
    //视频音频的处理
    //    NSString *videoReplaceStr = [NSString stringWithFormat:@"src=\"http://www.yishixue.com/data/upload"];
    NSString *videoReplaceStr = [NSString stringWithFormat:@"src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *videoTextStr = [textStr stringByReplacingOccurrencesOfString:@"src=\"/data/upload" withString:videoReplaceStr];
    
    if (videoTextStr.length>2) {
        NSString *str2 = [videoTextStr substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            videoTextStr = [videoTextStr substringFromIndex:3];
        }
    }
    
    NSString * str1 = [NSString stringWithFormat:@"<div style=\"margin-left:0px; margin-bottom:5px;color:red;font-size:%fpx;color:#010101;text-align:left;\">%@</div>",15.0 * WideEachUnit,videoTextStr];
    
    
    NSString *divStr = [NSString stringWithFormat:@"<div style=\"margin:%dpx;border:0;font-size:9px;color:red;;padding:0;\"></div>",SpaceBaside];
    NSString *styleStr = [NSString stringWithFormat:@"<style> .mobile_upload {width:%fpx; height:auto;} </style><style> .emot {width:%fpx; height:%fpx;color:red;} img{width:%fpx;} </style><div style=\"word-wrap:break-word; width:%fpx;\"><font style=\"font-size:%fpx;color:#262626;\">",MainScreenWidth-SpaceBaside * 2,16.0,18.0,MainScreenWidth - 2 * SpaceBaside,MainScreenWidth-SpaceBaside*2,18.0];
    //    NSString *str = [NSString stringWithFormat:@"%@%@%@%@</font></div>",str1,divStr,styleStr,content];
    NSString *str = [NSString stringWithFormat:@"%@%@%@</font></div>",str1,divStr,styleStr];
    
    [_classWebView loadHTMLString:str baseURL:nil];
}

//老师的视图
- (void)isHaveTeacherImage {
    NSString *originalStr =  [_teacherDict stringValueForKey:@"info"];
    NSString *imageStr1 = @"data/upload";
    NSString *imageStr2 = @"data/upload";
    if ([originalStr rangeOfString:imageStr1].location != NSNotFound || [originalStr rangeOfString:imageStr2].location != NSNotFound ) {//有
        isHaveTeacherImage = YES;
    } else {
        isHaveTeacherImage = NO;
    }
}

- (void)addTeacherWebView {
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *originalStr =  [_teacherDict stringValueForKey:@"info"];
    NSString *textStr = [originalStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    
    if (textStr.length>2) {
        NSString *str2 = [textStr substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            textStr = [textStr substringFromIndex:3];
        }
    }
    
    //视频音频的处理
    //    NSString *videoReplaceStr = [NSString stringWithFormat:@"src=\"http://www.yishixue.com/data/upload"];
    NSString *videoReplaceStr = [NSString stringWithFormat:@"src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *videoTextStr = [textStr stringByReplacingOccurrencesOfString:@"src=\"/data/upload" withString:videoReplaceStr];
    
    if (videoTextStr.length>2) {
        NSString *str2 = [videoTextStr substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            videoTextStr = [videoTextStr substringFromIndex:3];
        }
    }
    
    NSString * str1 = [NSString stringWithFormat:@"<div style=\"margin-left:0px; margin-bottom:5px;color:red;font-size:%fpx;color:#010101;text-align:left;\">%@</div>",15.0 * WideEachUnit,videoTextStr];
    
    
    NSString *divStr = [NSString stringWithFormat:@"<div style=\"margin:%dpx;border:0;font-size:9px;color:red;;padding:0;\"></div>",SpaceBaside];
    NSString *styleStr = [NSString stringWithFormat:@"<style> .mobile_upload {width:%fpx; height:auto;} </style><style> .emot {width:%fpx; height:%fpx;color:red;} img{width:%fpx;} </style><div style=\"word-wrap:break-word; width:%fpx;\"><font style=\"font-size:%fpx;color:#262626;\">",MainScreenWidth-SpaceBaside * 2,16.0,18.0,MainScreenWidth - 2 * SpaceBaside,MainScreenWidth-SpaceBaside*2,18.0];
    //    NSString *str = [NSString stringWithFormat:@"%@%@%@%@</font></div>",str1,divStr,styleStr,content];
    NSString *str = [NSString stringWithFormat:@"%@%@%@</font></div>",str1,divStr,styleStr];
    
    [_teacherWebView loadHTMLString:str baseURL:nil];
}

#pragma mark --- webViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView  {
    if (webView == _classWebView) {
        CGRect frame = _classWebView.frame;
        frame.size.width = MainScreenWidth - 20 * WideEachUnit;
        frame.size.height = 1 * WideEachUnit;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        NSLog(@"frame -- C = %@", [NSValue valueWithCGRect:frame]);
        webView.frame = frame;
        _webHight = frame.size.height;
        _classWebView.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, _webHight - 20 * WideEachUnit);
    } else {
        CGRect frame = _teacherWebView.frame;
        frame.size.width = MainScreenWidth - 20 * WideEachUnit;
        frame.size.height = 1 * WideEachUnit;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        NSLog(@"frame--T = %@", [NSValue valueWithCGRect:frame]);
        webView.frame = frame;
        _teacherWebHight = 5831;
        _teacherWebView.frame = CGRectMake(0 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, _teacherWebHight + 20 * WideEachUnit);
        [_teacherWebView sizeToFit];
    }
}

#pragma mark --- 手势
- (void)teacherViewClick:(UIGestureRecognizer *)ges {
    TeacherMainViewController *vc = [[TeacherMainViewController alloc] initWithNumID:_teacherID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)instViewClick:(UIGestureRecognizer *)ges {
    InstitutionMainViewController *vc = [[InstitutionMainViewController alloc] init];
    vc.uID = @"";
    vc.schoolID = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)serviceViewClick:(UIGestureRecognizer *)ges {
    NSURL *url = [NSURL URLWithString:[_serviceDict stringValueForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark --- 事件处理

- (void)instImageButtonCilck {
    InstitutionMainViewController *vc = [[InstitutionMainViewController alloc] init];
    vc.uID = [_schoolDict stringValueForKey:@"uid"];
    vc.schoolID = [_schoolDict stringValueForKey:@"school_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)unwindButtonCilck:(UIButton *)button {
    if (button.tag == 1) {//课程详情
        if (isUnwindClass) {//收上来
            //隐藏掉
            _classWebView.hidden = YES;
            _classContent.hidden = NO;
            
            isUnwindClass = NO;
            _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,48);
            _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + 48);
            //展开按钮的位置
            _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, 42, 40, 15);
            [_unwindClassButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            [_classIntroView addSubview:_unwindClassButton];
            
            //设置讲师以及其他的位置
            if (isUnwindTeacher) {
                _teacherInfo.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit,_teacherInfoViewHight);
                _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit + _teacherInfoViewHight );
                _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
                _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + _teacherInfoViewHight);
            } else {
                _teacherInfo.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit,7 * 16);
                _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit + 7 * 16 );
                _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
                _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 7 * 16);
            }
            
        } else {//展开
            isUnwindClass = YES;
            
            //吧之前的文本隐藏 吧webView 展示出来
            if (isHaveImage) {
                _classContent.hidden = YES;
                _classWebView.hidden = NO;
            } else {
                _classContent.hidden = NO;
                _classWebView.hidden = YES;
            }
            
            _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,_classIntroViewHight);
            _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + _classIntroViewHight );
            //展开按钮的位置
            _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, _classIntroViewHight - 42 + 20 + 20 * WideEachUnit, 40, 15);
            [_unwindClassButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
            if (isHaveImage) {
                _unwindClassButton.frame = CGRectMake(MainScreenWidth - 55, _webHight - 40 * WideEachUnit, 40, 15);
                [_classWebView addSubview:_unwindClassButton];
            } else {
                _unwindClassButton.frame = CGRectMake(MainScreenWidth - 55, _classIntroViewHight - 6 * WideEachUnit, 40, 15);
                [_classIntroView addSubview:_unwindClassButton];
            }
            
            //设置讲师试图的位置
            if (isUnwindTeacher) {
                _teacherInfo.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit,_teacherInfoViewHight);
                _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit + _teacherInfoViewHight );
                _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
                _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + _teacherInfoViewHight);
                if (isHaveImage) {
                    _classIntroView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _webHight);
                    _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + _teacherInfoViewHight);
                } else {
                    _classIntroView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _classIntroViewHight);
                    _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + _teacherInfoViewHight);
                }
                
            } else {
                _teacherInfo.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit,7 * 16);
                _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit + 7 * 16 );
                _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
                _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 7 * 16);
                //改变之前的位置
                if (isHaveImage) {
                    _classIntroView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _webHight);
                    _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 7 * 16);
                    if ([MoreOrSingle integerValue] == 1) {
                        _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit - 55 * WideEachUnit + 7 * 16);
                    }
                } else {
                    _classIntroView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _classIntroViewHight);
                    _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 7 * 16);
                    if ([MoreOrSingle integerValue] == 1) {
                        _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit - 55 * WideEachUnit + 7 * 16);
                    }
                }
            }
        }
        
        //设置滚动范围
        _scrollHight = CGRectGetMaxY(_teacherView.frame) + 10 * WideEachUnit;
        NSString *hightStr = [NSString stringWithFormat:@"%lf",_scrollHight];
        if ([_serviceOpen integerValue] == 1) {
            hightStr = [NSString stringWithFormat:@"%lf",_scrollHight + 80 * WideEachUnit];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_ClassDetailHight" object:hightStr];
        
    } else if (button.tag == 2) {//讲师详情
        if (isUnwindTeacher) {//收上来
            isUnwindTeacher = NO;
            
            if (isHaveTeacherImage) {
                _teacherWebView.hidden = YES;
                _teacherInfo.hidden = NO;
            }
            //设置详情的位置
            if (isUnwindClass) {
                _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,_classIntroViewHight);
                _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + _classIntroViewHight );
                //展开按钮的位置
                _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, _classIntroViewHight - 42 + 20 + 20 * WideEachUnit, 40, 15);
                [_unwindClassButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
                if (isHaveImage) {
                    _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + _webHight);
                }
            } else {
                if (_unwindClassButton.hidden == YES) {
                    _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,_classIntroViewHight);
                    _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + _classIntroViewHight);
                    //展开按钮的位置
                    _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, 42, 40, 15);
                } else {
                    _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,48);
                    _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + 48);
                    //展开按钮的位置
                    _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, 42, 40, 15);
                }
                [_unwindClassButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            }
            
            //设置讲师以及其他的位置
            _teacherInfo.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 40 * WideEachUnit,7 * 16);
            _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit + 7 * 16 );
            _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
            _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
            _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 7 * 16 + 65 * WideEachUnit);
            _unwindTeacherButton.frame = CGRectMake(MainScreenWidth - 50, 105, 30 * WideEachUnit, 30 * WideEachUnit);
            [_unwindTeacherButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            if ([MoreOrSingle integerValue] == 1) {
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit - 55 * WideEachUnit + 7 * 16);
            }
            
            if (isHaveTeacherImage) {
                _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit);
                _teacherInfo.frame = CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 40 * WideEachUnit, 10 * WideEachUnit);
                _unwindTeacherButton.frame = CGRectMake(MainScreenWidth - 50, 0 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit);
                
                _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
                _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + 65 * WideEachUnit);
                
            }
            
        } else {//展开
            
            if (isHaveTeacherImage) {
                _teacherInfo.hidden = YES;
                _teacherWebView.hidden = NO;
            } else {
                _teacherInfo.hidden = NO;
                _teacherWebView.hidden = YES;
            }
            
            isUnwindTeacher = YES;
            
            _classIntroView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _webHight + 20 * WideEachUnit);
            //设置详情的位置
            if (isUnwindClass) {
                _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,_classIntroViewHight);
                _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + _classIntroViewHight );
                //展开按钮的位置
                _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, _classIntroViewHight - 35 + 20 * WideEachUnit, 40, 15);
                [_unwindClassButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
                if (isHaveImage) {
                    _unwindClassButton.frame = CGRectMake(MainScreenWidth - 55, _webHight - 40 * WideEachUnit, 40, 15);
                    [_classWebView addSubview:_unwindClassButton];
                    _classIntroView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _webHight + 20 * WideEachUnit);
                }
            } else {
                if (_unwindClassButton.hidden == YES) {
                    _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,_classIntroViewHight);
                    _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + _classIntroViewHight);
                    //展开按钮的位置
                    _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, 42, 40, 15);
                } else {
                    _classContent.frame = CGRectMake(10 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,48);
                    _classIntroView.frame = CGRectMake(0, 0 * WideEachUnit, MainScreenWidth, 20 * WideEachUnit + 48);
                    //展开按钮的位置
                    _unwindClassButton.frame = CGRectMake(MainScreenWidth - 45, 42, 40, 15);
                }
                [_unwindClassButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            }
            
            //设置讲师以及其他的位置
            _teacherInfo.frame = CGRectMake(0 * WideEachUnit,10 * WideEachUnit ,MainScreenWidth - 20 * WideEachUnit,_teacherInfoViewHight);
            _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit + _teacherInfoViewHight );
            _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
            _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
            _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + _teacherInfoViewHight);
            _unwindTeacherButton.frame = CGRectMake(MainScreenWidth - 45, _teacherInfoViewHight + 20 * WideEachUnit - 25, 25, 25);
            [_unwindTeacherButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
            if ([MoreOrSingle integerValue] == 1) {
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit - 55 * WideEachUnit + _teacherInfoViewHight);
            }
            
            if (isHaveTeacherImage) {
                _teacherView.frame = CGRectMake(0, CGRectGetMaxY(_classIntroView.frame) + 10 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit + _teacherWebHight + 65 * WideEachUnit);
                _introduceView.frame = CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_teacherImage.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 0 * WideEachUnit + _teacherWebHight );
                
                _instLineButton.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
                _instView.frame = CGRectMake(0, CGRectGetMaxY(_introduceView.frame) + 20 * WideEachUnit, MainScreenWidth, 100 * WideEachUnit);
                _unwindTeacherButton.frame = CGRectMake(MainScreenWidth - 50 * WideEachUnit, _teacherWebHight - 40 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit);
                
            }
        }
        
        //设置滚动范围
        _scrollHight = CGRectGetMaxY(_teacherView.frame) + 10 * WideEachUnit - 70 * WideEachUnit;
        NSString *hightStr = [NSString stringWithFormat:@"%lf",_scrollHight];
        if ([_serviceOpen integerValue] == 1) {
            hightStr = [NSString stringWithFormat:@"%lf",_scrollHight + 90 * WideEachUnit];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_ClassDetailHight" object:hightStr];
    }
}

#pragma mark --- 网络请求
- (void)netWorkVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        //        _className
        NSLog(@"详情---%@",_dataSource);
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_dataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _dataSource = [_dataSource dictionaryValueForKey:@"data"];
            } else {
                _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        _schoolDict = [_dataSource dictionaryValueForKey:@"school_info"];
        _className.text = [_dataSource stringValueForKey:@"video_title"];
        _teacherID = [_dataSource stringValueForKey:@"teacher_id"];
        _personNumber.text = [NSString stringWithFormat:@"在学%@人",[_dataSource stringValueForKey:@"video_order_count"]];
        _price.text = [NSString stringWithFormat:@"育币:%@",[_dataSource stringValueForKey:@"price"]];
        NSString *urlStr = [_dataSource stringValueForKey:@""];
        [_teacherImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [_instImage sd_setImageWithURL:[NSURL URLWithString:[_schoolDict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
        _instName.text = [_schoolDict stringValueForKey:@"title"];
        _instClassAndFans.text = [NSString stringWithFormat:@"%@课程    好评度%@",[[_schoolDict dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"],[[_schoolDict objectForKey:@"count"] objectForKey:@"comment_rate"]];
        //        _classContent.text = [_dataSource stringValueForKey:@"video_intro"];
        //        [self MyselfDecision_ClassContent:[_dataSource stringValueForKey:@"video_intro"]];
        [self netWorkTeacherGetInfo];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)netWorkTeacherGetInfo {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_teacherID forKey:@"teacher_id"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =  [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _teacherDict = [dict dictionaryValueForKey:@"data"];
            } else {
                _teacherDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        //        _className
        NSLog(@"讲师详情---%@",_teacherDict);
        
        NSString *videoIntroStr = [Passport filterHTML:[_dataSource stringValueForKey:@"video_intro"]];
        [self isHaveImage];
        [self MyselfDecision_ClassContent:[_dataSource stringValueForKey:@"video_intro"]];
        
        //算出文本中有没有图片
        if (isHaveImage) {
            [self webViewSetOfContent];
        }
        
        [_teacherImage sd_setImageWithURL:[NSURL URLWithString:[_teacherDict stringValueForKey:@"headimg"]] placeholderImage:Image(@"站位图")];
        _teacherName.text = [_teacherDict stringValueForKey:@"name"];
        _classAndFans.text = [NSString stringWithFormat:@"%@课程  %@粉丝",[_teacherDict stringValueForKey:@"video_count"],[[_teacherDict dictionaryValueForKey:@"follow_state"] stringValueForKey:@"follower"]];
        NSString *infoStr = [Passport filterHTML:[_teacherDict stringValueForKey:@"info"]];
        [self isHaveTeacherImage];
        if (isHaveTeacherImage) {
            [self addTeacherWebView];
        }
        [self MyselfDecision_TeacherInfo:[_teacherDict stringValueForKey:@"info"]];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//配置客服按钮
- (void)netWorkGetThirdServiceUrl {
    
    NSString *endUrlStr = YunKeTang_Basic_Basic_getThirdServiceUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"5" forKey:@"count"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str != nil) {
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _serviceDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_serviceDict isKindOfClass:[NSArray class]]) {
        } else {
            _serviceOpen = [_serviceDict stringValueForKey:@"is_open"];
            if ([[_serviceDict stringValueForKey:@"is_open"] integerValue] == 1) {//重新加载一次
                _serviceView.hidden = NO;
            } else {
                _serviceView.hidden = YES;
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScroll) {
        if (!self.cellTabelCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            if (self.vc.canScrollAfterVideoPlay == YES) {
                self.cellTabelCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.vc.canScroll = YES;
            }
        }
    }
}

- (void)changeMainScrollViewHeight:(CGFloat)changeHeight {
    [_mainScroll setHeight:changeHeight];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _mainScroll.contentSize.height > _tabelHeight ? _mainScroll.contentSize.height : _tabelHeight + 10);
}

@end
