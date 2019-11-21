//
//  MyDownLoadViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/9/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//
//#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
//#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "MyDownLoadViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"
#import "ZFDownloadManager.h"
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"
#import "DiskSpaceTool.h"
#import <QuickLook/QuickLook.h>
//#import "bigWindPlayViewController.h"
#import "LibaryPlayViewController.h"

#import "TKProgressHUD+Add.h"


@interface MyDownLoadViewController ()<UITableViewDelegate,UITableViewDataSource,ZFDownloadDelegate>
{
    
    BOOL _isOn0;
    BOOL _isOn1;
    int _number;
    UILabel *_WZLabel;
    NSString *_size;
}

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong)ZFDownloadManager *downloadManage;
@property (atomic, strong) NSMutableArray *downloadObjectArr;
@property (atomic, strong) NSMutableArray *rowArray;

@property (strong ,nonatomic)UIWebView *webView;


@end

@implementation MyDownLoadViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    // 更新数据源
    _isOn0 = NO;
    _isOn1 = NO;
    _number = 0;
    [self initData];
    _rowArray = [NSMutableArray array];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)initData
{
    [self.downloadManage startLoad];
    NSMutableArray *downladed = self.downloadManage.finishedlist;
    NSMutableArray *downloading = self.downloadManage.downinglist;
    self.downloadObjectArr = @[].mutableCopy;
    [self.downloadObjectArr addObject:downladed];
    [self.downloadObjectArr addObject:downloading];
    [self.tableView reloadData];
    //fileSize
    NSArray *sectionArray = self.downloadObjectArr[0];
    NSLog(@"%@",sectionArray);
    NSMutableArray *marr = [NSMutableArray array];;
    for (int i =0; i<sectionArray.count; i++) {
        ZFFileModel *fileInfo = self.downloadObjectArr[0][i];
        NSString *strSize = fileInfo.fileSize;
        [marr addObject:strSize];
    }
    float num;
    for (int i=0; i<marr.count; i++) {
        
        NSLog(@"%@",marr[i]);

       float number = [marr[i] floatValue];
        num += number;
        
    }
    num = num/1000000;
    _size = [NSString stringWithFormat:@"%.2f",num];
    NSLog(@"%@",_size);
    _WZLabel.text = [NSString stringWithFormat:@"已下载%@,剩余%@可用",_size,[DiskSpaceTool freeDiskSpaceInBytes]];
}


- (void)addWebViewWithString:(NSString *)documentName {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,MainScreenHeight * 2, MainScreenWidth, 1)];
    [self.view addSubview:_webView];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [[NSBundle mainBundle]URLForResource:documentName withExtension:nil];
//    NSLog(@"----%@",path);
//    NSURL *url = [NSURL fileURLWithPath:path];
    NSLog(@"%@  %@",url,documentName);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"---%@",request);
    [_webView loadRequest:request];
    
    
}

- (ZFDownloadManager *)downloadManage
{
    if (!_downloadManage) {
        _downloadManage = [ZFDownloadManager sharedDownloadManager];
    }
    return _downloadManage;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = YES;
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"==============%@",[DiskSpaceTool freeDiskSpaceInBytes]);
    
    self.downloadManage.downloadDelegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self addNav];
    [self addDownView];
    UIView *backLab = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 15, MainScreenWidth, 15)];
    UIColor *color = [UIColor grayColor];
    backLab.backgroundColor = [color colorWithAlphaComponent:0.5];
    [self.view addSubview:backLab];
    _WZLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 15)];
    _WZLabel.text = [NSString stringWithFormat:@"剩余%@可用",[DiskSpaceTool freeDiskSpaceInBytes]];
    _WZLabel.textColor = [UIColor whiteColor];
    _WZLabel.font = [UIFont systemFontOfSize:11];
    _WZLabel.textAlignment = NSTextAlignmentCenter;
    [backLab addSubview:_WZLabel];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"我的下载";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,86)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [SYGView addSubview:backButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 30, 70, 30)];
    [cleanButton setTitle:@"清空下载" forState:UIControlStateNormal];
    cleanButton.titleLabel.font = Font(15);
    [cleanButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [SYGView addSubview:cleanButton];
    cleanButton.hidden = YES;
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(15, 40, 40, 40);
        titleLab.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        lineLab.frame = CGRectMake(0,87, MainScreenWidth, 1);
    }
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//下载页面
-(void)addDownView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 88);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
    
}

