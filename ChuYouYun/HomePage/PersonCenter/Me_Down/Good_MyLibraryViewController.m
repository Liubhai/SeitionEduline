//
//  Good_MyLibraryViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/6/4.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_MyLibraryViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "base64.h"
#import "GLNetWorking.h"
#import "AdViewController.h"

#import "Good_MyClassDownloadTableViewCell.h"
#import "LibraryCell.h"
#import "ZFDownloadManager.h"
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"


@interface Good_MyLibraryViewController ()<UITableViewDelegate,UITableViewDataSource,ZFDownloadDelegate> {
    BOOL _isOn0;
    BOOL _isOn1;
}

@property (strong ,nonatomic)UITableView    *tableView;
@property (strong ,nonatomic)UIImageView    *imageView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSArray        *titleArray;
@property (assign ,nonatomic)NSInteger      num;
@property (strong ,nonatomic)NSString       *downUrl;
@property (strong ,nonatomic)NSString       *downName;
@property (strong ,nonatomic)NSString       *docID;
@property (strong ,nonatomic)NSString       *downExtension;
@property (strong ,nonatomic)NSString       *needScore;

//下载数据相关
@property (nonatomic, strong)ZFDownloadManager  *downloadManage;

@end

@implementation Good_MyLibraryViewController

#pragma mark --- 懒加载
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34)];
        _imageView.image = Image(@"云课堂_空数据");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (ZFDownloadManager *)downloadManage
{
    if (!_downloadManage) {
        _downloadManage = [ZFDownloadManager sharedDownloadManager];
    }
    return _downloadManage;
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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"我的文库";
    [self getDownDataSource];//得到下载的数据源
//    [self addNav];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _titleArray = @[@"已完成",@"未完成"];
    _titleArray = @[@"已完成"];
    _num = 1;
    self.downloadManage.downloadDelegate = self;//设置代理
    _isOn0 = NO;
    _isOn1 = NO;
}

- (void)getDownDataSource {
    //    [self.downloadManage startLoad];
    NSMutableArray *finishedList = self.downloadManage.finishedlist;
    NSMutableArray *downingList = self.downloadManage.downinglist;
    
    for (int i = 0 ; i < finishedList.count ; i ++ ) {
        ZFFileModel *fileModel = finishedList[i];
        NSLog(@"type---%@",fileModel.fileType);
        if ([fileModel.fileType isEqualToString:@"pdf"] || [fileModel.fileType isEqualToString:@"ppt"] || [fileModel.fileType isEqualToString:@"excel"] || [fileModel.fileType isEqualToString:@"word"] || [fileModel.fileType isEqualToString:@"txt"] || [fileModel.fileType isEqualToString:@"docx"] || [fileModel.fileType isEqualToString:@"zip"] || [fileModel.fileType isEqualToString:@"jpg"] || [fileModel.fileType isEqualToString:@"pptx"]) {//判断是否为文库
            [_dataArray addObject:fileModel];
        }
    }
    //    [_dataArray addObject:finishArray];
    
    NSMutableArray *downingArray = [NSMutableArray array];
    for (int i = 0 ; i < downingList.count ; i ++) {
        ZFHttpRequest *request = downingList[i];
        ZFFileModel *fileModel = [request.userInfo objectForKey:@"File"];
        if ([fileModel.fileType isEqualToString:@"pdf"] || [fileModel.fileType isEqualToString:@"ppt"] || [fileModel.fileType isEqualToString:@"excel"] || [fileModel.fileType isEqualToString:@"word"] || [fileModel.fileType isEqualToString:@"txt"] || [fileModel.fileType isEqualToString:@"docx"] || [fileModel.fileType isEqualToString:@"zip"] || [fileModel.fileType isEqualToString:@"jpg"] || [fileModel.fileType isEqualToString:@"pptx"]) {//判断是否为文库
            [downingArray addObject:fileModel];
        }
    }
    
    if (_dataArray.count == 0 || _dataArray.count == 0) {
        self.imageView.hidden = NO;
        _tableView.hidden = YES;
    } else {
        self.imageView.hidden = YES;
        _tableView.hidden = NO;
    }
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的文库";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        WZLabel.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
    
}

