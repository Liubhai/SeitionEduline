
//
//  Good_ClassDownViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassDownViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "GLNetWorking.h"
#import "ZBLM3u8Manager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BRAVideoDownShowNotXibTableViewCell.h"
//缓存的模型
#import "SYGClassTool.h"
#import "BRDownFileCacheManager.h"
#import "Good_ClassCatalogTableViewCell.h"
#import "ZFDownloadManager.h"
#import "BRDownHelpManager.h"
#import "UIAlertView+OtherInfo.h"
#import "BRCourseDownInfoTableViewCell.h"
#import "BRPlayM3u8VideoViewController.h"
typedef enum : NSUInteger {
    kNotDown = 1,
    kDowning,
    kDownFinish,
} KNownType;

@interface Good_ClassDownViewController ()<UITableViewDataSource,UITableViewDelegate,BRUpdateDownProgressDelegate,BRAVideoDownShowNotXibTableViewCellDelegate>
{
    UITableView * _tableView;
    UILabel *lable;
    
    BOOL _isOn0;
    BOOL _isOn1;
    BOOL _isOn2;
    BOOL _isOn3;
    BOOL _isOn4;
    BOOL _isOn5;
    int _number;
    
    UIButton *button0;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    
    BOOL     isScene;//是否配置（人脸识别）
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
    NSInteger downIndexPathSection;
    NSInteger downIndexPathRow;
    
    UIImage   *faceImage;
}

@property (strong ,nonatomic)UITableView     *tableView;
@property (strong ,nonatomic)UIView          *tableViewHeaderView;
@property (strong ,nonatomic)UIImageView     *imageView;

@property (strong ,nonatomic)NSDictionary    *dataSource;
@property (strong ,nonatomic)NSArray         *dataArray;
@property (strong ,nonatomic)NSMutableArray  *newsDataArray;
@property (strong ,nonatomic)NSMutableArray  *sectionArray;
@property (strong ,nonatomic)NSMutableArray  *boolArray;

@property (strong ,nonatomic)NSString        *sectionID;
@property (strong ,nonatomic)NSString        *downUrl;
@property (strong ,nonatomic)NSString        *downTitle;
@property (strong ,nonatomic)NSTimer         *timer;

@property (strong ,nonatomic)NSMutableArray  *saveDataArray;
//下载第三方相关
@property (nonatomic, strong)ZFDownloadManager  *downloadManage;
@property (assign ,nonatomic)NSInteger           downSecition;
@property (assign ,nonatomic)NSInteger           downRow;
@property (assign ,nonatomic)CGFloat             downProgress;
@property (assign ,nonatomic)NSInteger           downIndex;


/**
 进度 dict，为什么需要，因为 数据类型是 dict。没法保存进度，不做大调整，因此增加一个 dict。专门存进度
 key:w文件id  value:KNownType
 */
@property (nonatomic, strong) NSMutableDictionary *progressDict;

@property (nonatomic, strong) BRCourseDownInfoTableViewCell *downHeaderInfoView;

/** 如果是班级课的时候 点击下载的课时cell */
@property (strong, nonatomic) BRAVideoDownShowNotXibTableViewCell *classCourseCurrentCell;

//@property (nonatomic, strong) NSData *courseInfoData;
@end

@implementation Good_ClassDownViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT)];
        _imageView.image = Image(@"云课堂_空数据");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    _titleImage.backgroundColor = BasidColor;
    _titleLabel.text = @"选择下载";
    _progressDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[BRDownHelpManager manager] br_addDelegates:self];
    [self interFace];
    [self addTableViewHeaderView];
    [self addTableView];
//    [self addWZView];
//    [self addControllerSrcollView];
    if ([_isDown integerValue] == 1) {//已经在我的下载界面了
        WS(ws);
        id responseObject = [[BRDownHelpManager manager] br_getCourseInfoWithListCourseInfo:_videoDataSource];
        _dataSource = responseObject;
        if ([_dataSource isKindOfClass:[NSArray class]]) {
            _dataArray = (NSArray *)_dataSource;
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            
            for (int i = 0 ; i < _dataArray.count; i ++ ) {
                NSArray *classArray = [[_dataArray objectAtIndex:i] arrayValueForKey:@"child"];
                if (classArray.count == 0) {
                    [_newsDataArray addObject:@[]];
                } else {
                    [_newsDataArray addObject:classArray];
                    [classArray enumerateObjectsUsingBlock:^(NSDictionary *a_course, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (_isClassCourse) {
                            NSArray *lastClassArray = [a_course arrayValueForKey:@"child"];
                            [lastClassArray enumerateObjectsUsingBlock:^(NSDictionary *last_course, NSUInteger lastidx, BOOL * _Nonnull stop) {
                                NSString *last_course_id = [last_course stringValueForKey:@"id"];
                                NSString *last_video_address = [last_course stringValueForKey:@"video_address"];
                                if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:last_video_address]) {
                                    ws.progressDict[last_course_id] = @(kDownFinish);
                                }
                            }];
                        } else {
                            NSString *course_id = [a_course stringValueForKey:@"id"];
                            NSString *video_address = [a_course stringValueForKey:@"video_address"];
                            if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:video_address]) {
                                ws.progressDict[course_id] = @(kDownFinish);
                            }
                        }
                    }];
                }
                [self br_updateHadDownFile];
                NSString *title = [[_dataArray objectAtIndex:i] stringValueForKey:@"title"];
                [_sectionArray addObject:title];
                
                NSMutableArray *boolArray = [NSMutableArray array];
                for (int k = 0 ; k < classArray.count ; k ++) {
                    
                    if (i == 0 && k == 0) {
                        [boolArray addObject:[NSNumber numberWithBool:YES]];
                    } else {
                        [boolArray addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                [_boolArray addObject:boolArray];
            }
        }
        [_tableView reloadData];
//        _newsDataArray = (NSMutableArray *)[_videoDataSource arrayValueForKey:YunKeTang_CurrentDownList];
//        _sectionArray = (NSMutableArray *)[_videoDataSource arrayValueForKey:YunKeTang_CurrentDownTitleList];
    } else {
        [self netWorkVideoGetCatalog];
    }

    [_tableView reloadData];
}
- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _sectionArray = [NSMutableArray array];
    _newsDataArray = [NSMutableArray array];
    _saveDataArray = [NSMutableArray array];
    _isOn0 = NO;
    _isOn1 = NO;
    _isOn2 = NO;
    _isOn3 = NO;
    _isOn4 = NO;
    _isOn5 = NO;
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"选择下载";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

