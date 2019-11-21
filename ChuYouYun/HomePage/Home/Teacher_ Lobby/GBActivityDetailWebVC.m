//
//  GBActivityDetailWebVC.m
//  ThinkSNS（探索版）
//
//  Created by 刘邦海 on 2017/11/6.
//  Copyright © 2017年 zhiyicx. All rights reserved.
//

#import "GBActivityDetailWebVC.h"
#import "ZLPhoto.h"
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

@interface GBActivityDetailWebVC ()<ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource> {
    BOOL isShowImageTouch;
    NSString *_imageBigUrl;
    NSString *_imageSmallUrl;
    NSMutableArray* _webImageUrlStrArray;
}
@property(nonatomic,strong) NSMutableArray *originalImageArray;
@property (strong ,nonatomic)NSString *ID;
@end

@implementation GBActivityDetailWebVC

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalImageArray = [[NSMutableArray alloc]init];
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.tabelHeight)];
    self.webview.delegate = self;
    self.webview.scrollView.delegate = self;
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.webview];
    [self netWorkTeacherGetInfo];
}

- (void)loadWebView {
    NSString *allStr = [NSString stringWithFormat:@"%@",self.infoDict[@"info"]];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *textStr = [allStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    NSString *content = [NSString stringWithFormat:@"%@",textStr];
    if (!SWNOTEmptyDictionary(self.infoDict)) {
        content = @"";
    } else {
        if (!SWNOTEmptyStr([self.infoDict objectForKey:@"info"])) {
            content = @"";
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><meta name=\"viewport\" content=\"width=device-width,height=device-height, user-scalable=no,initial-scale=1, minimum-scale=1, maximum-scale=1,target-densitydpi=device-dpi \"></head>"
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
    [self.webview loadHTMLString:str baseURL:nil];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
    [self.webview addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.cellTabelCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.cellTabelCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        self.vc.canScroll = YES;
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
    CGPoint pt = [sender locationInView:self.webview];
    NSString *imgStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.webview stringByEvaluatingJavaScriptFromString:imgStr];
    NSString *orignalStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).getAttribute('_src')", pt.x, pt.y];
    NSString *orignalUrl = [self.webview stringByEvaluatingJavaScriptFromString:orignalStr];
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
        //        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        
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

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return _webImageUrlStrArray.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    ZLPhotoPickerBrowserPhoto *photo;
    NSString *imageURLStr;
    // 如果没有原图，会拿到一个null字符串，注意是字符串
    if (![self.originalImageArray[indexPath.row] isEqualToString:@"null"]) {
        imageURLStr = self.originalImageArray[indexPath.row];
    }
    else{
        imageURLStr = _webImageUrlStrArray[indexPath.row];
    }
    photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[NSURL URLWithString:imageURLStr]];
    
    return photo;
}

- (void)setCellTabelCanScroll:(BOOL)cellTabelCanScroll {
    _cellTabelCanScroll = cellTabelCanScroll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _infoDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject];
        if ([[[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject] stringValueForKey:@"code"] integerValue] == 1) {
            [self loadWebView];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

@end
