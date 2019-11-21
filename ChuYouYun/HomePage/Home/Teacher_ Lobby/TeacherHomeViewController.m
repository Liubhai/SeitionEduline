//
//  TeacherHomeViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherHomeViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "ZhiBoMainViewController.h"


@interface TeacherHomeViewController ()<UIWebViewDelegate> {
    BOOL isHaveImage;
}

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView       *addressView;
@property (strong ,nonatomic)UIView       *classView;
@property (strong ,nonatomic)UIView       *photoView;
@property (strong ,nonatomic)UIView       *articeView;
@property (strong ,nonatomic)UIView       *detailView;
@property (strong ,nonatomic)UIWebView    *webView;
@property (strong ,nonatomic)UILabel      *addressLabel;
@property (strong ,nonatomic)UILabel      *teachType;//授课方式

@property (assign ,nonatomic)CGFloat  webHight;
@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSDictionary *teacherDic;
@property (strong ,nonatomic)NSMutableArray     *classArray;
@property (strong ,nonatomic)NSMutableArray     *photoArray;
@property (strong ,nonatomic)NSMutableArray     *articleArray;


@end

@implementation TeacherHomeViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self netWorkTeacherGetInfo];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    isHaveImage = NO;
}

- (void)addAddessView {
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
    _addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addressView];
    
    NSArray *arr = @[@"所在地"];
    NSString *adress;
    if ([_teacherDic[@"ext_info"][@"location"] isKindOfClass:[NSNull class]]) {
        adress = @"未填写所在地";
    }else if (_teacherDic[@"ext_info"][@"location"] == nil){
        adress = @"未填写所在地";
    } else if ([_teacherDic[@"ext_info"][@"location"] isEqualToString:@""]) {
        adress = @"未填写所在地";
    } else{
        adress = [NSString stringWithFormat:@"%@",_teacherDic[@"ext_info"][@"location"]];
    }
    NSString *skill = [NSString stringWithFormat:@"%@",_teacherDic[@"teach_way"]];
    
    if (_teacherDic == nil) {
        skill = @"";
    } else {
        if ([skill integerValue] == 2) {
            skill = @"线下授课";
        }else if ([skill integerValue] == 3){
            skill = @"线上线下均可";
        } else {
            skill = @"线上授课";
        }
    }
    
    NSArray *placedarr = @[adress,skill,skill,skill];
    for (int i = 0; i < 1; i ++) {
        UILabel *firstLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*i, 100, 50)];
        [_addressView addSubview:firstLab];
        firstLab.text = arr[i];
        firstLab.textColor = [UIColor colorWithHexString:@"#888"];
        firstLab.font = Font(13 * WideEachUnit);
        firstLab.textAlignment = NSTextAlignmentLeft;
        
        UILabel *line;
        UILabel *secondLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 0 + 40 * i, MainScreenWidth - 130, 50)];
        [self.view addSubview:secondLab];
        secondLab.text = placedarr[i];
        secondLab.textColor = [UIColor colorWithHexString:@"#656565"];
        secondLab.font = Font(13 * WideEachUnit);
        secondLab.textAlignment = NSTextAlignmentLeft;
        line = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*(i+1), MainScreenWidth - 30, 0.5)];
        
        [_addressView addSubview:line];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.6;
        line.hidden = YES;
    }
}

- (void)addDetailView {
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailView];
    
    //添加头部视图
    UILabel *moreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MainScreenWidth - 20, 40)];
    moreTitleLabel.backgroundColor = [UIColor whiteColor];
    moreTitleLabel.font = Font(13);
    moreTitleLabel.text = @"更多详情";
    moreTitleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [_detailView addSubview:moreTitleLabel];
    moreTitleLabel.hidden = YES;
    
    //添加线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_detailView addSubview:line];
    
    

    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MainScreenWidth - 20, 30)];
    infoLabel.backgroundColor = [UIColor whiteColor];
    infoLabel.font = Font(13);
    infoLabel.textColor = [UIColor colorWithHexString:@"#888"];
