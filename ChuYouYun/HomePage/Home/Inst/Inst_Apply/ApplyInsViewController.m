//
//  ApplyInsViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/2.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//  申请机构

#import "ApplyInsViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "ZhiyiHTTPRequest.h"
#import "TKProgressHUD+Add.h"
#import "PhotosView.h"
#import "SubjectView.h"
#import "Good_AddBankProvinceViewController.h"

@interface ApplyInsViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIImage *image;
}

@property (strong ,nonatomic)UIScrollView *scrollView;

@property (strong ,nonatomic)UITextField *textField0;
@property (strong ,nonatomic)UITextField *textField1;
@property (strong ,nonatomic)UITextField *textField2;
@property (strong ,nonatomic)UITextField *textField3;
@property (strong ,nonatomic)UITextField *textField4;
@property (strong ,nonatomic)UITextField *textField5;
@property (strong ,nonatomic)UITextField *textField6;
@property (strong ,nonatomic)UITextField *textField7;
@property (strong ,nonatomic)UITextField *textField8;
@property (strong ,nonatomic)UITextView  *textView8;
@property (strong ,nonatomic)UITextField *textField9;
@property (strong ,nonatomic)UITextField *textField10;
@property (strong ,nonatomic)UILabel     *cateLabel;

@property (strong ,nonatomic)UIButton    *logoButton;
@property (strong ,nonatomic)UIButton    *imageButton;
@property (assign ,nonatomic)NSInteger   buttonType;

@property (strong ,nonatomic)UIImageView *logoImageView;
@property (strong ,nonatomic)UIImageView *imageImageView;
@property (strong ,nonatomic)UIScrollView *imageScrollView;
@property (strong ,nonatomic)UIImageView  *idCardImageView;

@property (strong ,nonatomic)NSMutableArray *imageArray;
@property (strong ,nonatomic)NSMutableArray *imageIDArray;
@property (strong ,nonatomic)UIButton    *applyButton;

@property (strong ,nonatomic)NSString    *logoImageID;
@property (strong ,nonatomic)NSString    *imageImageID;
@property (strong ,nonatomic)NSString    *cateID;
@property (strong ,nonatomic)NSString    *adjunctID;//附件id
@property (strong ,nonatomic)NSMutableArray *adjunctArray;//附件的数组
@property (strong ,nonatomic)NSString    *identityID;
@property (strong ,nonatomic)NSMutableArray *idCardImageArray;
@property (strong ,nonatomic)NSMutableArray *idCardIDArray;

@property (strong ,nonatomic)NSDictionary *proVinceDict;
@property (strong ,nonatomic)NSDictionary *cityDict;
@property (strong ,nonatomic)NSDictionary *countyDict;
@property (strong ,nonatomic)NSString     *proVinceID;
@property (strong ,nonatomic)NSString     *cityID;
@property (strong ,nonatomic)NSString     *countyID;

@end

@implementation ApplyInsViewController

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
    [self addNSNotification];
    [self interFace];
    [self addNav];
    [self addScrollView];
    [self addInfoView];
}

- (void)addNSNotification {
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCateInfo:) name:@"SearchCateInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textView:) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArray = [NSMutableArray array];
    _imageIDArray = [NSMutableArray array];
    _adjunctArray = [NSMutableArray array];
    _idCardImageArray = [NSMutableArray array];
    _idCardIDArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProvince:) name:@"NSNotificationGood_Province" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCity:) name:@"NSNotificationGood_City" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCounty:) name:@"NSNotificationGood_County" object:nil];
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"申请机构";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, 88);
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
    
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight + 200)];
    if (iPhoneX) {
        _scrollView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight + 200);
    }
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 300);
    [self.view addSubview:_scrollView];
    
}

