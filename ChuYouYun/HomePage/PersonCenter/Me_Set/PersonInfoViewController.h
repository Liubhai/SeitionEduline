//
//  PersonInfoViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 17/1/24.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoViewController : UIViewController

@property (strong,nonatomic) UIButton *headerImageButton;
@property (strong,nonatomic) UITextField *userName;
@property (strong,nonatomic) UIButton *userSex;
@property (strong,nonatomic) UIScrollView *scrollview;

@property (strong,nonatomic) UITextView *userIdiograph;
@property (strong,nonatomic) UILabel *textNumber;
@property (strong,nonatomic) UIView *oneView;
@property (strong,nonatomic) UIView *twoView;
@property (strong,nonatomic) UIView *thereView;

@property (strong ,nonatomic)NSDictionary   *allInformation;
@property (strong ,nonatomic)NSDictionary   *allDict;


-(id)initWithUserFace:(UIImage *)face;



@end
