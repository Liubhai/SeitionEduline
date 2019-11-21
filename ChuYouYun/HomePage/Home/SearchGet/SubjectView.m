//
//  SubjectView.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "SubjectView.h"
#import "UIColor+HTMLColors.h"
#import "SYG.h"
#import "TKProgressHUD+Add.h"
#import "BigWindCar.h"
#import "GLCategorry.h"
#import "SearchCataLog.h"




@interface SubjectView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    UIButton *_btn;
    
    int numsender;
    long tempNum;
    
    CGRect _frame;
    
    UILabel *_titlelab;
    UIButton *_leftBtn ;
    NSArray *_tempArr;
    NSArray *_ISONArr;
    NSMutableArray *_muArray;
}
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *cateGorryArr;
@property (strong ,nonatomic)NSMutableArray *cellcateGorryArr;


@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *lookArray;
@property (strong ,nonatomic)UIScrollView *headScrollow;
///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@end

@implementation SubjectView

-(instancetype)initWithFrame:(CGRect)frame{
    tempNum = 1921;
    _frame = frame;
    _dataArray = [NSMutableArray array];
    if (self = [super initWithFrame:frame]) {
        _btns = [NSArray array];
        _ISONArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        _tempArr = @[@"全部",@"幼小",@"初中",@"高中",@"艺术",@"生活",@"体育",@"出国",@"语言",@"职业",@"22",@"23",@"24",@"25",@"26"];
        _muArray = [NSMutableArray arrayWithArray:_ISONArr];
        _cateGorryArr = [NSMutableArray array];
        _cellcateGorryArr = [NSMutableArray array];
        
        NSArray *CategorryArray = [SearchCataLog CataLogWithDic:nil];
        NSLog(@"%@",CategorryArray);
        if (CategorryArray.count == 0) {
            [self netWorkSchoolGetCategory];
            [self initUI];
        } else {
            _dataArray = [NSMutableArray arrayWithArray:CategorryArray];
            [self initUI];
            [self addBtn];
        }
    }
    return self;
}

-(void)initUI{
    
    _tableView = [[UITableView alloc]init];
    _headScrollow = [[UIScrollView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _headScrollow.delegate = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, _frame.size.height)];
    UIColor *color = [UIColor lightGrayColor];
    [self addSubview:view];
    color = [color colorWithAlphaComponent:0.7];
    view.backgroundColor = color;
    _tableView.frame = CGRectMake(100, 120, _frame.size.width - 100, _frame.size.height - 120);
    _headScrollow.frame = CGRectMake(0, 120, 100, _frame.size.height - 120);
    [view addSubview:_headScrollow];
    [view addSubview:_tableView];
    //需要传入按钮的个数
    _headScrollow.contentSize = CGSizeMake(100, _frame.size.height);
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    _headScrollow.scrollsToTop = NO;
}
//添加左边按钮

-(void)addBtn{
    
    NSMutableArray *marr = [NSMutableArray array];
    for (int i =0; i<_dataArray.count; i++) {
        _titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, i*40, 100, 40)];
        _titlelab.text = [NSString stringWithFormat:@"    %@",_dataArray[i][@"title"]];
        NSLog(@"-------%@",_dataArray[i][@"title"]);
        [_headScrollow addSubview:_titlelab];
        _titlelab.font = Font(12);
        _titlelab.textColor = [UIColor colorWithHexString:@"#333333"];
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*40, 100, 40)];
        [_headScrollow addSubview:_leftBtn];
        if (i==0) {
            _titlelab.backgroundColor = [UIColor whiteColor];
        }
        _leftBtn.tag = 100+i;
        [marr addObject:_titlelab];
        _leftBtn.titleLabel.font = Font(9);
        [_leftBtn addTarget:self action:@selector(sendNum:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.btns = [marr copy];
    _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"child"]];
    [_tableView reloadData];
}

