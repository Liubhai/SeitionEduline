//
//  TeacherApplyViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "TeacherApplyViewController.h"
#import "BuyAgreementViewController.h"
#import "TKProgressHUD+Add.h"

#define ApplyHeight 52
#define ApplySpace 20
#define MAX_IMAGE_COUNT 9

@interface TeacherApplyViewController () {
    CGFloat keyHeight;
    NSString *whichTextIsbegin;
    NSInteger currentPickerRow;
    NSInteger firstRow;
    NSInteger secondRow;
    BOOL currentPickerType;// 默认 机构  yes 分类
    NSString *schoolID;
    NSString *classID;
    NSString *attach_ids;
    NSString *verified_status;
}

@end

@implementation TeacherApplyViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"讲师认证";
    
    currentPickerRow = 0;
    firstRow = 0;
    secondRow = 0;
    
    currentPickerType = NO;
    
    schoolID = @"";
    classID = @"";
    attach_ids = @"";
    verified_status = @"";
    
    _imageArray = [NSMutableArray new];
    _schoolArray = [NSMutableArray new];
    
    _dataSource = [NSMutableArray new];
    _firstDataSource = [NSMutableArray new];
    _secondDataSource = [NSMutableArray new];
    
    [self makeSubViews];
    [self makePickerView];
    [self getTeacherApplyInfo];
}

