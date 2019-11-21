//
//  SpeedSettingViewController.m
//  xdflive
//
//  Created by Gaojin Hsu on 3/28/16.
//  Copyright © 2016 Gensee. Inc. All rights reserved.
//

#import "SpeedSettingViewController.h"

@interface SpeedSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableArray *params;

@end

@implementation SpeedSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
//    
//    SPEED_NORMAL,
//    SPEED_125,
//    SPEED_150,
//    SPEED_175,
//    SPEED_2,
//    SPEED_25,
//    SPEED_3,
//    SPEED_35,
//    SPEED_4
    
    
    self.items = [NSMutableArray arrayWithObjects:@"正常速度播放", @"1.25倍速度播放", @"1.5倍速度播放", @"1.75倍速度播放", @"2倍速度播放", @"2.5倍速度播放", @"3倍速度播放", @"3.5倍速度播放", @"4倍速度播放",nil];
    
    self.params = [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:SPEED_NORMAL], [NSNumber numberWithInt:SPEED_125],[NSNumber numberWithInt:SPEED_150],[NSNumber numberWithInt:SPEED_175],[NSNumber numberWithInt:SPEED_2],[NSNumber numberWithInt:SPEED_25],[NSNumber numberWithInt:SPEED_3],[NSNumber numberWithInt:SPEED_35],[NSNumber numberWithInt:SPEED_4],nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.vodplayer SpeedPlay:[self.params[indexPath.row] intValue]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
