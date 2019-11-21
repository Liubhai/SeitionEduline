//
//  BRAVideoDownShowNotXibTableViewCell.h
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRAVideoDownShowNotXibTableViewCell;

@protocol BRAVideoDownShowNotXibTableViewCellDelegate <NSObject>

- (void)BRAVideoDownShowNotXibTableViewCellSelected:(NSDictionary *)classCourseCellDict cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow classCellRow:(NSInteger)classCellRow;
- (void)downloadSelected:(NSDictionary *)dict currentCell:(BRAVideoDownShowNotXibTableViewCell *)currentCell;

@end

@interface BRAVideoDownShowNotXibTableViewCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *nNameLabel;
@property (nonatomic, strong) UILabel *mStatusLabel;
@property (nonatomic,copy) void(^br_selectedBlock)(BRAVideoDownShowNotXibTableViewCell *cell);

@property (assign, nonatomic) id<BRAVideoDownShowNotXibTableViewCellDelegate> delegate;
@property (strong, nonatomic) UITableView *cellTableView;
@property (assign, nonatomic) BOOL isClassNew;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *cellTableViewSpace;
@property (assign, nonatomic) NSInteger cellRow;
@property (assign, nonatomic) NSInteger cellSection;
@property (strong, nonatomic) NSMutableDictionary *downLoadMutableDict;

- (void)br_updateProgress:(float)progress;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow;
// 数据赋值
- (void)setClassCourseDownListCellInfo:(NSDictionary *)cellInfo downLoadMutableDict:(NSMutableDictionary *)dict;
@end

