//
//  Good_QuesAndAnsPublishViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/25.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndAnsPublishViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

@interface Good_QuesAndAnsPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate> {
        UIImage *image;
}

@property (strong ,nonatomic)UITextField    *textField;
@property (strong ,nonatomic)UITextView     *textView;
@property (strong ,nonatomic)UILabel        *hintLabel;
@property (strong ,nonatomic)UIView         *photoView;
@property (strong ,nonatomic)UIView         *downView;
@property (strong ,nonatomic)UITableView    *cateTableView;

@property (strong ,nonatomic)NSMutableArray *imagesArray;
@property (strong ,nonatomic)NSMutableArray *imageIDArray;
@property (strong ,nonatomic)NSArray        *dataArray;
@property (strong ,nonatomic)NSDictionary   *currentCateDict;
@property (strong ,nonatomic)NSDictionary   *publishDict;
@property (strong ,nonatomic)NSString       *allImageIDStr;

@end

@implementation Good_QuesAndAnsPublishViewController

-(UITableView *)cateTableView {
    if (!_cateTableView) {
        _cateTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 125, MainScreenWidth - 20, _dataArray.count * 40 * WideEachUnit) style:UITableViewStyleGrouped];
        _cateTableView.delegate = self;
        _cateTableView.dataSource = self;
        _cateTableView.rowHeight = 40 * WideEachUnit;
        _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cateTableView.backgroundColor = [UIColor colorWithHexString:@"#f9fbfb"];
        if (currentIOS >= 11.0) {
            Passport *ps = [[Passport alloc] init];
            [ps adapterOfIOS11With:_cateTableView withHight:0];
        }
    }
    return _cateTableView;
}

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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"发布问题";
    _rightButton.hidden = NO;
    [_rightButton setTitle:@"发布" forState:0];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
    [self addOtherView];
    [self addImageView];
    [self addDownView];
}

- (void)rightButtonClick:(id)sender {
    [self publishButtonCilck];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _imagesArray = [NSMutableArray array];
    _imageIDArray = [NSMutableArray array];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewText:) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
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
    WZLabel.text = @"发布问题";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [publishButton setTitle:@"发布" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:publishButton];
    
}


#pragma mark --- 添加视图
- (void)addOtherView {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 * WideEachUnit, MACRO_UI_UPHEIGHT + 16, MainScreenWidth - 30 * WideEachUnit, 40 * WideEachUnit)];
    textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField];
    textField.font = Font(14);
    textField.textColor = [UIColor colorWithHexString:@"#888"];
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    textField.placeholder = @"请选择分类";
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [textField.leftView addSubview:button];
    
    
    textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView.backgroundColor = [UIColor whiteColor];
    UIButton *rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
    [rightbutton setImage:Image(@"icon_dropdown@3x") forState:UIControlStateNormal];
    [textField.rightView addSubview:rightbutton];
    textField.delegate = self;
    [rightbutton addTarget:self action:@selector(rightButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    _textField = textField;
    
    
    //添加透明的按钮
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _textField.frame.size.width, _textField.frame.size.height)];
    clearButton.backgroundColor = [UIColor clearColor];
    [clearButton addTarget:self action:@selector(rightButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_textField addSubview:clearButton];
    
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, _textField.bottom + 1, MainScreenWidth - 30 * WideEachUnit, 1)];
    lineButton.backgroundColor = BasidColor;
    [self.view addSubview:lineButton];
    
    //添加输入框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_textField.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 300 * WideEachUnit)];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    
    
    //添加提示文本
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 5 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, 20 * WideEachUnit)];
    _hintLabel.text = @"请输入您的问题";
    _hintLabel.textColor = [UIColor colorWithHexString:@"#c4cccc"];
    _hintLabel.font = Font(16 * WideEachUnit);
    [_textView addSubview:_hintLabel];
    
    
    //添加图片
    
    UIButton *addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 100 * WideEachUnit, 80 * WideEachUnit, 80 * WideEachUnit)];
    [addImageButton setImage:Image(@"add_hao") forState:UIControlStateNormal];
    addImageButton.layer.borderWidth = 1;
    addImageButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    addImageButton.titleLabel.font = Font(23);
    addImageButton.backgroundColor = [UIColor whiteColor];
    [addImageButton addTarget:self action:@selector(addImageButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:addImageButton];
}


- (void)addImageView {
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, MainScreenWidth, 80 * WideEachUnit)];
    _photoView.backgroundColor = [UIColor whiteColor];
    [_textView addSubview:_photoView];
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 40 *     WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    UIButton *pictureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit, 1, 40 * WideEachUnit, 36 * WideEachUnit)];
    [pictureButton setImage:Image(@"icon_picture@3x") forState:UIControlStateNormal];
    [_downView addSubview:pictureButton];
    pictureButton.hidden = YES;
    
    //键盘按钮
    UIButton *kyobrdButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 1, 40 * WideEachUnit, 38 * WideEachUnit)];
    [kyobrdButton setImage:Image(@"icon_picture@3x") forState:UIControlStateNormal];
    [_downView addSubview:kyobrdButton];
    kyobrdButton.hidden = YES;
    
    //添加线
