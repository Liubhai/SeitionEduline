//
//  BRPlayM3u8VideoViewController.m
//  M3U8DownLoadTest
//
//  Created by git burning on 2019/6/18.
//  Copyright © 2019 controling. All rights reserved.
//

#import "BRPlayM3u8VideoViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "SYG.h"
#import "ZFPlayerControlView.h"
#import "ZFPlayerController.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayer.h"
@interface BRPlayM3u8VideoViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *mWebView;
@property (nonatomic, strong) ZFPlayerController *mPlayer;
@property (nonatomic, strong) ZFPlayerControlView *controllView;

@end

@implementation BRPlayM3u8VideoViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"播放";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addNav];
    
    if ([self.playUrl.absoluteString rangeOfString:@"http"].location == NSNotFound) {
        self.playUrl = [NSURL fileURLWithPath:self.filePath isDirectory:YES];
      
    }
    
    UIView *headerPlayView = [[UIView alloc] init];
    headerPlayView.frame = CGRectMake(0, NavigationBarHeight, [UIScreen mainScreen].bounds.size.width, 200 * (MainScreenWidth / 320));
    [self.view addSubview:headerPlayView];
    _controllView = [[ZFPlayerControlView alloc] init];
    _mPlayer = [ZFPlayerController playerWithPlayerManager:[[ZFAVPlayerManager alloc] init] containerView:headerPlayView];
    _mPlayer.controlView = _controllView;
    __weak BRPlayM3u8VideoViewController *weakSelf = self;
    _mPlayer.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        [weakSelf setNeedsStatusBarAppearanceUpdate];
    };
    
    self.controllView.player.assetURL = self.playUrl;
    [self.mPlayer pause];
    
    
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:closeBtn];
//    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
//    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [closeBtn addTarget:self action:@selector(br_selectedCloseAction:) forControlEvents:UIControlEventTouchUpInside];
//    
    
//
//
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.allowsInlineMediaPlayback = YES;
//    config.mediaPlaybackRequiresUserAction = NO;
//
//    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)configuration:config];
//    [self.view addSubview:web];
//    _mWebView = web;
//    web.UIDelegate = self;
//    web.navigationDelegate = self;
////    //说明是本地的
//    if ([self.playUrl.absoluteString rangeOfString:@"http:"].location == NSNotFound) {
////        self.filePath =[self.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL fileURLWithPath:self.filePath];
//        NSString *html = @"<div><center><video id='load_success_video'  width=\"100%\" height=\"100%\" controls><source src=\"5cf745a20d448.mp4\" media=\"\"></video></center></div>";
//        [web loadHTMLString:html baseURL:url];
//        [self playVideo];
//    }
//    else{
//        [web loadRequest:[NSURLRequest requestWithURL:self.playUrl]];
//    }
//
    
   // [web loadRequest:[NSURLRequest requestWithURL:self.playUrl]];

//    [web loadRequest:[NSURLRequest requestWithURL:self.playUrl]];
    // Do any additional setup after loading the view.
}
-(NSURL *)url {
    NSURL *url=[NSURL URLWithString:@"http://download.3g.joy.cn/video/236/60236937/1451280942752_hd.mp4"];
    return url;
}
-(void)playVideo {
    //call JS func to update JS content
    NSString *js = [NSString stringWithFormat:@"document.getElementById('load_success_video').play()"];
    
    
    [_mWebView evaluateJavaScript:js completionHandler:^(id _Nullable other, NSError * _Nullable error) {
        if (error) {
#if DEBUG
            NSLog(@"---call function %@ : %@", js, error.userInfo);
#endif
        } else {
#if DEBUG
            NSLog(@"---call js function %@ success", js);
#endif
        }
    }];

}

-(void)br_selectedCloseAction:(UIButton *)sender{
 
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    
}
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorCancelled) {
        NSLog(@"Canceled request: %@", webView.request.URL);
        return;
    }
    else if ([error.domain isEqualToString:@"WebKitErrorDomain"] && (error.code == 102 || error.code == 204)) {
        NSLog(@"ignore: %@", error);
        return;
    }

    NSLog(@"%@", [error localizedDescription]);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