- (void)addInfoView {
    
    CGFloat ViewW = MainScreenWidth - 2 * SpaceBaside;
    CGFloat ViewH = 40;
    
    NSString *appNameAccount = [NSString stringWithFormat:@"%@账号:",AppName];
    NSArray *textArray = @[appNameAccount,@"选机构分类:",@"机构名称:",@"法人身份证:",@"联系电话:",@"机构地区:",@"机构地址:",@"认证理由:",@"认证附件:",@"身份证附件:"];
    
    for (int i = 0 ; i < textArray.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * i, ViewW, ViewH)];
         if (i < 7){
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i), ViewW, ViewH);
        } else if (i == 0) {
            
        } else if (i == 6) {
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i +  2), ViewW, ViewH * 2);
        } else if (i == 8) {
              view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i), ViewW, ViewH * 4);
        } else if (i == 9) {
            view.frame = CGRectMake(SpaceBaside, SpaceBaside + (ViewH + SpaceBaside) * (i + 2) + 20 * WideEachUnit, ViewW, ViewH * 4);
        }
        

        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_scrollView addSubview:view];
        
        //添加文本
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, 80, ViewH)];
        textLabel.text = textArray[i];
        textLabel.font = Font(14);
        textLabel.textColor = [UIColor grayColor];
        [view addSubview:textLabel];
 
        //添加输入框
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, MainScreenWidth - 100 - 20,ViewH)];
        textField.backgroundColor = [UIColor whiteColor];
        [view addSubview:textField];
        
        //textField 赋值
        switch (i) {
            case 0:
                _textField0 = textField;
                _textField0.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"uname"];
                _textField0.textColor = [UIColor grayColor];
                _textField0.font = Font(13);
                break;
            case 1:
                _textField1 = textField;
                break;
            case 2:
                _textField2 = textField;
                break;
            case 3:
                _textField3 = textField;
                break;
            case 4:
                _textField4 = textField;
                break;
            case 5:
                _textField5 = textField;
                break;
            case 6:
                _textField6 = textField;
                break;
            case 7:
                _textField7 = textField;
                break;
            case 8:
                _textField8 = textField;
//                _textField8.frame = CGRectMake(90, 0, MainScreenWidth - 100 - 20,ViewH * 2);
                _textView8 = [[UITextView alloc] initWithFrame:CGRectMake(90, 5, MainScreenWidth - 120, ViewH * 2)];
                [view addSubview:_textView8];
                break;
            case 9:
                _textField9 = textField;
                break;
            default:
                break;
        }
        
        
        if (i == 1) {
            
            //添加银行
            _cateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, MainScreenWidth - 2 * SpaceBaside - 40, ViewH)];
            _cateLabel.text = @"请选择机构分类";
            _cateLabel.font = Font(14);
            [view addSubview:_cateLabel];
            
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 2 * SpaceBaside - 40, 0,40, 40)];
            [downButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            [downButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            downButton.tag = 3000;
            [view addSubview:downButton];
            [textField removeFromSuperview];
        }
        
        if (i == 5) {
            //添加手势
            [textField addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldClick:)]];
            
            UIButton *textButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textField.frame.size.width, textField.frame.size.height)];
            textButton.backgroundColor = [UIColor clearColor];
            [textButton addTarget:self action:@selector(textButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [textField addSubview:textButton];
        }
        
        //往上面添加东西
        if (i == 8) {//认证附件
            UIButton *adjunctButton = [[UIButton alloc] initWithFrame:CGRectMake(120, SpaceBaside / 2, 80, 30)];
            [adjunctButton setTitle:@"选中附件" forState:UIControlStateNormal];
            adjunctButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            adjunctButton.layer.borderWidth = 1;
            adjunctButton.layer.cornerRadius = 3;
            adjunctButton.titleLabel.font = Font(15);
            adjunctButton.layer.borderColor = [UIColor grayColor].CGColor;
            [adjunctButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
            adjunctButton.tag = 4000;
            [adjunctButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:adjunctButton];
            
            
            //添加文本
            UILabel *adjunLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, MainScreenWidth - 120 - 2 * SpaceBaside, 40)];
            adjunLabel.text = @"申请独立财务账户需提交以下材料:营业执照、税务登记证、组织机构代码、对公账号相关信息";
            adjunLabel.textColor = [UIColor grayColor];
            adjunLabel.font = Font(10);
            adjunLabel.numberOfLines = 3;
            [view addSubview:adjunLabel];
            
            [textField removeFromSuperview];
            
            //添加滚动试图
            _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, MainScreenWidth - 20 * WideEachUnit, 60)];
            _imageScrollView.backgroundColor = [UIColor whiteColor];
            _imageScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 60);
            [view addSubview:_imageScrollView];
        }
        
        if (i == 9) {//认证附件
            UIButton *adjunctButton = [[UIButton alloc] initWithFrame:CGRectMake(120, SpaceBaside / 2, 80, 30)];
            [adjunctButton setTitle:@"选中附件" forState:UIControlStateNormal];
            adjunctButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            adjunctButton.layer.borderWidth = 1;
            adjunctButton.layer.cornerRadius = 3;
            adjunctButton.titleLabel.font = Font(15);
            adjunctButton.layer.borderColor = [UIColor grayColor].CGColor;
            [adjunctButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
            adjunctButton.tag = 5000;
            [adjunctButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:adjunctButton];
            
            
            //添加文本
            UILabel *adjunLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, MainScreenWidth - 120 - 2 * SpaceBaside, 40)];
            adjunLabel.text = @"提供申请人的身份证相关信息";
            adjunLabel.textColor = [UIColor grayColor];
            adjunLabel.font = Font(10);
            adjunLabel.numberOfLines = 3;
            [view addSubview:adjunLabel];
            
            [textField removeFromSuperview];
            