//MARK:更新已下载数量
- (void)br_updateHadDownFile{
    NSInteger count = self.progressDict.allValues.count;
    _downHeaderInfoView.hadDownLabel.text = [NSString stringWithFormat:@"已下载%ld个任务",count];
}
- (void)addTableViewHeaderView {
    _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 110)];
    
    _downHeaderInfoView = [[[NSBundle mainBundle] loadNibNamed:@"BRCourseDownInfoTableViewCell" owner:self options:nil] firstObject];
    [_tableViewHeaderView addSubview:_downHeaderInfoView];
    _downHeaderInfoView.frame = _tableViewHeaderView.bounds;
    
    _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableViewHeaderView];
    
    _downHeaderInfoView.mNameLabel.text = [_videoDataSource stringValueForKey:@"video_title"];
    NSString *urlStr = [_videoDataSource stringValueForKey:@"cover"];
    [_downHeaderInfoView.mImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    NSString * section_count =  [_videoDataSource stringValueForKey:@"section_count"];
    _downHeaderInfoView.totalCourseLabel.text = [NSString stringWithFormat:@"共%@节",section_count];
    [self br_updateHadDownFile];
    
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth, MainScreenHeight - MACRO_UI_UPHEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _tableViewHeaderView;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark  --- 表格视图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit)];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableHeadView.tag = section;
    
    //添加标题
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 50 * WideEachUnit, 50 * WideEachUnit)];
    sectionTitle.text = _sectionArray[section];
    sectionTitle.textColor = [UIColor colorWithHexString:@"333"];
    sectionTitle.font = Font(14 * WideEachUnit);
    [tableHeadView addSubview:sectionTitle];
    
    //添加箭头
    UIButton *arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit, 0, 40 * WideEachUnit, 50 * WideEachUnit)];
    [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];//灰色乡下@2x
    [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];//灰色乡下@2x
    arrowsButton.enabled = NO;
    if (section == 0) {
        if (_isOn0) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    } else if (section == 1) {
        if (_isOn1) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 2) {
        if (_isOn2) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 3) {
        if (_isOn3) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 4) {
        if (_isOn4) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }
    [tableHeadView addSubview:arrowsButton];
    
    //给整个View添加手势
    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
    
    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_isDown integerValue] == 1) {
        return _sectionArray.count;
    } else {//平常
        return _dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isOn0) {
        if (section == 0) {
            return 0;
        }
    }
    if (_isOn1) {
        if (section == 1) {
            return 0;
        }
    }
    if (_isOn2) {
        if (section == 2) {
            return 0;
        }
    }
    if (_isOn3) {
        if (section == 3) {
            return 0;
        }
    }
    if (_isOn4) {
        if (section == 4) {
            return 0;
        }
    }
    if (_isOn5) {
        if (section == 5) {
            return 0;
        }
    }

    NSArray *sectionArray = _newsDataArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_isClassCourse) {
        WS(ws);
        NSArray *cellArray = _newsDataArray[indexPath.section];
        NSDictionary *dict = [cellArray objectAtIndex:indexPath.row];
        NSString *id_str = dict[@"id"];
        NSString *cell_identifier = [NSString stringWithFormat:@"sadasdasdasd--%@",id_str];
        BRAVideoDownShowNotXibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
        if (cell == nil) {
            cell = [[BRAVideoDownShowNotXibTableViewCell alloc] initWithReuseIdentifier:cell_identifier isClassNew:_isClassCourse cellSection:indexPath.section cellRow:indexPath.row];
        }
        
        [cell setClassCourseDownListCellInfo:dict downLoadMutableDict:self.progressDict];
        
        cell.br_selectedBlock = ^(BRAVideoDownShowNotXibTableViewCell * _Nonnull cell1) {
            NSIndexPath *selectedIndex = [tableView indexPathForCell:cell1];
            NSArray *temp_array = ws.newsDataArray[selectedIndex.section];
            NSDictionary *a_info_dict = temp_array[selectedIndex.row];
            //            NSString *video_address = a_info_dict[@"video_address"];
            [ws br_selectedDownInfo:a_info_dict];
        };
        
        cell.nNameLabel.text = dict[@"title"];
        if (_isClassCourse) {
            cell.delegate = self;
        }
        return cell;
    } else {
        WS(ws);
        NSArray *cellArray = _newsDataArray[indexPath.section];
        NSDictionary *dict = [cellArray objectAtIndex:indexPath.row];
        NSString *id_str = dict[@"id"];
        NSString *cell_identifier = [NSString stringWithFormat:@"sadasdasdasd--%@",id_str];
        BRAVideoDownShowNotXibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identifier];
        if (cell == nil) {
            cell = [[BRAVideoDownShowNotXibTableViewCell alloc] initWithReuseIdentifier:cell_identifier isClassNew:_isClassCourse cellSection:indexPath.section cellRow:indexPath.row];
        }
        
        [cell setClassCourseDownListCellInfo:dict downLoadMutableDict:self.progressDict];
        NSInteger type = [self.progressDict[id_str] integerValue];
        if (type == kDownFinish) {
            [cell br_updateProgress:-1];
            cell.mStatusLabel.text = @"已下载";
            
        }
        cell.br_selectedBlock = ^(BRAVideoDownShowNotXibTableViewCell * _Nonnull cell1) {
            NSIndexPath *selectedIndex = [tableView indexPathForCell:cell1];
            NSArray *temp_array = ws.newsDataArray[selectedIndex.section];
            NSDictionary *a_info_dict = temp_array[selectedIndex.row];
            //            NSString *video_address = a_info_dict[@"video_address"];
            [ws br_selectedDownInfo:a_info_dict];
        };
        
        cell.nNameLabel.text = dict[@"title"];
        if (_isClassCourse) {
            cell.delegate = self;
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isClassCourse) {
        NSArray *secitonArray = _newsDataArray[indexPath.section];
        NSDictionary *dic = [secitonArray objectAtIndex:indexPath.row];
        return 50 * WideEachUnit + [[dic objectForKey:@"child"] count] * 50 * WideEachUnit;
    }
    return 50 * WideEachUnit;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isClassCourse) {
        return;
    }
    _downRow = indexPath.row;
    _downSecition = indexPath.section;
    NSDictionary *dict = _newsDataArray[_downSecition][_downRow];
    if ([_isDown integerValue] == 1) {
        
        NSString *url = dict[@"video_address"];
        if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:url]) {
            [TKProgressHUD showError:@"已下载" toView:self.view];
            
            NSString * localPlayUrlString = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlString:url];
            
            NSURL *playUrl = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlUrl:localPlayUrlString];
            
            BRPlayM3u8VideoViewController *playVC = [[BRPlayM3u8VideoViewController alloc] init];
            playVC.playUrl = playUrl;
            playVC.filePath = localPlayUrlString;
            [self.navigationController pushViewController:playVC animated:YES];
            return;
        }
    }
}

