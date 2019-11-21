//
//  ZhiboDetailIntroVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/19.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ZhiboDetailIntroVC.h"
#import "ZLPhoto.h"
#import "SYG.h"
#import "BigWindCar.h"

#define upAndDownHeight 75.0

@interface ZhiboDetailIntroVC ()<UIWebViewDelegate,UIScrollViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource> {
    BOOL isShowImageTouch;
    NSString *_imageBigUrl;
    NSString *_imageSmallUrl;
    NSMutableArray* _webImageUrlStrArray;
    NSMutableArray *teacherImageUrlStrIArray;
    BOOL isClassImageTap;
}

@property(nonatomic,strong) NSMutableArray *originalImageArray;
@property(nonatomic,strong) NSMutableArray *teacherOriginalImageArray;

@property (strong ,nonatomic)NSString       *ID;
@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (strong ,nonatomic)NSDictionary   *schoolDict;
@property (strong ,nonatomic)NSString       *teacherID;
@property (strong ,nonatomic)NSDictionary   *teacherDict;

@property (assign ,nonatomic)CGFloat        scrollHight;
@property (assign ,nonatomic)CGFloat        teacherInfoViewHight;
@property (assign ,nonatomic)CGFloat        webHight;
@property (assign ,nonatomic)CGFloat        classWebHight;
@property (assign ,nonatomic)CGFloat        teacherWebHight;

@property (strong ,nonatomic)NSDictionary   *serviceDict;
@property (strong ,nonatomic)NSString       *serviceOpen;


//营销数据
@property (strong ,nonatomic)NSString       *orderSwitch;

/** 课程表述简介 */
@property (strong ,nonatomic) UIView *ClassIntroBackView;
@property (strong ,nonatomic) UIWebView *ClassIntroWeb;
// 提取标签里面纯文字(如果web高度大于某个值,那么收起来的时候就显示纯文字,展开就显示完整版web)
@property (strong, nonatomic) UILabel *classContentLabel;
/** 讲师版块儿 */
@property (strong ,nonatomic) UIView *teacherIntroBackView;
@property (strong, nonatomic) UILabel *teacherTitleLabel;
@property (strong, nonatomic) UILabel *teacherNameLabel;
@property (strong, nonatomic) UILabel *teacherOtherLabel;
@property (strong, nonatomic) UIImageView *teacherHeaderImage;
@property (strong ,nonatomic) UIWebView *TeacherIntroWeb;
// 提取标签里面纯文字(如果web高度大于某个值,那么收起来的时候就显示纯文字,展开就显示完整版web)
@property (strong, nonatomic) UILabel *teacherContentLabel;
/** 机构版块儿 */
@property (strong, nonatomic) UIView *institutionBackView;
@property (strong, nonatomic) UILabel *instutuionTitleLabel;
@property (strong, nonatomic) UILabel *instutuionNameLabel;
@property (strong, nonatomic) UILabel *instutuionOtherLabel;
@property (strong, nonatomic) UIImageView *instutuionHeaderImage;
@property (strong, nonatomic) UIButton *classDownButton;
@property (strong, nonatomic) UIButton *teacherDownButton;

@end

@implementation ZhiboDetailIntroVC

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

-(instancetype)initWithNumID:(NSString *)ID WithOrderSwitch:(NSString *)orderSwitch {
    self = [super init];
    if (self) {
        _ID = ID;
        _orderSwitch = orderSwitch;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _teacherWebHight = 0;
    _classWebHight = 0;
    self.originalImageArray = [[NSMutableArray alloc]init];
    _teacherOriginalImageArray = [NSMutableArray new];
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tabelHeight)];
    _mainScroll.delegate = self;
    _mainScroll.backgroundColor = [UIColor whiteColor];
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _tabelHeight + 10);
    [self.view addSubview:_mainScroll];
    [self makeClassInfoWebView];
//    [self makeClassIntroWebView];
//    [self makeTeacherIntroView];
//    [self makeIntitutionView];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _ClassIntroWeb.bottom > _tabelHeight ? _ClassIntroWeb.bottom : (_tabelHeight + 10));
    [self netWorkLiveGetInfo];
}

- (void)makeClassInfoWebView {
    _ClassIntroWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    _ClassIntroWeb.delegate = self;
    _ClassIntroWeb.scrollView.scrollEnabled = NO;
    _ClassIntroWeb.scrollView.showsVerticalScrollIndicator = NO;
    _ClassIntroWeb.scrollView.showsHorizontalScrollIndicator = NO;
    [_mainScroll addSubview:_ClassIntroWeb];
}