//            //添加滚动试图
            UIImageView *idCardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 60, 60)];
            idCardImageView.backgroundColor = [UIColor whiteColor];
            [view addSubview:idCardImageView];
            _idCardImageView = idCardImageView;
        }
        
    }
    
    
    //添加立即申请的按钮
    
    CGFloat applyButtonY = SpaceBaside + (SpaceBaside + ViewH) * 13 + 2 * ViewH;
    
    _applyButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, applyButtonY, MainScreenWidth - 2 * SpaceBaside, ViewH + SpaceBaside)];
    [_applyButton setTitle:@"立即申请" forState:UIControlStateNormal];
    _applyButton.backgroundColor = BasidColor;
    _applyButton.layer.cornerRadius = 5;
    [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_applyButton addTarget:self action:@selector(applyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_applyButton];
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_applyButton.frame) + 280);
 
}


//资格图像
- (void)howManyImage {//这里来设置图片
    
    CGFloat imageViewW = 60;
    for (int i = 0 ; i < _imageArray.count ; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside + (imageViewW + SpaceBaside) * i, 0, 60, 60)];
        imageView.image = _imageArray[i];
        [_imageScrollView addSubview:imageView];
        _imageScrollView.contentSize = CGSizeMake(i * (60 + SpaceBaside) + 100, 60);
    }
}


//身份证图像
- (void)howManyImageOfIDCardImageView {//这里来设置图片
    
    CGFloat imageViewW = 60;
    for (int i = 0 ; i < _idCardImageArray.count ; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside + (imageViewW + SpaceBaside) * i, 0, 60, 60)];
        imageView.image = _idCardImageArray[i];
        [_idCardImageView addSubview:imageView];
//        _imageScrollView.contentSize = CGSizeMake(i * (60 + SpaceBaside) + 100, 60);
    }
}


#pragma mark --- 通知
- (void)getCateInfo:(NSNotification *)Not {
    
    _cateLabel.text = Not.userInfo[@"title"];
    _cateID = Not.userInfo[@"id"];
}

- (void)textView:(NSNotification *)not {
    
    if (_textView8.text.length > 50) {
        _textView8.text = [_textView8.text substringToIndex:50];
        [TKProgressHUD showError:@"内容不能过长" toView:self.view];
        return;
    } else {
        
    }
}

- (void)getProvince:(NSNotification *)not {
    _proVinceDict = not.object;
    _textField5.text = [_proVinceDict stringValueForKey:@"title"];
    _proVinceID = [_proVinceDict stringValueForKey:@"area_id"];
}

- (void)getCity:(NSNotification *)not {
    _cityDict = not.object;
    _textField5.text = [NSString stringWithFormat:@"%@  %@",[_proVinceDict stringValueForKey:@"title"],[_cityDict stringValueForKey:@"title"]];
    _cityID = [_cityDict stringValueForKey:@"area_id"];
}

- (void)getCounty:(NSNotification *)not {
    _countyDict = not.object;
    _textField5.text = [NSString stringWithFormat:@"%@ %@ %@",[_proVinceDict stringValueForKey:@"title"],[_cityDict stringValueForKey:@"title"],[_countyDict stringValueForKey:@"title"]];
    _countyID = [_countyDict stringValueForKey:@"area_id"];
}



