//
//  SXXQViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/23.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXXQViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIToolbarDelegate>

@property (strong, nonatomic) UITableView *tableVIew;
@property (strong, nonatomic) UITextField *speaktext;
@property (strong, nonatomic) UIButton *sendBtn;
@property (strong, nonatomic) UIView *barView;
@property (assign, nonatomic)NSString *list_is;
@property (assign, nonatomic)NSString *toUid;
@property (strong, nonatomic)NSString *uface;
@property (strong, nonatomic)NSString *sendTo;
@property (strong, nonatomic)UIImage *userFace;
@property (strong, nonatomic)NSMutableArray *fromArr;
@property (strong, nonatomic)NSMutableArray *dateArr;
@property (strong, nonatomic)UIImageView *myHead;

-(id)initWithChatUserid:(NSString *)uId uFace:(NSString *)urlStr toUserID:(NSString *)toUserId sendToID:(NSString *)sendToID;


@end