- (void)downloadSelected:(NSDictionary *)dict currentCell:(BRAVideoDownShowNotXibTableViewCell *)currentCell {
    if (_isClassCourse) {
        _classCourseCurrentCell = currentCell;
    }
    [self br_selectedDownInfo:dict];
}

- (void)BRAVideoDownShowNotXibTableViewCellSelected:(NSDictionary *)classCourseCellDict cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow classCellRow:(NSInteger)classCellRow {
    _downRow = cellRow;
    _downSecition = cellSection;
    NSDictionary *dict = classCourseCellDict;//_newsDataArray[_downSecition][_downRow];
    if ([_isDown integerValue] == 1) {
        
        NSString *url = dict[@"video_address"];
        if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:url]) {
            [TKProgressHUD showError:@"已下载" toView:self.view];
            
            NSString * localPlayUrlString = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlString:url];
            
            NSURL *playUrl = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlUrl:localPlayUrlString];
            
            BRPlayM3u8VideoViewController *playVC = [[BRPlayM3u8VideoViewController alloc] init];
            playVC.playUrl = playUrl;
            playVC.filePath = localPlayUrlString;
            [self.navigationController pushViewController:playVC animated:YES];
            return;
        }
    }
}

#pragma mark --- 手势
- (void)tableHeadViewClick:(UITapGestureRecognizer *)not {
    NSInteger notTag = not.view.tag;
    if (notTag == 0) {
        _isOn0 = !_isOn0;
    } else if (notTag == 1) {
        _isOn1 = !_isOn1;
    } else if (notTag == 2) {
        _isOn2 = !_isOn2;
    } else if (notTag == 3) {
        _isOn3 = !_isOn3;
    } else if (notTag == 4) {
        _isOn4 = !_isOn4;
    } else if (notTag == 5) {
        _isOn5 = !_isOn5;
    }
    [_tableView reloadData];
}

