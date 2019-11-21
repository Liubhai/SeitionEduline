//
//  ShopOrderDetailVC.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/6/11.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopOrderDetailVC : BaseViewController

// 传递原始数据
@property (strong, nonatomic) NSDictionary *originDict;
// 用户流水
@property (strong ,nonatomic)NSDictionary   *userAccountDict;
@property (assign, nonatomic) BOOL isHaveDefault;
@property (assign, nonatomic) BOOL isHaveAilPay;
@property (assign, nonatomic) BOOL isHaveWxPay;
@property (strong, nonatomic) NSString *scoreStaus;
@property (assign, nonatomic) CGFloat percentage;
@property (assign, nonatomic) NSInteger numValue;
@property (strong, nonatomic) NSDictionary *addressDict;

// 整个容器
@property (strong, nonatomic) UIScrollView *mainScrollView;

/** 商品支付是否显示三方支付(用于应对上架时候切换) */
@property (assign, nonatomic) BOOL showThirdPayMethod;

/** 商品简介容器 */
@property (strong, nonatomic) UIView *shopIntroBackView;
/** 商品封面 */
@property (strong, nonatomic) UIImageView *shopFaceImageView;
/** 商品名称 */
@property (strong, nonatomic) UILabel *shopNameLabel;
/** 商品简介 */
@property (strong, nonatomic) UILabel *shopIntroLabel;

/** 支付方式背景 */
@property (strong, nonatomic) UIView *payMethodBackView;
@property (strong, nonatomic) UILabel *payTitleLabel;
@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) UIView *line5;
@property (strong, nonatomic) UILabel *tipLabel;

// 支付宝
@property (strong, nonatomic) UIView *alipayBackView;
@property (strong, nonatomic) UIView *line2;
@property (strong, nonatomic) UIImageView *alipayIcon;
@property (strong, nonatomic) UILabel *alipayLabel;
@property (strong, nonatomic) UIButton *alipayButton;
@property (strong, nonatomic) UIButton *alipayBackButton;

// 微信支付
@property (strong, nonatomic) UIView *weixinBackView;
@property (strong, nonatomic) UIView *line3;
@property (strong, nonatomic) UIImageView *weixinIcon;
@property (strong, nonatomic) UILabel *weixinLabel;
@property (strong, nonatomic) UIButton *weixinButton;
@property (strong, nonatomic) UIButton *weixinBackButton;

// 积分支付
@property (strong, nonatomic) UIView *integralBackView;
@property (strong, nonatomic) UIView *line4;
@property (strong, nonatomic) UIImageView *integralIcon;
@property (strong, nonatomic) UILabel *integralLabel;
@property (strong, nonatomic) UIButton *integralButton;
@property (strong, nonatomic) UIButton *integralBackButton;


/** 收获地址背景 */
@property (strong, nonatomic) UIView *addressBackView;
@property (strong, nonatomic) UILabel *addressTitleLabel;
@property (strong, nonatomic) UIView *addressLine1;
@property (strong, nonatomic) UIView *addressLine2;
@property (strong, nonatomic) UIImageView *addressIcon;
@property (strong, nonatomic) UILabel *nameAndPhoneLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIButton *rightIcon;
@property (strong, nonatomic) UIButton *addressButton;


/** 支付金额背景 */
@property (strong, nonatomic) UIView *payCountBackView;
@property (strong, nonatomic) UIView *payCountLine;
@property (strong, nonatomic) UILabel *payCountTitle;
@property (strong, nonatomic) UILabel *payCountLabel;


/** 支付协议背景 */
@property (strong, nonatomic) UIView *agreementBackView;
@property (strong, nonatomic) UIView *agreementLine;
@property (strong, nonatomic) UIButton *agreeButton;
@property (strong, nonatomic) UIButton *agreeBackButton;
@property (strong, nonatomic) UILabel *agreeTitle;

/** 底部视图 */
@property (strong, nonatomic) UILabel *allMoneyLabel;
@property (strong, nonatomic) UIButton *submitButton;

@end