//    UIButton *lineButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 5 , MainScreenWidth, 1)];
//    [lineButton1 setImage:Image(@"icon_picture@3x") forState:UIControlStateNormal];
//    [_downView addSubview:lineButton1];
//
//    UIButton *lineButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 39 * WideEachUnit, 40 * WideEachUnit, 1)];
//    [lineButton2 setImage:Image(@"icon_picture@3x") forState:UIControlStateNormal];
//    [_downView addSubview:lineButton2];
}

- (void)addTableView {
//    _cateTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 125, MainScreenWidth - 20, _dataArray.count * 40 * WideEachUnit) style:UITableViewStyleGrouped];
//    _cateTableView.delegate = self;
//    _cateTableView.dataSource = self;
//    _cateTableView.rowHeight = 40 * WideEachUnit;
//    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _cateTableView.backgroundColor = [UIColor colorWithHexString:@"#f9fbfb"];
//    if (currentIOS >= 11.0) {
//        Passport *ps = [[Passport alloc] init];
//        [ps adapterOfIOS11With:_cateTableView withHight:0];
//    }
    [self.view addSubview:self.cateTableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellStr = @"WDTableViewCell";
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#f9fbfb"];
    cell.textLabel.font = Font(14);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#888"];
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_cateTableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentCateDict = [_dataArray objectAtIndex:indexPath.row];
    [_cateTableView removeFromSuperview];
    _textField.text = [_currentCateDict stringValueForKey:@"title"];
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addImageButtonCilck {
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];
}

//- (void)buttonCilck:(UIButton *)button {
//    if (button.tag == 0) {//图片
//        NSLog(@"图片");
//
//    }
//}

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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    //    [_headerImageButton setBackgroundImage:image forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    [_imagesArray addObject:image];
    [self addPhoto];
    [self netWorkUserUpLoad];
}


- (void)addPhoto {
    CGFloat imageViewH = 60 * WideEachUnit;
    CGFloat imageViewW = 60 * WideEachUnit;
    for (int i = 0 ; i < _imagesArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit + (imageViewW + 10 * WideEachUnit) * i, 10 * WideEachUnit, imageViewW, imageViewH)];
        imageView.image = _imagesArray[i];
        [_photoView addSubview:imageView];
        
    }
}




#pragma mark ---- 点击事件

- (void)publishButtonCilck {
    [self netWorkWendaRelease];
}

- (void)rightButtonCilck {
    [self netWorkWendaGetCategory];
}

#pragma mark --- TextFiledDelegate (设置为不可编辑)
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark --- 通知
- (void)textViewText:(NSNotification *)not {
    if (_textView.text.length > 0) {
        _hintLabel.hidden = YES;
    } else {
        _hintLabel.hidden = NO;
    }
}

- (void)KeyboardHide:(NSNotification *)not {
    _downView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 40 * WideEachUnit);
}

- (void)KeyboardShow:(NSNotification *)not {
//    _downView.frame = CGRectMake(0, 300, MainScreenWidth, 40 * WideEachUnit);
//    NSDictionary *dict = not.userInfo;
    CGFloat keyBoardHeight = 330;
    _downView.frame = CGRectMake(0, MainScreenHeight - keyBoardHeight, MainScreenWidth, 40 * WideEachUnit);
}

#pragma mark ---

- (void)getImageIDStr {
    for (int i = 0; i < _imageIDArray.count ; i ++) {
        if (i == 0) {
            _allImageIDStr = _imageIDArray[0];
        } else {
            _allImageIDStr = [NSString stringWithFormat:@"%@,%@",_allImageIDStr,_imageIDArray[i]];
        }
    }
}

//首页推荐机构的数据
- (void)netWorkWendaGetCategory {
    
    NSString *endUrlStr = YunKeTang_WenDa_wenda_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if (_dataArray.count == 0) {
                [TKProgressHUD showError:@"没有问答分类" toView:self.view];
            } else {
                [self addTableView];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }

        [_cateTableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//发布问答
- (void)netWorkWendaRelease{
    [self getImageIDStr];
    
    NSString *endUrlStr = YunKeTang_WenDa_wenda_release;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    if (UserOathToken == nil) {
        [TKProgressHUD showError:@"请先登录" toView:self.view];
        return;
    }
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_currentCateDict == nil) {
        [TKProgressHUD showError:@"请选择类型" toView:self.view];
        return;
    } else {
        [mutabDict setObject:[_currentCateDict stringValueForKey:@"zy_wenda_category_id"] forKey:@"typeid"];//问答的类型
    }
    if (self.textView.text.length == 0) {
        [TKProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    } else {
        [mutabDict setObject:self.textView.text forKey:@"content"];
    }
    if (_allImageIDStr == nil) {
        
    } else {
         [mutabDict setObject:_allImageIDStr forKey:@"attr"];
    }
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {//发布成功
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self backPressed];
            });
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

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
        
        NSData *dataImg=UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            NSString *imageID = [dict stringValueForKey:@"attach_id"];
            [_imageIDArray addObject:imageID];
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        NSLog(@"---%@",dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}




@end
