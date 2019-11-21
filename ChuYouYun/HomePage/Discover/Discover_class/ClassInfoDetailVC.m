//
//  ClassInfoDetailVC.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "ClassInfoDetailVC.h"
#import "AppDelegate.h"
#import "ZLPhoto.h"
#import "SYG.h"
#import "BigWindCar.h"

@interface ClassInfoDetailVC ()<UIWebViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate,ZLPhotoPickerBrowserViewControllerDataSource> {
    NSMutableArray* _webImageUrlStrArray;
    BOOL isClassImageTap;
    NSString *_imageBigUrl;
    NSString *_imageSmallUrl;
    BOOL isShowImageTouch;
}

@property (strong ,nonatomic) UIWebView *ClassIntroWeb;
@property(nonatomic,strong) NSMutableArray *originalImageArray;

@end

@implementation ClassInfoDetailVC

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originalImageArray = [[NSMutableArray alloc]init];
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _tableHeight)];
    _mainScroll.backgroundColor = [UIColor whiteColor];
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.delegate = self;
    _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _tableHeight + 10);
    [self.view addSubview:_mainScroll];
    _ClassIntroWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    _ClassIntroWeb.delegate = self;
    _ClassIntroWeb.scrollView.scrollEnabled = NO;
    _ClassIntroWeb.scrollView.showsVerticalScrollIndicator = NO;
    _ClassIntroWeb.scrollView.showsHorizontalScrollIndicator = NO;
    [_mainScroll addSubview:_ClassIntroWeb];
    if (@available(iOS 11.0, *)) {
        _mainScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScroll) {
        if (!self.cellTabelCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y <= 0) {
            self.cellTabelCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
            self.vc.canScroll = YES;
        }
    }
}

- (void)setOriginDict:(NSDictionary *)originDict {
    _originDict = originDict;
    if (SWNOTEmptyDictionary(_originDict)) {
        [self loadClassWebView];
    }
}

- (void)loadClassWebView {
    NSString *allStr = [NSString stringWithFormat:@"%@",_originDict[@"album_intro"]];
    NSString *replaceStr = [NSString stringWithFormat:@"<img src=\"%@/data/upload",EncryptHeaderUrl];
    NSString *textStr = [allStr stringByReplacingOccurrencesOfString:@"<img src=\"/data/upload" withString:replaceStr];
    NSString *content = [NSString stringWithFormat:@"%@",textStr];
    if (!SWNOTEmptyDictionary(_originDict)) {
        content = @"";
    } else {
        if (!SWNOTEmptyStr([_originDict objectForKey:@"album_intro"])) {
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
        [_ClassIntroWeb setHeight:[height floatValue] + 20];
        _mainScroll.contentSize = CGSizeMake(MainScreenWidth, _ClassIntroWeb.bottom > _tableHeight ? _ClassIntroWeb.bottom : (_tableHeight + 10));
        
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
    if (sender.view == _ClassIntroWeb) {
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

@end