- (void)makeSubViews {
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    [self.view addSubview:_mainScrollView];
    
    _statusBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, ApplyHeight)];
    [_mainScrollView addSubview:_statusBg];
    _statusTitle = [[UILabel alloc] initWithFrame:CGRectMake(ApplySpace, 0, 100, ApplyHeight)];
    _statusTitle.text = @"当前状态";
    _statusTitle.textColor = RGBHex(0x333333);
    _statusTitle.font = SYSTEMFONT(14);
    [_statusBg addSubview:_statusTitle];
    _statusResult = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - ApplySpace - 150, 0, 150, ApplyHeight)];
    _statusResult.font = SYSTEMFONT(14);
    _statusResult.textAlignment = NSTextAlignmentRight;
    [_statusBg addSubview:_statusResult];
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _statusBg.bottom, MainScreenWidth, 6)];
    _line1.backgroundColor = RGBHex(0xF8F8F8);
    [_mainScrollView addSubview:_line1];
    
    _organizationBg = [[UIView alloc] initWithFrame:CGRectMake(0, _line1.bottom, MainScreenWidth, ApplyHeight)];
    [_mainScrollView addSubview:_organizationBg];
    _organizationTitle = [[UILabel alloc] initWithFrame:CGRectMake(ApplySpace, 0, 100, ApplyHeight)];
    _organizationTitle.text = @"机构名称";
    _organizationTitle.textColor = RGBHex(0x333333);
    _organizationTitle.font = SYSTEMFONT(14);
    [_organizationBg addSubview:_organizationTitle];
    _organizationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - ApplySpace - 16, 0, 16, 16)];
    _organizationIcon.centerY = _organizationBg.height / 2.0;
    _organizationIcon.image = Image(@"右箭头");
    [_organizationBg addSubview:_organizationIcon];
    _organizationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_organizationIcon.left - 200, 0, 200, ApplyHeight)];
    _organizationLabel.text = @"请选择";
    _organizationLabel.textAlignment = NSTextAlignmentRight;
    _organizationLabel.textColor = RGBHex(0xB5B5B5);
    _organizationLabel.font = SYSTEMFONT(13);
    [_organizationBg addSubview:_organizationLabel];
    _organizationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, ApplyHeight)];
    _organizationButton.backgroundColor = [UIColor clearColor];
    [_organizationButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_organizationBg addSubview:_organizationButton];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(0, _organizationBg.bottom, MainScreenWidth, 2)];
    _line2.backgroundColor = RGBHex(0xF8F8F8);
    [_mainScrollView addSubview:_line2];
    
    _classBg = [[UIView alloc] initWithFrame:CGRectMake(0, _line2.bottom, MainScreenWidth, ApplyHeight)];
    [_mainScrollView addSubview:_classBg];
    _classleftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ApplySpace, 0, 8, 8)];
    _classleftIcon.image = Image(@"star");
    _classleftIcon.centerY = ApplyHeight / 2.0;
    [_classBg addSubview:_classleftIcon];
    _classTitle = [[UILabel alloc] initWithFrame:CGRectMake(_classleftIcon.right + 4, 0, 100, ApplyHeight)];
    _classTitle.text = @"分类";
    _classTitle.textColor = RGBHex(0x333333);
    _classTitle.font = SYSTEMFONT(14);
    [_classBg addSubview:_classTitle];
    _classIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - ApplySpace - 16, 0, 16, 16)];
    _classIcon.centerY = ApplyHeight / 2.0;
    _classIcon.image = Image(@"右箭头");
    [_classBg addSubview:_classIcon];
    _classLabel = [[UILabel alloc] initWithFrame:CGRectMake(_classIcon.left - 200, 0, 200, ApplyHeight)];
    _classLabel.text = @"请选择";
    _classLabel.textAlignment = NSTextAlignmentRight;
    _classLabel.textColor = RGBHex(0xB5B5B5);
    _classLabel.font = SYSTEMFONT(13);
    [_classBg addSubview:_classLabel];
    _classButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, ApplyHeight)];
    _classButton.backgroundColor = [UIColor clearColor];
    [_classButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_classBg addSubview:_classButton];
    
    _line3 = [[UIView alloc] initWithFrame:CGRectMake(0, _classBg.bottom, MainScreenWidth, 2)];
    _line3.backgroundColor = RGBHex(0xF8F8F8);
    [_mainScrollView addSubview:_line3];
    
    _nameBg = [[UIView alloc] initWithFrame:CGRectMake(0, _line3.bottom, MainScreenWidth, ApplyHeight)];
    [_mainScrollView addSubview:_nameBg];
    _nameleftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ApplySpace, 0, 8, 8)];
    _nameleftIcon.image = Image(@"star");
    _nameleftIcon.centerY = ApplyHeight / 2.0;
    [_nameBg addSubview:_nameleftIcon];
    _nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(_nameleftIcon.right + 4, 0, 100, ApplyHeight)];
    _nameTitle.text = @"姓名";
    _nameTitle.textColor = RGBHex(0x333333);
    _nameTitle.font = SYSTEMFONT(14);
    [_nameBg addSubview:_nameTitle];
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(MainScreenWidth - ApplySpace - 200, 0, 200, ApplyHeight)];
    _nameTextField.placeholder = @"请填写(必)";
    _nameTextField.textAlignment = NSTextAlignmentRight;
    _nameTextField.textColor = RGBHex(0xB5B5B5);
    _nameTextField.font = SYSTEMFONT(13);
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.delegate = self;
    [_nameBg addSubview:_nameTextField];
    
    _line4 = [[UIView alloc] initWithFrame:CGRectMake(0, _nameBg.bottom, MainScreenWidth, 2)];
    _line4.backgroundColor = RGBHex(0xF8F8F8);
    [_mainScrollView addSubview:_line4];
    
    _reasonBg = [[UIView alloc] initWithFrame:CGRectMake(0, _line4.bottom, MainScreenWidth, 172)];
    [_mainScrollView addSubview:_reasonBg];
    _reasonleftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ApplySpace, 0, 8, 8)];
    _reasonleftIcon.image = Image(@"star");
    _reasonleftIcon.centerY = ApplyHeight / 2.0;
    [_reasonBg addSubview:_reasonleftIcon];
    _reasonTitle = [[UILabel alloc] initWithFrame:CGRectMake(_reasonleftIcon.right + 4, 0, 100, ApplyHeight)];
    _reasonTitle.text = @"理由";
    _reasonTitle.textColor = RGBHex(0x333333);
    _reasonTitle.font = SYSTEMFONT(14);
    [_reasonBg addSubview:_reasonTitle];
    _reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(ApplySpace, _reasonTitle.bottom, MainScreenWidth - ApplySpace * 2, 120)];
    _reasonTextView.layer.masksToBounds = YES;
    _reasonTextView.layer.cornerRadius = 5;
    _reasonTextView.backgroundColor = RGBHex(0xF8F8F8);
    _reasonTextView.returnKeyType = UIReturnKeyDone;
    _reasonTextView.delegate = self;
    [_reasonBg addSubview:_reasonTextView];
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_reasonTextView.left + 10, _reasonTextView.top + 6.5, 50, 20)];
    _placeholderLabel.textColor = RGBHex(0xB5B5B5);
    _placeholderLabel.font = SYSTEMFONT(14);
    _placeholderLabel.text = @"请填写认证理由…";
    CGFloat placeholderWidth = [_placeholderLabel.text sizeWithFont:_placeholderLabel.font].width + 4;
    [_placeholderLabel setWidth:placeholderWidth];
    [_reasonBg addSubview:_placeholderLabel];
    
    _picBg = [[UIView alloc] initWithFrame:CGRectMake(0, _reasonBg.bottom, MainScreenWidth, ApplyHeight)];
    [_mainScrollView addSubview:_picBg];
    _picleftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ApplySpace, 0, 8, 8)];
    _picleftIcon.image = Image(@"star");
    _picleftIcon.centerY = ApplyHeight / 2.0;
    [_picBg addSubview:_picleftIcon];
    _picTitle = [[UILabel alloc] initWithFrame:CGRectMake(_picleftIcon.right + 4, 0, 100, ApplyHeight)];
    _picTitle.text = @"资格认证附件";
    _picTitle.textColor = RGBHex(0x333333);
    _picTitle.font = SYSTEMFONT(14);
    [_picBg addSubview:_picTitle];
    _picIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth - ApplySpace - 16, 0, 16, 16)];
    _picIcon.centerY = ApplyHeight / 2.0;
    _picIcon.image = Image(@"右箭头");
    [_picBg addSubview:_picIcon];
    _picLabel = [[UILabel alloc] initWithFrame:CGRectMake(_picIcon.left - 200, 0, 200, ApplyHeight)];
    _picLabel.text = @"上传附件";
    _picLabel.textAlignment = NSTextAlignmentRight;
    _picLabel.textColor = RGBHex(0xB5B5B5);
    _picLabel.font = SYSTEMFONT(13);
    [_picBg addSubview:_picLabel];
    _picButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, ApplyHeight)];
    _picButton.backgroundColor = [UIColor clearColor];
    [_picButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_picBg addSubview:_picButton];
    _picsContainView = [[UIView alloc] initWithFrame:CGRectMake(ApplySpace, ApplyHeight, MainScreenWidth - ApplySpace * 2, 0)];
    [_picBg addSubview:_picsContainView];
    
    _line5 = [[UIView alloc] initWithFrame:CGRectMake(0, _picBg.bottom, MainScreenWidth, 2)];
    _line5.backgroundColor = RGBHex(0xF8F8F8);
    [_mainScrollView addSubview:_line5];
    
    /// 解锁协议
    _agreementBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _line5.bottom, MainScreenWidth, ApplyHeight)];
    _agreementBackView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_agreementBackView];
    _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 24, 24)];
    [_agreementBackView addSubview:_agreeButton];
    [_agreeButton setImage:Image(@"unchoose_s@3x") forState:0];
    [_agreeButton setImage:Image(@"choose@3x") forState:UIControlStateSelected];
    _agreeButton.selected = YES;
    _agreeButton.centerX = _agreementBackView.height / 2.0;
    _agreeBackButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, 30, 30)];
    _agreeBackButton.backgroundColor = [UIColor clearColor];
    [_agreeBackButton addTarget:self action:@selector(agreeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _agreeBackButton.center = _agreeButton.center;
    [_agreementBackView addSubview:_agreeBackButton];
    _agreeTitle = [[UILabel alloc] initWithFrame:CGRectMake(_agreeButton.right + 3, _agreeButton.top, MainScreenWidth - _agreeButton.right - 3, 16)];
    _agreeTitle.text = [NSString stringWithFormat:@"我已阅读并同意《%@认证条款》",AppName];
    _agreeTitle.textColor = RGBHex(0x8B8888);
    _agreeTitle.font = SYSTEMFONT(14);
    NSMutableAttributedString *mutal = [[NSMutableAttributedString alloc] initWithString:_agreeTitle.text];
    [mutal addAttributes:@{NSForegroundColorAttributeName: BasidColor} range:NSMakeRange(7, _agreeTitle.text.length - 7)];
    _agreeTitle.attributedText = [[NSAttributedString alloc] initWithAttributedString:mutal];
    _agreeTitle.centerY = _agreeButton.centerY;
    [_agreementBackView addSubview:_agreeTitle];
    CGFloat labelWidth = [_agreeTitle.text sizeWithFont:_agreeTitle.font].width + 4;
    UIButton *agreeDetailVCButton = [[UIButton alloc] initWithFrame:CGRectMake(_agreeTitle.left + labelWidth / 2.0, 0, labelWidth / 2.0, 30)];
    agreeDetailVCButton.centerY = _agreeTitle.centerY;
    agreeDetailVCButton.backgroundColor = [UIColor clearColor];
    [agreeDetailVCButton addTarget:self action:@selector(goToAgreeDetailVC) forControlEvents:UIControlEventTouchUpInside];
    [_agreementBackView addSubview:agreeDetailVCButton];

    _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _agreementBackView.bottom + 40, MainScreenWidth - 40, 40)];
    _submitButton.backgroundColor = BasidColor;
    [_submitButton setTitle:@"提交申请" forState:0];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:0];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    [_submitButton addTarget:self action:@selector(uploadImageToNet) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_submitButton];
    
    _mainScrollView.contentSize = CGSizeMake(0, (_submitButton.bottom + 40) > MainScreenHeight ? (_submitButton.bottom + 40) : MainScreenHeight);
}

