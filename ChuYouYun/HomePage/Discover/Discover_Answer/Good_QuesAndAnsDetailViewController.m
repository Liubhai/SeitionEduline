//
//  Good_QuesAndAnsDetailViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/16.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_QuesAndAnsDetailViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "TKProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"

#import "Good_QuesAndAnsCommentTableViewCell.h"
#import "Good_QuesAndCommentDetailViewController.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface Good_QuesAndAnsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (strong ,nonatomic)UIView         *tableHeaderView;
@property (strong ,nonatomic)UIView         *photoView;
@property (strong ,nonatomic)UITableView    *tableView;
@property (strong ,nonatomic)UIView         *downView;
@property (strong ,nonatomic)UILabel        *detail;
@property (strong ,nonatomic)UILabel        *time;
@property (strong ,nonatomic)UIView         *segmentView;
@property (strong ,nonatomic)UIImageView    *imageView;
@property (strong ,nonatomic)UIView         *downTextView;
@property (strong ,nonatomic)UITextField    *textField;
@property (strong ,nonatomic)UIButton       *sendButton;

@property (strong ,nonatomic)NSArray        *dataArray;
@property (strong ,nonatomic)NSDictionary   *dataSource;
@property (assign ,nonatomic)CGFloat        labelSizeHight;

@property (strong ,nonatomic)NSString       *answer_switch;

@end

@implementation Good_QuesAndAnsDetailViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:_tableView.bounds];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        _imageView.frame = CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame), MainScreenWidth,MainScreenHeight);
        _imageView.backgroundColor = [UIColor redColor];
        [_tableView addSubview:_imageView];
    }
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_dataArray.count == 0) {
        self.tableView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_tableHeaderView.frame) + MainScreenHeight - 64 - 50 * WideEachUnit);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addTableHeaderView];
    [self addTableView];
    [self addDownView];
    [self addDownTextView];
    [self netWorkWendaGetCommentList];
    [self netWorkCourseReviewConf];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _answer_switch = @"1";
    
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addSubview:_downTextView];
    [self.downTextView addSubview:self.textField];
    [self.downTextView addSubview:self.sendButton];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"问答详情";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    if (iPhoneX) {
        SYGView.frame = CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight);
        backButton.frame = CGRectMake(5, 35, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
    }
}

- (void)addTableHeaderView {
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 200 * WideEachUnit)];
    if (iPhoneX) {
        _tableHeaderView.frame = CGRectMake(0, 88, MainScreenWidth, 200 * WideEachUnit);
    }
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableHeaderView];
    
    //添加头像
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 12 * WideEachUnit, 35  *WideEachUnit, 35 * WideEachUnit)];
    imageButton.backgroundColor = [UIColor whiteColor];
    imageButton.layer.cornerRadius = 17.5 * WideEachUnit;
    imageButton.layer.masksToBounds = YES;
    [imageButton sd_setImageWithURL:[NSURL URLWithString:[_dict stringValueForKey:@"userface"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    [_tableHeaderView addSubview:imageButton];
    
    //添加名字
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60 * WideEachUnit, 12 + 12.5 * WideEachUnit, MainScreenWidth - 60 * WideEachUnit, 15 * WideEachUnit)];
    name.text = [_dict stringValueForKey:@"uname"];
    name.font = Font(13 * WideEachUnit);
    name.textColor = BlackNotColor;
    [_tableHeaderView addSubview:name];
    
    //添加具体的
    _detail = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 60 * WideEachUnit, MainScreenWidth - 60 * WideEachUnit, 15 * WideEachUnit)];
    _detail.text = [_dict stringValueForKey:@"wd_description"];
    _detail.font = Font(16 * WideEachUnit);
    _detail.textColor = [UIColor colorWithHexString:@"#888"];
    [_tableHeaderView addSubview:_detail];
    [self setIntroductionText:[_dict stringValueForKey:@"wd_description"]];
    
    
    //添加展示图片的视图
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, CGRectGetMaxY(_detail.frame) + 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 0 * WideEachUnit)];
    _photoView.backgroundColor = [UIColor whiteColor];
    [_tableHeaderView addSubview:_photoView];
    NSArray *photoArray = [_dict arrayValueForKey:@"wd_attr"];
    if (photoArray.count == 0) {
        
    } else {
        [self imageWithArray:photoArray];
    }
    
    
    
    //时间
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_photoView.frame) + 10 * WideEachUnit, 80 * WideEachUnit, 15 * WideEachUnit)];
    time.text = [_dict stringValueForKey:@"ctime"];
    time.font = Font(13 * WideEachUnit);
    time.textColor = [UIColor colorWithHexString:@"#888"];
    [_tableHeaderView addSubview:time];
    _time = time;
    
    //添加分类的按钮
    UIButton *cateButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(time.frame) + 10 * WideEachUnit, CGRectGetMaxY(_detail.frame) + 10 * WideEachUnit, 100 * WideEachUnit, 15 * WideEachUnit)];
    [cateButton setTitle:@"知识分类" forState:UIControlStateNormal];
    [cateButton setImage:Image(@"quesType") forState:UIControlStateNormal];
    cateButton.titleLabel.font = Font(13 * WideEachUnit);
    [cateButton setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
    cateButton.backgroundColor = [UIColor whiteColor];
    cateButton.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,50 * WideEachUnit);
    cateButton.titleEdgeInsets = UIEdgeInsetsMake(0,10 * WideEachUnit, 0, 0);
    [_tableHeaderView addSubview:cateButton];
    cateButton.hidden = YES;
    
    
    _tableHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(time.frame) + 20 * WideEachUnit);
    //添加分割线
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame) - 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit)];
    segmentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableHeaderView addSubview:segmentView];
    _segmentView = segmentView;
}