- (void)makeClassIntroWebView {
    _ClassIntroBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    _ClassIntroBackView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_ClassIntroBackView];
    _ClassIntroWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    _ClassIntroWeb.delegate = self;
    _ClassIntroWeb.scrollView.scrollEnabled = NO;
    _ClassIntroWeb.scrollView.showsVerticalScrollIndicator = NO;
    _ClassIntroWeb.scrollView.showsHorizontalScrollIndicator = NO;
    _ClassIntroWeb.hidden = YES;
    [_ClassIntroBackView addSubview:_ClassIntroWeb];
    _classContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MainScreenWidth - 20, 1)];
    _classContentLabel.numberOfLines = 7;
    [_ClassIntroBackView addSubview:_classContentLabel];
    _classDownButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 55, upAndDownHeight, 30, 30)];
    [_classDownButton setImage:Image(@"灰色乡下@2x") forState:0];
    [_classDownButton setImage:Image(@"向上@2x") forState:UIControlStateSelected];
    _classDownButton.selected = NO;
    [_classDownButton addTarget:self action:@selector(upAndDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ClassIntroBackView addSubview:_classDownButton];
    _classDownButton.hidden = YES;
}

- (void)makeTeacherIntroView {
    _teacherIntroBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ClassIntroBackView.frame) + 10 * WideEachUnit, MainScreenWidth, 265 * WideEachUnit)];
    _teacherIntroBackView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_teacherIntroBackView];
    
    //讲师信息
    _teacherTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _teacherTitleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    _teacherTitleLabel.backgroundColor = [UIColor whiteColor];
    _teacherTitleLabel.font = Font(15 * WideEachUnit);
    _teacherTitleLabel.text = @"讲师信息";
    [_teacherIntroBackView addSubview:_teacherTitleLabel];
    
    //添加横线
    UIButton *teacherTitleLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 38 * WideEachUnit, MainScreenWidth, 1)];
    teacherTitleLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_teacherIntroBackView addSubview:teacherTitleLineButton];
    
    //添加讲师头像
    _teacherHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 42 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    _teacherHeaderImage.backgroundColor = [UIColor whiteColor];
    _teacherHeaderImage.layer.cornerRadius = 25 * WideEachUnit;
    _teacherHeaderImage.layer.masksToBounds = YES;
    [_teacherIntroBackView addSubview:_teacherHeaderImage];
    
    
    //讲师名字
    _teacherNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, 50 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _teacherNameLabel.textColor = [UIColor colorWithHexString:@"#333"];
    _teacherNameLabel.backgroundColor = [UIColor whiteColor];
    _teacherNameLabel.font = Font(14 * WideEachUnit);
    _teacherNameLabel.text = @"";
    [_teacherIntroBackView addSubview:_teacherNameLabel];
    
    //讲师课程数和粉丝数
    _teacherOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, 67 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _teacherOtherLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _teacherOtherLabel.backgroundColor = [UIColor whiteColor];
    _teacherOtherLabel.font = Font(12 * WideEachUnit);
    _teacherOtherLabel.text = @"0课程    好评度0";
    [_teacherIntroBackView addSubview:_teacherOtherLabel];
    
    _TeacherIntroWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, _teacherHeaderImage.bottom + 10 * HigtEachUnit, MainScreenWidth, 1)];
    _TeacherIntroWeb.delegate = self;
    _TeacherIntroWeb.scrollView.scrollEnabled = NO;
    _TeacherIntroWeb.scrollView.showsVerticalScrollIndicator = NO;
    _TeacherIntroWeb.scrollView.showsHorizontalScrollIndicator = NO;
    _TeacherIntroWeb.hidden = YES;
    [_teacherIntroBackView addSubview:_TeacherIntroWeb];
    _teacherContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _teacherHeaderImage.bottom + 10 * HigtEachUnit, MainScreenWidth - 20, 1)];
    [_teacherIntroBackView addSubview:_teacherContentLabel];
    _teacherDownButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 55, upAndDownHeight, 30, 30)];
    [_teacherDownButton setImage:Image(@"灰色乡下@2x") forState:0];
    [_teacherDownButton setImage:Image(@"向上@2x") forState:UIControlStateSelected];
    _teacherDownButton.selected = NO;
    [_teacherDownButton addTarget:self action:@selector(upAndDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_teacherIntroBackView addSubview:_teacherDownButton];
    _teacherDownButton.hidden = YES;
}