#pragma mark --- 弹出框
//是否 真要下载
- (void)isSureDown {
    
    NSDictionary *dict = _newsDataArray[_downSecition][_downRow];
    NSString *messageStr = [NSString stringWithFormat:@"确定要下载%@改课程？",[dict stringValueForKey:@"title"]];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self videoDown:dict[@"video_address"]];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cellDownButtonCilck:(UIButton *)button {//下载
    NSInteger sectionNum = button.tag / 10;
    NSInteger rowNum = button.tag % 10;
    _downSecition = sectionNum;
    _downRow = rowNum;
    NSArray *buttonArray = [_newsDataArray objectAtIndex:sectionNum];
    NSDictionary *dict = [buttonArray objectAtIndex:rowNum];
    _downUrl = [dict stringValueForKey:@"video_address"];
    _downTitle = [dict stringValueForKey:@"title"];
    [self videoDown:[dict stringValueForKey:@"video_address"]];
}

#pragma mark ---下载代理更新
-(void)downHelpUpdateProgress:(float)progress url:(NSString *)url isDownFinish:(BOOL)isFinish courseInfo:(nonnull NSDictionary *)courseInfo{
    
    WS(ws);
    if (url.length <= 0) {
        return;
    }
    NSString *courseId = [NSString stringWithFormat:@"%@",[courseInfo objectForKey:@"id"]];
    NSString *downUrlRoot = [[url componentsSeparatedByString:@"?"] firstObject];
    if (_isClassCourse) {
        for (int i = 0; i< _newsDataArray.count; i++) {
            NSArray *pass = _newsDataArray[i];
            for (int j = 0; j<pass.count; j++) {
                NSArray *last = [pass[j] objectForKey:@"child"];
                for (int k = 0; k<last.count; k++) {
//                    NSString *video_address = last[k][@"video_address"];
//                    NSString * video_address_root = [[video_address componentsSeparatedByString:@"?"] firstObject];
                    NSString *passCourseID = [NSString stringWithFormat:@"%@",last[k][@"id"]];
                    if ([courseId isEqualToString:passCourseID]) { //找到相同的了
                        
                        NSString *id_str = last[k][@"id"];
                        
                        if (_classCourseCurrentCell) {
                            if (isFinish) {
                                _classCourseCurrentCell.mStatusLabel.text = @"已下载";
                                [_classCourseCurrentCell br_updateProgress:-1];
                                [ws.progressDict setObject:@(kDownFinish) forKey:id_str];
                                [ws br_updateHadDownFile];
                                [ws br_saveDownInfoInCoreData];
                            }
                            else{
                                _classCourseCurrentCell.mStatusLabel.text = nil;
                                [_classCourseCurrentCell br_updateProgress:progress];
                                [ws.progressDict setObject:@(kDowning) forKey:id_str];
                                
                            }
                        }
                    }
                }
            }
        }
    } else {
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *selectedIndex = [ws.tableView indexPathForCell:obj];
            if (selectedIndex) {
                if (selectedIndex.section < ws.newsDataArray.count) {
                    NSArray *temp_array = ws.newsDataArray[selectedIndex.section];
                    if (selectedIndex.row < temp_array.count) {
                        NSDictionary *a_info_dict = temp_array[selectedIndex.row];
                        NSString *video_address = a_info_dict[@"video_address"];
                        NSString * video_address_root = [[video_address componentsSeparatedByString:@"?"] firstObject];
                        NSString *passCourseID = [NSString stringWithFormat:@"%@",a_info_dict[@"id"]];
                        if ([courseId isEqualToString:passCourseID]) { //找到相同的了
                            
                            NSString *id_str = a_info_dict[@"id"];
                            
                            //需要判断是否同一个
                            if ([obj isKindOfClass:[BRAVideoDownShowNotXibTableViewCell class]]) {
                                BRAVideoDownShowNotXibTableViewCell *tempCell = obj;
                                if (isFinish) {
                                    tempCell.mStatusLabel.text = @"已下载";
                                    [tempCell br_updateProgress:-1];
                                    [ws.progressDict setObject:@(kDownFinish) forKey:id_str];
                                    [ws br_updateHadDownFile];
                                    [ws br_saveDownInfoInCoreData];
                                }
                                else{
                                    tempCell.mStatusLabel.text = nil;
                                    [tempCell br_updateProgress:progress];
                                    [ws.progressDict setObject:@(kDowning) forKey:id_str];
                                    
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
        }];

    }
}
#pragma mark --- 下载

/**
 视频详情，保存到缓存里面,,只在当前界面做保存。。。不然改动太大
 */
- (void)br_saveDownInfoInCoreData{
    if (self.dataSource) {
        if (_videoDataSource.allValues.count > 0) {
            [[BRDownFileCacheManager manager] saveClasses:@[_videoDataSource]];
        }
        [[BRDownHelpManager manager] br_saveCoureData:_dataSource coureInfo:_videoDataSource];
    }
}
//MARK:新的下载方法
- (void)br_selectedDownInfo:(NSDictionary *)downDict{
    
    // 这里要先去请求下载地址 然后再去下载
    NSString *endUrlStr = course_getSectionHour;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[NSString stringWithFormat:@"%@",[downDict objectForKey:@"id"]] forKey:@"id"];
    NSString *course_id = [NSString stringWithFormat:@"%@",[downDict objectForKey:@"id"]];
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            NSDictionary *pass = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            NSString *url = pass[@"video_address"];
            
            NSInteger first = 0;
            NSInteger second = 0;
            NSInteger third = 0;
            BOOL hasCourseID = NO;
            NSMutableDictionary *passCourseInfo;
            // 这里要重新组装数据源了 把地址装进数据源
            NSMutableArray *passArray = [NSMutableArray arrayWithArray:_dataArray];
            for (int i = 0; i<passArray.count; i++) {
                if (hasCourseID) {
                    break;
                }
                NSMutableArray *passArraySecond = [NSMutableArray arrayWithArray:[passArray[i] arrayValueForKey:@"child"]];
                for (int j = 0; j<passArraySecond.count; j++) {
                    if (hasCourseID) {
                        break;
                    }
                    if (!_isClassCourse) {
                        NSString *passCourse_id = [NSString stringWithFormat:@"%@",[passArraySecond[j] objectForKey:@"id"]];
                        if ([passCourse_id isEqualToString:course_id]) {
                            hasCourseID = YES;
                            first = i;
                            second = j;
                            passCourseInfo = [NSMutableDictionary dictionaryWithDictionary:passArraySecond[j]];
                            break;
                        }
                    } else {
                        NSMutableArray *passArrayThird = [NSMutableArray arrayWithArray:[passArraySecond[j] arrayValueForKey:@"child"]];
                        for (int k = 0; k<passArrayThird.count; k++) {
                            NSString *passCourse_id = [NSString stringWithFormat:@"%@",[passArrayThird[k] objectForKey:@"id"]];
                            if ([passCourse_id isEqualToString:course_id]) {
                                hasCourseID = YES;
                                first = i;
                                second = j;
                                third = k;
                                passCourseInfo = [NSMutableDictionary dictionaryWithDictionary:passArrayThird[k]];
                                break;
                            }
                        }
                    }
                }
            }
            
            if (hasCourseID && SWNOTEmptyDictionary(passCourseInfo)) {
                [passCourseInfo setObject:url forKey:@"video_address"];
                if (_isClassCourse) {
                    /// 三层 班级课
                    
                    // 取出第二层
                    NSMutableArray *pass10 = [NSMutableArray arrayWithArray:[_dataArray[first] arrayValueForKey:@"child"]];
                    // 取出第三层
                    NSMutableArray *pass11 = [NSMutableArray arrayWithArray:[pass10[second] arrayValueForKey:@"child"]];
                    // 替换第三层数据源
                    [pass11 replaceObjectAtIndex:third withObject:[NSDictionary dictionaryWithDictionary:passCourseInfo]];
                    
                    // 取出第二层数据源
                    NSMutableDictionary *pass11Dict = [NSMutableDictionary dictionaryWithDictionary:pass10[second]];
                    // 替换第二层数据源
                    [pass11Dict setObject:[NSArray arrayWithArray:pass11] forKey:@"child"];
                    [pass10 replaceObjectAtIndex:second withObject:pass11Dict];
                    
                    
                    NSMutableDictionary *pass11Dict1 = [NSMutableDictionary dictionaryWithDictionary:_dataArray[first]];
                    [pass11Dict1 setObject:[NSArray arrayWithArray:pass10] forKey:@"child"];
                    
                    NSMutableArray *pass = [NSMutableArray arrayWithArray:_dataArray];
                    [pass replaceObjectAtIndex:first withObject:pass11Dict1];
                    _dataArray = [NSArray arrayWithArray:pass];
                } else {
                    /// 两层 点播课
                    NSMutableArray *pass10 = [NSMutableArray arrayWithArray:[_dataArray[first] arrayValueForKey:@"child"]];
                    [pass10 replaceObjectAtIndex:second withObject:[NSDictionary dictionaryWithDictionary:passCourseInfo]];
                    
                    NSMutableDictionary *pass11Dict = [NSMutableDictionary dictionaryWithDictionary:_dataArray[first]];
                    [pass11Dict setObject:[NSArray arrayWithArray:pass10] forKey:@"child"];
                    
                    NSMutableArray *pass = [NSMutableArray arrayWithArray:_dataArray];
                    [pass replaceObjectAtIndex:first withObject:pass11Dict];
                    _dataArray = [NSArray arrayWithArray:pass];
                }
            }
            
            _dataSource = (NSDictionary *)_dataArray;
            
            if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:url]) {
                [TKProgressHUD showError:@"已下载" toView:self.view];
                
                NSString * localPlayUrlString = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlString:url];
                
                NSURL *playUrl = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlUrl:localPlayUrlString];
                BRPlayM3u8VideoViewController *playVC = [[BRPlayM3u8VideoViewController alloc] init];
                playVC.playUrl = playUrl;
                playVC.filePath = localPlayUrlString;
                [self.navigationController pushViewController:playVC animated:YES];
                return;
            }
            else{
                if (![[GLNetWorking isConnectionAvailable] isEqualToString:@"wifi"]) {
                    UIAlertView *_downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                    _downAlertView.otherInfo = downDict;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_downAlertView show];
                    });
                } else {
                    [[BRDownHelpManager manager] br_startDownUrl:url dictInfo:downDict];
                }
            }
        }
            
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}
-(void)videoDown:(NSString *)url{
    if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:url]) {
        [TKProgressHUD showError:@"已下载" toView:self.view];
        
        NSString * localPlayUrlString = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlString:url];

        NSURL *playUrl = [[ZBLM3u8Manager shareInstance] localPlayUrlWithOriUrlUrl:localPlayUrlString];
