//
//  GreatViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GreatViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"

#import "TKProgressHUD+Add.h"
#import "DLViewController.h"

@interface GreatViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate>

{
    UIImage *image;
    BOOL isSeled;
}

@property (strong ,nonatomic)UIScrollView *scrollView;

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UITableView *cityTableView;

@property (strong ,nonatomic)NSArray *cityDataArray;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UITextField *classField;

@property (strong ,nonatomic)UITextField *nameField;

@property (strong ,nonatomic)NSString *ID;

@property (strong ,nonatomic)UITextView *textIntro;

@property (strong ,nonatomic)UITextView *textGG;

@property (strong ,nonatomic)NSString *imageID;

@property (strong ,nonatomic)UILabel  *choose;


@end

@implementation GreatViewController

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
    [self addScrollView];
    [self addMoreView];
    [self addIntoView];
    [self addPulikView];
    [self addButtonView];
//    [self addTableView];
    //    [self NetWork];
//    [self netWork];
//    [self netWorkCate];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];

    isSeled = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardCome:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"创建小组";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 100);
    if (iPhone5o5Co5S) {
        _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 200);
    }
    [self.view addSubview:_scrollView];
    
}
- (void)addMoreView {
    
    
    for (int i = 0; i < 2; i ++) {
        
        UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(SpaceBaside,  2 * SpaceBaside + (SpaceBaside + SpaceBaside + 40) * i , MainScreenWidth - 2 * SpaceBaside, 40)];
        textFied.layer.borderWidth = 1;
        
        textFied.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        textFied.layer.cornerRadius = 5;
        
        textFied.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        textFied.leftViewMode = UITextFieldViewModeAlways;
        
        textFied.rightView = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth - 100, 0, 100, 40)];
        textFied.rightViewMode = UITextFieldViewModeAlways;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.font = Font(16);
        label.textAlignment = NSTextAlignmentCenter;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        
        button.titleLabel.font = Font(14);
        button.tag = i;
        
        if ( i == 0) {
            
            label.text = @"小组名称:";
            
             [button setTitle:@"设为私密" forState:UIControlStateNormal];
            
            [button setImage:Image(@"radionbutton") forState:UIControlStateNormal];
            [button setImage:Image(@"radiobutton_sel") forState:UIControlStateSelected];
//            button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,60);
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            button.backgroundColor = [UIColor clearColor];
            
            _nameField = textFied;
 
        } else {
            label.text = @"分类:";
             [button setTitle:@"" forState:UIControlStateNormal];
            [button setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            
            textFied.font = Font(15);
            textFied.textColor = BasidColor;
            _classField = textFied;
            
            
            UILabel *choose = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, _classField.frame.size.width - 140, _classField.frame.size.height)];
            choose.backgroundColor = [UIColor whiteColor];
            [_classField addSubview:choose];
            choose.text = @"请选择";
            choose.font = Font(15);
            choose.textColor = BasidColor;
            _choose = choose;
          
        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
         [textFied.leftView addSubview:label];
        [textFied.rightView addSubview:button];
        
        [_scrollView addSubview:textFied];
        
        
    }
    
    
    //添加封面试图
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 140, MainScreenWidth - 20, 170)];
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.layer.borderWidth = 1;
    coverView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    coverView.layer.cornerRadius = 5;
    [_scrollView addSubview:coverView];
    
    
    //添加文版
    UILabel *FMLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside, 50, 30)];
    FMLabel.font = Font(14);
    FMLabel.text = @"封面:";
    FMLabel.textAlignment = NSTextAlignmentCenter;
    [coverView addSubview:FMLabel];
    
    //图片
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 20, 120, 120)];
    [coverView addSubview:imageButton];
    _imageButton = imageButton;
    
    //添加添加按钮
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 20 - 70, 10, 50, 50)];
    [addButton setBackgroundImage:Image(@"选择图片") forState:UIControlStateNormal];
    [coverView addSubview:addButton];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}


- (void)addIntoView {
    //添加封面试图
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 330, MainScreenWidth - 20, 100)];
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.layer.borderWidth = 1;
    coverView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    coverView.layer.cornerRadius = 5;
    [_scrollView addSubview:coverView];
    
    
    //添加文版
    UILabel *FMLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside, 50, 30)];
    FMLabel.font = Font(14);
    FMLabel.text = @"简介:";
    FMLabel.textAlignment = NSTextAlignmentCenter;
    [coverView addSubview:FMLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, SpaceBaside, MainScreenWidth - 100, 80)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    [coverView addSubview:textView];
    _textIntro = textView;

    
}

- (void)addPulikView {
    //添加封面试图
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 440, MainScreenWidth - 20, 100)];
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.layer.borderWidth = 1;
    coverView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    coverView.layer.cornerRadius = 5;
    [_scrollView addSubview:coverView];
    
    
    //添加文版
    UILabel *FMLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside, 50, 30)];
    FMLabel.font = Font(14);
    FMLabel.text = @"公告:";
    FMLabel.textAlignment = NSTextAlignmentCenter;
    [coverView addSubview:FMLabel];
    
    //添加textView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, SpaceBaside, MainScreenWidth - 100, 80)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    [coverView addSubview:textView];
    _textGG = textView;
    
    
}

