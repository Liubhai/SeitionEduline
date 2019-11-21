//
//  GBActivityDetailWebVC.h
//  ThinkSNS（探索版）
//
//  Created by 刘邦海 on 2017/11/6.
//  Copyright © 2017年 zhiyicx. All rights reserved.
//

#import "BaseViewController.h"
#import "TeacherMainViewController.h"

@interface GBActivityDetailWebVC : BaseViewController<UIWebViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) NSDictionary *infoDict;
@property (strong, nonatomic) NSString *type;//详情页底部是否有控件，处理高度
@property (assign, nonatomic) CGFloat tabelHeight;
@property (strong, nonatomic) TeacherMainViewController *vc;
@property (assign, nonatomic) BOOL cellTabelCanScroll;
-(instancetype)initWithNumID:(NSString *)ID;

@end