//    infoLabel.hidden = YES;

    if (_teacherDic[@"info"] == nil || [_teacherDic[@"info"] isEqual:[NSNull null]]) {
        infoLabel.text = @"暂无详情";
        infoLabel.font = Font(13);
        infoLabel.textColor = [UIColor grayColor];
    } else {
//        infoLabel.text = [Passport filterHTML: _teacherDic[@"info"]];
        infoLabel.text = [Passport getZZwithString:_teacherDic[@"info"]];
    }
    infoLabel.numberOfLines = 0;
    infoLabel.hidden = YES;
    
    //检测详情里面是否有图片
    [self isHaveImage];
    if (isHaveImage) {
        [self addWebView];
        infoLabel.hidden = YES;
    } else {
        infoLabel.hidden = NO;
    }
    

    CGRect labelSize = [infoLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 30 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    infoLabel.frame = CGRectMake(15 * WideEachUnit, 0 * WideEachUnit,  MainScreenWidth - 30 * WideEachUnit, labelSize.size.height + 10 * WideEachUnit);
    [_detailView addSubview:infoLabel];
    
    _detailView.frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 20 * WideEachUnit);
    NSLog(@"%lf",_detailView.frame.size.height);
    
    
    double getHigt = CGRectGetMaxY(_detailView.frame) + 20;
    NSString *higtStr = [NSString stringWithFormat:@"%lf",getHigt];
    
    
    //这里要传个通知到 主界面去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherHomeScrollHight" object:higtStr];
}

#pragma mark --- 检测是否有图片
- (void)isHaveImage {
    NSString *originalStr =  [_teacherDic stringValueForKey:@"info"];
    NSString *imageStr1 = @"data/upload";
    NSString *imageStr2 = @"data/upload";
    if ([originalStr rangeOfString:imageStr1].location != NSNotFound || [originalStr rangeOfString:imageStr2].location != NSNotFound ) {//有
        isHaveImage = YES;
    } else {
        isHaveImage = NO;
    }
}

- (void)addWebView {
    NSString *allStr = [NSString stringWithFormat:@"%@",_teacherDic[@"info"]];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *textStr = [allStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 30)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    if (iPhoneX) {
        _webView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    [_detailView addSubview:_webView];

    
    
    NSString *content = textStr;
    if (content.length>2) {
        NSString *str2 = [content substringWithRange:NSMakeRange(0, 3)];
        if ([str2 isEqualToString:@"<p>"]) {
            content = [content substringFromIndex:3];
        }
    }
    
    NSString * str1 = [NSString stringWithFormat:@"<div style=\"margin-left:0px; margin-bottom:5px;font-size:%fpx;color:#010101;text-align:left;\">%@</div>",13.0 * WideEachUnit,textStr];
    NSString *divStr = [NSString stringWithFormat:@"<div style=\"margin:%dpx;border:0;padding:0;\"></div>",SpaceBaside];
    NSString *styleStr = [NSString stringWithFormat:@"<style> .mobile_upload {width:%fpx; height:auto;} </style><style> .emot {width:%fpx; height:%fpx;} img{width:%fpx;} </style><div style=\"word-wrap:break-word; width:%fpx;\"><font style=\"font-size:%fpx;color:#262626;\">",MainScreenWidth-SpaceBaside*2,13.0,13.0,MainScreenWidth - 2 * SpaceBaside,MainScreenWidth-SpaceBaside*2,13.0];
    NSString *str = [NSString stringWithFormat:@"%@%@%@</font></div>",str1,divStr,styleStr];
    
    [_webView loadHTMLString:str baseURL:nil];
}

#pragma mark --- SrcollViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView  {
    
    CGRect frame = self.webView.frame;
    frame.size.width = MainScreenWidth - 20 * WideEachUnit;
    frame.size.height = 1 * WideEachUnit;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webView.frame = frame;
    _webHight = frame.size.height;
    _webView.frame = CGRectMake(0, 0, MainScreenWidth, _webHight);
    _detailView.frame = CGRectMake(0, 10 * WideEachUnit, MainScreenWidth, _webHight + 20 * WideEachUnit);
    
    double getHigt = CGRectGetMaxY(_detailView.frame) + 20;
    NSString *higtStr = [NSString stringWithFormat:@"%lf",getHigt];
    //这里要传个通知到 主界面去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherHomeScrollHight" object:higtStr];
}



#pragma mark ---网络请求
//获取讲师详情
- (void)netWorkTeacherGetInfo {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"teacher_id"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _teacherDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_teacherDic stringValueForKey:@"code"] integerValue] == 1) {
            _teacherDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            [self addAddessView];
            [self addDetailView];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [self addAddessView];
        [self addDetailView];
    }];
    [op start];
}



@end
