//
//  Good_PersonFaceRegisterViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/12/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_PersonFaceRegisterViewController : UIViewController

@property (strong ,nonatomic)NSString      *typeStr;
@property (strong ,nonatomic)NSString      *tryStr;

@property (strong ,nonatomic)NSDictionary  *tokenAndTokenSerectDict;//这个字段是用于强制登录的时候 要创建人脸时用到的token和 tokenSercet

@end