//        MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:playUrl];
//        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        BRPlayM3u8VideoViewController *playVC = [[BRPlayM3u8VideoViewController alloc] init];
        playVC.playUrl = playUrl;
        playVC.filePath = localPlayUrlString;
        [self.navigationController pushViewController:playVC animated:YES];
        return;
    }
    if (![[GLNetWorking isConnectionAvailable] isEqualToString:@"wifi"]) {
        UIAlertView *_downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        _downAlertView.accessibilityLabel = url;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downAlertView show];
        });
    } else {
        [self downLoadVideo:url];
    }
}

-(void)downLoadVideo:(NSString *)url{
    
    if (_downUrl.length == 0) {
        [TKProgressHUD showError:@"下载地址为空" toView:self.view];
        return;
    }
//    NSURL *imagegurl = [NSURL URLWithString:_downUrl];
//    NSData *data = [NSData dataWithContentsOfURL:imagegurl];
//    UIImage *videoImage = [[UIImage alloc] initWithData:data];
    //此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    

#warning 修改成m3u8下载
    [[ZBLM3u8Manager shareInstance] downloadVideoWithUrlString:_downUrl downloadProgressHandler:^(float progress,NSString *oriUrl) {
        
        NSLog(@"%@加载进度", oriUrl);
        
        
    } downloadSuccessBlock:^(NSString *localPlayUrlString,NSString *oriUrl) {
//        [[ZBLM3u8Manager shareInstance]  tryStartLocalService];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self playWithUrlString:localPlayUrlString];
//        });
    }];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_downUrl filename:_downTitle fileimage:videoImage];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 1;
