//
//  BBLaunchAdMonitor.m
//  Search
//
//  Created by iXcoder on 15/4/22.
//  Copyright (c) 2015年 iXcoder. All rights reserved.
//

#import "BBLaunchAdMonitor.h"
#import "AdViewController.h"
#import "BigWindCar.h"


@import UIKit.UIScreen;
@import UIKit.UIImage;
@import UIKit.UIImageView;
@import UIKit.UIButton;
@import UIKit.UILabel;
@import UIKit.UIColor;
@import UIKit.UIFont;
@import QuartzCore.CALayer;

typedef NS_ENUM(NSInteger, BBLaunchAdProcess) {
    BBLaunchAdProcessFailed = -1,
    BBLaunchAdProcessNone ,
    BBLaunchAdProcessLoading ,
    BBLaunchAdProcessSuccess
};

NSString *BBLaunchAdDetailDisplayNotification = @"BBShowLaunchAdDetailNotification";
NSString *BBLaunchAdDetailImageUrlNotification = @"BBLaunchAdDetailImageUrlNotification";

static BBLaunchAdMonitor *monitor = nil;

@interface BBLaunchAdMonitor()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    
}

//@property (nonatomic, assign) BOOL imgLoaded;
@property (nonatomic, assign) BBLaunchAdProcess process;

@property (nonatomic, strong) NSMutableData *imgData;
@property (nonatomic, strong) NSURLConnection *conn;

@property (nonatomic, strong) NSMutableDictionary *detailParam;

@property (assign ,nonatomic) NSInteger number;
@property (strong ,nonatomic) UILabel *timeLabel;

@end


@implementation BBLaunchAdMonitor

+ (void)showAdAtPath:(NSString *)path onView:(UIView *)container timeInterval:(NSTimeInterval)interval detailParameters:(NSDictionary *)param
{
    if (![self validatePath:path]) {
        return ;
    }
    
    [[self defaultMonitor] loadImageAtPath:path];
    while ((monitor.process != BBLaunchAdProcessFailed) && (monitor.process != BBLaunchAdProcessSuccess) ) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    [monitor.detailParam removeAllObjects];
    [monitor.detailParam addEntriesFromDictionary:param];
    if (monitor.process == BBLaunchAdProcessFailed) {
        return ;
    }
    [self showImageOnView:container forTime:interval];
}

+ (instancetype)defaultMonitor
{
    @synchronized (self) {
        if (!monitor) {
            monitor = [[BBLaunchAdMonitor alloc] init];
            monitor.detailParam = [NSMutableDictionary dictionary];
            monitor.number = 0;
        }
        return monitor;
    }
}

+ (BOOL)validatePath:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path];
    return url != nil;
}

+ (void)showImageOnView:(UIView *)container forTime:(NSTimeInterval)time
{
    CGRect f = [UIScreen mainScreen].bounds;
    NSLog(@"screen size:%@", NSStringFromCGRect(f));
    UIView *v = [[UIView alloc] initWithFrame:f];
    v.backgroundColor = [UIColor whiteColor];
    
//    f.size.height -= 50;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:f];
    iv.image = [UIImage imageWithData:monitor.imgData];
    monitor.conn = nil;
    [monitor.imgData setLength:0];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.userInteractionEnabled = YES;
    [v addSubview:iv];
    
    //手势
    [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    
    [container addSubview:v];
    [container bringSubviewToFront:v];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(f.size.width - 110,30, 40, 30)];
    timeLabel.text = @"5s后";
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    timeLabel.layer.borderWidth = 1.0f;
    timeLabel.layer.cornerRadius = 3.0f;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [v addSubview:timeLabel];
    monitor.timeLabel = timeLabel;
    
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];

    
    
    
    UIButton *showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showDetailBtn setTitle:@"跳过->" forState:UIControlStateNormal];
    [showDetailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showDetailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    showDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    showDetailBtn.frame = CGRectMake(f.size.width - 70, 30, 60, 30);
    showDetailBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    showDetailBtn.layer.borderWidth = 1.0f;
    showDetailBtn.layer.cornerRadius = 3.0f;
    [showDetailBtn addTarget:self action:@selector(showAdDetail:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:showDetailBtn];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, f.size.height + 10, f.size.width - 20, 30)];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"©2015 iXcoder. All Rights Reserved";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:15];
//    [v addSubview:label];
//    label = nil;
    
    [container addSubview:v];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        v.userInteractionEnabled = NO;
        [UIView animateWithDuration:.25
                         animations:^{
                             v.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [v removeFromSuperview];
                         }];
    });
}


+ (void)timePast {
    
    monitor.number ++;
    NSInteger endTime = 5 - monitor.number;
    monitor.timeLabel.text = [NSString stringWithFormat:@"%lds后",endTime];
    
}


+ (void)imageClick:(UITapGestureRecognizer *)tap {
    
    UIView *sup = [(UIButton *)tap.view superview];
//    sup.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25
                     animations:^{
//                         sup.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [sup removeFromSuperview];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:BBLaunchAdDetailImageUrlNotification
                                                                             object:monitor.detailParam];
                         
                         
                         [monitor.detailParam removeAllObjects];
                     }];

    
    
    
}


+ (void)showAdDetail:(id)sender
{
    UIView *sup = [(UIButton *)sender superview];
    sup.userInteractionEnabled = NO;
    [UIView animateWithDuration:.25
                     animations:^{
                         sup.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [sup removeFromSuperview];
//                         [[NSNotificationCenter defaultCenter] postNotificationName:BBLaunchAdDetailDisplayNotification
//                                                                             object:monitor.detailParam];
                         [monitor.detailParam removeAllObjects];
                     }];
    
}

- (void)loadImageAtPath:(NSString *)path
{
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    request = [NSURLRequest requestWithURL:URL cachePolicy:0 timeoutInterval:10.];
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (self.conn) {
        self.process = BBLaunchAdProcessLoading;
        [self.conn start];
    }
}

#pragma mark - NSURLConnectionDataDelegate method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    if (resp.statusCode != 200) {
//        self.imgLoaded = YES;
        self.process = BBLaunchAdProcessFailed;
        return ;
    }
    self.imgData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imgData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    self.imgLoaded = YES;
    self.process = BBLaunchAdProcessSuccess;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"图片数据获取失败");
//    self.imgLoaded = YES;
    self.process = BBLaunchAdProcessFailed;
}




@end

