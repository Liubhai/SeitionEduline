//
//  ManageAddressViewController.h
//  dafengche
//
//  Created by IOS on 16/10/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageAddressViewController : UIViewController

@property (nonatomic,strong)UIImageView *ImagV;
@property (nonatomic,strong)UILabel *firstLab;
@property (nonatomic,strong)UILabel *secondLab;
@property (nonatomic,strong)UILabel *lineLab;
@property (nonatomic,strong)UILabel *thirdLab;
@property (strong, nonatomic)UIButton *secondBtn;
@property (strong, nonatomic)UIButton *firstBtn;
@property (strong, nonatomic)UIButton *thirdBtn;
@property (strong ,nonatomic)void (^seleAdressCell)(NSDictionary *adressDict);
//默认收货地址的图片
@property (strong, nonatomic)UIImageView *imgView;

@property (nonatomic,strong)UILabel *defaultlab;


@end