//
//    //保存数据
//    [self saveDataSource];
//    [self saveVideoDataSource];
}

#pragma mark --- 已经下载文件以及正在下载的文件进行监听
- (void)downFileHandle {
    //这里应该处理 （获取到当前的下载进度）
    NSMutableArray *downloadingArray = self.downloadManage.downinglist;
    for (int i = 0 ; i < downloadingArray.count ; i ++) {
        ZFFileModel *model = [downloadingArray objectAtIndex:i];
        if ([model.fileName isEqualToString:_downTitle]) {//为当前下载的课程
            _downIndex = i;
        }
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

#pragma mark ---- Timer
- (void)updateProgress:(NSTimer *)timer {
    NSMutableArray *downloadingArray = self.downloadManage.downinglist;
    ZFFileModel *downModel = [downloadingArray objectAtIndex:_downIndex];
    _downProgress = (float)[downModel.fileReceivedSize longLongValue] / [downModel.fileSize longLongValue];
    //刷新指定下载的那一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_downRow inSection:_downSecition];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    if (_downProgress == 1) {
        [_timer invalidate];
        _timer = nil;
        _downProgress = 0;
    }
}

#pragma mark --- UIAlertView 相关
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSString *url = alertView.otherInfo[@"video_address"];
        if (url) {
            [[BRDownHelpManager manager] br_startDownUrl:url dictInfo:alertView.otherInfo];
        }
        //[self downLoadVideo:alertView.accessibilityLabel];
    }else
        return;
}

