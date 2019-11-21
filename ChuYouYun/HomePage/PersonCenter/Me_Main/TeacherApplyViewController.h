//
//  TeacherApplyViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/11/21.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeacherApplyViewController : BaseViewController

@property(retain, nonatomic) NSDictionary *teacherApplyInfo;

@property(retain, nonatomic) NSMutableArray *imageArray;

@property(retain, nonatomic) NSMutableArray *schoolArray;

@property(retain, nonatomic) NSMutableArray *secondDataSource;
@property(retain, nonatomic) NSMutableArray *firstDataSource;
@property(retain, nonatomic) NSMutableArray *dataSource;

@property(retain, nonatomic) UIView *pickerLineView;
@property(retain, nonatomic) UIButton *sureButton;
@property(retain, nonatomic) UIButton *cancelButton;
@property(retain, nonatomic) UIView *whiteBackView;
@property(retain, nonatomic) UIView *pickBackView;
@property(retain, nonatomic) UIPickerView *choosePickerView;

@property(retain, nonatomic) UIButton *submitButton;

@property(retain, nonatomic) UIButton *agreeButton;
@property(retain, nonatomic) UILabel *agreementLabel;
@property(retain, nonatomic) UIButton *selectIcon;
@property(retain, nonatomic) UIView *agreeBg;

@property(retain, nonatomic) UIView *picsContainView;
@property(retain, nonatomic) UIButton *picButton;
@property(retain, nonatomic) UIImageView *picIcon;
@property(retain, nonatomic) UILabel *picLabel;
@property(retain, nonatomic) UILabel *picTitle;
@property(retain, nonatomic) UIImageView *picleftIcon;
@property(retain, nonatomic) UIView *picBg;

@property(retain, nonatomic) UILabel *placeholderLabel;
@property(retain, nonatomic) UITextView *reasonTextView;
@property(retain, nonatomic) UILabel *reasonTitle;
@property(retain, nonatomic) UIImageView *reasonleftIcon;
@property(retain, nonatomic) UIView *reasonBg;

@property(retain, nonatomic) UIButton *nameButton;
@property(retain, nonatomic) UILabel *nameLabel;
@property(retain, nonatomic) UILabel *nameTitle;
@property(retain, nonatomic) UIImageView *nameleftIcon;
@property(retain, nonatomic) UITextField *nameTextField;
@property(retain, nonatomic) UIView *nameBg;

@property(retain, nonatomic) UIButton *classButton;
@property(retain, nonatomic) UIImageView *classIcon;
@property(retain, nonatomic) UILabel *classLabel;
@property(retain, nonatomic) UILabel *classTitle;
@property(retain, nonatomic) UIImageView *classleftIcon;
@property(retain, nonatomic) UIView *classBg;

@property(retain, nonatomic) UIButton *organizationButton;
@property(retain, nonatomic) UIImageView *organizationIcon;
@property(retain, nonatomic) UILabel *organizationLabel;
@property(retain, nonatomic) UILabel *organizationTitle;
@property(retain, nonatomic) UIView *organizationBg;

@property(retain, nonatomic) UIView *line5;
@property(retain, nonatomic) UIView *line4;
@property(retain, nonatomic) UIView *line3;
@property(retain, nonatomic) UIView *line2;
@property(retain, nonatomic) UIView *line1;

@property(retain, nonatomic) UIButton *statusButton;
@property(retain, nonatomic) UILabel *statusResult;
@property(retain, nonatomic) UILabel *statusTitle;
@property(retain, nonatomic) UIView *statusBg;

@property(retain, nonatomic) UIScrollView *mainScrollView;

@end

NS_ASSUME_NONNULL_END