- (void)makeIntitutionView {
    _institutionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherIntroBackView.frame), MainScreenWidth, 80 * WideEachUnit)];
    _institutionBackView.backgroundColor = [UIColor whiteColor];
    [_mainScroll addSubview:_institutionBackView];
    
    //所属机构
    _instutuionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _instutuionTitleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    _instutuionTitleLabel.backgroundColor = [UIColor whiteColor];
    _instutuionTitleLabel.font = Font(15 * WideEachUnit);
    _instutuionTitleLabel.text = @"所属机构";
    [_institutionBackView addSubview:_instutuionTitleLabel];
    
    //添加横线
    UIButton *instTitleLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 35 * WideEachUnit, MainScreenWidth, 1)];
    instTitleLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_institutionBackView addSubview:instTitleLineButton];
    
    //所属机构图像
    _instutuionHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_instutuionTitleLabel.frame) + 20 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
    _instutuionHeaderImage.backgroundColor = [UIColor whiteColor];
    _instutuionHeaderImage.layer.cornerRadius = 25 * WideEachUnit;
    _instutuionHeaderImage.layer.masksToBounds = YES;
    [_institutionBackView addSubview:_instutuionHeaderImage];
    
    
    //讲师名字
    _instutuionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, CGRectGetMaxY(_instutuionTitleLabel.frame) + 25 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _instutuionNameLabel.textColor = [UIColor colorWithHexString:@"#333"];
    _instutuionNameLabel.backgroundColor = [UIColor whiteColor];
    _instutuionNameLabel.font = Font(14 * WideEachUnit);
    _instutuionNameLabel.text = @"";
    [_institutionBackView addSubview:_instutuionNameLabel];
    
    //讲师课程数和粉丝数
    _instutuionOtherLabel = [[UILabel alloc] initWithFrame:CGRectMake(72 * WideEachUnit, CGRectGetMaxY(_instutuionNameLabel.frame) + 8 * WideEachUnit - 3 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _instutuionOtherLabel.textColor = [UIColor colorWithHexString:@"#888"];
    _instutuionOtherLabel.backgroundColor = [UIColor whiteColor];
    _instutuionOtherLabel.font = Font(12 * WideEachUnit);
    _instutuionOtherLabel.text = @"0课程    好评度";
    [_institutionBackView addSubview:_instutuionOtherLabel];
    [_institutionBackView setHeight:_instutuionHeaderImage.bottom + 10];
}

- (void)loadClassWebView {
    NSString *allStr = [NSString stringWithFormat:@"%@",_dataSource[@"video_intro"]];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *textStr = [allStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    NSString *content = [NSString stringWithFormat:@"%@",textStr];
    if (!SWNOTEmptyDictionary(_dataSource)) {
        content = @"";
    } else {
        if (!SWNOTEmptyStr([_dataSource objectForKey:@"video_intro"])) {
            content = @"";
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width,height=device-height,font-size:15px, user-scalable=no,initial-scale=1, minimum-scale=1, maximum-scale=1,target-densitydpi=device-dpi \"></head>"
                     "<body>"
                     "<script type='text/javascript'>"
                     "window.onload = function(){\n"
                     "var $img = document.getElementsByTagName('img');\n"
                     "for(var p in  $img){\n"
                     " $img[p].style.width = '100%%';\n"
                     "$img[p].style.height ='auto'\n"
                     "}\n"
                     "}"
                     "</script>%@"
                     "</body>"
                     "</html>",content];
    [self.ClassIntroWeb loadHTMLString:str baseURL:nil];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
    [self.ClassIntroWeb addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)loadTeacherWebView {
    NSString *allStr = [NSString stringWithFormat:@"%@",_teacherDict[@"info"]];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *textStr = [allStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    NSString *content = [NSString stringWithFormat:@"%@",textStr];
    if (!SWNOTEmptyDictionary(_teacherDict)) {
        content = @"";
    } else {
        if (!SWNOTEmptyStr([_teacherDict objectForKey:@"info"])) {
            content = @"";
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width,height=device-height,font-size:15px, user-scalable=no,initial-scale=1, minimum-scale=1, maximum-scale=1,target-densitydpi=device-dpi \"></head>"
                     "<body>"
                     "<script type='text/javascript'>"
                     "window.onload = function(){\n"
                     "var $img = document.getElementsByTagName('img');\n"
                     "for(var p in  $img){\n"
                     " $img[p].style.width = '100%%';\n"
                     "$img[p].style.height ='auto'\n"
                     "}\n"
                     "}"
                     "</script>%@"
                     "</body>"
                     "</html>",content];
    [self.TeacherIntroWeb loadHTMLString:str baseURL:nil];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
    [self.TeacherIntroWeb addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == _ClassIntroWeb) {
        _webImageUrlStrArray = nil;
        
        // 获取图片的JS
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        if(objs[i].class != 'emot')\
        imgScr = imgScr + objs[i].src + '+';\
        };\
        return imgScr;\
        };";
        
        // 获取原图的JS
        static  NSString * const jsGetOriginalImages =
        @"function getOriginalImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        if(objs[i].class != 'emot')\
        imgScr = imgScr + objs[i].getAttribute('_src') + '+';\
        };\
        return imgScr;\
        };";
        
        
        [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
        [webView stringByEvaluatingJavaScriptFromString:jsGetOriginalImages];//注入js方法
        NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
        _classWebHight = [height floatValue] + 20;
        [_ClassIntroWeb setHeight:[height floatValue] + 20];
        _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _ClassIntroWeb.bottom > _tabelHeight ? _ClassIntroWeb.bottom : (_tabelHeight + 10));
        
        NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
        _webImageUrlStrArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
        if (_webImageUrlStrArray.count >= 2) {
            [_webImageUrlStrArray removeLastObject];
        }
        NSString *getOriginalImageStr = [webView stringByEvaluatingJavaScriptFromString:@"getOriginalImages()"];
        NSArray * originalArray = [NSMutableArray arrayWithArray:[getOriginalImageStr componentsSeparatedByString:@"+"]];
        self.originalImageArray = [[NSMutableArray alloc]initWithArray:originalArray];
        if (self.originalImageArray.count >= 2) {
            [self.originalImageArray removeLastObject];
        }
        
        NSMutableArray* delateArray = [[NSMutableArray alloc]init];
        NSMutableArray* tempArray = [[NSMutableArray alloc]initWithArray:_webImageUrlStrArray];
        
        // TS系统中的 新版本（16.10月以后）动态表情头
        NSString* headerUrl =[NSString stringWithFormat:@"%@resources/theme/stv1/_static/js/um/dialogs/emotion",EncryptHeaderUrl];
        //  旧版本（16.10月之前）动态表情头
        //  需要过滤掉这部分表情图片
        NSString *oldeHeaderUrl = [NSString stringWithFormat:@"%@addons",EncryptHeaderUrl];
        
        for (NSString* tempUrl in _webImageUrlStrArray) {
            if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
                [delateArray addObject:tempUrl];
            }
        }
        
        for (NSString* temp in _webImageUrlStrArray) {
            for (NSString* delate in delateArray) {
                if ([delate isEqualToString:temp]) {
                    [tempArray removeObject:temp];
                    break;
                }
            }
        }
        _webImageUrlStrArray = tempArray;
        
        // 过滤原图中的表情
        NSMutableArray* delateOriginalArray = [[NSMutableArray alloc]init];
        NSMutableArray* tempOriginalArray = [[NSMutableArray alloc]initWithArray:self.originalImageArray];
        
        for (NSString* tempUrl in self.originalImageArray) {
            if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
                [delateOriginalArray addObject:tempUrl];
            }
        }
        
        for (NSString* temp in self.originalImageArray) {
            for (NSString* delate in delateOriginalArray) {
                if ([delate isEqualToString:temp]) {
                    [tempOriginalArray removeObject:temp];
                    break;
                }
            }
        }
        self.originalImageArray = tempOriginalArray;
    }
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    if (webView == _ClassIntroWeb) {
//        _webImageUrlStrArray = nil;
//
//        // 获取图片的JS
//        static  NSString * const jsGetImages =
//        @"function getImages(){\
//        var objs = document.getElementsByTagName(\"img\");\
//        var imgScr = '';\
//        for(var i=0;i<objs.length;i++){\
//        if(objs[i].class != 'emot')\
//        imgScr = imgScr + objs[i].src + '+';\
//        };\
//        return imgScr;\
//        };";
//
//        // 获取原图的JS
//        static  NSString * const jsGetOriginalImages =
//        @"function getOriginalImages(){\
//        var objs = document.getElementsByTagName(\"img\");\
//        var imgScr = '';\
//        for(var i=0;i<objs.length;i++){\
//        if(objs[i].class != 'emot')\
//        imgScr = imgScr + objs[i].getAttribute('_src') + '+';\
//        };\
//        return imgScr;\
//        };";
//
//
//        [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
//        [webView stringByEvaluatingJavaScriptFromString:jsGetOriginalImages];//注入js方法
//        NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
//        _classWebHight = [height floatValue] + 20;
//        UITextView *ii;
//        if ([height floatValue] > upAndDownHeight) {
//            _ClassIntroWeb.hidden = YES;
//            [_ClassIntroWeb setHeight:upAndDownHeight];
//            [self MyselfDecision_ClassContent:[Passport filterHTML:_dataSource[@"video_intro"]]];
//        } else {
//            _ClassIntroWeb.hidden = NO;
//            [_ClassIntroWeb setHeight:[height floatValue] + 20];
//            [_classDownButton setTop:_ClassIntroWeb.bottom];
//            [_classDownButton setHeight:0];
//            [_ClassIntroBackView setHeight:_classDownButton.bottom];
//            _classDownButton.hidden = YES;
//            [_teacherIntroBackView setTop:_ClassIntroBackView.bottom + 10 * HigtEachUnit];
//            [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
//            [_institutionBackView setTop:_teacherIntroBackView.bottom + 10 * HigtEachUnit];
//            _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _institutionBackView.bottom > _tabelHeight ? _institutionBackView.bottom : (_tabelHeight + 10));
//        }
//        NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
//        _webImageUrlStrArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
//        if (_webImageUrlStrArray.count >= 2) {
//            [_webImageUrlStrArray removeLastObject];
//        }
//        NSString *getOriginalImageStr = [webView stringByEvaluatingJavaScriptFromString:@"getOriginalImages()"];
//        NSArray * originalArray = [NSMutableArray arrayWithArray:[getOriginalImageStr componentsSeparatedByString:@"+"]];
//        self.originalImageArray = [[NSMutableArray alloc]initWithArray:originalArray];
//        if (self.originalImageArray.count >= 2) {
//            [self.originalImageArray removeLastObject];
//        }
//
//        NSMutableArray* delateArray = [[NSMutableArray alloc]init];
//        NSMutableArray* tempArray = [[NSMutableArray alloc]initWithArray:_webImageUrlStrArray];
//
//        // TS系统中的 新版本（16.10月以后）动态表情头
//        NSString* headerUrl =[NSString stringWithFormat:@"%@resources/theme/stv1/_static/js/um/dialogs/emotion",EncryptHeaderUrl];
//        //  旧版本（16.10月之前）动态表情头
//        //  需要过滤掉这部分表情图片
//        NSString *oldeHeaderUrl = [NSString stringWithFormat:@"%@addons",EncryptHeaderUrl];
//
//        for (NSString* tempUrl in _webImageUrlStrArray) {
//            if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
//                [delateArray addObject:tempUrl];
//            }
//        }
//
//        for (NSString* temp in _webImageUrlStrArray) {
//            for (NSString* delate in delateArray) {
//                if ([delate isEqualToString:temp]) {
//                    [tempArray removeObject:temp];
//                    break;
//                }
//            }
//        }
//        _webImageUrlStrArray = tempArray;
//
//        // 过滤原图中的表情
//        NSMutableArray* delateOriginalArray = [[NSMutableArray alloc]init];
//        NSMutableArray* tempOriginalArray = [[NSMutableArray alloc]initWithArray:self.originalImageArray];
//
//        for (NSString* tempUrl in self.originalImageArray) {
//            if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
//                [delateOriginalArray addObject:tempUrl];
//            }
//        }
//
//        for (NSString* temp in self.originalImageArray) {
//            for (NSString* delate in delateOriginalArray) {
//                if ([delate isEqualToString:temp]) {
//                    [tempOriginalArray removeObject:temp];
//                    break;
//                }
//            }
//        }
//        self.originalImageArray = tempOriginalArray;
//    } else if (webView == _TeacherIntroWeb) {
//        teacherImageUrlStrIArray = nil;
//
//        // 获取图片的JS
//        static  NSString * const jsGetImages =
//        @"function getImages(){\
//        var objs = document.getElementsByTagName(\"img\");\
//        var imgScr = '';\
//        for(var i=0;i<objs.length;i++){\
//        if(objs[i].class != 'emot')\
//        imgScr = imgScr + objs[i].src + '+';\
//        };\
//        return imgScr;\
//        };";
//
//        // 获取原图的JS
//        static  NSString * const jsGetOriginalImages =
//        @"function getOriginalImages(){\
//        var objs = document.getElementsByTagName(\"img\");\
//        var imgScr = '';\
//        for(var i=0;i<objs.length;i++){\
//        if(objs[i].class != 'emot')\
//        imgScr = imgScr + objs[i].getAttribute('_src') + '+';\
//        };\
//        return imgScr;\
//        };";
//
//
//        [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
//        [webView stringByEvaluatingJavaScriptFromString:jsGetOriginalImages];//注入js方法
//        NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
//        _teacherWebHight = [height floatValue] + 20;
//        if ([height floatValue] > upAndDownHeight) {
//            [_TeacherIntroWeb setHeight:upAndDownHeight];
//            _TeacherIntroWeb.hidden = YES;
//            _teacherContentLabel.hidden = NO;
//            [self MyselfDecision_TeacherInfo:[Passport filterHTML:[_teacherDict stringValueForKey:@"info"]]];
//        } else {
//            _TeacherIntroWeb.hidden = NO;
//            _teacherContentLabel.hidden = YES;
//            [_TeacherIntroWeb setHeight:[height floatValue] + 20];
//            [_teacherDownButton setTop:_TeacherIntroWeb.bottom];
//            [_teacherDownButton setHeight:0];
//            [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
//            _teacherDownButton.hidden = YES;
//        }
//        [_teacherIntroBackView setTop:_ClassIntroBackView.bottom + 10 * HigtEachUnit];
//        [_institutionBackView setTop:_teacherIntroBackView.bottom + 10 * HigtEachUnit];
//        _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _institutionBackView.bottom > _tabelHeight ? _institutionBackView.bottom : (_tabelHeight + 10));
//        NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
//        teacherImageUrlStrIArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
//        if (teacherImageUrlStrIArray.count >= 2) {
//            [teacherImageUrlStrIArray removeLastObject];
//        }
//        NSString *getOriginalImageStr = [webView stringByEvaluatingJavaScriptFromString:@"getOriginalImages()"];
//        NSArray * originalArray = [NSMutableArray arrayWithArray:[getOriginalImageStr componentsSeparatedByString:@"+"]];
//        self.teacherOriginalImageArray = [[NSMutableArray alloc]initWithArray:originalArray];
//        if (self.teacherOriginalImageArray.count >= 2) {
//            [self.teacherOriginalImageArray removeLastObject];
//        }
//
//        NSMutableArray* delateArray = [[NSMutableArray alloc]init];
//        NSMutableArray* tempArray = [[NSMutableArray alloc]initWithArray:teacherImageUrlStrIArray];
//
//        // TS系统中的 新版本（16.10月以后）动态表情头
//        NSString* headerUrl =[NSString stringWithFormat:@"%@resources/theme/stv1/_static/js/um/dialogs/emotion",EncryptHeaderUrl];
//        //  旧版本（16.10月之前）动态表情头
//        //  需要过滤掉这部分表情图片
//        NSString *oldeHeaderUrl = [NSString stringWithFormat:@"%@addons",EncryptHeaderUrl];
//
//        for (NSString* tempUrl in teacherImageUrlStrIArray) {
//            if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
//                [delateArray addObject:tempUrl];
//            }
//        }
//
//        for (NSString* temp in teacherImageUrlStrIArray) {
//            for (NSString* delate in delateArray) {
//                if ([delate isEqualToString:temp]) {
//                    [tempArray removeObject:temp];
//                    break;
//                }
//            }
//        }
//        teacherImageUrlStrIArray = tempArray;
//
//        // 过滤原图中的表情
//        NSMutableArray* delateOriginalArray = [[NSMutableArray alloc]init];
//        NSMutableArray* tempOriginalArray = [[NSMutableArray alloc]initWithArray:self.teacherOriginalImageArray];
//
//        for (NSString* tempUrl in self.teacherOriginalImageArray) {
//            if ([tempUrl hasPrefix:headerUrl] || [tempUrl hasPrefix:oldeHeaderUrl]) {
//                [delateOriginalArray addObject:tempUrl];
//            }
//        }
//
//        for (NSString* temp in self.teacherOriginalImageArray) {
//            for (NSString* delate in delateOriginalArray) {
//                if ([delate isEqualToString:temp]) {
//                    [tempOriginalArray removeObject:temp];
//                    break;
//                }
//            }
//        }
//        self.teacherOriginalImageArray = tempOriginalArray;
//    }
//
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.cellTabelCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        if (_isZhibo) {
            self.vc.canScroll = YES;
        } else {
            self.mainVC.canScroll = YES;
        }
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL = [ request URL  ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        //打开网址
        if (isShowImageTouch) {
            isShowImageTouch = NO;
            return NO;
        }
        /**
         BrowserViewController *browS = [[BrowserViewController alloc]initWithUrl:requestURL];
         [self.navigationController presentViewController:browS animated:YES completion:NULL];
         */
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap1:(UITapGestureRecognizer *)sender
{
    if (sender.view == _TeacherIntroWeb) {
        isClassImageTap = NO;
        CGPoint pt = [sender locationInView:_TeacherIntroWeb];
        NSString *imgStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *urlToSave = [_TeacherIntroWeb stringByEvaluatingJavaScriptFromString:imgStr];
        NSString *orignalStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).getAttribute('_src')", pt.x, pt.y];
        NSString *orignalUrl = [_TeacherIntroWeb stringByEvaluatingJavaScriptFromString:orignalStr];
        if (urlToSave.length > 0&&[urlToSave rangeOfString:@"/expression/"].location==NSNotFound&&[urlToSave rangeOfString:@"/emotion/"].location==NSNotFound) {
            _imageBigUrl = orignalUrl;
            _imageSmallUrl = urlToSave;
            isShowImageTouch = YES;
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            pickerBrowser.delegate = self;
            pickerBrowser.dataSource = self;
            // 是否可以删除照片
            pickerBrowser.editing = NO;
            // 当前分页的值
            // pickerBrowser.currentPage = indexPath.row;
            // 传入组
            // pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            
            int row = 0;
            
            for (int i = 0; i < teacherImageUrlStrIArray.count; i ++) {
                if ([_imageSmallUrl isEqualToString:teacherImageUrlStrIArray[i]]) {
                    row = i;
                    break;
                }
            }
            pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
            
            // 展示控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [pickerBrowser showPickerVc:window.rootViewController];
        }
    } else if (sender.view == _ClassIntroWeb) {
        isClassImageTap = YES;
        CGPoint pt = [sender locationInView:_ClassIntroWeb];
        NSString *imgStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *urlToSave = [_ClassIntroWeb stringByEvaluatingJavaScriptFromString:imgStr];
        NSString *orignalStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).getAttribute('_src')", pt.x, pt.y];
        NSString *orignalUrl = [_ClassIntroWeb stringByEvaluatingJavaScriptFromString:orignalStr];
        if (urlToSave.length > 0&&[urlToSave rangeOfString:@"/expression/"].location==NSNotFound&&[urlToSave rangeOfString:@"/emotion/"].location==NSNotFound) {
            _imageBigUrl = orignalUrl;
            _imageSmallUrl = urlToSave;
            isShowImageTouch = YES;
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            pickerBrowser.delegate = self;
            pickerBrowser.dataSource = self;
            // 是否可以删除照片
            pickerBrowser.editing = NO;
            // 当前分页的值
            // pickerBrowser.currentPage = indexPath.row;
            // 传入组
            // pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            
            int row = 0;
            
            for (int i = 0; i < _webImageUrlStrArray.count; i ++) {
                if ([_imageSmallUrl isEqualToString:_webImageUrlStrArray[i]]) {
                    row = i;
                    break;
                }
            }
            pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
            
            
            // 展示控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [pickerBrowser showPickerVc:window.rootViewController];
        }
    }
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    if (isClassImageTap) {
        return _webImageUrlStrArray.count;
    } else {
        return teacherImageUrlStrIArray.count;
    }
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo;
    NSString *imageURLStr;
    if (isClassImageTap) {
        // 如果没有原图，会拿到一个null字符串，注意是字符串
        if (![self.originalImageArray[indexPath.row] isEqualToString:@"null"]) {
            imageURLStr = self.originalImageArray[indexPath.row];
        }
        else{
            imageURLStr = _webImageUrlStrArray[indexPath.row];
        }
    } else {
        // 如果没有原图，会拿到一个null字符串，注意是字符串
        if (![self.teacherOriginalImageArray[indexPath.row] isEqualToString:@"null"]) {
            imageURLStr = self.teacherOriginalImageArray[indexPath.row];
        }
        else{
            imageURLStr = teacherImageUrlStrIArray[indexPath.row];
        }
    }
    photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[NSURL URLWithString:imageURLStr]];
    
    return photo;
}

#pragma mark --- 网络请求
//直播详情
- (void)netWorkLiveGetInfo {
    
    NSString *endUrlStr = YunKeTang_Live_live_getInfo;
    if (!_isZhibo) {
        endUrlStr = YunKeTang_Video_video_getInfo;
    }
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_isZhibo) {
        [mutabDict setObject:_ID forKey:@"live_id"];
    } else {
        [mutabDict setObject:_ID forKey:@"id"];
    }
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
            if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
                if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    _dataSource = [dict dictionaryValueForKey:@"data"];
                } else {
                    _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                }
            }
            [self loadClassWebView];
            /// 现在只展示课程简介
            /**
            _schoolDict = [_dataSource dictionaryValueForKey:@"school_info"];
            _teacherID = [_dataSource stringValueForKey:@"teacher_id"];
            [_instutuionHeaderImage sd_setImageWithURL:[NSURL URLWithString:[_schoolDict stringValueForKey:@"cover"]] placeholderImage:Image(@"站位图")];
            _instutuionTitleLabel.text = [_schoolDict stringValueForKey:@"title"];
            _instutuionOtherLabel.text = [NSString stringWithFormat:@"%@课程    好评度%@",[[_schoolDict dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"],[[_schoolDict objectForKey:@"count"] objectForKey:@"comment_rate"]];
            
            [self netWorkTeacherGetInfo];
             */
        } else {
            return;
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)netWorkTeacherGetInfo {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_teacherID == nil) {
        return;
    }
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
        _teacherDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        [_teacherHeaderImage sd_setImageWithURL:[NSURL URLWithString:[_teacherDict stringValueForKey:@"headimg"]] placeholderImage:Image(@"站位图")];
        _teacherNameLabel.text = [_teacherDict stringValueForKey:@"name"];
        _teacherOtherLabel.text = [NSString stringWithFormat:@"%@课程  %@粉丝",[_teacherDict stringValueForKey:@"video_count"],[[_teacherDict dictionaryValueForKey:@"follow_state"] stringValueForKey:@"follower"]];
        [self loadClassWebView];
        [self loadTeacherWebView];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