#pragma mark ---保存数据相关
- (void)saveDataSource {
    
    //标记是否下载
    NSMutableDictionary *cellDict = (NSMutableDictionary *) _newsDataArray[_downSecition][_downRow];
    [cellDict setObject:@"1" forKey:YunKeTang_CurrentDownExit];
    NSMutableArray *secitionArray1 = _newsDataArray[_downSecition];
    NSMutableArray *replaceArray = [NSMutableArray array];
    for (int i = 0 ; i < secitionArray1.count ; i ++) {
        NSMutableDictionary *replaceDict = [secitionArray1 objectAtIndex:i];
        [replaceDict removeObjectForKey:@"wid"];
        [replaceArray addObject:replaceDict];
    }
    [replaceArray replaceObjectAtIndex:_downRow withObject:cellDict];
    [_newsDataArray replaceObjectAtIndex:_downSecition withObject:replaceArray];
    
    //改变字典的值
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *saveArray = [userDefaults objectForKey:YunKeTang_VideoDataSource];
    NSMutableDictionary *selfVideoSourceDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (saveArray.count == 0) {//说明当前还是空的
        [selfVideoSourceDict setObject:@"1" forKey:YunKeTang_CurrentDownCount];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"id"] forKey:@"id"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_title"] forKey:@"video_title"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"cover"] forKey:@"cover"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"price"] forKey:@"price"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count"] forKey:@"video_order_count"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count_mark"] forKey:@"video_order_count_mark"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"section_count"] forKey:@"section_count"];
        [selfVideoSourceDict setObject:_newsDataArray forKey:YunKeTang_CurrentDownList];
        [selfVideoSourceDict setObject:_sectionArray forKey:YunKeTang_CurrentDownTitleList];
        [_saveDataArray addObject:selfVideoSourceDict];
    } else {//说明是有值的
        _saveDataArray = [NSMutableArray arrayWithArray:saveArray];
        BOOL isExit = NO;
        NSInteger isExitNumber = 0;
        for (int i = 0 ; i < saveArray.count ; i ++) {
            NSDictionary *dict = [saveArray objectAtIndex:i];
            NSString *videoID = [dict stringValueForKey:@"id"];
            if ([videoID isEqualToString:[_videoDataSource stringValueForKey:@"id"]]) {
                isExit = YES;
                
                if ([[[[[dict arrayValueForKey:YunKeTang_CurrentDownList] objectAtIndex:_downSecition] objectAtIndex:_downRow] stringValueForKey:YunKeTang_CurrentDownExit] integerValue] == 1) {
                    return;
                }
                
                isExitNumber = i;
                if ([[dict stringValueForKey:@"YunKeTang_CurrentDownCount"] integerValue] == 0) {
                     [selfVideoSourceDict setObject:@"1" forKey:YunKeTang_CurrentDownCount];
                } else {
                    
                }
                [selfVideoSourceDict setObject:[dict stringValueForKey:YunKeTang_CurrentDownCount] forKey:YunKeTang_CurrentDownCount];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"id"] forKey:@"id"];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"video_title"] forKey:@"video_title"];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"cover"] forKey:@"cover"];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"price"] forKey:@"price"];
                [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count"] forKey:@"video_order_count"];
                [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count_mark"] forKey:@"video_order_count_mark"];
                [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"section_count"] forKey:@"section_count"];
                [selfVideoSourceDict setObject:[dict arrayValueForKey:YunKeTang_CurrentDownTitleList] forKey:YunKeTang_CurrentDownTitleList];
                
                NSMutableDictionary *indexDict = [NSMutableDictionary dictionaryWithDictionary:[[[dict arrayValueForKey:YunKeTang_CurrentDownList] objectAtIndex:_downSecition] objectAtIndex:_downRow]];
                [indexDict setObject:@"1" forKey:YunKeTang_CurrentDownExit];
                NSMutableArray *secitionArray = [NSMutableArray arrayWithArray:[[dict arrayValueForKey:YunKeTang_CurrentDownList] objectAtIndex:_downSecition]];
                [secitionArray replaceObjectAtIndex:_downRow withObject:indexDict];
                NSMutableArray *array = [NSMutableArray arrayWithArray:[dict arrayValueForKey:YunKeTang_CurrentDownList]];
                [array replaceObjectAtIndex:_downSecition withObject:secitionArray];
                [selfVideoSourceDict setObject:array forKey:YunKeTang_CurrentDownList];
            }
        }
        
        if (isExit) {//说明相同 （就不添加了）应该添加下载的课时
            NSInteger downCount = [[selfVideoSourceDict objectForKey:YunKeTang_CurrentDownCount] integerValue];
            NSInteger newDownCount = downCount + 1;
            NSString *newDownCountStr = [NSString stringWithFormat:@"%ld",newDownCount];
            [selfVideoSourceDict setObject:newDownCountStr forKey:YunKeTang_CurrentDownCount];
            
            [_saveDataArray replaceObjectAtIndex:isExitNumber withObject:selfVideoSourceDict];
        } else {
            [selfVideoSourceDict setObject:@"1" forKey:YunKeTang_CurrentDownCount];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"id"] forKey:@"id"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_title"] forKey:@"video_title"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"cover"] forKey:@"cover"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"price"] forKey:@"price"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count"] forKey:@"video_order_count"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count_mark"] forKey:@"video_order_count_mark"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"section_count"] forKey:@"section_count"];
            [selfVideoSourceDict setObject:_newsDataArray forKey:YunKeTang_CurrentDownList];
            [selfVideoSourceDict setObject:_sectionArray forKey:YunKeTang_CurrentDownTitleList];
            [_saveDataArray addObject:selfVideoSourceDict];
        }
    }
    NSArray *data = (NSArray *)_saveDataArray;
   // [userDefaults setObject:data forKey:YunKeTang_VideoDataSource]; //这里会崩溃应该字典里面有null
}

#pragma mark --- 保存数据有关
- (void)saveVideoDataSource {
    //取出本地的数据
    NSArray *classArray = [SYGClassTool classWithDic:nil];
    BOOL isHave = NO;
    for (int i = 0 ; i < classArray.count ; i ++) {
        NSMutableDictionary *indexDict = [classArray objectAtIndex:i];
        if ([[indexDict stringValueForKey:@"id"] integerValue] == [[_videoDataSource stringValueForKey:@"id"] integerValue]) {//说明是同一个课程
            isHave = YES;
        }
    }
    if (isHave) {
        [_videoDataSource setObject:@"1" forKey:YunKeTang_CurrentDownCount];
        
        
    } else {
        NSMutableArray *mutabArray = [NSMutableArray arrayWithCapacity:0];
        [mutabArray addObject:_videoDataSource];
       [SYGClassTool saveClasses:mutabArray];
    }
    
}