- (void)goToAgreeDetailVC {
    BuyAgreementViewController *vc = [[BuyAgreementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)placeholderTap {
    [_reasonTextView becomeFirstResponder];
}

- (void)uploadImageToNet {
    
    if ([verified_status isEqualToString:@"1"]) {
        //取消认证
        [self unApplyMethod];
        return;
    }
    
    if (!SWNOTEmptyArr(_imageArray)) {
        [TKProgressHUD showError:@"至少上传一张认证附件" toView:self.view];
        return;
    }
    NSString *endUrlStr = attach_multipleUploads;
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
        for (int i = 0; i<_imageArray.count; i++) {
            NSData *dataImg=UIImageJPEGRepresentation(_imageArray[i], 0.5);
            [formData appendPartWithFileData:dataImg name:[NSString stringWithFormat:@"teacherapply%d",i] fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpeg"];
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            attach_ids = @"";
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_WithJson:[dict stringValueForKey:@"data"]];
            if (SWNOTEmptyArr(dict)) {
                NSArray *attach_ids_array = [NSArray arrayWithArray:(NSArray *)dict];
                for (int i = 0; i<attach_ids_array.count; i++) {
                    if (i==0) {
                        attach_ids = [NSString stringWithFormat:@",%@,",[attach_ids_array[i] objectForKey:@"attach_id"]];
                    } else {
                        attach_ids = [NSString stringWithFormat:@"%@%@,",attach_ids,[attach_ids_array[i] objectForKey:@"attach_id"]];
                    }
                }
                [self submitButtonClick:attach_ids];
            }
            
        } else {
            [TKProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [TKProgressHUD showError:@"上传图片超时,请重试" toView:self.view];
    }];
}

- (void)submitButtonClick:(NSString *)imageId_string {
    
    if (!SWNOTEmptyStr(schoolID)) {
        [TKProgressHUD showError:@"请选择认证机构" toView:self.view];
        return;
    }
    if (!SWNOTEmptyStr(classID)) {
        [TKProgressHUD showError:@"请选择认证分类" toView:self.view];
        return;
    }
    if (!SWNOTEmptyStr(_nameTextField.text)) {
        [TKProgressHUD showError:@"请填写姓名" toView:self.view];
        return;
    }
    if (!SWNOTEmptyStr(_reasonTextView.text)) {
        [TKProgressHUD showError:@"请输入您的认证理由" toView:self.view];
        return;
    }
    
    NSString *endUrlStr = teacher_doAuth;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:schoolID forKey:@"school"];
    [mutabDict setObject:classID forKey:@"cate"];
    [mutabDict setObject:_nameTextField.text forKey:@"name"];
    [mutabDict setObject:_reasonTextView.text forKey:@"reason"];
    [mutabDict setObject:attach_ids forKey:@"attach_ids"];
    
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
        [TKProgressHUD showError:[statusDict stringValueForKey:@"msg"] toView:self.view];
        if ([[statusDict stringValueForKey:@"code"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [TKProgressHUD showError:[statusDict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD showError:@"认证超时,请重试" toView:self.view];
    }];
    [op start];
    
}

- (void)unApplyMethod {
    
    NSString *endUrlStr = teacher_cancelAuth;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
        [TKProgressHUD showError:[statusDict stringValueForKey:@"msg"] toView:self.view];
        if ([[statusDict stringValueForKey:@"code"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [TKProgressHUD showError:[statusDict stringValueForKey:@"msg"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [TKProgressHUD showError:@"请求超时,请重试" toView:self.view];
    }];
    [op start];
       
}

- (void)agreeButtonClick {
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
        return;
    }
    _agreeButton.selected = !_agreeButton.selected;
    if (_agreeButton.selected) {
        _submitButton.enabled = YES;
        _submitButton.backgroundColor = BasidColor;
    } else {
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = [UIColor colorWithHexString:@"#a5c3eb"];
    }
}

- (void)coverButtonClick:(UIButton *)sender {
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
        return;
    }
    [_nameTextField resignFirstResponder];
    [_reasonTextView resignFirstResponder];
    if (sender == _picButton) {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
        action.delegate = self;
        [action showInView:self.view];
    } else if (sender == _organizationButton) {
        currentPickerType = NO;
        _pickBackView.hidden = NO;
        _whiteBackView.hidden = NO;
        currentPickerRow = 0;
        firstRow = 0;
        secondRow = 0;
        [_choosePickerView reloadAllComponents];
        if (_schoolArray.count) {
            [_choosePickerView selectRow:0 inComponent:0 animated:NO];
        }
    } else if (sender == _classButton) {
        currentPickerType = YES;
        currentPickerRow = 0;
        firstRow = 0;
        secondRow = 0;
        [self getClassTypeInfo];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//进入相册
        if (_imageArray.count >= MAX_IMAGE_COUNT) {
            [TKProgressHUD showError:[NSString stringWithFormat:@"最多选%d张图片",MAX_IMAGE_COUNT] toView:self.view];
            return;
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT -_imageArray.count delegate:self singleChoose:NO];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
 
    }else if (buttonIndex == 1){//相机拍照
        
        if (_imageArray.count>=MAX_IMAGE_COUNT) {
            [TKProgressHUD showError:[NSString stringWithFormat:@"最多选%d张图片",MAX_IMAGE_COUNT] toView:self.view];
            return;
        }
        else
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                UIImagePickerController *_imagePickerController1 = [[UIImagePickerController alloc]init];
                _imagePickerController1.sourceType = UIImagePickerControllerSourceTypeCamera;
                _imagePickerController1.delegate = self;
                _imagePickerController1.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
                _imagePickerController1.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                [self presentViewController:_imagePickerController1 animated:YES completion:^{
                    
                }];
            }
            else
            {
                [TKProgressHUD showError:@"设备不支持" toView:self.view];
            }
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [_imageArray addObject:image];
    }];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    if ([assets count]) {
        [_imageArray addObjectsFromArray:photos];
        [self dealPictures];
    }
    else {
        [_imageArray addObjectsFromArray:photos];
        [self dealPictures];
    }
}

- (void)dealPictures {
    [_picsContainView removeAllSubviews];
    CGFloat picSpace = 5;
    CGFloat picWW = (MainScreenWidth - ApplySpace * 2 - 2 * picSpace) / 3.0;
    for (int i = 0; i<_imageArray.count; i++) {
        UIImageView *applyImage = [[UIImageView alloc] initWithFrame:CGRectMake(picSpace + (picSpace + picWW) * (i%3), (picWW + picSpace) * (i/3), picWW, picWW)];
        applyImage.clipsToBounds = YES;
        applyImage.contentMode = UIViewContentModeScaleAspectFill;
        applyImage.tag = 666 + i;
        applyImage.userInteractionEnabled = YES;
        [applyImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        if ([_imageArray[i] isKindOfClass:[UIImage class]]) {
            applyImage.image = (UIImage *)_imageArray[i];
        } else {
            [applyImage sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:Image(@"站位图")];
        }
        [_picsContainView addSubview:applyImage];
    }
    if (_imageArray.count) {
        [_picsContainView setHeight:((_imageArray.count % 3) == 0) ? ((picWW + picSpace) * (_imageArray.count/3) - picSpace) : ((picWW + picSpace) * (_imageArray.count/3) + picWW)];
        [_picBg setHeight:_picsContainView.bottom + 10];
    } else {
        [_picsContainView setHeight:0];
        [_picBg setHeight:_picsContainView.bottom];
    }
    [_line5 setTop:_picBg.bottom];
    [_agreementBackView setTop:_line5.bottom];
    [_submitButton setTop:_agreementBackView.bottom + 40];
    _mainScrollView.contentSize = CGSizeMake(0, (_submitButton.bottom + 40) > MainScreenHeight ? (_submitButton.bottom + 40) : MainScreenHeight);
}

-(void)tapImage:(UITapGestureRecognizer *)tgr{
    if ([verified_status isEqualToString:@"1"] || [verified_status isEqualToString:@"0"]) {
        return;
    }
    [self.view endEditing:YES];
    ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
    scanVC.imgArr = _imageArray;
    scanVC.index = tgr.view.tag - 666;
    scanVC.delegate = self;
    [self presentViewController:scanVC animated:YES completion:^{
        
    }];
}

-(void)sendPhotoArr:(NSArray *)array{
    [_imageArray removeAllObjects];
    [_imageArray addObjectsFromArray:array];
    [self dealPictures];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyHeight = [endValue CGRectValue].size.height;
    
}

- (void)textFieldDidChanged:(NSNotification *)notice {
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([verified_status isEqualToString:@"0"] || [verified_status isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChanged:(NSNotification *)notice {
    UITextView *txtview = (UITextView *)notice.object;
    if (txtview.text.length > 0) {
        _placeholderLabel.hidden = YES;
    } else {
        _placeholderLabel.hidden = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_nameTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_reasonTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)makePickerView {
    _pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
    _pickBackView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3].CGColor;
    [self.view addSubview:_pickBackView];
    
    _whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 240.5, MainScreenWidth, 241)];
    _whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_whiteBackView];
    
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [_cancelButton setTitle:@"取消" forState:0];
    [_cancelButton setTitleColor:RGBHex(0xB5B5B5) forState:0];
    [_cancelButton addTarget:self action:@selector(pickerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_cancelButton];
    
    _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 0, 70, 50)];
    [_sureButton setTitle:@"确定" forState:0];
    [_sureButton setTitleColor:BasidColor forState:0];
    [_sureButton addTarget:self action:@selector(pickerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBackView addSubview:_sureButton];
    
    _pickerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _cancelButton.bottom, MainScreenWidth, 1)];
    _pickerLineView.backgroundColor = RGBHex(0xB5B5B5);
    [_whiteBackView addSubview:_pickerLineView];
    
    _choosePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _pickerLineView.bottom, MainScreenWidth, 190)];
    _choosePickerView.delegate = self;
    _choosePickerView.dataSource = self;
    _choosePickerView.backgroundColor = [UIColor whiteColor];
    [_whiteBackView addSubview:_choosePickerView];
    
    _pickBackView.hidden = YES;
    _whiteBackView.hidden = YES;
}


