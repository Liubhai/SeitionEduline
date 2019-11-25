//
//  Good_PersonFaceRegisterViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/12/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_PersonFaceRegisterViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "ZhiyiHTTPRequest.h"

#import "DetectionViewController.h"
#import "NetAccessModel.h"
#import "ImageIOSave.h"

//#import "SuccessResultViewController.h"
//#import "FailResultViewController.h"

@interface Good_PersonFaceRegisterViewController () {
    UIImage *faceImage;
}
@property (strong ,nonatomic)UIImageView      *phoneImageView;
@property (strong ,nonatomic)NSString         *faceID;

@end

@implementation Good_PersonFaceRegisterViewController

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFcae];
    [self addNav];
    [self addScanView];
}

- (void)interFcae {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGoodStr:) name:@"NSNotficaitonFaceType" object:nil];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"人脸绑定";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
}

- (void)addScanView {
    __weak typeof(self) weakSelf = self;
    DetectionViewController* dvc = [[DetectionViewController alloc] init];
    dvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* bestImage = [UIImage imageWithData:data];
            NSLog(@"bestImage = %@",bestImage);
            faceImage = bestImage;
            
            if ([_tryStr integerValue] == 2) {//体验刷脸
                [self backPressed];
            }
            [self addPhotoImageView];
            [self netWorkUserUpLoad];
            NSString* bestImageStr = [[images[@"bestImage"] lastObject] copy];
            
            //检测活动的方法
            [[NetAccessModel sharedInstance] detectUserLivenessWithFaceImageStr:bestImageStr completion:^(NSError *error, id resultObject) {
                if (error == nil) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                    if ([dict[@"result_num"] integerValue] > 0) {
                        NSDictionary* d = dict[@"result"][0];
                        NSLog(@"faceliveness = %f",[d[@"face_probability"] floatValue]);
                        if (d[@"faceliveness"] != nil && [d[@"faceliveness"] floatValue] > 0.834963 ) {
//                            [weakSelf gotoRegister:bestImageStr originImage:originImage];
                        } else {
//                            [weakSelf performSegueWithIdentifier:@"Register2Fail" sender:@{@"image":originImage,@"tip":@"注册人脸非活体",@"subtip":[NSString stringWithFormat:@"活体检测分数:%0.6f",[d[@"faceliveness"] floatValue]],@"kind":@"注册",@"goon":@(0),@"name":@"123456"}];
                        }
                    }
                }
            }];
        }
    };
//    [self presentViewController:dvc animated:YES completion:nil];
    dvc.formStr = @"register";
    if ([_typeStr integerValue] == 1) {//注册
        dvc.formStr = @"1";
    } else if ([_typeStr integerValue] == 2) {//考试
        dvc.formStr = @"2";
    } else if ([_typeStr integerValue] == 3) {//视频
        dvc.formStr = @"3";
    }
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)gotoRegister:(NSString *)bestImageStr originImage:(UIImage *)originImage {
    __weak typeof(self) weakSelf = self;
    [[NetAccessModel sharedInstance] registerFaceWithImageBaseString:bestImageStr userName:@"123456" completion:^(NSError *error, id resultObject) {
        if (error == nil) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
            NSInteger type = 0;
            NSString* tip = @"验证不成功!";
            if (dict[@"error_code"] == nil) {
                NSLog(@"成功了 = %@",dict);
                type = 1;
                tip = @"注册完毕!";

//                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.passwordTextField.text forKey:weakSelf.usernameTextField.text];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 保存下成功之后的图片
                [ImageIOSave writeImage:originImage withName:@"123456"];
            } else {
                NSLog(@"失败了 = %@,%@,%@",dict[@"error_code"],dict[@"error_msg"],dict[@"log_id"]);
            }
            [weakSelf performSegueWithIdentifier:@"Register2Success" sender:@{@"image":originImage,@"tip":tip,@"type":@(type),@"goon":@(1),@"name":@"123456"}];
        }
    }];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSDictionary *)sender {
//    if ([segue.identifier isEqualToString:@"Register2Success"]) {
//        SuccessResultViewController* svc = segue.destinationViewController;
//        svc.dict = sender;
//    } else {
//        FailResultViewController *fvc = segue.destinationViewController;
//        fvc.dict = sender;
//    }
//}



#pragma mark --- 事件处理
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---- 通知
- (void)getGoodStr:(NSNotification *)not {

    NSString *goodStr = (NSString *)not.object;
    if ([goodStr isEqualToString:@"good"]) {
//        [TKProgressHUD showMessag:@"绑定中...." toView:self.view];
        //添加图片视图
        [self addPhotoImageView];
    }
}

#pragma mark --- 添加图片视图 （）
- (void)addPhotoImageView {
    _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 200 * WideEachUnit, 200 * WideEachUnit)];
    _phoneImageView.center = self.view.center;
    _phoneImageView.backgroundColor = [UIColor whiteColor];
    _phoneImageView.image = faceImage;
    [self.view addSubview:_phoneImageView];
}
#pragma mark --- 网络请求 (人脸识别的图片上传的接口)
//获得图片的ID
- (void)netWorkUserUpLoad {
    
    NSString *endUrlStr = YunKeTang_Attach_attach_upload;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSString *encryptStr1 = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [requestSerializer setValue:encryptStr1 forHTTPHeaderField:HeaderKey];
    [requestSerializer setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    manger.requestSerializer = requestSerializer;
    
    [manger POST:allUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *dataImg=UIImageJPEGRepresentation(faceImage, 1.0);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            _faceID = [dict stringValueForKey:@"attach_id"];
            [self NetWorkYouTuCreatePerson];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//创建人脸
- (void)NetWorkYouTuCreatePerson {
    
    NSString *endUrlStr = YunKeTang_YouTu_youtu_createPerson;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *oath_token_Str = nil;
    if (_tokenAndTokenSerectDict != nil) {//说明是从登录界面过来创建人脸的
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",[_tokenAndTokenSerectDict stringValueForKey:@"oauth_token"],[_tokenAndTokenSerectDict stringValueForKey:@"oauth_token_secret"]];
    } else {//直接添加人脸的（从绑定进入）
            oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    [mutabDict setObject:_faceID forKey:@"attach_id"];
    

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:@"创建成功" toView:self.view];
            //创建通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterFaceLoginOrRegister" object:@"100"];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        //推迟一秒退出
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self backPressed];
        });
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//添加更多的人脸
- (void)NetWorkAddFace {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:@"" forKey:@"attach_ids"];
    // mod:@"Youtu" act:@"addFace"
    [manager BigWinCar_GetPublicWay:dic mod:@"face" act:@"add" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"person_id"] != nil) {
                [TKProgressHUD showError:@"创建成功" toView:self.view];
            }
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
//        [TKProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self backPressed];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




@end
