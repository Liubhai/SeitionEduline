//
//  emotionViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/7.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "emotionViewController.h"
#import <UIKit/UIKit.h>
#import "emotionjiexi.h"
#import "SYG.h"
@interface emotionViewController ()
@property (strong ,nonatomic)NSArray *emotionarr;
-(void)initwithinterface;
@end

@implementation emotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initwithinterface];
}
-(void)initwithinterface{
    self.view.backgroundColor=[UIColor whiteColor];
    _emotionarr=[NSArray array];
    _emotionarr=@[@"aoman.png",@"baiyan.png",@"bishi.png",@"bizui.png",@"cahan",@"caidao",@"chajin",@"cheer",@"chong",@"ciya",@"da",@"dabian",@"dabing",@"dajiao",@"daku",@"dangao",@"danu",@"dao",@"deyi",@"diaoxie",@"e",@"fadai",@"fadou",@"fan",@"fanu",@"feiwen",@"fendou",@"gangga",@"gouyin",@"guzhang",@"haha",@"haixiu",@"haqian",@"hua",@"huaixiao",@"hufen",@"huishou",@"huitou",@"jidong",@"jingkong",@"jingya",@"kafei",@"keai",@"kelian",@"ketou",@"kiss",@"ku",@"kuaikule",@"kulou",@"kun",@"lanqiu",@"lenghan",@"liuhan",@"liulei",@"liwu",@"love",@"ma",@"nanguo",@"no",@"ok",@"peifu",@"pijiu",@"pingpang",@"pizui",@"qiang",@"qinqin",@"qioudale",@"qiu",@"quantou",@"ruo",@"se",@"shandian",@"shengli",@"shenma",@"shuai",@"shuijiao",@"taiyang",@"tiao",@"tiaopi",@"tiaosheng",@"tiaowu",@"touxiao",@"tu",@"tuzi",@"wabi",@"weiqu",@"weixiao",@"wen",@"woshou",@"xia",@"xianwen",@"xigua",@"xinsui",@"xu",@"yinxian",@"yongbao",@"youhengheng",@"youtaiji",@"yueliang",@"yun",@"zaijian",@"zhadan",@"zhemo",@"zhuakuang",@"zhuanquan",@"zhutou",@"zuohengheng",@"zuotaiji",@"zuqiu"];

}

-(void)gethigh:(NSMutableAttributedString*)string{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin context:nil];
    UILabel *label;
    label.attributedText=[emotionjiexi jiexienmojconent:label.text font:[UIFont boldSystemFontOfSize:16]];
}

@end