#pragma mark --- 获取下载的数据



#pragma mark --- 网络请求
//获取列表
- (void)netWorkVideoGetCatalog {
    
    NSString *endUrlStr = YunKeTang_Video_video_getCatalog;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    WS(ws);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        if ([responseObject isKindOfClass:[NSData class]]) {
//            _courseInfoData = responseObject;
//        }
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_dataSource isKindOfClass:[NSArray class]]) {
            _dataArray = (NSArray *)_dataSource;
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            
            for (int i = 0 ; i < _dataArray.count; i ++ ) {
                NSArray *classArray = [[_dataArray objectAtIndex:i] arrayValueForKey:@"child"];
                if (classArray.count == 0) {
                    [_newsDataArray addObject:@[]];
                } else {
                    [_newsDataArray addObject:classArray];
                    [classArray enumerateObjectsUsingBlock:^(NSDictionary *a_course, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (_isClassCourse) {
                            NSArray *lastClassArray = [a_course arrayValueForKey:@"child"];
                            [lastClassArray enumerateObjectsUsingBlock:^(NSDictionary *last_course, NSUInteger lastidx, BOOL * _Nonnull stop) {
                                NSString *last_course_id = [last_course stringValueForKey:@"id"];
                                NSString *last_video_address = [last_course stringValueForKey:@"video_address"];
                                if ([self isDownLoadVideo:last_course_id]) {
                                    ws.progressDict[last_course_id] = @(kDownFinish);
                                }
//                                if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:last_video_address]) {
//                                    ws.progressDict[last_course_id] = @(kDownFinish);
//                                }
                            }];
                        } else {
                            NSString *course_id = [a_course stringValueForKey:@"id"];
                            NSString *video_address = [a_course stringValueForKey:@"video_address"];
                            if ([self isDownLoadVideo:course_id]) {
                                ws.progressDict[course_id] = @(kDownFinish);
                            }
//                            if ([[ZBLM3u8Manager shareInstance] exitLocalVideoWithUrlString:video_address]) {
//                                ws.progressDict[course_id] = @(kDownFinish);
//                            }
                        }
                    }];
                }
                [self br_updateHadDownFile];
                NSString *title = [[_dataArray objectAtIndex:i] stringValueForKey:@"title"];
                [_sectionArray addObject:title];
                
                NSMutableArray *boolArray = [NSMutableArray array];
                for (int k = 0 ; k < classArray.count ; k ++) {
                    
                    if (i == 0 && k == 0) {
                        [boolArray addObject:[NSNumber numberWithBool:YES]];
                    } else {
                        [boolArray addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                [_boolArray addObject:boolArray];
            }
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        [error lo];
        [TKProgressHUD showError:[error localizedDescription] toView:[UIApplication sharedApplication].keyWindow];

    }];
    [op start];
}

// MARK: - 判断是否已经下载了
- (BOOL)isDownLoadVideo:(NSString *)courseId {
    id responseObject = [[BRDownHelpManager manager] br_getCourseInfoWithListCourseInfo:_videoDataSource];
    BOOL isDown = NO;
    if ([responseObject isKindOfClass:[NSArray class]]) {
        NSArray *pass = (NSArray *)responseObject;
        if (_isClassCourse) {
            for (int i = 0; i<pass.count; i++) {
                if (isDown) {
                    break;
                }
                NSArray *pass1 = [NSArray arrayWithArray:[pass[i] objectForKey:@"child"]];
                for (int j = 0; j<pass1.count; j++) {
                    if (isDown) {
                        break;
                    }
                    NSArray *pass2 = [NSArray arrayWithArray:[pass1[j] objectForKey:@"child"]];
                    for (int k = 0; k < pass2.count; k++) {
                        NSString *passCourseID = [NSString stringWithFormat:@"%@",[pass2[k] objectForKey:@"id"]];
                        if ([passCourseID isEqualToString:courseId] && SWNOTEmptyStr([pass2[k] objectForKey:@"video_address"])) {
                            isDown = YES;
                            break;
                        }
                    }
                }
            }
            return isDown;
        } else {
            for (int i = 0; i<pass.count; i++) {
                if (isDown) {
                    break;
                }
                NSArray *pass1 = [NSArray arrayWithArray:[pass[i] arrayValueForKey:@"child"]];
                for (int j = 0; j < pass1.count; j++) {
                    NSString *passCourseID = [NSString stringWithFormat:@"%@",[pass1[j] objectForKey:@"id"]];
                    if ([passCourseID isEqualToString:courseId] && SWNOTEmptyStr([pass1[j] objectForKey:@"video_address"])) {
                        isDown = YES;
                        break;
                    }
                }
            }
            return isDown;
        }
    } else {
        return NO;
    }
}


@end
