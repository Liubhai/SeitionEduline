//
//  PublishTopicViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/19.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "PublishTopicViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"


#import "photoImageView.h"
#import "TKProgressHUD+Add.h"
#import "ZhiyiHTTPRequest.h"
#import "TKProgressHUD+Add.h"




@interface PublishTopicViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
//    PlaceholderTextView *view1;
//    PlaceholderTextView * view2;
    UIImage *image;
}

@property (strong ,nonatomic)UITextField *SYGTextField;

@property (strong ,nonatomic)photoImageView *photosView;

@property (strong ,nonatomic)NSMutableArray *imageArray;

@property (strong ,nonatomic)NSMutableArray *imageIDArray;
@property (strong ,nonatomic)NSString *imageID;
@property (strong ,nonatomic)NSString *imageAllID;

@end

@implementation PublishTopicViewController

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
    [self interFace];
    [self addNav];
//    [self addInfoView];
//    [self addTableView];
//    [self addDownView];
    [self addMoreView];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    _imageArray = [NSMutableArray array];
    _imageIDArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textView:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"发贴";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加分类的按钮
    UIButton *SortButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 30, 60, 30)];
    [SortButton setTitle:@"发表" forState:UIControlStateNormal];
    [SortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SortButton addTarget:self action:@selector(SortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SortButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

    
    
}

- (void)addMoreView {
    
    _SYGTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, MainScreenWidth, 40)];
    _SYGTextField.placeholder = @"标题（必填）";
    _SYGTextField.font = [UIFont systemFontOfSize:17];
    _SYGTextField.layer.borderWidth = 0.1;
    _SYGTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    _SYGTextField.leftViewMode = UITextFieldViewModeAlways;
    _SYGTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _SYGTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_SYGTextField];
    [_SYGTextField becomeFirstResponder];
    //    [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    [_SYGTextField setValue:[UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
 
//    if (iPhone5o5Co5S) {
//        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 121, MainScreenWidth, 240)];
//    }
//
//    else if(iPhone4SOriPhone4)
//    {
//        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 121, MainScreenWidth, 130)];
//    }
//
//
//    else if(iPhone6)
//    {
//        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 121, MainScreenWidth, 270)];
//    }
//    else if(iPhone6Plus)
//    {
//        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 121, MainScreenWidth, 340)];
//    }
    
//    view2.placeholder=@"写点什么吧....";
//    view2.delegate = self;
//    view2.font=[UIFont systemFontOfSize:17];
//    [view2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    view2.placeholderFont=[UIFont systemFontOfSize:13];
//    view2.layer.borderWidth=0.3;
//    view2.returnKeyType = UIReturnKeyDone;
//    view2.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    [self.view addSubview:view2];
//    [view2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    view2.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    
//    //添加展示图片的View 并开始的时候 隐藏
//    _photosView = [[photoImageView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 100)];
//    _photosView.backgroundColor = [UIColor whiteColor];
//    if (iPhone5o5Co5S) {
//        _photosView.frame = CGRectMake(0, 100, MainScreenWidth, 80);
//    } else if (iPhone6) {
//         _photosView.frame = CGRectMake(0, 110, MainScreenWidth, 80);
//    } else if (iPhone6Plus) {
//         _photosView.frame = CGRectMake(0, 150, MainScreenWidth, 80);
//    }
//    _photosView.hidden = YES;
//    _photosView.Num = 4;
//    _photosView.userInteractionEnabled = YES;
//    [view2 addSubview:_photosView];
//
//    //添加
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(view2.frame) - 60 - 120, 50, 50)];
//    if (iPhone5o5Co5S) {
//        addButton.frame = CGRectMake(5, CGRectGetMaxY(view2.frame) - 55 - 120, 50, 50);
//    }
//    [addButton setBackgroundImage:Image(@"选择图片") forState:UIControlStateNormal];
//
//    [addButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
//    [view2 addSubview:addButton];

}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)SortButtonClick {
    
//    if (_SYGTextField.text.length == 0 || view2.text.length == 0) {
//        
//        [TKProgressHUD showError:@"请输入标题或者内容" toView:self.view];
//        return;
//    } else if (view2.text.length < 10) {
//        [TKProgressHUD showSuccess:@"请输入内容超过10个字" toView:self.view];
//        return;
//    }
    
    if (image != nil) {
//        [self netWorkImageID];
    }
    [self getImageIDStr];
    [self netWorkPublish];
    
}

- (void)getImageIDStr {
    if (_imageIDArray.count) {
        for (int i = 0 ; i < _imageIDArray.count ; i++) {
            if (i == 0) {
                _imageAllID = _imageIDArray[0];
            } else {
                _imageAllID = [NSString stringWithFormat:@"%@,%@",_imageAllID,_imageIDArray[i]];
            }
        }
    }
}

- (void)addImage {
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];

    
}

#pragma mark --- 相册相机代理

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//进入相册
        //创建图片选取控制器
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
        
        
    }else if (buttonIndex == 1){//相机拍照
        
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
        
    }
}

//回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [self.photosView addImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    _photosView.hidden = NO;
    [self netWorkImageID];
}

#pragma mark --- 网络请求
- (void)netWorkPublish {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_IDString forKey:@"group_id"];
    [dic setValue:_SYGTextField.text forKey:@"title"];
//    [dic setValue:view2.text forKey:@"content"];
    if (_imageID != nil) {
        [dic setValue:_imageID forKey:@"attach"];
    }
    NSLog(@"%@",dic);
    [manager BigWinCar_groupAddTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [TKProgressHUD showSuccess:@"发布成功" toView:self.view];
            [self backPressed];
        } else {
            [TKProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

//获得文件的ID
- (void)netWorkImageID {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    NSString *url1 = @"app=api&mod=Exam&act=addAttach";
    NSString *url2 = [NSString stringWithFormat:@"%@%@",basidUrl,url1];
    
    [manager POST:url2 parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传图片
        //        NSArray *images = [self.photosView totalImages];
        
        //        if (images.count != 0) {
        //            for (UIImage *imgae in images) {
        //                NSData *dataImg=UIImageJPEGRepresentation(imgae, 0.5);
        //                [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        //            }
        //        }
        
        NSData *dataImg=UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInteger:1]]) {
            //            [_imageIDArray addObject:responseObject[@"data"][0]];
            //            NSLog(@"%@",_imageIDArray);
            
            _imageID = responseObject[@"data"][0];
            [_imageIDArray addObject:_imageID];
            NSLog(@"%@",_imageID);
        } else {
            [TKProgressHUD showError:@"上传失败" toView:self.view];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [TKProgressHUD showError:@"上传图片失败" toView:self.view];
    }];
}


#pragma mark --- 通知

- (void)textField:(NSNotification *)Not {
    if (_SYGTextField.text.length > 20) {
        [TKProgressHUD showError:@"标题不能超过15个字" toView:self.view];
        _SYGTextField.text = [_SYGTextField.text substringToIndex:20];
    }
    
}

- (void)textView:(NSNotification *)Not {
//    if (view2.text.length > 100) {
//        [TKProgressHUD showError:@"内容不能过长" toView:self.view];
//        view2.text = [view2.text substringToIndex:100];
//    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//键盘消失
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