#pragma mark ---

//头部视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    NSLog(@"----%@",self.downloadObjectArr);
    NSArray *sectionArray = self.downloadObjectArr[section];
    return sectionArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZFDownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFDownloadedCell"];
        
        if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"ZFDownloadedCell" owner:nil options:nil];
            cell = [cellArr objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        
        cell.fileInfo = fileInfo;
        
        NSString *str = cell.sizeLabel.text;
        
        NSLog(@"%@",fileInfo.fileimage);
        
        return cell;
        
    } else {
        
        ZFDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZFDownloadingCell"];
        
        if (!cell) {
            
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"ZFDownloadingCell" owner:nil options:nil];
            cell = [cellArr objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        if (request == nil) { return nil; }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        
        __weak typeof(self) weakSelf = self;
        
        // 下载按钮点击时候的要刷新列表
        
        cell.btnClickBlock = ^{
            
            [weakSelf initData];
        };
        
        // 下载模型赋值
        cell.fileInfo = fileInfo;
        // 下载的request
        cell.request = request;
        return cell;
    }
    
    return nil;
}

-(void)addDownLoadTaskAction:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",@"123456");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",self.downloadObjectArr[indexPath.section][indexPath.row]);
    if (indexPath.section ==1) {
        return;
    }
    ZFFileModel *model = self.downloadObjectArr[indexPath.section][indexPath.row];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"0000%@",paths);
    NSString *HHHJJ = [paths stringByAppendingPathComponent:@"ZFDownLoad/CacheList/"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];

    if ([model.fileName rangeOfString:@"."].location == NSNotFound) {
        
    } else {
        //保存到本地
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
        NSString *librayUrl = [defaults objectForKey:model.fileName];//根据键值取出name
        
        NSLog(@"%@",librayUrl);
        
        
        LibaryPlayViewController *libaryVc = [[LibaryPlayViewController alloc] init];
        libaryVc.urlStr = librayUrl;
        [self.navigationController pushViewController:libaryVc animated:YES];
        
        
        
//        NSArray *ss = [model.fileName componentsSeparatedByString:@"."];
//        
//        [self addWebViewWithString:ss[0]];
        

//        NSString *GGG = [NSString stringWithFormat:@"%@/%@",HHHJJ,model.fileName];
//        NSLog(@"%@",GGG);
//        NSString *path = [[NSBundle mainBundle] pathForResource:GGG ofType:nil];
//        NSLog(@"-----%@",path);
//        NSURL *url = [NSURL fileURLWithPath:GGG];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [_webView loadRequest:request];
        
    }
}

#pragma mark - Navigation

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPat{
    
    if (_number==0) {
        
        [_tableView reloadData];
        _number++;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _number = 0;
    if (indexPath.section == 0) {
        
        ZFFileModel *fileInfo = self.downloadObjectArr[indexPath.section][indexPath.row];
        [self.downloadManage deleteFinishFile:fileInfo];
        
    }else if (indexPath.section == 1) {
        
        ZFHttpRequest *request = self.downloadObjectArr[indexPath.section][indexPath.row];
        [self.downloadManage deleteRequest:request];
    }
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

//下面两个方法可以设置头视图尾视图，我们可以在view上做任何事情，具体就看大家想怎么办了
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
    btn.tag =section;
    NSArray *sectionArray = self.downloadObjectArr[section];
    NSString *str1 ;
    
    if (section==0) {
        
        str1 = [NSString stringWithFormat:@"   下载完成(%ld)",sectionArray.count];
        
    }else{
        
        str1 = [NSString stringWithFormat:@"   下载中(%ld)",sectionArray.count];
    }
    
    [btn setTitle:str1 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //左对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    return btn;
}

-(void)change:(UIButton *)sender{
    
    if (sender.tag == 0) {
        _isOn0 = !_isOn0;
    }else{
        _isOn1 = !_isOn1;
    }
    [_tableView reloadData];
}

#pragma mark - ZFDownloadDelegate
// 开始下载
- (void)startDownload:(ZFHttpRequest *)request
{
    NSLog(@"开始下载!");
}

// 下载中
- (void)updateCellProgress:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

// 下载完成
- (void)finishedDownload:(ZFHttpRequest *)request
{
    [self initData];
}

// 更新下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo
{
    NSArray *cellArr = [self.tableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[ZFDownloadingCell class]]) {
            ZFDownloadingCell *cell = (ZFDownloadingCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

@end
