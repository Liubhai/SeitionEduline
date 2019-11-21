//
//  InstitutionsChooseVC.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/10/22.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

typedef void(^institutionChooseBlock)(BOOL succesed);

#import "BaseViewController.h"
#import "SYG.h"
#import "SYGTextField.h"
#import "YunKeTang_Api.h"
#import "Passport.h"
#import "AppDelegate.h"

@interface InstitutionsChooseVC : BaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) BOOL fromSetingVC;

@property (nonatomic,copy) institutionChooseBlock institutionChooseFinished;
@property (strong, nonatomic) SYGTextField *institutionSearch;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIScrollView *recommendScrollView;
@property (strong, nonatomic) UITableView *searchResultTableView;
@property (strong, nonatomic) NSMutableArray *recommendArray;
@property (strong, nonatomic) NSMutableArray *searchArray;

@end