#pragma mark --- 滚动试图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark --- 手势
- (void)textFieldClick:(UIGestureRecognizer *)tap {
    Good_AddBankProvinceViewController *vc = [[Good_AddBankProvinceViewController alloc] init];
    vc.typeStr = @"applyIns";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addButton {
    
}


- (void)getWhichBank {
//    PopView *popView = [[PopView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
//    [self.view addSubview:popView];
    SubjectView *subjectView = [[SubjectView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:subjectView];
}

- (void)adjunctButtonClick {
    
    
}

- (void)textButtonClick {
    Good_AddBankProvinceViewController *vc = [[Good_AddBankProvinceViewController alloc] init];
    vc.typeStr = @"applyIns";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyButtonClick {
    
    [self netWorkSchoolApply];
}

#pragma mark --- UISheet 

- (void)addButtonClick:(UIButton *)button {
    
    if (button.tag == 3000) {
        [self getWhichBank];
        return;
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];
    
    _buttonType = button.tag;
    
}


#pragma mark --- ActionSheet

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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    
    if (_buttonType == 1000) {//logo
        _logoImageView.image = image;
    } else if (_buttonType == 2000) {
        _imageImageView.image = image;
    } else if (_buttonType == 4000) {//附件
        [_imageArray addObject:image];
        [self howManyImage];
        [self netWorkUserManyUpLoad];
        return;
    } else if (_buttonType == 5000) {
//        _idCardImageView.image = image;
        [_idCardImageArray addObject:image];
        [self howManyImageOfIDCardImageView];
        [self netWorkUserManyUpLoad];
        return;
    }
    [self netWorkUserUpLoad];
}

#pragma mark ---键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark --- 网络请求
//申请成为机构
- (void)netWorkSchoolApply {
    
    NSString *endUrlStr = YunKeTang_School_school_apply;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (_textField2.text.length == 0) {
        [TKProgressHUD showError:@"机构名称不能为空" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_textField2.text forKey:@"title"];
    }
    
    if (_cateID == nil) {
        [TKProgressHUD showError:@"请选择机构类型" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_cateID forKey:@"cate_id"];
    }
    
    if (_textField7.text.length == 0) {
        [TKProgressHUD showError:@"请填写认证理由" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_textField7.text forKey:@"reason"];
    }
    
    if (_textField4.text.length == 0) {
        [TKProgressHUD showError:@"请填写电话" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_textField4.text forKey:@"phone"];
    }
    if (_textField3.text.length == 0) {
        [TKProgressHUD showError:@"请填写身份证" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_textField3.text forKey:@"idcard"];
    }
    if (_adjunctArray.count > 0) {
        NSString *adjunIDS = nil;
        for (int i = 0 ; i < _adjunctArray.count ; i++) {
            if (i == 0) {
                adjunIDS = _adjunctArray[0];
            } else {
                adjunIDS = [NSString stringWithFormat:@"%@,%@",adjunIDS,_adjunctArray[i]];
            }
            
        }
        [mutabDict setObject:adjunIDS forKey:@"attach_id"];//机构附件id
        
    } else {
        [TKProgressHUD showError:@"请添加附件" toView:self.view];
        return;
    }
    if (_textField6.text.length > 0) {
        [mutabDict setObject:_textField6.text forKey:@"address"];
    } else {
        [TKProgressHUD showError:@"请填写地址" toView:self.view];
        return;
    }
    
    if (_proVinceID == nil) {
        [TKProgressHUD showError:@"请选择所在省份" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_proVinceID forKey:@"province"];//省的ID
    }
    if (_cityID == nil) {
        [TKProgressHUD showError:@"请选择所在城市" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_cityID forKey:@"city"];//城市的ID
    }
    if (_countyID == nil) {
        [TKProgressHUD showError:@"请选择所在区域" toView:self.view];
        return;
    } else {
        [mutabDict setObject:_countyID forKey:@"area"];//区域的ID
    }
    if (SWNOTEmptyStr(_textField5.text)) {
        [mutabDict setObject:_textField5.text forKey:@"location"];
    }
    if (_idCardIDArray.count == 0) {
        [TKProgressHUD showError:@"请上传身份证附件" toView:self.view];
        return;
    } else {
        NSString *identIDS = nil;
        for (int i = 0 ; i < _idCardIDArray.count ; i++) {
            if (i == 0) {
                identIDS = _idCardIDArray[0];
            } else {
                identIDS = [NSString stringWithFormat:@"%@,%@",identIDS,_idCardIDArray[i]];
            }
            
        }
        [mutabDict setObject:identIDS forKey:@"identity_id"];
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
        NSDictionary *statusDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[statusDict stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:@"申请成功，请等待审核" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [TKProgressHUD showError:[statusDict stringValueForKey:@"msg"] toView:self.view];
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//上传图片
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
            if (_buttonType == 1000) {
                _logoImageID = [dict stringValueForKey:@"attach_id"];
            } else if (_buttonType ==  2000) {
                _imageImageID = [dict stringValueForKey:@"attach_id"];
            } else if (_buttonType == 4000) {//附件
                
            } else if (_buttonType == 5000) {//身份证
                _identityID = [dict stringValueForKey:@"attach_id"];
            }
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



//获得附件图片的ID
- (void)netWorkUserManyUpLoad {

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
        //上传图片
        NSMutableArray *images = [NSMutableArray arrayWithArray:_imageArray];
        if (images.count != 0) {
            for (UIImage *imgae in images) {
                NSData *dataImg=UIImageJPEGRepresentation(imgae, 0.5);
                [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
            }
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            [_imageIDArray addObject:[dict stringValueForKey:@"attach_id"]];
            _adjunctID = [dict stringValueForKey:@"attach_id"];
            if (_buttonType == 4000) {
                [_adjunctArray addObject:_adjunctID];
                [self howManyImage];
            } else if (_buttonType == 5000) {
                [_idCardIDArray addObject:_adjunctID];
                [self howManyImageOfIDCardImageView];
            }

        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}





@end
