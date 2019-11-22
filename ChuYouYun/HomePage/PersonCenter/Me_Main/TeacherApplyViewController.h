//
//  TeacherApplyViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"

#import "SYG.h"
#import "YunKeTang_Api.h"
#import "TKProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"

#import "TZImagePickerController.h"
#import "ScanPhotoViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface TeacherApplyViewController : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, TZImagePickerControllerDelegate, sendPhotoArrDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property(strong, nonatomic) NSDictionary *teacherApplyInfo;

@property(strong, nonatomic) NSMutableArray *imageArray;

@property(strong, nonatomic) NSMutableArray *schoolArray;

@property(strong, nonatomic) NSMutableArray *secondDataSource;
@property(strong, nonatomic) NSMutableArray *firstDataSource;
@property(strong, nonatomic) NSMutableArray *dataSource;

@property(strong, nonatomic) UIView *pickerLineView;
@property(strong, nonatomic) UIButton *sureButton;
@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIView *whiteBackView;
@property(strong, nonatomic) UIView *pickBackView;
@property(strong, nonatomic) UIPickerView *choosePickerView;

@property(strong, nonatomic) UIButton *submitButton;

@property(strong, nonatomic) UIButton *agreeDetailVCButton;
@property(strong, nonatomic) UIButton *agreeButton;
@property(strong, nonatomic) UILabel *agreeTitle;
@property(strong, nonatomic) UIButton *agreeBackButton;
@property(strong, nonatomic) UIView *agreementBackView;

@property(strong, nonatomic) UIView *picsContainView;
@property(strong, nonatomic) UIButton *picButton;
@property(strong, nonatomic) UIImageView *picIcon;
@property(strong, nonatomic) UILabel *picLabel;
@property(strong, nonatomic) UILabel *picTitle;
@property(strong, nonatomic) UIImageView *picleftIcon;
@property(strong, nonatomic) UIView *picBg;

@property(strong, nonatomic) UILabel *placeholderLabel;
@property(strong, nonatomic) UITextView *reasonTextView;
@property(strong, nonatomic) UILabel *reasonTitle;
@property(strong, nonatomic) UIImageView *reasonleftIcon;
@property(strong, nonatomic) UIView *reasonBg;

@property(strong, nonatomic) UIButton *nameButton;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *nameTitle;
@property(strong, nonatomic) UIImageView *nameleftIcon;
@property(strong, nonatomic) UITextField *nameTextField;
@property(strong, nonatomic) UIView *nameBg;

@property(strong, nonatomic) UIButton *classButton;
@property(strong, nonatomic) UIImageView *classIcon;
@property(strong, nonatomic) UILabel *classLabel;
@property(strong, nonatomic) UILabel *classTitle;
@property(strong, nonatomic) UIImageView *classleftIcon;
@property(strong, nonatomic) UIView *classBg;

@property(strong, nonatomic) UIButton *organizationButton;
@property(strong, nonatomic) UIImageView *organizationIcon;
@property(strong, nonatomic) UILabel *organizationLabel;
@property(strong, nonatomic) UILabel *organizationTitle;
@property(strong, nonatomic) UIView *organizationBg;

@property(strong, nonatomic) UIView *line5;
@property(strong, nonatomic) UIView *line4;
@property(strong, nonatomic) UIView *line3;
@property(strong, nonatomic) UIView *line2;
@property(strong, nonatomic) UIView *line1;

@property(strong, nonatomic) UIButton *statusButton;
@property(strong, nonatomic) UILabel *statusResult;
@property(strong, nonatomic) UILabel *statusTitle;
@property(strong, nonatomic) UIView *statusBg;

@property(strong, nonatomic) UIScrollView *mainScrollView;

@end

NS_ASSUME_NONNULL_END