#pragma mark --- 添加表格
- (void)addTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT - 34) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90 * WideEachUnit;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
    //    NSArray *oneArray = [_dataArray objectAtIndex:0];
    //    NSArray *twoArray = [_dataArray objectAtIndex:1];
    //    if (oneArray.count == 0 || twoArray.count == 0) {
    //        self.imageView.hidden = NO;
    //        _tableView.hidden = YES;
    //    } else {
    //        self.imageView.hidden = YES;
    //        _tableView.hidden = NO;
    //    }
    
    if (_dataArray.count == 0 || _dataArray.count == 0) {
        self.imageView.hidden = NO;
        _tableView.hidden = YES;
    } else {
        self.imageView.hidden = YES;
        _tableView.hidden = NO;
    }
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit)];
//    sectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//
//    //添加标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 20 * WideEachUnit, 50 * WideEachUnit)];
//    title.text = [_titleArray objectAtIndex:section];
//    title.textColor = [UIColor colorWithHexString:@"#333"];
//    title.font = Font(16 * WideEachUnit);
//    [sectionView addSubview:title];
//    return sectionView;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isOn0) {
        if (section==0) {
            return 0;
        }
    }
    if (_isOn1) {
        if (section==1) {
            return 0;
        }
    }
    //    NSArray *sectionArray = self.dataArray[section];
    //    return sectionArray.count;
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.section == 0) {//已经完成
    //        ZFDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFDownloadedCell"];
    //        if (!cell) {
    //            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"ZFDownloadedCell" owner:nil options:nil];
    //            cell = [cellArr objectAtIndex:0];
    //            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //        }
    //        ZFFileModel *fileModel = self.dataArray[indexPath.section][indexPath.row];
    //        cell.fileInfo = fileModel;
    //        return cell;
    //    } else {//下载中
    //        ZFDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFDownloadingCell"];
    //        if (!cell) {
    //            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"ZFDownloadingCell" owner:nil options:nil];
    //            cell = [cellArr objectAtIndex:0];
    //            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //        }
    //        ZFHttpRequest *request = self.dataArray[indexPath.section][indexPath.row];
    //        if (request == nil) { return nil; }
    //        ZFFileModel *fileModel = [request.userInfo objectForKey:@"File"];
    //        __weak typeof(self) weakSelf = self;
    //        // 下载按钮点击时候的要刷新列表
    //        cell.btnClickBlock = ^{
    //            [weakSelf getDownDataSource];
    //            [_tableView reloadData];
    //        };
    //        cell.fileInfo = fileModel;
    //        // 下载的request
    //        cell.request = request;
    //        return cell;
    //    }
    //    return nil;
    
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"culture";
        //自定义cell类
        LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[LibraryCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        ZFFileModel *fileModel = self.dataArray[indexPath.row];
        [cell dataWithModel:fileModel withState:@"1"];
        [cell.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.downButton.tag = indexPath.section * 100 + indexPath.row;
        
        cell.typeLabel.hidden = YES;
        cell.timeLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImageView.frame) + 10, 50 * WideEachUnit, MainScreenWidth - 2 * SpaceBaside, 20 * WideEachUnit);
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"culture";
        //自定义cell类
        LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[LibraryCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        ZFHttpRequest *request = self.dataArray[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        NSLog(@"%@",request);
        //        NSLog(@"%@",request.userInfo);
        //        ZFFileModel *fileModel = [request.userInfo objectForKey:@"File"];
        ZFFileModel *fileModel = (ZFFileModel *)request;
        [cell dataWithModel:fileModel withState:@"2"];
        [cell.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.downButton.tag = indexPath.section * 100 + indexPath.row;
        return cell;
    } else {
        return nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {//已经下载过的
        ZFFileModel *fileModel = self.dataArray[indexPath.row];
        AdViewController *vc = [[AdViewController alloc] init];
        vc.adStr = fileModel.fileURL;
        vc.titleStr = fileModel.fileName;
        if ([fileModel.fileType isEqualToString:@"zip"] || [fileModel.fileType isEqualToString:@"pptx"] || [fileModel.fileType isEqualToString:@"docx"] || [fileModel.fileType isEqualToString:@""] || [fileModel.fileType isEqualToString:@""]) {
            [TKProgressHUD showError:@"不支持打开此类文库" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {//未完成
        return;
    }
}

#pragma mark --- 事件监听

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonCilck:(UIButton *)button {
    
}

- (void)downButtonClick:(UIButton *)button {//删除当前已经下载好的文库
    [self isSureDownDeal:button];
}

- (void)deleDownLibrary:(UIButton *)button {
    NSInteger indexPath = button.tag % 100;
    ZFFileModel *model = [_dataArray objectAtIndex:indexPath];
    [self.downloadManage deleteFinishFile:model];
    [_dataArray removeAllObjects];
    [self getDownDataSource];
    [_tableView reloadData];
}

#pragma mark --- 提醒框
- (void)isSureDownDeal:(UIButton *)button {
    
    NSString *messageStr = [NSString stringWithFormat:@"确定要删除该文库？"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self deleDownLibrary:button];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