- (void)pickerViewButtonClick:(UIButton *)sender {
    if (sender == _sureButton) {
        if (currentPickerType) {
            if (_dataSource.count) {
                classID = [NSString stringWithFormat:@"%@",[_dataSource[currentPickerRow] objectForKey:@"id"]];
                _classLabel.text = [NSString stringWithFormat:@"%@",[_dataSource[currentPickerRow] objectForKey:@"title"]];
                if (_firstDataSource.count) {
                    NSString *first_Class_Id = [NSString stringWithFormat:@"%@",[_firstDataSource[firstRow] objectForKey:@"id"]];
                    if ([first_Class_Id isEqualToString:@"0"]) {
                        _classLabel.text = [NSString stringWithFormat:@"%@",[_dataSource[currentPickerRow] objectForKey:@"title"]];
                    } else {
                        _classLabel.text = [NSString stringWithFormat:@"%@",[_firstDataSource[firstRow] objectForKey:@"title"]];
                        classID = [NSString stringWithFormat:@"%@,%@",classID,first_Class_Id];
                        if (_secondDataSource.count) {
                            NSString *second_Class_Id = [NSString stringWithFormat:@"%@",[_secondDataSource[secondRow] objectForKey:@"id"]];
                            if ([second_Class_Id isEqualToString:@"0"]) {
                                _classLabel.text = [NSString stringWithFormat:@"%@",[_firstDataSource[firstRow] objectForKey:@"title"]];
                            } else {
                                _classLabel.text = [NSString stringWithFormat:@"%@",[_secondDataSource[secondRow] objectForKey:@"title"]];
                                classID = [NSString stringWithFormat:@"%@,%@,%@",classID,first_Class_Id,second_Class_Id];
                            }
                        }
                    }
                }
            }
        } else {
            _organizationLabel.text = [NSString stringWithFormat:@"%@",[_schoolArray[currentPickerRow] objectForKey:@"title"]];
            schoolID = [NSString stringWithFormat:@"%@",[_schoolArray[currentPickerRow] objectForKey:@"id"]];
        }
    }
    _pickBackView.hidden = YES;
    _whiteBackView.hidden = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (currentPickerType) {
        return 3;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (currentPickerType) {
        if (component == 0) {
            return _dataSource.count;
        } else if (component == 1) {
            return _firstDataSource.count;
        } else {
            return _secondDataSource.count;
        }
    } else {
        return _schoolArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (currentPickerType) {
        return MainScreenWidth / 3.0;
    } else {
        return MainScreenWidth;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 35)];
    pickerLabel.font = SYSTEMFONT(14);
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    if (currentPickerType) {
        [pickerLabel setWidth:MainScreenWidth / 3.0];
        if (component == 0) {
            pickerLabel.text = [NSString stringWithFormat:@"%@",[_dataSource[row] objectForKey:@"title"]];
        } else if (component == 1) {
            pickerLabel.text = [NSString stringWithFormat:@"%@",[_firstDataSource[row] objectForKey:@"title"]];
        } else {
            pickerLabel.text = [NSString stringWithFormat:@"%@",[_secondDataSource[row] objectForKey:@"title"]];
        }
    } else {
        pickerLabel.text = [NSString stringWithFormat:@"%@",[_schoolArray[row] objectForKey:@"title"]];
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (currentPickerType) {
        if (component == 0) {
            currentPickerRow = row;
            firstRow = 0;
            secondRow = 0;
            [_firstDataSource removeAllObjects];
            [_secondDataSource removeAllObjects];
            if (_dataSource.count) {
                [_firstDataSource addObjectsFromArray:[_dataSource[row] objectForKey:@"child"]];
                if (_firstDataSource.count) {
                    [_secondDataSource addObjectsFromArray:[_firstDataSource[0] objectForKey:@"child"]];
                }
            }
            [_choosePickerView reloadComponent:1];
            [_choosePickerView reloadComponent:2];
        } else if (component == 1) {
            firstRow = row;
            secondRow = 0;
            [_secondDataSource removeAllObjects];
            if (_firstDataSource.count) {
                [_secondDataSource addObjectsFromArray:[_firstDataSource[row] objectForKey:@"child"]];
            }
            [_choosePickerView reloadComponent:2];
        } else {
            secondRow = row;
        }
    } else {
        currentPickerRow = row;
    }
}

- (void)getTeacherApplyInfo {
    NSString *endUrlStr = teacher_authInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mutabDict setObject:@(page) forKey:@"page"];
//    [mutabDict setObject:@"20" forKey:@"count"];
//    [mutabDict setObject:_commentTypeString forKey:@"type"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            _teacherApplyInfo = [NSDictionary dictionaryWithDictionary:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            if (SWNOTEmptyDictionary(_teacherApplyInfo)) {
                [_schoolArray removeAllObjects];
                [_schoolArray addObjectsFromArray:[_teacherApplyInfo objectForKey:@"school"]];
                if (SWNOTEmptyDictionary([_teacherApplyInfo objectForKey:@"verifyInfo"])) {
                    verified_status = [NSString stringWithFormat:@"%@",[[_teacherApplyInfo objectForKey:@"verifyInfo"] objectForKey:@"verified_status"]];
                    [self setValueForTeacherInfo:[_teacherApplyInfo objectForKey:@"verifyInfo"]];
                    if ([verified_status isEqualToString:@"1"]) {
                        [_submitButton setTitle:@"取消认证" forState:0];
                        _statusResult.text = @"认证成功";
                        _statusResult.textColor = BasidColor;
                        _submitButton.enabled = YES;
                        _submitButton.backgroundColor = BasidColor;
                    } else if ([verified_status isEqualToString:@"0"]) {
                        [_submitButton setTitle:@"认证中" forState:0];
                        _statusResult.text = @"认证中";
                        _submitButton.backgroundColor = [UIColor colorWithHexString:@"#a5c3eb"];
                        _submitButton.enabled = NO;
                    } else {
                        [_submitButton setTitle:@"提交申请" forState:0];
                        _statusResult.text = @"认证失败";
                        _statusResult.textColor = [UIColor redColor];
                        _submitButton.enabled = YES;
                        _submitButton.backgroundColor = BasidColor;
                    }
                } else {
                    _statusResult.text = @"未认证";
                    _statusResult.textColor = RGBHex(0xB5B5B5);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

- (void)getClassTypeInfo {
    if (!SWNOTEmptyStr(schoolID)) {
        [TKProgressHUD showError:@"请先选择一个机构" toView:self.view];
        return;
    }
    NSString *endUrlStr = teacher_getCate;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:schoolID forKey:@"mhm_id"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            [_dataSource removeAllObjects];
            [_firstDataSource removeAllObjects];
            [_secondDataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStrFromData:responseObject]];
            if (_dataSource.count) {
                if ([_dataSource[0] objectForKey:@"child"]) {
                    [_firstDataSource addObjectsFromArray:[_dataSource[0] objectForKey:@"child"]];
                    if (_firstDataSource.count) {
                        if ([_firstDataSource[0] objectForKey:@"child"]) {
                           [_secondDataSource addObjectsFromArray:[_firstDataSource[0] objectForKey:@"child"]];
                        }
                    }
                }
            }
            _pickBackView.hidden = NO;
            _whiteBackView.hidden = NO;
            [_choosePickerView reloadAllComponents];
            if (_dataSource.count) {
                [_choosePickerView selectRow:0 inComponent:0 animated:NO];
            }
            if (_firstDataSource.count) {
                [_choosePickerView selectRow:0 inComponent:1 animated:NO];
            }
            if (_secondDataSource.count) {
                [_choosePickerView selectRow:0 inComponent:2 animated:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}

- (void)setValueForTeacherInfo:(NSDictionary *)info {
    if ([verified_status isEqualToString:@"1"] || [verified_status isEqualToString:@"0"]) {
        _organizationLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"school"]];
        _classLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"cate"]];
        _nameTextField.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"name"]];
        _reasonTextView.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"reason"]];
        _placeholderLabel.hidden = YES;
        [_imageArray removeAllObjects];
        [_imageArray addObjectsFromArray:[info objectForKey:@"img_url"]];
        [self dealPictures];
    }
}

@end
