//
//  TeacherApplyViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "TeacherApplyViewController.h"

#define ApplyHeight 52
#define ApplySpace 20

@interface TeacherApplyViewController ()

@end

@implementation TeacherApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"讲师认证";
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
    _organizationLabel.text = @"不选择则为平台讲师";
    _organizationLabel.textColor = RGBHex(0xB5B5B5);
    _organizationLabel.font = SYSTEMFONT(13);
    _organizationLabel.textAlignment = NSTextAlignmentCenter;
    [_organizationBg addSubview:_organizationLabel];
    _organizationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, ApplyHeight)];
    _organizationButton.backgroundColor = [UIColor clearColor];
    [_organizationBg addSubview:_organizationButton];
    
    _line2 = [[UIView alloc] initWithFrame:CGRectMake(0, _organizationBg.bottom, MainScreenWidth, 2)];
    _line2.backgroundColor = RGBHex(0xF8F8F8);
    [_mainScrollView addSubview:_line2];
    
    _classBg = [[UIView alloc] initWithFrame:CGRectMake(0, _line2.bottom, MainScreenWidth, ApplyHeight)];
    
}

@end
