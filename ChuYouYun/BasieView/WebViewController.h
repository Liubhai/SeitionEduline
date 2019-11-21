//
//  WebViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/6/26.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *titleString;

@end