- (void)upAndDownButtonClick:(UIButton *)sender {
    if (sender == _classDownButton) {
        _classDownButton.selected = !_classDownButton.selected;
        if (_classDownButton.selected) {
            _classContentLabel.hidden = YES;
            _ClassIntroWeb.hidden = NO;
            // 展开
            [_ClassIntroWeb setHeight:_classWebHight];
            [_classDownButton setTop:_ClassIntroWeb.bottom];
            [_ClassIntroBackView setHeight:_classDownButton.bottom];
            
        } else {
            // 收起来
            _classContentLabel.hidden = NO;
            _ClassIntroWeb.hidden = YES;
            [_ClassIntroWeb setHeight:upAndDownHeight];
            [_classDownButton setTop:_classContentLabel.bottom];
            [_ClassIntroBackView setHeight:_classDownButton.bottom];
        }
        [_teacherIntroBackView setTop:_ClassIntroBackView.bottom + 10 * HigtEachUnit];
        [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
        [_institutionBackView setTop:_teacherIntroBackView.bottom + 10 * HigtEachUnit];
        _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _institutionBackView.bottom > _tabelHeight ? _institutionBackView.bottom : (_tabelHeight + 10));
    } else {
        _teacherDownButton.selected = !_teacherDownButton.selected;
        if (_teacherDownButton.selected) {
            // 展开
            _teacherContentLabel.hidden = YES;
            _TeacherIntroWeb.hidden = NO;
            [_TeacherIntroWeb setHeight:_teacherWebHight];
            [_teacherDownButton setTop:_TeacherIntroWeb.bottom];
            [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
        } else {
            // 收起来
            _teacherContentLabel.hidden = NO;
            _TeacherIntroWeb.hidden = YES;
            [_TeacherIntroWeb setHeight:upAndDownHeight];
            [_teacherDownButton setTop:_teacherContentLabel.bottom];
            [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
        }
        [_teacherIntroBackView setTop:_ClassIntroBackView.bottom + 10 * HigtEachUnit];
        [_institutionBackView setTop:_teacherIntroBackView.bottom + 10 * HigtEachUnit];
        _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _institutionBackView.bottom > _tabelHeight ? _institutionBackView.bottom : (_tabelHeight + 10));
    }
}

- (void)changeMainScrollViewHeight:(CGFloat)changeHeight {
    [_mainScroll setHeight:changeHeight];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _mainScroll.contentSize.height > _tabelHeight ? _mainScroll.contentSize.height : _tabelHeight + 10);
}