- (void)imageWithArray:(NSArray *)array {
    CGFloat Space = 10;
    CGFloat JJ = 14;
    CGFloat BWirth = (MainScreenWidth - 30 * WideEachUnit - (2 * Space)) / 3;
    //这个的图片是正方形
    for (int i = 0 ; i < array.count ; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + (i % 3) * BWirth + (i % 3) * Space, Space + (i / 3) * BWirth + (i / 3) * Space, BWirth, BWirth)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:Image(@"站位图")];
        [_photoView addSubview:imageView];
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
    }
    
    //图片试图的大小
    if (array.count % 3 == 0) {
        _photoView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_detail.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, (array.count / 3) * (BWirth + Space));
    } else {
        _photoView.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_detail.frame) + 10 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, (array.count / 3 + 1) * (BWirth + Space));
    }
    
    //确定点赞和评论的位置
    _time.frame = CGRectMake(15 * WideEachUnit, CGRectGetMaxY(_photoView.frame) + 10 * WideEachUnit, 90 * WideEachUnit, 20 * WideEachUnit);
    _tableHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(_time.frame) + 10 * WideEachUnit);
    _segmentView.frame = CGRectMake(0, CGRectGetMaxY(_time.frame) + 10 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit);
}




- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 60 * WideEachUnit - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 60 * WideEachUnit - 88);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100 * WideEachUnit;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _tableHeaderView;
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)addDownView {
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 60 * WideEachUnit, MainScreenWidth, 60 * WideEachUnit)];
    if (iPhoneX) {
        _downView.frame = CGRectMake(0, MainScreenHeight - 83, MainScreenWidth, 83);
    }
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    CGFloat buttonW = MainScreenWidth / 3;
    CGFloat buttonH = 60 * WideEachUnit;
    NSArray *imageArray = @[@"ico_like@3x",@"ico_collect@3x",@""];
    NSArray *titleArray = @[@"1288",@"收藏",@"评论"];
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonW * i, 0, buttonW, buttonH)];
        button.tag = i;
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#888"] forState:UIControlStateNormal];
        button.titleLabel.font = Font(13 * WideEachUnit);
        button.imageEdgeInsets =  UIEdgeInsetsMake(5 * WideEachUnit,buttonW / 2 - 20 * WideEachUnit,30 * WideEachUnit,0);
        button.titleEdgeInsets = UIEdgeInsetsMake(20 * WideEachUnit, 0, 0, 0);
        if (i == 0) {
             button.imageEdgeInsets =  UIEdgeInsetsMake(5 * WideEachUnit,buttonW / 2 - 5 * WideEachUnit,30 * WideEachUnit,0);
            button.hidden = YES;
        } else if (i == 1) {
//            button.backgroundColor = [UIColor whiteColor];
            button.hidden = YES;
        } else if (i == 2) {
            button.frame = CGRectMake(buttonW * i + 10 * WideEachUnit , 10, buttonW - 20 * WideEachUnit, buttonH - 20 * WideEachUnit);
            button.frame = CGRectMake(30 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 60 * WideEachUnit, buttonH - 20 * WideEachUnit);
            button.layer.cornerRadius = 5 * WideEachUnit;
            [button setImage:nil forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = BasidColor;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [button addTarget:self action:@selector(downButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
    }
    
    if ([_answer_switch integerValue] == 0) {
        _downView.hidden = YES;
    } else {
        _downView.hidden = YES;
    }
}


- (void)addDownTextView {
    _downTextView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 40 * WideEachUnit)];
    _downTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downTextView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 0, MainScreenWidth - 90 * WideEachUnit, 40 * WideEachUnit)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 3;
    _textField.delegate = self;
    _textField.font = Font(14);
    _textField.returnKeyType = UIReturnKeySend;
    
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(10 * WideEachUnit, 0, 10 * WideEachUnit, 40 * WideEachUnit)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_downTextView addSubview:_textField];
    
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 65 * WideEachUnit, 5 * WideEachUnit, 50 * WideEachUnit, 30 * WideEachUnit)];
    _sendButton.backgroundColor = BasidColor;
    _sendButton.layer.cornerRadius = 3;
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_downTextView addSubview:_sendButton];
    
}

