//
//  GroupListPopViewController.m
//  YunKeTang
//
//  Created by 刘邦海 on 2019/9/23.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "GroupListPopViewController.h"
#import "GrouListCell.h"

@interface GroupListPopViewController ()<GrouListCellDelegate>

@end

@implementation GroupListPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 0, MainScreenWidth - 60, 280)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.cornerRadius = 3;
    _tableView.centerY = MainScreenHeight / 2.0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _groupTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_tableView.left, _tableView.top - 40 + 3, MainScreenWidth - 60, 40)];
    _groupTitleLabel.text = @"开团详情";
    _groupTitleLabel.backgroundColor = [UIColor whiteColor];
    _groupTitleLabel.font = SYSTEMFONT(13);
    _groupTitleLabel.textColor = RGBHex(0x373737);
    _groupTitleLabel.textAlignment = NSTextAlignmentCenter;
    _groupTitleLabel.layer.masksToBounds = YES;
    UIBezierPath * path1 = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = _groupTitleLabel.bounds;
    maskLayer1.path = path1.CGPath;
    _groupTitleLabel.layer.mask = maskLayer1;
    [self.view addSubview:_groupTitleLabel];
    
    // 关闭按钮
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _tableView.bottom + 25, 36, 36)];
    _closeButton.centerX = MainScreenWidth / 2.0;
    [_closeButton setImage:Image(@"close") forState:0];
    [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"groulistcell";
    GrouListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GrouListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setGroupInfo:_dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
//    return _dataSource.count
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: - 加入团的点击事件 GrouListCellDelegate
- (void)joinGroupByGroupId:(NSString *)groupID groupInfo:(NSDictionary *)groupInfo {
    ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
    vc.dict = _videoDataSource;
    vc.typeStr = _courseType;
    vc.cid = [_videoDataSource stringValueForKey:@"id"];
    vc.activityInfo = [NSDictionary dictionaryWithDictionary:_activityInfo];
    vc.isJoinGroup = YES;
    vc.isBuyAlone = YES;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

// MARK: - 关闭按钮
- (void)closeButtonClick {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
