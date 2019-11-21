//
//  TeacherArticleViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherArticleViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"


@interface TeacherArticleViewController ()

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSArray  *artliceArray;

@end

@implementation TeacherArticleViewController

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
    [self netWorkArticle];
}


- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addArtileView {
    
    NSInteger tempNum = _artliceArray.count;
    for (int i =0; i<tempNum; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 + 70 * i, 60, 60)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_artliceArray[i][@"image"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
        [self.view addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(80, 70 + 70 * i, MainScreenWidth - 100, 20)];
        title.font = [UIFont systemFontOfSize:17];
        title.textColor = [UIColor blackColor];
        title.text = [NSString stringWithFormat:@"%@",_artliceArray[i][@"art_title"]];
        title.numberOfLines = 2;
        [self.view  addSubview:title];
        
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(80, 100 + 70 * i, MainScreenWidth - 100, 20)];
        time.text = [NSString stringWithFormat:@"%@",_artliceArray[i][@"art_title"]];
        NSString *starTime = [Passport formatterDate:_artliceArray[i][@"ctime"]];
        time.text = [NSString stringWithFormat:@"%@",starTime];
        time.font = Font(14);
        time.textColor = [UIColor grayColor];
        [self.view  addSubview:time];
    }
    
    
    if (_artliceArray.count == 0) {
        //添加空白提示
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
        imageView.image = Image(@"云课堂_空数据 （小）");
        imageView.center = CGPointMake(MainScreenWidth / 2 , 300);
        if (iPhone6) {
            imageView.center = CGPointMake(MainScreenWidth / 2 , 220);
        } else if (iPhone6Plus) {
            imageView.center = CGPointMake(MainScreenWidth / 2 , 280);
        } else if (iPhone5o5Co5S) {
            imageView.center = CGPointMake(MainScreenWidth / 2 , 190);
        }
        [self.view addSubview:imageView];
    }
    
}


#pragma mark --- 获取文章的数据
-(void)netWorkArticle {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:_ID forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getArticleList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _artliceArray = responseObject[@"data"];
        }
        [self addArtileView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self addArtileView];
    }];
}



@end