#pragma mark --- 界面的配置
-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _detail.text = text;
    //设置label的最大行数
    _detail.numberOfLines = 0;
    if ([_detail.text isEqual:[NSNull null]]) {
        _detail.frame = CGRectMake(15 * WideEachUnit,130 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit,30 * WideEachUnit);
        return;
    }
    
    CGRect labelSize = [text boundingRectWithSize:CGSizeMake(MainScreenWidth - 30 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 * WideEachUnit]} context:nil];
    _detail.frame = CGRectMake(15 * WideEachUnit,60 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit,labelSize.size.height);
    _tableHeaderView.frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 105 * WideEachUnit);
    _labelSizeHight = labelSize.size.height + 105 * WideEachUnit;
}


#pragma mark --- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 36 * WideEachUnit)];
    view.backgroundColor = [UIColor whiteColor];
    
    //添加文本
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth / 2 , 36 * WideEachUnit)];
    label.text = @"0条评论";
    label.text = [NSString stringWithFormat:@"%ld条评论",_dataArray.count];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#333"];
    [view addSubview:label];
    
    //添加按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 0, 80 * WideEachUnit, 36 * WideEachUnit)];
    [button setTitle:@"默认排序" forState:UIControlStateNormal];
    [button setImage:Image(@"") forState:UIControlStateNormal];
    button.titleLabel.font = Font(12 * WideEachUnit);
    [button setTitleColor:[UIColor colorWithHexString:@"#666"] forState:UIControlStateNormal];
    [view addSubview:button];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_dataArray.count == 0) {
        return _labelSizeHight;
    } else {
        return 0.01;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120 * WideEachUnit;
//    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"WDTableViewCell";
    Good_QuesAndAnsCommentTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];

    if (cell == nil) {
        cell = [[Good_QuesAndAnsCommentTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    [cell dataWithDict:dict];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    Good_QuesAndCommentDetailViewController *vc = [[Good_QuesAndCommentDetailViewController alloc] init];
//    vc.dict = [_dataArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downButtonCilck:(UIButton *)button {
    if (button.tag == 0) {//点赞
        
    } else if (button.tag == 1) {//收藏
        
    } else if (button.tag == 2) {//写问答
        if (!UserOathToken) {
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
        [self.textField becomeFirstResponder];
    }
}

- (void)sendButtonCilck {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if (_textField.text.length == 0) {
        [TKProgressHUD showError:@"请输入评论" toView:self.view];
        return;
    }
    [self netWorkWendaDoComment];
}

#pragma mark  ---- 手势
- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    NSArray *imageArray = [_dict arrayValueForKey:@"wd_attr"];
    int count = (int)imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [imageArray[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = _photoView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}

#pragma mark --- 键盘处理
//键盘弹上来
- (void)keyboardWillShow:(NSNotification *)not {
    NSLog(@"-----%@",not.userInfo);
    CGRect rect = [not.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat HFloat = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
//        _downView.frame = CGRectMake(0, MainScreenHeight - 50 - HFloat, MainScreenWidth, 50);
//        self.textField.frame = CGRectMake(15, MainScreenHeight - 40 * WideEachUnit - HFloat, MainScreenWidth - 30 * WideEachUnit, 40 * WideEachUnit);
        _downTextView.frame = CGRectMake(0, MainScreenHeight - 40 * WideEachUnit - HFloat, MainScreenWidth, 40 * WideEachUnit);
        
    }];
}

//键盘下去
- (void)keyboardWillHide:(NSNotification *)not {
    [UIView animateWithDuration:0.25 animations:^{
        _downView.frame = CGRectMake(0, MainScreenHeight - 60 * WideEachUnit, MainScreenWidth, 60 * WideEachUnit);
        _downTextView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 40 * WideEachUnit);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //点搜索按钮
    if (self.textField.text.length > 0) {
        [self netWorkWendaDoComment];
    } else {
        [TKProgressHUD showError:@"内容不能为空" toView:self.view];
    }
    [self.textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}



#pragma mark --- 网络请求

- (void)netWorkWendaGetCommentList {
    
    NSString *endUrlStr = YunKeTang_WenDa_wenda_getCommentList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_dict stringValueForKey:@"id"] forKey:@"wid"];
    
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
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        } else {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
        
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
            self.imageView.frame = CGRectMake(0, CGRectGetMaxY(_tableHeaderView.frame) + 40 * WideEachUnit, MainScreenWidth,MainScreenHeight - 64 - 50 * WideEachUnit);
            _tableView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight * 5 + _labelSizeHight + 100 * WideEachUnit);
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)netWorkWendaDoComment {
    
    NSString *endUrlStr = YunKeTang_WenDa_wenda_doComment;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_dict stringValueForKey:@"id"] forKey:@"wid"];
    [mutabDict setObject:self.textField.text forKey:@"content"];
    
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
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
            [self netWorkWendaGetCommentList];
        } else {
            [TKProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
            return ;
        }
        _textField.text = @"";
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//评论的配置
- (void)netWorkCourseReviewConf {
    NSString *endUrlStr = YunKeTang_Course_video_reviewConf;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _answer_switch = [dict stringValueForKey:@"wenda_switch"];
            if ([_answer_switch integerValue] == 1) {//关
                _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64);
                _downView.hidden = YES;
            } else {// 0 为开
                _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 60 * WideEachUnit);
                _downView.hidden = NO;
            }
            if (iPhoneX) {
                _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88 - 83);
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}






@end