- (void)addButtonView {
    
    UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(SpaceBaside, 560, MainScreenWidth - 20, 50)];
    [button setTitle:@"创建小组" forState:UIControlStateNormal];
    button.backgroundColor = BasidColor;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    
}

- (void)addTitleView {
    
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    allButton.backgroundColor = [UIColor clearColor];
    [allButton addTarget:self action:@selector(allButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allButton];
    _allButton = allButton;
    
    
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 185, MainScreenWidth - 100, (_cateArray.count) * 50) style:UITableViewStylePlain];
    _cityTableView.rowHeight = 50;
    _cityTableView.delegate = self;
    _cityTableView.dataSource = self;
    _cityTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_cityTableView];

}

#pragma mark ---- 表格试图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cateArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _cateArray[indexPath.row][@"title"];
    cell.textLabel.textColor = BasidColor;
    cell.textLabel.font = Font(14);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_cityTableView deselectRowAtIndexPath:indexPath animated:YES];
    _choose.text = _cateArray[indexPath.row][@"title"];
    
    _ID = _cateArray[indexPath.row][@"id"];
    [self allButtonCilck];
    
}

#pragma mark --- 滚动试图
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}


#pragma mark --- 时间监听

- (void)buttonClick:(UIButton *)button {
    if (button.tag == 0) {

        button.selected = !isSeled;
        isSeled = !isSeled;
        
    } else {
        
        [self addTitleView];
        
    }
}

- (void)addButtonClick {
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];
}

- (void)addButtonPressed {
    
    [self netWork];
    
}

- (void)allButtonCilck {
    [_allButton removeFromSuperview];
    [_cityTableView removeFromSuperview];
}


#pragma mark --- 

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
    [_imageButton setBackgroundImage:image forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self netWorkImageID];
}

#pragma mark --- 键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}

#pragma mark --- 网络请求

- (void)netWork {

    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if (_nameField.text.length > 0) {
         [dic setValue:_nameField.text forKey:@"name"];
    } else {
        [TKProgressHUD showError:@"请填写小组名称" toView:self.view];
        return;
    }
    
    if (_imageID) {
         [dic setValue:_imageID forKey:@"group_logo"];
    } else {
        [TKProgressHUD showError:@"请上传小组封面" toView:self.view];
        return;
    }
    if (_ID) {
        [dic setValue:_ID forKey:@"cate_id"];
    } else {
        [TKProgressHUD showError:@"请选择小组类型" toView:self.view];
        return;
    }
    
    if (isSeled) {
        [dic setValue:@"open" forKey:@"type"];
    } else {
        [dic setValue:@"close" forKey:@"type"];
    }

    if (_textIntro.text.length > 0) {
        [dic setValue:_textIntro.text forKey:@"intro"];
    } else {
        [TKProgressHUD showError:@"请填写小组简介" toView:self.view];
        return;
    }
    if (_textGG.text.length > 0) {
        [dic setValue:_textGG.text forKey:@"announce"];
    } else {
        [TKProgressHUD showError:@"请填写小组公告" toView:self.view];
        return;
    }
    [manager BigWinCar_CreateGroup:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];

         if ([responseObject[@"code"]  integerValue] == 1) {
             [TKProgressHUD showMessag:@"创建成功" toView:self.view];
             [self.navigationController popViewControllerAnimated:YES];
         } else {
             [TKProgressHUD showError:msg toView:self.view];
         }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [TKProgressHUD showError:@"创建小组失败" toView:self.view];
    }];
}


- (void)netWorkImageID {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",basidUrl,@"app=api&mod=Exam&act=addAttach"];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"data"]);
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInteger:1]]) {
//            [_imageIDArray addObject:responseObject[@"data"][0]];
//            NSLog(@"%@",_imageIDArray);
            
            _imageID = responseObject[@"data"][0];
            NSLog(@"%@",_imageID);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [TKProgressHUD showError:@"上传失败" toView:self.view];
    }];
}


//键盘弹起
- (void)keyboardCome:(NSNotification *)Not {
    
    //    NSLog(@"%@",isUp);
    NSLog(@"%@",Not.userInfo);
//    if (_textIntro.selectable == YES) {
//        [_scrollView setContentOffset:CGPointMake(0,300) animated:YES];
//    } else if (_textGG.selectable == YES) {
//        [_scrollView setContentOffset:CGPointMake(0,400) animated:YES];
//    }
//    [_scrollView setContentOffset:CGPointMake(0,100) animated:YES];
     [_scrollView setContentOffset:CGPointMake(0,400) animated:YES];
    
}

//键盘下去
- (void)keyboardHide:(NSNotification *)Not {
    [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
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