//课程详情的自适应
- (void)MyselfDecision_TeacherInfo:(NSString *)textStr {
    //文本赋值
    _teacherContentLabel.text = textStr;
    //设置label的最大行数
    _teacherContentLabel.numberOfLines = 0;
    _teacherContentLabel.font = SYSTEMFONT(15);
//    _teacherContentLabel.attributedText = attributedString;
    CGRect labelSize = [_teacherContentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    [_teacherContentLabel setHeight:labelSize.size.height > 7 * 16 ?  7 * 16 : labelSize.size.height];
    [_teacherDownButton setTop:_teacherContentLabel.bottom];
    [_teacherDownButton setHeight:30];
    [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
    _teacherDownButton.hidden = NO;
}

//课程详情的自适应
- (void)MyselfDecision_ClassContent:(NSString *)textStr {
    //文本赋值
    _classContentLabel.text = textStr;
    //设置label的最大行数
    _classContentLabel.numberOfLines = 0;
    _classContentLabel.font = SYSTEMFONT(15);
//    _classContentLabel.attributedText = attributedString;
    
    CGRect labelSize = [_classContentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    [_classContentLabel setHeight:labelSize.size.height > 7 * 16 ?  7 * 16 : labelSize.size.height];
    [_classDownButton setTop:_classContentLabel.bottom];
    [_classDownButton setHeight:30];
    _classDownButton.hidden = NO;
    [_ClassIntroBackView setHeight:_classDownButton.bottom];
    [_teacherIntroBackView setTop:_ClassIntroBackView.bottom + 10 * HigtEachUnit];
    [_teacherIntroBackView setHeight:_teacherDownButton.bottom];
    [_institutionBackView setTop:_teacherIntroBackView.bottom + 10 * HigtEachUnit];
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _institutionBackView.bottom > _tabelHeight ? _institutionBackView.bottom : (_tabelHeight + 10));
}

@end