#pragma 响应事件

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int num = (int)[_cateGorryArr[indexPath.section][@"child"] count] -1;
    num = num/3 + 1;
    NSLog(@"%d",num);
    if (num) {
        return 30*num;
    }else{
        return 30;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_cateGorryArr.count==0) {
        return 0;
    }else{
        return [_muArray[section] integerValue];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cateGorryArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"==%ld",indexPath.section);
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    for (int i=0; i<[_cateGorryArr[indexPath.section][@"child"] count]; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((i%3)*_tableView.frame.size.width/3,30*(i/3),_tableView.frame.size.width/3,30)];
        [cell addSubview:btn];
        btn.titleLabel.font = Font(12);
        [btn setTitle:_cateGorryArr[indexPath.section][@"child"][i][@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.tag = 1000 + [_cateGorryArr[indexPath.section][@"child"][i][@"id"] integerValue];
        [btn addTarget:self action:@selector(sendID:) forControlEvents:UIControlEventTouchUpInside];
        // }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.current_w-10, 40)];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tableView.current_w-10, 40)];
    titleLab.text = [NSString stringWithFormat:@"  %@",_cateGorryArr[section][@"title"]];
    titleLab.textColor = [UIColor blackColor];
    //titleLab.backgroundColor = [UIColor cyanColor];
    [view addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:13];
    //向上向下箭头
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(_tableView.current_w - 30, 12, 16, 16)];
    [view addSubview:imgV];
    //if (section) {
    NSString *imgName = [NSString stringWithFormat:@"GLIMG%@",_muArray[section]];
    imgV.image = Image(imgName);
    //}
    UIButton *ZKBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _tableView.current_w-10, 40)];
    [view addSubview:ZKBtn];
    ZKBtn.tag = 1000+section;
    [ZKBtn addTarget:self action:@selector(zkBtn:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
#define mac  -----------------------------按钮点击事件----------------------------
-(void)sendNum:(UIButton *)sender{
    
    if (_dataArray[sender.tag - 100][@"child"] == nil) {//说明这下面级没有了
        NSDictionary *dic = [_dataArray objectAtIndex:sender.tag - 100];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[dic stringValueForKey:@"id"] forKey:@"id"];
        [dict setObject:[dic stringValueForKey:@"title"] forKey:@"title"];
        
        
        //添加通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchCateInfo" object:nil userInfo:dict];
        //移除试图
        [self removeFromSuperview];
        return;
    }
    
    _ISONArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    _muArray = [NSMutableArray arrayWithArray:_ISONArr];
    
    NSLog(@"%ld",sender.tag-100);
    if (_cateGorryArr.count) {
        [_cateGorryArr removeAllObjects];
    }
    _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[sender.tag - 100][@"child"]];
    [_tableView reloadData];
    //    _headScrollow.contentOffset = CGPointMake(0, 40*(sender.tag - 100));
    
    for (int i=0; i<_dataArray.count; i++) {
        if (sender.tag -100 == i) {
            UILabel *lab =self.btns[i];
            lab.backgroundColor = [UIColor whiteColor];
        }else{
            UILabel *lab =self.btns[i];
            lab.backgroundColor = [UIColor clearColor];
        }
    }
}

-(void)sendID:(UIButton *)sender{
    
    NSInteger Num = sender.tag - 1000;
    
    NSLog(@"%ld",Num);
    NSString *idStr = [NSString stringWithFormat:@"%ld",Num];
    NSString *title = sender.titleLabel.text;
    
    NSLog(@"---%@",sender.titleLabel.text);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:idStr forKey:@"id"];
    [dict setObject:title forKey:@"title"];
    
    
    //添加通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchCateInfo" object:nil userInfo:dict];
    
    //移除试图
    [self removeFromSuperview];
    
}

-(void)zkBtn:(UIButton *)sender{
    
    if ([_cateGorryArr objectAtIndex:sender.tag - 1000][@"child"] == nil) {//说明没有下级了
        NSDictionary *dic = [_cateGorryArr objectAtIndex:sender.tag - 1000];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[dic stringValueForKey:@"id"] forKey:@"id"];
        [dict setObject:[dic stringValueForKey:@"title"] forKey:@"title"];
        
        
        //添加通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchCateInfo" object:nil userInfo:dict];
        //移除试图
        [self removeFromSuperview];
        return;
    }
    
    if (sender.tag==10000) {
        //        [self removeFromSuperview];
        return;
    }else{
        long num = sender.tag - 1000;
        if ([_muArray[num] isEqualToString: @"1"]) {
            [_muArray replaceObjectAtIndex:num withObject:@"0"];
        }else{
            [_muArray replaceObjectAtIndex:num withObject:@"1"];
        }
        [_tableView reloadData];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

#pragma mark --- 网络请求

////首页广告图
//- (void)netWorkHomeGetCateList {
//
//
//    BigWindCar *manager = [BigWindCar manager];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//
//    NSArray *CategorryArray = [SearchCataLog CataLogWithDic:dic];
//    NSLog(@"%@",CategorryArray);
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
//        [dic setObject:UserOathToken forKey:@"oauth_token"];
//        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
//    }
//    [manager BigWinCar_GetPublicWay:dic mod:@"School" act:@"getSchoolCategory" success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSLog(@"%@",operation);
//        NSLog(@"%@",responseObject);
//        if ([responseObject[@"code"] integerValue] == 0) {
//            _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
//            [self addBtn];
//            if (CategorryArray.count) {//本地已经有数据了
//            } else {
//                //保存数据
//                [SearchCataLog saveCataLogs:responseObject[@"data"]];
//            }
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//}


#pragma mark --- 网络请求
#pragma mark --- 网络请求
- (void)netWorkSchoolGetCategory {
    
    NSString *endUrlStr = YunKeTang_School_school_getCategory;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@""] isKindOfClass:[NSArray class]]) {
                _dataArray = (NSMutableArray *)[dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
            [self addBtn];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
